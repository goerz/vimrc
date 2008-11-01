#!/usr/bin/python
# -*- coding: utf-8 -*-

############################################################################
#    Copyright (C) 2008 by Michael Goerz                                   #
#    http://www.physik.fu-berlin.de/~goerz                                 #
#                                                                          #
#    This program is free software; you can redistribute it and/or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation; either version 3 of the License, or     #
#    (at your option) any later version.                                   #
#                                                                          #
#    This program is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.                          #
#                                                                          #
#    You should have received a copy of the GNU General Public License     #
#    along with this program; if not, write to the                         #
#    Free Software Foundation, Inc.,                                       #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
############################################################################
"""
Pass STDIN to a screen session (as if it was typed there)
"""

from optparse import OptionParser
import sys
import os


def main(argv=None):
    """
    Main program.
    """
    if argv is None:
        argv = sys.argv
    usage = 'Usage: %s [OPTIONS]' % os.path.basename(sys.argv[0])
    arg_parser = OptionParser(usage=usage)
    arg_parser.add_option('-S', action='store', dest='session',
                          help="screen session name")
    arg_parser.add_option('-p', action='store', dest='window',
                          help="window inside screen session")
    options, args = arg_parser.parse_args(argv)
    if len(args) > 1:
        arg_parser.print_help()
        return 1
    command = 'screen '
    if options.session is not None:
        command += "-S %s " % options.session
    if options.window is not None:
        command += "-p %s " % options.window
    command +=  '-X stuff '

    for line in sys.stdin:
        line = line.replace(chr(92), chr(92)+chr(92)) # \ => \\
        line = line.replace(r'"', chr(92) + '"') # " => \"
        line_command = command + '"' + line + '"'
        os.system(line_command)

    return 0


if __name__ == "__main__":
    sys.exit(main())

