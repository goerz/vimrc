#!/usr/bin/perl -w
use strict;

# Replace lines containing color codes for 256 color terminals, like
#
# hi SignColumn       cterm=none       ctermfg=241  ctermbg=253 
#
# with equivalent lines for a 88-color terimal, like
#
# hi SignColumn       cterm=none       ctermfg=83   ctermbg=87 
#
# You have to make sure that there are no incompatible colors before you run
# this.

my %color88 = ();

foreach my $dataline (<DATA>){
    if ($dataline =~ /^\s*([0-9]+)\s+([0-9]+)/){
        $color88{$1} = $2;
    }
}


foreach my $line (<STDIN>){
    $line =~ s/cterm(fg|bg)\s*=\s*([0-9]+)/cterm$1=$color88{$2}/g;
    print $line;
}

__DATA__
0 0
1 1
2 2
3 3
4 4
5 5
6 6
7 7
9 9
10 10
11 11
12 12
13 13
14 14
15 15
16 16
17 17
18 18
19 19
22 20
23 21
24 22
25 23
28 24
29 25
30 26
31 27
34 28
35 29
36 30
37 31
52 32
53 33
54 34
55 35
58 36
59 37
60 38
61 39
64 40
65 41
66 42
67 43
70 44
71 45
72 46
73 47
88 48
89 49
90 50
91 51
94 52
95 53
96 54
97 55
100 56
101 57
102 58
103 59
106 60
107 61
108 62
109 63
124 64
125 65
126 66
127 67
130 68
131 69
132 70
133 71
136 72
137 73
138 74
139 75
142 76
143 77
144 78
145 79
232 80
235 81
237 8
238 82
241 83
244 84
247 85
250 86
253 87
