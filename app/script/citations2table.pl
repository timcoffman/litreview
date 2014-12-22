#!/usr/bin/env perl
use warnings;
use strict;

local $\ = "\r\n" ;

package Converter ;
use strict ;
our @ISA = qw( ) ;

package IEEEConverter ;
use strict ;
our @ISA = qw( Converter ) ;

package PsycInfoConverter ;
use strict ;
our @ISA = qw( Converter ) ;

package ISIConverter ;
use strict ;
our @ISA = qw( Converter ) ;

package PubMedConverter ;
use strict ;
our @ISA = qw( Converter ) ;

package ACMConverter ;
use strict ;
our @ISA = qw( Converter ) ;

# ------------------------------------------------------------------------
# main program
# ------------------------------------------------------------------------

my %converterMap = (
					'ieee' => IEEEConverter->new(),
					'psycinfo' => PsycInfoConverter->new(),
					'isi' => ISIConverter->new(),
					'pubmed' => PubMedConverter->new(),
					'acm' => ACMConverter->new(),
					) ;

my $converter ;
while ( my $arg = shift )
{
	if ( exists $converterMap{$arg} )
	{
		$converter = $converterMap{$arg} ;
	}
	else
	{
		die "you must specify a converter (" . join(', ',keys(%converterMap)) . ")" unless $converter ;

		my $filename = $arg ;
		my $tableFilename = $filename ;
		$tableFilename =~ s/([.][^.]+)?$/.tab/ ;
		print STDERR "converting \"$filename\" to \"$tableFilename\"...\n" ;
		
		eval
		{
			my $IN ;
			my $OUT ;
			open($IN,'<',$filename) or die "couldn't read $filename" ;
			open($OUT,'>',$tableFilename) or die "couldn't write ,$tableFilename" ;
			
			$converter->convert($IN,$OUT) ;
			
			close($IN) ;
			close($OUT) ;
		} ;
		warn $@ if $@ ;
	}
}

# ------------------------------------------------------------------------
# PubMedConverter
# ------------------------------------------------------------------------
package PubMedConverter ;

sub initialize()
{
	my $self = shift ;
	$self->{'line'} = "\n" ;
	$self->{'data'} = '^([A-Z][A-Z0-9]*)\s*[-]\s*(.*)$' ;
	$self->{'divider'} = '^\s*$' ;
	$self->{'continuation'} = '^\s*(\S.*)\s*$' ;
	$self->{'column_map'} = {
		'PubId' => 'PMID',
		'Author' => 'AU',
		'Title' => 'TI',
		'Abstract' => 'AB',
		'Date' => \&just_the_year,
		'Journal' => 'SO',
		'Keyword' => undef,
		'Source' => \&source_name
	} ;
}

sub source_name() { my ($self,$h,$c) = @_ ; return 'PubMed' ; }

sub just_the_year()
{
	my ($self,$h,$c) = @_ ;
	my $date = $h->{'DA'} ;
	if ( $date and $date =~ /^\s*([0-9]{4})[0-9]{4}\s*$/) { $date = $1 ; }
	return $date ;
}
1;
# ------------------------------------------------------------------------
# ACMConverter
# ------------------------------------------------------------------------
package ACMConverter ;

sub initialize()
{
	my $self = shift ;
	$self->{'line'} = "\n" ;
	$self->{'data'} = '^([%]\S+)\s*(.*)$' ;
	$self->{'divider'} = '^\s*$' ;
	$self->{'continuation'} = '^\s*(\S.*)\s*$' ;
	$self->{'column_map'} = {
		'PubId' => '%1',
		'Author' => '%A',
		'Title' => '%T',
		'Abstract' => '%-',
		'Date' => '%D',
		'Journal' => ['%B', '%I'],
		'Keyword' => undef,
		'Source' => \&source_name
	} ;
}

sub source_name() { my ($self,$h,$c) = @_ ; return 'ACM' ; }
1;
# ------------------------------------------------------------------------
# IEEEConverter
# ------------------------------------------------------------------------
package IEEEConverter ;

use Digest::MD5 ;

sub initialize()
{
	my $self = shift ;
	$self->{'line'} = "\n" ;
	$self->{'data'} = '^([A-Z][A-Z0-9]*)\s*[-]\s*(.*)$' ;
	$self->{'divider'} = '^ER ' ;
	$self->{'continuation'} = '^\s*(\S.*)\s*$' ;
	$self->{'column_map'} = {
		'PubId' => \&calc_hash,
		'Author' => 'AU',
		'Title' => 'TI',
		'Abstract' => 'AB',
		'Date' => 'PY',
		'Journal' => 'JO',
		'Keyword' => 'KW',
		'Source' => \&source_name
	} ;
}

