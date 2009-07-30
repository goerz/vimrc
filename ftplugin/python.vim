setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class 
setlocal foldnestmax=2
setlocal ts=4 
setlocal formatoptions=croql 
setlocal textwidth=79 nofoldenable 
setlocal omnifunc=pythoncomplete#Complete
setlocal keywordprg='$HOME/.vim/scripts/python_help.pl'
setlocal pumheight=15
setlocal completeopt=menu,menuone
compiler pylint
let b:sendToProgramMode="ipython"
let b:SuperTabDefaultCompletionType = "<c-x><c-o>"

setlocal tags+=/usr/lib/python/tags

python << EOF
import vim

def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
       "%(space)spdb.set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

    for strLine in vim.current.buffer:
        if strLine == "import pdb":
            break
    else:
        vim.current.buffer.append( 'import pdb', 0)
        vim.command( 'normal j1')

vim.command( 'map <f7> :py SetBreakpoint()<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == 'import pdb' or strLine.lstrip()[:15] == 'pdb.set_trace()':
            nLines.append( nLine)
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

vim.command( 'map <s-f7> :py RemoveBreakpoints()<cr>')
EOF
