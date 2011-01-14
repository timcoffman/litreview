#!/bin/sh
# convert line continuations into continued lines
perl -e 'while(<>) { s/\\\r?\n$/ /; print ; }' < import.sql > import.c.sql
/usr/local/mysql/bin/mysql --user litreview --password < import.c.sql
