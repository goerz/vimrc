#!/usr/bin/env python3
"""This script fixes RST-links in the QNET documentation"""

import re
import logging

import click

import qnet

__version__ = '0.1.0'

RST_RX = re.compile(
    r':(?P<directive>(func|exc|class|attr|meth)):'
    r'`(?P<prefix>[.~]*)(?P<target>.*?)`')


@click.command()
@click.help_option('--help', '-h')
@click.version_option(version=__version__)
@click.option(
    '--debug', is_flag=True, help='enable debug logging')
@click.option(
    '--currentmodule', help='Full path of the "current module" to be '
    'omitted from any target name')
@click.argument('infile', type=click.Path(exists=True), required=False)
def main(debug, currentmodule, infile):
    """Fix RST-links in the QNET documentation

    If INFILE not given, read from STDIN.
    """
    logging.basicConfig(level=logging.WARNING)
    logger = logging.getLogger(__name__)
    if debug:
        logger.setLevel(logging.DEBUG)
        logger.debug("Enabled debug output")
    replacements = {}
    stdout = click.get_text_stream('stdout')
    if infile is None:
        infile = '-'  # STDIN
    with click.open_file(infile) as stdin:
        for line in stdin:
            for match in RST_RX.finditer(line):
                if "." in match.group('prefix'):
                    # We leave "." prefixes alone
                    continue
                if match.group('directive') in ['func', 'class']:
                    obj_name = match.group('target').split(".")[-1]
                    atr_name = None
                else:
                    try:
                        obj_name, atr_name = (
                            match.group('target').split(".")[-2:])
                    except ValueError as exc_info:
                        logger.debug(str(exc_info))
                        continue
                try:
                    obj = getattr(qnet, obj_name)
                    target = obj.__module__ + "." + obj_name
                    if atr_name is not None:
                        target += "." + atr_name
                    if currentmodule is not None:
                        if target.startswith(currentmodule):
                            target = target.replace(currentmodule, '')
                    replacements[match.group()] = \
                        r':{directive}:`{prefix}{target}`'.format(
                            directive=match.group('directive'),
                            prefix=match.group('prefix'), target=target)
                except AttributeError as exc_info:
                    logger.debug(str(exc_info))
                    continue
            for string, replacement in replacements.items():
                line = line.replace(string, replacement)
            stdout.write(line)


def test_rx():
    s = r':func:`~qnet.algebra.abstract_algebra.substitute`'
    match = RST_RX.match(s)
    assert match
    assert match.group() == s
    assert match.group('directive') == 'func'
    assert match.group('prefix') == '~'
    assert match.group('target') == 'qnet.algebra.abstract_algebra.substitute'


if __name__ == "__main__":
    main()
