#!/bin/sh
# convert line continuations into continued lines
perl -e 'while(<>) { s/\\\r?\n$/ /; print ; }' < tag.sql > tag.c.sql
/usr/local/mysql/bin/mysql --user litreview --password < tag.c.sql
