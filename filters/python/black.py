#!/usr/bin/env python3
"""Run text through the Black formatter, as a filter"""

from tempfile import NamedTemporaryFile
import logging
import subprocess
import os

import click

__version__ = '0.1.0'


def _get_black_executable():
    candidates = [os.path.expanduser('~/.vim/black/bin/black')]
    for black in candidates:
        if os.path.isfile(black):
            return black
    return 'black'


@click.command()
@click.help_option('--help', '-h')
@click.version_option(version=__version__)
@click.option('--debug', is_flag=True, help='enable debug logging')
@click.option(
    '--executable',
    default=_get_black_executable(),
    help='executable for black',
)
@click.option(
    '--line-length',
    '-l',
    type=int,
    default=79,
    help='How many characters per line to allow. [default: 79]',
)
@click.option(
    '--string-normalization/--no-string-normalization',
    '-s/-S',
    default=False,
    help="Whether or not to apply string normalization [default: off]",
)
@click.option(
    '--safe/--fast',
    default=True,
    help="If --fast given, skip temporary sanity checks",
)
@click.argument('infile', type=click.Path(exists=True), required=False)
def main(debug, executable, line_length, string_normalization, safe, infile):
    """Fix RST-links in the QNET documentation

    If INFILE not given, read from STDIN.
    """
    logging.basicConfig(level=logging.WARNING)
    logger = logging.getLogger(__name__)
    if debug:
        logger.setLevel(logging.DEBUG)
        logger.debug("Enabled debug output")
    stdout = click.get_text_stream('stdout')
    if infile is None:
        infile = '-'  # STDIN
    with click.open_file(infile) as stdin:
        data = stdin.read()
        with NamedTemporaryFile(
            mode='w', suffix='.py', delete=False
        ) as temp_fh:
            temp_fh.write(data)
            filename = temp_fh.name
    cmd = [executable, '-l', str(line_length)]
    if not string_normalization:
        cmd.append('-S')
    if safe:
        cmd.append('--safe')
    else:
        cmd.append('--fast')
    cmd.append(filename)
    try:
        msg = subprocess.check_output(
            cmd, stderr=subprocess.STDOUT, universal_newlines=True
        )
        with open(filename) as temp_fh:
            stdout.write(temp_fh.read())
    except subprocess.CalledProcessError as exc_info:
        stdout.write(data)
        logger.debug(exc_info.output)
    else:
        logger.debug(msg)


if __name__ == "__main__":
    main()
