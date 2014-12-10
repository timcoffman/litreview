#!/usr/bin/env ruby
#
# This file was generated by RubyGems.
#
# The application 'amatch' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0"

if ARGV.first =~ /^_(.*)_$/ and Gem::Version.correct? $1 then
  version = $1
  ARGV.shift
end

gem 'amatch', version
load Gem.bin_path('amatch', 'agrep.rb', version)
