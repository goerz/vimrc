#!/usr/bin/perl -w
use strict;



# replace_command_with_content($string, $pos, $replacement)
sub replace_text_command{
    # deletes in $string the command that begins at $pos
    # e.g. '...\textbf{blabla} ...' with '... {\bf blabla} ...'
    # where $replacement it '\bf'
    my $string = shift;
    my $i = shift; # the position where the command starts
                   # this might be index($filecontents, '\textbf{')
    my $replacement = shift;
    my $j;
    my $k;
    my $open;
    my $letter;
    # the plan is this: set an index $j to the first opening bracket
    # and and index $k to the corresponding closing bracket. Then delete
    # everything between $i and $k (including) with the text between $j and $k
    # (excluding)
    $j = $i;
    while (1){
        # go through the text letterwise, search for '{'
        $letter = substr($string, $j, 1);
        last if ($letter eq '{');
        if ($letter eq '}'){$open -=  1;}
        $j += 1;
    }
    $k = $j+1;
    $open = 1; # this counts the open brackets
    while (1){
        # go through the text letterwise, search for closing '}'
        $letter = substr($string, $k, 1);
        if ($letter eq '{'){$open += 1;}
        if ($letter eq '}'){$open -=  1;}
        last if ($open == 0);
        $k += 1;
    }
    # $j and $k are now set as expected
    substr($string, $i, $k-$i+1) = '{' . $replacement . ' ' 
                                   . substr($string, $j+1, $k-$j-1) . '}';
    return $string;
}



# process a single file / or STDIN if no file given
sub run{
    my $file = shift;
    # get input file contents into string
    my $filecontents = '';
    if (defined($file)){
        open(IN, "$file") or die("Couldn't open $file.in for reading");
        my @filecontents_array = <IN>;
        $filecontents = join('', @filecontents_array);
        close IN;
    } else {
        my @filecontents_array = <STDIN>;
        $filecontents = join('', @filecontents_array);
    }

    # process

    while ($filecontents =~ m'\\textbf\{'){
        $filecontents = replace_text_command($filecontents, 
                        index($filecontents, $&), '\bf');
    }
    while ($filecontents =~ m'\\textit\{'){
        $filecontents = replace_text_command($filecontents, 
                        index($filecontents, $&), '\it');
    }

    # write output
    if (defined($file)){
        open(OUT, ">$file.out") or die ("Couldn't open $file.out for writing");
        print OUT $filecontents;
        close OUT;

        rename($file, "$file~"); # save backup
        rename("$file.out", $file); # overwrite file with it's stipped result
    } else {
        print $filecontents;
    }
}


if (defined(@ARGV) and (@ARGV > 0)){
    foreach my $file (@ARGV){
        run($file);
    }
} else {
    run();
}


