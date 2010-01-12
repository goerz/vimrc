#!/usr/bin/perl -w
use strict;

my $usage="fix_atomic_prop_psi.pl DATFILE\n";

if (@ARGV >= 1){
    my $datfile = $ARGV[0];
    open(STDIN, $datfile) or die("Couldn't open $datfile\n");
}

print "#       time[au]            Re[Psi]             Im[Psi]            |Psi|^2              phase             population\n";
my $time = 0.0;
foreach my $line (<STDIN>){
    if ($line =~ m'^\s*#\s*time\s*=\s+([+\-\d.EDed]+)\s*$'){
        $time = $1;
        $time = sprintf("%-20s", $time);
    } elsif ($line =~ m'^\s*([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)') {
        my $r = $1;
        my $re_psi = $2;
        $re_psi = sprintf("%-20s", $re_psi);
        my $im_psi = $3;
        $im_psi = sprintf("%-20s", $im_psi);
        my $sq_psi = $4;
        $sq_psi = sprintf("%-20s", $sq_psi);
        my $phase  = $5;
        $phase = sprintf("%-20s", $phase);
        my $population  = $6;
        $population = sprintf("%-20s", $population);
        print "$time $re_psi $im_psi $sq_psi $phase $population\n";
    } elsif ($line =~ m'^\s*([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)\s+([+\-\d.EDed]+)') {
        my $r = $1;
        my $re_psi = $2;
        $re_psi = sprintf("%-20s", $re_psi);
        my $im_psi = $3;
        $im_psi = sprintf("%-20s", $im_psi);
        my $sq_psi = $4;
        $sq_psi = sprintf("%-20s", $sq_psi);
        my $phase  = $5;
        $phase = sprintf("%-20s", $phase);
        print "$time $re_psi $im_psi $sq_psi $phase\n";
    }
}

close STDIN;
