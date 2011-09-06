#!/usr/bin/perl -w
use strict;



sub replace_command_with_content{
    # replace_command_with_content($string, $pos)
    # deletes in $string the command that begins at $pos
    # e.g. '...\textrm{blabla} ...' with '... blabla ...'
    my $string = shift;
    my $i = shift; # the position where the command starts
                   # this might be index($filecontents, '\textrm{')
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
    substr($string, $i, $k-$i+1) = substr($string, $j+1, $k-$j-1);
    return $string;
}


sub delete_command{
    # delete_command($string, $pos)
    # deletes in $string the command that begins at $pos
    # including all the content, e.g. '...before \textrm{blabla} after...'
    # with '...before  after...'
    my $string = shift;
    my $i = shift; # the position where the command starts
                   # this might be index($filecontents, '\textrm{')
    my $j;
    my $k;
    my $open;
    my $letter;
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
    substr($string, $i, $k-$i+1) = '';
    return $string;
}


sub run{
    # do the cleanup for a single file.
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
    # get footnotes
    my @footnotes = ();
    while ($filecontents =~ m/\\useURL\[\d+\]\[#sdfootnote\d+anc\]\[\]\[(\d+)\]\\from\[\d+\] (.*?)\n\n/gs){
        $footnotes[$1-1] = $2;
    }

    # process

    while ($filecontents =~ m/\\useURL\[\d+\]\[#sdfootnote\d+sym\]\[\]\[\\high{(\d+)}\]\\from\[\d+\]/gs){
        my $fntext = $footnotes[$1-1];
        $filecontents =~ s/\\useURL\[\d+\]\[#sdfootnote\d+sym\]\[\]\[\\high{(\d+)}\]\\from\[\d+\]/\\footnote{\n$fntext\n}\n/;
    }

    #while ($filecontents =~ m'\\foreignlanguage'){
        #$filecontents = replace_command_with_content($filecontents, index($filecontents, '\foreignlanguage'));
    #}


    # simple an short replacements
    while ($filecontents =~ m'\n\\crlf\n'){
        $filecontents =~ s'\n\\crlf\n'';
    }

    $filecontents =~ s/“/\\quotation{/g;
    $filecontents =~ s/”/}/g;
    $filecontents =~ s/\s*\.\s*\.\s*\.\s*/\\dots /g;
    $filecontents =~ s/^_//g;
    $filecontents =~ s/―/--/g;
    $filecontents =~ s/(\w)’(\w)/$1'$2/g;

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

if (defined(@ARGV) and ($ARGV > 0)){
    foreach my $file (@ARGV){
        run($file);
    }
} else {
    run();
}


