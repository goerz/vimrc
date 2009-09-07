#!/usr/bin/perl -w
use strict;

# This scripts moves the fortran continuation character to col 80

foreach my $line (<STDIN>){
    if ($line =~ /&$/){
        chomp($line);
        $line =~ s/\s*&$//;
        if (length($line) < 79){
            $line = sprintf("%-*s", 78, $line);
            print "$line &\n";
        } else {
            print "$line &\n";
        }
    } else {
        print $line;
    }
}
