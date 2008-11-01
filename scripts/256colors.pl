#!/usr/bin/perl
# Author: Michael Goerz <goerz@physik.fu-berlin.de>
# Original Author: Todd Larason <jtl@molehill.org>

# use the resources for colors 0-15 - usually more-or-less a
# reproduction of the standard ANSI colors, but possibly more
# pleasing shades

print "Usage: 256colors.pl < palette\n\n";

# colors 16-231 are a 6x6x6 color cube
for ($red = 0; $red < 6; $red++) {
    for ($green = 0; $green < 6; $green++) {
	for ($blue = 0; $blue < 6; $blue++) {
	    printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
		   16 + ($red * 36) + ($green * 6) + $blue,
		   ($red ? ($red * 40 + 55) : 0),
		   ($green ? ($green * 40 + 55) : 0),
		   ($blue ? ($blue * 40 + 55) : 0));
	}
    }
}

# colors 232-255 are a grayscale ramp, intentionally leaving out
# black and white
for ($gray = 0; $gray < 24; $gray++) {
    $level = ($gray * 10) + 8;
    printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
	   232 + $gray, $level, $level, $level);
}


my %emphasizedcolors = ();

# all numbers piped to STDIN are taken as color codes for the emphasized colors
foreach $line (<STDIN>){
    while ($line =~ /([0-9]+)/g){
        $emphasizedcolors{$1+0} = 1;
    }
}

my %validcolors = ();

# get valid colors from DATA
foreach $line (<DATA>){
    $line = $line + 0;
    $validcolors{$line} = 1;
}

sub validcolor{
    # return 1 if color is valid, 0 otherwise
    my $color = shift;
    return exists($validcolors{$color});
}

sub printcolor{
    # print a block in the specified color, if it is valid
    my $color = shift;
    my $emphasis = $emphasizedcolors{$color};
    if (validcolor($color)){
        if ($emphasis){
            print "\x1b[48;5;${color}m[]";
        } else {
            print "\x1b[48;5;${color}m  ";
        }
    } else {
       if ($emphasis){
           print "\x1b[0m[]";
       } else {
           print "\x1b[0m..";
       }
    }
}


# get the colors that should be emphasized
foreach $line (<STDIN>){
}

# display the colors

# first the system ones:
print "\nSystem colors (0-15):\n\n";
for ($color = 0; $color < 8; $color++) {
    printcolor($color);
}
print "\x1b[0m\n";
for ($color = 8; $color < 16; $color++) {
    printcolor($color);
}
print "\x1b[0m\n\n";

# now the color cube
print "Color cube, 6x6x6 (16-231):\n";
print "Calculate color code as (36*cube) + (6*row) + column + 16\n";
print "    with cube, row, column in [0,5]\n\n";
for ($green = 0; $green < 6; $green++) {
    for ($red = 0; $red < 6; $red++) {
	for ($blue = 0; $blue < 6; $blue++) {
	    $color = 16 + ($red * 36) + ($green * 6) + $blue;
        printcolor($color);
	}
	print "\x1b[0m ";
    }
    print "\n";
}
print "    16-51        52-87       88-123       124-159      160-195      196-231   \n";


# now the grayscale ramp
print "\nGrayscale ramp, 24 shades (232-255):\n\n";
for ($color = 232; $color < 256; $color++) {
    printcolor($color);
    print "\x1b[0m\n" if (($color - 231) % 6 == 0);
}
print "\x1b[0m\n";

__DATA__
0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
145
146
147
148
149
150
151
152
153
154
155
156
157
158
159
160
161
162
163
164
165
166
167
168
169
170
171
172
173
174
175
176
177
178
179
180
181
182
183
184
185
186
187
188
189
190
191
192
193
194
195
196
197
198
199
200
201
202
203
204
205
206
207
208
209
210
211
212
213
214
215
216
217
218
219
220
221
222
223
224
225
226
227
228
229
230
231
232
233
234
235
236
237
238
239
240
241
242
243
244
245
246
247
248
249
250
251
252
253
254
255
