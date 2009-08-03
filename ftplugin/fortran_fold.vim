"fortran_fold.vim: Fold up a fortran module
" Maintainer: Michael Goerz <goerz@physik.fu-berlin.de>
" Version:    1.0
" Require:    Vim 7 with Python enabled
" License:    GPL3
"   - Put this file into your ~/.vim/ftplugins folder.
" Usage:
""


if has("python")
python << EOF
def FortranFold():
    import subprocess
    import vim
    import re
    debug = False

    if debug: log = open("foldlog.txt", 'w')

    fortran_fold_patterns = {
        'comment'        : re.compile(r'^\s*!!'),
        'declaration'    : re.compile(r' :: '),
        'begin_interface': re.compile(r'^\s*interface'),
        'end_interface'  : re.compile(r'^\s*end interface'),
        'begin_sub'      : re.compile(r'^\s*subroutine'),
        'end_sub'        : re.compile(r'^\s*end subroutine'),
        'begin_function' : re.compile(r'\s*function \w+\s*\('),
        'end_function'   : re.compile(r'^\s*end function'),
        'begin_loop'     : re.compile(r'^\s*do'),
        'end_loop'       : re.compile(r'^\s*end do')
    }

    r = vim.current.range
    line_nr = r.start
    a = line_nr
    aa = line_nr
    aaa = line_nr
    b = line_nr
    bb = line_nr
    bbb = line_nr
    open_loops = 0
    in_comment = False
    in_declaration = False
    in_routine = False
    in_interface = False
    for line in r:
        line_nr = line_nr + 1
        if debug: log.write("%s:%s\n" % (line_nr, line))
        if fortran_fold_patterns['comment'].search(line):
            if not in_comment:
                a = line_nr
                in_comment = True
        else:
            if in_comment:
                in_comment = False
                b = line_nr - 1
                vim.command("%s,%s fold" % (a,b))
                if debug: log.write("*** %s,%s fold comment\n" % (a,b))
        if in_routine and not in_interface:
            if fortran_fold_patterns['declaration'].search(line):
                if debug: log.write("*** matched declaration\n")
                if not in_declaration:
                    aa = line_nr
                    if debug: log.write("*** store declaration\n")
                    in_declaration = True
            elif in_declaration:
                if ( not re.search("^\s*$", line) 
                and not fortran_fold_patterns['begin_interface'].search(line) ):
                    if in_declaration:
                        in_declaration = False
                        bb = line_nr-2
                        if debug: log.write("*** end declaration (%s)\n" %bb)
                        if (bb-aa > 0):
                            vim.command("%s,%s fold" % (aa,bb))
                            if debug: 
                                log.write("*** %s,%s fold declaration\n" 
                                % (aa,bb))
            if fortran_fold_patterns['begin_loop'].search(line):
                if debug: 
                    log.write("*** matched begin_loop (open_loops = %s)\n" 
                    % open_loops)
                if open_loops == 0:
                    aa = line_nr
                    if debug: log.write("*** store loop\n")
                open_loops = open_loops + 1
            if fortran_fold_patterns['end_loop'].search(line):
                open_loops = open_loops - 1
                if debug: 
                    log.write("*** matched end of loop (open_loops = %s)\n" 
                    % open_loops)
                if open_loops == 0:
                    bb = line_nr
                    if (bb-aa > 15):
                        vim.command("%s,%s fold" % (aa,bb))
                        if debug: log.write("*** %s,%s fold loop\n" % (aa,bb))
        if fortran_fold_patterns['begin_sub'].search(line):
            if debug: log.write("*** matched beginning of sub\n")
            if not in_routine and not in_interface:
                in_routine = True
                a = line_nr
                if debug: log.write("*** store sub\n")
        if fortran_fold_patterns['end_sub'].search(line):
            if debug: log.write("*** matched end of sub\n")
            if in_routine and not in_interface:
                in_routine = False
                b = line_nr
                vim.command("%s,%s fold" % (a,b))
                if debug: log.write("*** %s,%s fold routin\n" % (a,b))
        if fortran_fold_patterns['begin_function'].search(line):
            if debug: log.write("*** matched beginning of function\n")
            if not in_routine and not in_interface:
                in_routine = True
                a = line_nr
                if debug: log.write("*** store function\n")
        if fortran_fold_patterns['end_function'].search(line):
            if debug: log.write("*** matched end of function\n")
            if in_routine and not in_interface:
                in_routine = False
                b = line_nr
                vim.command("%s,%s fold" % (a,b))
                if debug: log.write("*** %s,%s fold routine\n" % (a,b))
        if fortran_fold_patterns['begin_interface'].search(line):
            if not in_interface:
                in_interface = True
                aaa = line_nr
                if debug: log.write("*** store interface\n")
        if fortran_fold_patterns['end_interface'].search(line):
            if in_interface:
                in_interface = False
                bbb = line_nr
                vim.command("%s,%s fold" % (aaa,bbb))
                if debug: log.write("*** %s,%s fold interface\n" % (aaa,bbb))

    if debug: log.close()
EOF
cabbr FortranFold python FortranFold()
endif
