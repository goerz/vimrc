#!/bin/bash
# Convert a latex snippet to Sphinx restructured text, assuming the Sphinx cite-extension

pandoc -f latex -t rst \
    | perl -p -e 's/:raw-latex:`\\cite{([\w,\s]+)}`/:cite:`\1`/' \
    | perl -p -e 's/“/"/' \
    | perl -p -e 's/”/"/' \
    | perl -p -e "s/’/'/" \
    | perl -p -e 's/`\[eq:([a-zA-Z0-9_]+)\] <#eq:[a-zA-Z0-9_]+>`__/:eq:`\1`/'
