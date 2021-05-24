#!/usr/bin/env python
"""Shift all textblocks (from the testpos package) by a given offsets.

This program acts as a filter, reading from STDIN and writing to STDOUT.
"""
import sys
import re

RX_TEXTBLOCK = re.compile(
    r"\\begin\{textblock\}\{(?P<width>[0-9.+-]+)\}\s*\(\s*(?P<x>[0-9.+-]+),\s*(?P<y>[0-9.+-]+)\s*\)"
)


def main(argv=None):
    """Main function."""
    if argv is None:
        argv = sys.argv
    try:
        xoffset = float(argv[-2])
        yoffset = float(argv[-1])
    except (ValueError, IndexError):
        sys.stderr.write("Usage: %s XOFFSET YOFFSET\n\n" % argv[0])
        return 1
    for line in sys.stdin:
        match = RX_TEXTBLOCK.search(line)
        if match:
            new_x = float(match.group("x")) + xoffset
            new_y = float(match.group("y")) + yoffset
            replacement = r"\begin{textblock}{%s}(%.2f,%.2f)" % (
                match.group("width"),
                new_x,
                new_y,
            )
            line = line.replace(match.group(0), replacement)
        sys.stdout.write(line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
