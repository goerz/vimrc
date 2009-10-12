#!/usr/bin/perl -w
use strict;

# This scripts expands a single line containing a gnuplot plot command for the
# first block in a file into a series of such lines, one for each block In
# addition, the first (comment) line of each block is used as a title

foreach my $line (<STDIN>){
    if ($line =~ /^plot "([^"]+)" (.*) index \d (.*)$/){
        chomp($line);
        my $filename = $1;
        my $before = $2;
        my $after = $3;
        my $block = 0;
        open(INFILE, $filename) or die ("Couldn't open $filename\n");
        my $blank_lines = 0;
        my $prev_two_lines_were_blank = 0;
        foreach my $line (<INFILE>){
            if ($line =~ m/^\s*$/){
                $blank_lines += 1;
            } else {
                if ($blank_lines >= 2 or $block==0){
                    $blank_lines = 0;
                    $block += 1;
                    if ($line =~ /^\s*#\s*(.*)$/){
                        my $title = $1;
                        $title =~ s/^\s*//;
                        $title =~ s/\s*$//;
                        print "set title \"$title\"\n" unless ($title eq '');
                    }
                    $block -= 1;
                    print "plot \"$filename\" $before index $block $after\n";
                    $block += 1;
                }
            }
        }

        close INFILE;

    } else {
        print $line;
    }
}
