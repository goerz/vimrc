#!/usr/bin/perl -w
use strict;

# compile markdown with maruku

if (@ARGV <  1){
    die("Usage: make_maruku.pl [options] file.markdown\n");
}

my $infile =  pop(@ARGV);
my $tmpfile = $infile;
if ($infile =~/\.markdown$/){
    $tmpfile =~  s/markdown$/tmp/;
    if (-e $tmpfile){
        die("$tmpfile exists. Please delete it\n");
    }
}
my $options = join(" ", @ARGV);

open(INFILE, $infile) or die ("Couldn't read from $infile\n");
open(TMPFILE, ">$tmpfile") or die ("Couldn't write to $tmpfile\n");

my $in_yaml = 0;
my $line = 0;
my $start_content = 0;
while (<INFILE>){
    $line += 1;
    $in_yaml = 1 if (($line == 1) and $_ =~ m'^---\s*$');
    if (($line > 1) and $_ =~ m'^---\s*$'){
        $in_yaml = 0;
        $_ = "\n";
    }
    if ($in_yaml){
        if ($_ =~ /^title: .*/i){
            print TMPFILE $_;
        }
    } else {
        print TMPFILE $_;
    }
}

close TMPFILE;
close INFILE;

system("maruku $options $tmpfile");
unlink $tmpfile or die ("Couldn't remove $tmpfile\n");
