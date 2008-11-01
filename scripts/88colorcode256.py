#!/usr/bin/python

import sys

def color256(a):
    """ map a urxvt colour to an xterm-256 colour"""
    if a == 8:
        return 237
    elif a < 16:
        return a
    elif a > 79:
        return 232 + (3 * (a - 80))
    else:
        b = a - 16
        x = b % 4
        y = (b / 4) % 4
        z = (b / 16)
        return 16 + (x) + color256(6 * color256(y)) + (36 * color256(z))

targetcolor = int(sys.argv[1])
if targetcolor == 255:
    targetcolor = 15

lowermatch = -1
highermatch = 253 
for color in xrange(88):
    replacement = color256(color)
    if replacement < targetcolor:
        if replacement > lowermatch:
            lowermatch = replacement
    if replacement > targetcolor:
        if replacement < highermatch:
            highermatch = replacement
    if replacement == targetcolor:
        print "%s (OK)" % targetcolor
        sys.exit()
print "%s; %s" % (lowermatch, highermatch)



