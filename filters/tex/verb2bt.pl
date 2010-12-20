#!/usr/bin/perl -w
use strict;



sub replace_verb_with_backtick{
    # Replace e.g. \verb|code| with `code`
    my $string = shift;
    $string =~ s@
            \\verb(.)      # $1 = Opening delimiter
            (.+?)          # $2 = The code block
            \1             # Matching closer
        @
            my $c = "$2";
            my $delimiter = select_delimiter($c);
            $c =~ s/^[ \t]*//g; # leading whitespace
            $c =~ s/[ \t]*$//g; # trailing whitespace
            "$delimiter$c$delimiter";
        @egsx;
    return $string;
}

sub select_delimiter{
    my $text = shift;
    my $delimiter = '`';
    while (index($text, $delimiter) >= 0){
        $delimiter .= '`';
    }
    return $delimiter;
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
    $filecontents = replace_verb_with_backtick($filecontents);

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


