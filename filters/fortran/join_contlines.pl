#!/usr/bin/perl -w
use strict;

# This scripts joins continued lines. Don't use for lines that are split in the
# middle of strings

my $margin = 80;

if (@ARGV > 0){
    $margin = $ARGV[0];
}

my $continued = 0;
foreach my $line (<STDIN>){
    chomp($line);
    if ($continued){
        $line =~ s/^\s*\&?\s*/ /;
    }
    if ($line =~ /^(.*\S)\s*\&\s*$/){ # line ends in '&'
        print $1;
        $continued = 1; # next line is a continuation
    } else {
        $continued = 0; # next line is NOT a continuation
        print $line, "\n";
    }
}
