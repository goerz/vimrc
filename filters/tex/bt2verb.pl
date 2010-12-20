#!/usr/bin/perl -w
use strict;



sub replace_backtick_with_verb{
    # Replace e.g. `code` or |code| with \verb|code|
    my $string = shift;
    $string =~ s@
            (?<!\\verb)    # Character before opening ` can't be \\verb
            ([`|]+)        # $1 = Opening run of ` or |
            (.+?)          # $2 = The code block
            (?<![`|])
            \1             # Matching closer
            (?![`|])
        @
            my $c = "$2";
            my $delimiter = select_delimiter($c);
            $c =~ s/^[ \t]*//g; # leading whitespace
            $c =~ s/[ \t]*$//g; # trailing whitespace
            "\\verb$delimiter$c$delimiter";
        @egsx;
    return $string;
}

sub select_delimiter{
    my $text = shift;
    my $delimiters = '|`\'"!*~=+#%?/^@.l1234567890';
    foreach my $delimiter (split(//, $delimiters)){
        if (index($text, $delimiter) < 0){
            return $delimiter;
        }
    }
    die("Can't find suitable delimiter\n");
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
    $filecontents = replace_backtick_with_verb($filecontents);

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


