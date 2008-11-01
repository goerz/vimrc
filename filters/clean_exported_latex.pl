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

    # process

    # remove {\setlanguage{...}...} and similar constructs
    while ($filecontents =~ m'\{\\selectlanguage'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '{\selectlanguage'));
    }
    while ($filecontents =~ /\\selectlanguage\{[A-Za-z]*\}/){
        $filecontents =~ s/\\selectlanguage\{[A-Za-z]*\}//;
    }
    while ($filecontents =~ /\\foreignlanguage\{[a-z]*\}\{/){
        $filecontents =~ s'\\foreignlanguage\{[a-z]*\}\{'\foreignlanguage{';
    }
    while ($filecontents =~ m'\\foreignlanguage'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '\foreignlanguage'));
    }


    # remove \textstyleFootnoteSymbol{...} and similar constructs
    while($filecontents =~ m'\\textstyle[A-Za-z]+\{\s*\}'){
        $filecontents =~ s'\\textstyle[A-Za-z]+\{\s*\}'';
    }
    while($filecontents =~ m'\\textstyle[A-Za-z]+\{'){
        $filecontents = replace_command_with_content($filecontents, $-[0])  # @- is a special variable for regexes: it holds an array with the offsets of all matched groups
    }


    # make footnotes right
    while ($filecontents =~ m'\\footnotemark\{\s*\}'){
        $filecontents =~ s'\\footnotemark\{\s*\}'';
    }

    while ($filecontents =~ m'\\footnotetext\{\s*'){
        $filecontents =~ s'\\footnotetext\{\s*'\footnote{';
    }



    # remove weird font styles
    while ($filecontents =~ m'\\textrm\{'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '\textrm{'));
    }
    while ($filecontents =~ m'\\textmd\{'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '\textmd{'));
    }
    while ($filecontents =~ m'\{\\rmfamily'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '{\rmfamily'));
    }
    while ($filecontents =~ m'\{\\mdseries'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '{\mdseries'));
    }
    while ($filecontents =~ m'\{\\sffamily'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '{\sffamily'));
    }
    while ($filecontents =~ m'\{\\ttfamily'){
        $filecontents = replace_command_with_content($filecontents, index($filecontents, '{\ttfamily'));
    }
    while ($filecontents =~ m'\\sffamily(?![{a-z])'){
        $filecontents =~ s'\\sffamily(?![{a-z])'';
    }
    while ($filecontents =~ m'\\ttfamily(?![{a-z])'){
        $filecontents =~ s'\\ttfamily(?![{a-z])'';
    }
    while ($filecontents =~ m'\\rmfamily(?![{a-z])'){
        $filecontents =~ s'\\rmfamily(?![{a-z])'';
    }
    while ($filecontents =~ m'\\bfseries(?![{a-z])'){
        $filecontents =~ s'\\bfseries(?![{a-z])'';
    }
    while ($filecontents =~ m'\\mdseries(?![{a-z])'){
        $filecontents =~ s'\\mdseries(?![{a-z])'';
    }
    while ($filecontents =~ m'\\itshape(?![{a-z])'){
        $filecontents =~ s'\\itshape(?![{a-z])'';
    }


    # simple an short replacements
    while ($filecontents =~ m'\\par(?![a-z])'){
        $filecontents =~ s'\\par(?![a-z])'';
    }
    while ($filecontents =~ m'\\bigskip(?![a-z])'){
        $filecontents =~ s'\\bigskip(?![a-z])'';
    }
    while ($filecontents =~ m'\\[ ]'){
        $filecontents =~ s'\\[ ]' ';
    }
    while ($filecontents =~ m'\\pagestyle{[A-Za-z]}'){
        $filecontents =~ s'\\pagestyle{[A-Za-z]}'';
    }
    while ($filecontents =~ m'\\clearpage(?![a-z])'){
        $filecontents =~ s'\\clearpage(?![a-z])'';
    }
    while ($filecontents =~ m'\\footnote\{\s+'ms){
        $filecontents =~ s'\\footnote\{\s+'\footnote{'ms;
    }
    while ($filecontents =~ m'\s+\\footnote\{'ms){
        $filecontents =~ s'\s+\\footnote\{'\footnote{'ms;
    }
    while ($filecontents =~ m'\\pagestyle\{.*?\}'){
        $filecontents =~ s'\\pagestyle\{.*?\}'';
    }
    while ($filecontents =~ m'\\liststyle[A-Za-z]+'){
        $filecontents =~ s'\\liststyle[A-Za-z]+'';
    }
    while ($filecontents =~ m'\\textquotesingle'){
        $filecontents =~ s"\\textquotesingle"'";
    }


    # fix messed up structure
    while ($filecontents =~ m'\\chapter\[.*?\]'ms){
        $filecontents =~ s'\\chapter\[.*?\]'\chapter'ms;
    }
    while ($filecontents =~ m'\\section\[.*?\]'ms){
        $filecontents =~ s'\\section\[.*?\]'\section'ms;
    }
    while ($filecontents =~ m'\\subsection\[.*?\]'ms){
        $filecontents =~ s'\\subsection\[.*?\]'\subsection'ms;
    }
    while ($filecontents =~ m'\\subsubsection\[.*?\]'ms){
        $filecontents =~ s'\\subsubsection\[.*?\]'\subsubsection'ms;
    }
    while ($filecontents =~ m'\\paragraph\[.*?\]'ms){
        $filecontents =~ s'\\paragraph\[.*?\]''ms;
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

if (defined(@ARGV) and ($ARGV > 0)){
    foreach my $file (@ARGV){
        run($file);
    }
} else {
    run();
}


