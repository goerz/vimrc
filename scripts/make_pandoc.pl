#!/usr/bin/perl -w
use strict;

# compile markdown with pandoc. Yaml Frontmatter is stripped from the file
# before processing

if (@ARGV <  1){
    die("Usage: make_pandoc.pl [options] file.pandoc\n");
}

my $infile =  pop(@ARGV);
my $tmpfile = $infile;
if ($infile =~/\.(markdown|pandoc)$/){
    $tmpfile =~  s/markdown$/tmp/;
    $tmpfile =~  s/pandoc$/tmp/;
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

my $outfile = $infile;
if ($infile =~/\.(markdown|pandoc)$/){
    $outfile =~  s/markdown$/html/;
    $outfile =~  s/pandoc$/html/;
} else {
    $outfile = "$infile.html";
}
system("pandoc -s -o \"$outfile\" $options \"$tmpfile\"");
unlink $tmpfile or die ("Couldn't remove $tmpfile\n");
