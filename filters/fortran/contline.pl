#!/usr/bin/perl -w
use strict;

# This scripts moves the fortran continuation character to col 80

my $margin = 80;

if (@ARGV > 0){
    $margin = $ARGV[0];
}

foreach my $line (<STDIN>){
    if ($line =~ /&$/){
        chomp($line);
        $line =~ s/\s*&$//;
        if (length($line) < $margin-1){
            $line = sprintf("%-*s", $margin-2, $line);
            print "$line &\n";
        } else {
            print "$line &\n";
        }
    } else {
        print $line;
    }
}
