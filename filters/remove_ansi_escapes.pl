#!/usr/bin/perl -w
use strict;

# This scripts removes ANSI escape codes. This is useful for cleaning up CLI
# logs

my @codes = (
    # from http://asthe.com/chongo/tech/comp/ansi_escapes.html
    #   ESC code sequence                       Function
    #  -------------------             ---------------------------
    #   Cursor Controls:
         qr/\e\[[0-9]+;[0-9]+H/,           #  Moves cusor to line , column
         qr/\e\[[0-9]+;[0-9]+f/,
         qr/\e\[[0-9]+A/,                  #  Moves cursor up n lines
         qr/\e\[[0-9]+B/,                  #  Moves cursor down lines
         qr/\e\[[0-9]+C/,                  #  Moves cursor forward n spaces
         qr/\e\[[0-9]+D/,                  #  Moves cursor back n spaces
         qr/\e\[[0-9]+;[0-9]+R/,           #  Reports current cursor line & column
         qr/\e\[s/,                        #  Saves cursor position for recall later
         qr/\e\[u/,                        #  Return to saved cursor position
    #   Erase Functions:
         qr/\e\[2J/,                       #  Clear screen and home cursor
         qr/\e\[K/,                        #  Clear to end of line
    #   Set Graphics Rendition:
         qr/\e\[([0-9]+;)*([0-9]+)?m/,
         qr/\e\[=[0-9]+;7h/,
         qr/\e\[=h/,
         qr/\e\[=0h/,
         qr/\e\[\?7h/,
         qr/\e\[=[0-9]+;7l/,               # Resets mode n set with above command
         qr/\e\[=l/,
         qr/\e\[=0l/,
         qr/\e\[\?7l/,
    #   Keyboard Reassignments:
         qr/\e\[([0-9]+;)+p/,
         qr/\e\["\w+"p/,
         qr/\e\[[0-9]+;"[[:print:]]+";[0-9]+;[0-9]+;"[[:print:]]+";[0-9]+p/
);

my $text = join("", <STDIN>);
foreach my $pattern (@codes){
    $text =~ s/$pattern//g;
}
print $text;
