#!/usr/bin/perl -w
use strict;

my $result = readpipe("pydoc $ARGV[0]");
if ($result =~ /^no Python documentation found/){
    system("pyhelp.py $ARGV[0]");
} else {
    open(PAGER, "|less") or die("couln't open pager");
    print PAGER $result;
    close PAGER;

}


