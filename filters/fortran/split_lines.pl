#!/usr/bin/perl -w
use strict;

# This scripts splits lines to stay within linewidth

my $line_length = 80;

if (@ARGV > 0){
    $line_length = $ARGV[0];
}

foreach my $line (<STDIN>){
    chomp($line);
    if (length($line) <= $line_length){
        print $line, "\n";
    } else {
        my $indent = '';
        if ($line =~ /^(\s*&?\s*)/){
            $indent = $1;
        }
        if ($indent !~ /&/){
            $indent = $indent."& ";
        }
        while(length($line) > $line_length){
            my $splitpos = rindex($line, " ", $line_length-2);
            print substr($line, 0, $splitpos);
            print " "x($line_length-$splitpos-1), "&\n";
            $line = $indent.substr($line, $splitpos+1);
        }
        print $line, "\n";
    }
}
