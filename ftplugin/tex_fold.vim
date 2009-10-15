"latex_fold.vim: Fold up a latex code
" Maintainer: Michael Goerz <goerz@physik.fu-berlin.de>
" Version:    1.0
" Require:    Vim 7 with Python enabled
" License:    GPL3
"   - Put this file into your ~/.vim/ftplugins folder.
" Usage:
""


if has("python")
python << EOF
def LatexFold():
    import subprocess
    import vim
    import re
    debug = True

    if debug: log = open("foldlog.txt", 'w')

    latex_fold_patterns = {
        'blank'          : re.compile(r'^\s*$'),
        'comment'        : re.compile(r'^\s*%'),
        'begin_document' : re.compile(r'^\s*\\begin\{document\}'),
        'begin_env'      : re.compile(r'^\s*\\begin[\[{]'),
        'end_env'        : re.compile(r'^\s*\\end[\[{]'),
        'section'        : re.compile(r'^\s*\\section[\[{]'),
        'subsection'     : re.compile(r'^\s*\\subsection[\[{]')
    }

    r = vim.current.range
    line_nr = r.start
    if (r.start == r.end):
        # if called without range, format entire buffer
        r = vim.current.buffer
        line_nr = 0
    ca = line_nr
    ea = line_nr
    sa = line_nr
    ssa = line_nr
    eb = line_nr
    cb = line_nr
    sb = line_nr
    ssb = line_nr
    in_comment = False
    in_env = False
    in_section = False
    in_subsection = False
    open_env = 0
    blank_block_start = line_nr
    blank_block_end = line_nr
    in_blank_block = False
    for line in r:
        line_nr = line_nr + 1
        if debug: log.write("%s:%s\n" % (line_nr, line))

        if latex_fold_patterns['blank'].search(line):
            if debug: log.write("*** blank line\n")
            if in_blank_block:
                blank_block_end = line_nr
            else:
                in_blank_block = True
                blank_block_start = line_nr
                blank_block_end = line_nr
        else:
            in_blank_block = False

        if latex_fold_patterns['begin_document'].search(line):
            vim.command("%s,%s fold" % (1,line_nr-1))
            if debug: log.write("*** fold preamble\n")

        if latex_fold_patterns['comment'].search(line):
            if not in_comment:
                ca = line_nr
                in_comment = True
        else:
            if in_comment:
                in_comment = False
                cb = line_nr - 1
                vim.command("%s,%s fold" % (ca,cb))
                if debug: log.write("*** %s,%s fold comment\n" % (ca,cb))

        if (latex_fold_patterns['begin_env'].search(line) 
        and "\\begin{document}" not in line):
            if debug: 
                log.write("*** matched begin_env (open_env = %s)\n" 
                % open_env)
            if open_env == 0:
                ea = line_nr
                if debug: log.write("*** store env\n")
            open_env = open_env + 1
        if (latex_fold_patterns['end_env'].search(line)
        and "\\end{document}" not in line):
            open_env = open_env - 1
            if debug: 
                log.write("*** matched end of env (open_env = %s)\n" 
                % open_env)
            if open_env == 0:
                eb = line_nr
                if (eb-eb > 15):
                    vim.command("%s,%s fold" % (ea,eb))
                    if debug: log.write("*** %s,%s fold env\n" % (ea,eb))

        if latex_fold_patterns['section'].search(line):
            if debug: 
                log.write("*** matched section\n")
            if in_subsection:
                ssb = line_nr-1
                if ssb == blank_block_end:
                    if debug: log.write("*** Setting ssb to before blank_block\n")
                    ssb = blank_block_start-1
                vim.command("%s,%s fold" % (ssa,ssb))
                if debug: log.write("*** %s,%s fold subsection\n" % (ssa,ssb))
                in_subsection = False
            if in_section:
                sb = line_nr-1
                if sb == blank_block_end:
                    if debug: log.write("*** Setting sb to before blank_block\n")
                    sb = blank_block_start-1
                vim.command("%s,%s fold" % (sa,sb))
                if debug: log.write("*** %s,%s fold section\n" % (sa,sb))
            in_section = True
            sa = line_nr

        if latex_fold_patterns['subsection'].search(line):
            if debug: 
                log.write("*** matched subsection\n")
            if in_subsection:
                ssb = line_nr-1
                if ssb == blank_block_end:
                    if debug: log.write("*** Setting ssb to before blank_block\n")
                    ssb = blank_block_start-1
                vim.command("%s,%s fold" % (ssa,ssb))
                if debug: log.write("*** %s,%s fold subsection\n" % (ssa,ssb))
            in_subsection = True
            ssa = line_nr

    if in_subsection:
        vim.command("%s,$ fold" % ssa)
        if debug: log.write("*** %s,$ fold subsection\n" % ssa)
    if in_section:
        vim.command("%s,$ fold" % sa)
        if debug: log.write("*** %s,$ fold section\n" % sa)


    if debug: log.close()
EOF
command -bar -range LatexFold :<line1>,<line2> python LatexFold()
endif
