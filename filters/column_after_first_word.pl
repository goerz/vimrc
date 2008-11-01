#!/usr/bin/perl -w
use strict;

# This scripts adds spaces to the end of the first word of each line, so that
# all the second words start in the same column, like this:
#
#  Lorem         ipsum dolor sit amet, consectetuer adipiscing elit. Phasellu
#  purus         eu nisi. Cras pulvinar quam eu metus mollis convallis. Cum 
#  penatibuset   magnis dis parturient montes, nascetur ridiculus mus. Nunc
#  sem,          volutpat eu, adipiscing ut, viverra vitae, nisi. Proin leo
#  imperdietnec, porta vel, ultrices eu, nisi. Praesent tristique luctus or
          
my $maxlen = 0;
my @lines = ();

foreach my $line (<STDIN>){
    if ($line =~ /^(.*?)\s(.*)$/){
        my $firstword = $1;
        if ($maxlen < length($firstword)){
            $maxlen = length($firstword);
        }
        push(@lines, $line);
    }
}

foreach my $line (@lines){
    if ($line =~ /^(.*?)\s(.*)$/){
        my $firstword = $1;
        if (length($firstword) < $maxlen){
            $firstword .= (" " x ($maxlen - length($firstword)));
        }
        print $firstword, $2, "\n";
    }
}
