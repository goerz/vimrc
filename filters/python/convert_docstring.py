#!/usr/bin/env python3
"""Convert a RST-formatted docstring to a Google format docstring"""

import re
import sys
import inspect
import textwrap
from collections import OrderedDict

PARAM_REGEX = re.compile(
    ":param (?P<name>[\*\w]+): (?P<doc>.*?)"
    "(?:(?=:param)|(?=:type)|(?=:returns?)|(?=:raises)|(?=:rtype)|\Z)", re.S)
PTYPE_REGEX = re.compile(
    ":type (?P<name>[\*\w]+): (?P<typename>.*?)"
    "(?:(?=:param)|(?=:type)|(?=:returns?)|(?=:raises)|(?=:rtype)|\Z)", re.S)
RTYPE_REGEX = re.compile(
    ":rtype\s*: (?P<typename>.*?)"
    "(?:(?=:param)|(?=:type)|(?=:returns?)|(?=:raises)|(?=:rtype)|\Z)", re.S)
RETURNS_REGEX = re.compile(
    ":returns?\s*: (?P<doc>.*?)"
    "(?:(?=:param)|(?=:type)|(?=:returns?)|(?=:raises)|(?=:rtype)|\Z)", re.S)


def trim(docstring):
    """trim function from PEP-257"""
    if not docstring:
        return ""
    # Convert tabs to spaces (following the normal Python rules)
    # and split into a list of lines:
    lines = docstring.expandtabs().splitlines()
    # Determine minimum indentation (first line doesn't count):
    indent = sys.maxsize
    for line in lines[1:]:
        stripped = line.lstrip()
        if stripped:
            indent = min(indent, len(line) - len(stripped))
    # Remove indentation (first line is special):
    trimmed = [lines[0].strip()]
    if indent < sys.maxsize:
        for line in lines[1:]:
            trimmed.append(line[indent:].rstrip())
    # Strip off trailing and leading blank lines:
    while trimmed and not trimmed[-1]:
        trimmed.pop()
    while trimmed and not trimmed[0]:
        trimmed.pop(0)

    # Current code/unittests expects a line return at
    # end of multiline docstrings
    # workaround expected behavior from unittests
    if "\n" in docstring:
        trimmed.append("")

    # Return a single string:
    return "\n".join(trimmed)



def parse_docstring(docstring):
    """Parse the docstring into its components."""

    returns = rtype = ""

    delimiter_choices = [
        ('"""', '"""'), ("'''", "'''"), ('r"""', '"""'), ("r'''", "'''"), ]

    delimiters = ('', '')
    docstring = inspect.cleandoc(docstring).strip()
    for (quotes_left, quotes_right) in delimiter_choices:
        docstring_is_quoted = (
            docstring.startswith(quotes_left) and
            docstring.endswith(quotes_right))
        if docstring_is_quoted:
            delimiters = (quotes_left, quotes_right)
            docstring = docstring[len(quotes_left):].lstrip()
            docstring = docstring[:-len(quotes_right)].rstrip()
            break

    first_match = 0   # the position of the first match

    matched_strings = []

    params = OrderedDict()
    for match in PARAM_REGEX.finditer(docstring):
        first_match = min(first_match or match.start(), match.start())
        matched_strings.append(match.group())
        if match.group('name') in params:
            params[match.group('name')]['doc'] = match.group('doc').strip()
        else:
            params[match.group('name')] = {
                'doc': match.group('doc').strip(), 'type': ''}
    for match in PTYPE_REGEX.finditer(docstring):
        first_match = min(first_match or match.start(), match.start())
        matched_strings.append(match.group())
        if match.group('name') in params:
            params[match.group('name')]['type'] \
                = match.group('typename').strip()
        else:
            params[match.group('name')] = {
                'doc': '', 'type': match.group('typename').strip()}
    for match in RTYPE_REGEX.finditer(docstring):
        first_match = min(first_match or match.start(), match.start())
        matched_strings.append(match.group())
        rtype = match.group('typename').strip()
    for match in RETURNS_REGEX.finditer(docstring):
        first_match = min(first_match or match.start(), match.start())
        matched_strings.append(match.group())
        returns = match.group('doc').strip()

    description = docstring[:first_match]
    epilogue = docstring[first_match:]
    for matched_string in matched_strings:
        description = description.replace(matched_string, '')
        epilogue = epilogue.replace(matched_string, '')

    return {
        "description": description.strip(),
        "params": params,
        "returns": returns,
        "rtype": rtype,
        "delimiters": delimiters,
        "epilogue": epilogue.strip(),
    }


def format_hanging(text, initial_indent='    ', subsequenet_indent='        '):
    lines = [l.strip() for l in text.split("\n")]
    res = initial_indent + lines[0]
    for line in lines[1:]:
        res += "\n" + subsequenet_indent + line
    return res


def convert_docstring(docstring):
    indentation = re.search(r'^\s*', docstring).group()
    data = parse_docstring(docstring)
    lines = []
    lines.append(data['description'])
    if len(data['params']) > 0:
        lines.append("")
        lines.append("Args:")
    for param_name, param_dict in data['params'].items():
        if len(param_dict['type']) > 0:
            lines.append(format_hanging(
                "%s (%s): %s" % (
                    param_name, param_dict['type'], param_dict['doc'])))
        else:
            lines.append(format_hanging(
                "%s: %s" % (param_name, param_dict['doc'])))
    if len(data['returns']) > 0 or len(data['rtype']) > 0:
        lines.append("")
        lines.append("Returns:")
        if len(data['rtype']) > 0:
            lines.append(format_hanging(
                "%s: %s" % (data['rtype'], data['returns'])))
        else:
            lines.append(format_hanging("%s" % data['returns']))
    lines.append(data['epilogue'])
    res = (data['delimiters'][0] + "\n".join(lines) + data['delimiters'][1])
    while "\n\n\n" in res:
        res = res.replace("\n\n\n", "\n\n")
    res = textwrap.indent(res, indentation)
    return res


if __name__ == "__main__":
    docstring = sys.stdin.read()
    print(convert_docstring(docstring))
