#!/usr/bin/perl -w
use strict;
use WWW::Lipsum;

# this script generate filler text.
# call as 
#     lipsum.pl
# for 1 paragraph of text
#     lipsum.pl 3 par
# for 3 paragraphs of text
#     lipsum 10 words
# for 10 words of text.

my $lipsum = WWW::Lipsum->new;


my $amount = 1;
my $kind = 'paras';

my $argument = '';

if (defined(@ARGV)){
    $argument = join(" ", @ARGV);
}

if ($argument =~ /^([0-9]+)\s*([wp])?/){
    if (defined($1)){
        $amount = $1;
    }
    if (defined($2)){
        if ($2 eq 'w'){
            $kind = 'words';
        }
    }
}


my @output =  $lipsum->generate(
    amount => $amount,
    what   => $kind,
    start  => 'no',
    html   => 0
);

print join("\n\n", @output), "\n";