sub calc_hash() { my ($self,$h,$c) = @_ ; return "MD5-" . Digest::MD5->md5_hex( $h->{'TI'} ) ; }

sub source_name() { my ($self,$h,$c) = @_ ; return 'IEEE' ; }
1;
# ------------------------------------------------------------------------
# PsycInfoConverter
# ------------------------------------------------------------------------

package PsycInfoConverter ;

use Digest::MD5 ;

sub initialize()
{
	my $self = shift ;
	$self->{'line'} = "\r" ;
	$self->{'data'} = '^([A-Z][A-Z0-9]*)\s*[:]\s*(.*)$' ;
	$self->{'divider'} = '^\s*$' ;
	$self->{'continuation'} = '^\s*(\S.*)\s*$' ;
	$self->{'column_map'} = {
		'PubId' => 'AN',
		'Author' => 'AU',
		'Title' => 'TI',
		'Abstract' => 'AB',
		'Date' => 'PY',
		'Journal' => 'SO',
		'Keyword' => 'DE',
		'Source' => \&source_name
	} ;
}

sub source_name() { my ($self,$h,$c) = @_ ; return 'PsycInfo' ; }
1;
# ------------------------------------------------------------------------
# ISIConverter
# ------------------------------------------------------------------------

package ISIConverter ;

use Digest::MD5 ;

sub initialize()
{
	my $self = shift ;
	$self->{'line'} = "\n" ;
	$self->{'data'} = '^([A-Z][A-Z0-9]*)\s*[ ]\s*(.*)$' ;
	$self->{'divider'} = '^\s*$' ;
	$self->{'continuation'} = '^\s*(\S.*)\s*$' ;
	$self->{'column_map'} = {
		'PubId' => 'UT',
		'Author' => 'AU',
		'Title' => 'TI',
		'Abstract' => 'AB',
		'Date' => 'PY',
		'Journal' => 'SO',
		'Keyword' => undef,
		'Source' => \&source_name
	} ;
}

sub source_name() { my ($self,$h,$c) = @_ ; return 'ISI' ; }
1;


# ------------------------------------------------------------------------
# Converter
# ------------------------------------------------------------------------
package Converter ;

sub new()
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->{'columns'} = ['PubId','Author','Title','Abstract','Date','Journal','Keyword','Source'] ;
	$self->initialize();
	for my $field ('line','column_map','divider','data','continuation') { exists $self->{$field} or die "$self must define a $field" ; }
	for my $column ( @{$self->{'columns'}} ) { exists $self->{'column_map'}->{$column} or warn "$self failed to map column $column" ; }
	return $self;
}

sub initialize()
{
	my $self = shift ;
	die "$self must override initialize()" ;
}

sub convert()
{
	my $self = shift ;
	my ($IN,$OUT) = @_ ;
	
	my @columns = @{$self->{'columns'}} ;
	my $divider = $self->{'divider'} ;
	my $data = $self->{'data'} ;
	my $continuation = $self->{'continuation'} ;
	
	print $OUT join("\t",@columns) ;
	
	local $/ = $self->{'line'} ;
	
	my $k ;
	my %h = () ;
	while(<$IN>)
	{
		s/[\r\n]+$// ;
		if ( /$divider/ )
		{
			$self->print_table(\%h,$OUT) if %h ;
			%h = () ;
		} 
		elsif ( my ($c,$t) = /$data/)
		{
			$k=$c;
			$h{$k} .= '; ' if exists $h{$k} ;
			$h{$k} .= $t ;
		}
		elsif ( my ($e) = /$continuation/  )
		{
			$h{$k} .= " " . $e if $k;
		}
		else
		{
			warn "rejecting \"$_\"\n" ;
		}
	}
	$self->print_table(\%h,$OUT) if %h ;
}

sub print_table()
{
	my $self = shift ;
	my ($h,$OUT) = @_ ;
	
	my @columns = @{$self->{'columns'}} ;
	
	my @values = () ;
	for my $column (@columns)
	{
		my $value = '' ;
		my $i = $self->{'column_map'}->{$column} ;
		if ( not defined $i )
		{
			$value = "" ;
		}
		elsif ( ref($i) eq 'CODE' )
		{
			$value = $i->($self,$h,$column) ;
		}
		elsif ( ref($i) eq 'ARRAY' )
		{
			$value = "" ;
			for my $j (@$i)
			{
				if ( exists $h->{$j} )
				{
					$value = $h->{$j};
					last ;
				}
			}
		}
		elsif ( exists $h->{$i} )
		{
			$value = $h->{$i};
		}
		$value =~ s/[\t]/ /g;
		push @values, $value ;
	}
	print $OUT join("\t",@values) ;
}
1;
