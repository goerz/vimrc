"send.vim: Send the current range to the STDIN of an arbitrary command line
"          program. Special support for sending text to an ipython interpreter
"          running inside screen (via my send2screen.py script)
"          http://users.physik.fu-berlin.de/~goerz/blog/2008/09/integrating-vim-with-ipython/
" Maintainer: Michael Goerz <goerz@physik.fu-berlin.de>
" Version:    2.0
" Require:    Vim 7 with Python enabled
" License:    GPL3
" History:
"   2008-10-20: version 1.0
"   2009-04-12: version 2.0
" Thanks:
"   Peter Battaglia for pointing out indentation issues with ipython.
" Setup:
"   - Put this file into your ~/.vim/plugins folder.
"     You probably also want to get my send2screen.py script.
"   - Change settings in your vimrc:
"     - map keys as you like (see end of this file)
"     - suggestion: enable ipython mode when you're in python files: add
"         let b:sendToProgramMode="ipython"
"       to your python.vim ftplugin, or add
"         autocmd BufNewFile,BufRead *.py let b:sendToProgramMode="ipython"
"       to your .vimrc
" Usage:
"   - Set the program that the plugin should send text to. For example, if
"     you have ipython running in the first tab of a screen session named
"     'ipy', you could use the send2screen.py script to send commands to that
"     ipython by specifying
"     b:sendToProgramName="~/.vim/scripts/send2screen.py -S ipy -p 0"
"   - Specifically if you're sending to ipython, make sure that 
"     b:sendToProgramMode is set to 'ipython'.
"   - If you're not sending to ipython you have the option to set the 
"     value of b:sendSkipBlankLines. As the name implies. Blank lines are
"     not sent if this is 1
"   - Note that all these settings are local to a buffer. You can however
"     also make them global by setting the variables with a g: prefix (i.e
"     g:sendToProgramName instead of b:sendToProgramName). A setting local
"     to a buffer always takes preference over a global setting.
"   - After setting the necessary variables, you can send text with your
"     chosen keymappings.
" " 
""

" option variables: note that you can override these with variables local 
" to each buffer (e.g. b:sendToProgramName)
let g:sendToProgramName=""
let g:sendToProgramMode='' " 'ipython' or leave blank
let g:sendSkipBlankLines=0 " Skip blank lines if enabled. For 'ipython' mode 
                           " blank lines are always skipped, independent of 
                           " this setting

if has("python")
python << EOF
import subprocess
import vim
import re

send_vim_patterns = {
    'indentation'  : re.compile('^(\s\s\s\s)+'),
    'continuation' : re.compile(r'\\$'),
    'emptyline'    : re.compile(r'^\s*$'),
    'first_word'   : re.compile('^([a-z]+)')
}


def se_vim_var(varname):
    """ Read and retrun the contents of the vim variable varname.
        Try to read b:varname, if that doesn't exist try g:varname, if all
        fails, return None.
    """
    if bool(int(vim.eval('exists("b:%s")' % varname))):
        return vim.eval("b:%s" % varname)
    elif bool(int(vim.eval('exists("g:%s")' % varname))):
        return vim.eval("g:%s" % varname)
    return None


def se_state_var(varname, value=None):
    """ Get/set abstract state variable by name. 
        Valid names are 'last_indent', 'f_lastbackslash'

        If value is given, the value of varname is set.
        Returns the value of varname (after it's set)

        I'm using this slightly complicated wrapper for the following reasons:
        state variables should persist between calls. It makes sense however
        to have independent state vars for every buffer. This can
        only be done by storing everything in vim variables (I think). I'm
        using this abstraction layer so that I can change the implementation
        again at a later point
    """
    if varname == 'last_indent':
        if value is not None:
             vim.command("let b:send_var_last_indent=%i" % value)
        try:
            if bool(int(vim.eval('exists("b:send_var_last_indent")'))):
                return int(vim.eval("b:send_var_last_indent"))
            else:
                return se_state_var('last_indent', 0)
        except:
            return None
    elif varname == 'f_lastbackslash':
        if value is not None:
            if value is True:
                vim.command("let b:send_var_f_lastbackslash=1")
            else:
                vim.command("let b:send_var_f_lastbackslash=0")
        try:
            if bool(int(vim.eval('exists("b:send_var_f_lastbackslash")'))):
                return bool(int(vim.eval("b:send_var_f_lastbackslash")))
            else:
                return se_state_var('f_lastbackslash', False)
        except:
            return None
    else:
        raise ValueError("No variable with name %s" % varname)


def send(program_name=None):
    """ Send current range to STDIN of program_name
        
        This defers to ipython_send or default_send, depending on
        b:sendToProgramMode variable
    """
    if program_name is None:
        program_name = se_vim_var("sendToProgramName")
    if (program_name is None) or (program_name == ""):
        print "Please set the 'sendToProgramName' variable. E.g.:"
        print ":let b:sendToProgramName=\"~/.vim/scripts/send2screen.py -S ipy1 -p 1\""
        print ":let b:sendToProgramName=\"pbcopy\""
        return 1
    print ( "sendToProgramName=%s" % program_name )[:80]
    mode = se_vim_var("sendToProgramMode")
    if mode == 'ipython':
        ipython_send(program_name)
    else:
        default_send(program_name)


def ipython_send(program_name=None):
    """ Send current range to STDIN of program_name, modifying it to work as
        input to the ipython interpreter.

        Called from the send() procedure

        You would use this together with an ipython running inside a screen 
        session (e.g. in tab "1" inside a screen session named 'ipy'). The
        sendToProgramName would then be set to my send2screen.py script:
        :let b:sendToProgramName="~/.vim/scripts/send2screen.py -S ipy -p 1"

        ipython now has a few peculiarities (thanks to Peter Battaglia for
        pointing these out): if a block end at indentation level 0, you must
        send an extra newline to tell ipython that the block is finished. The
        keywords 'else', 'except', 'finally', and 'elif' however can occur at
        indentation level 0 but do not close the if/try block they belong to;
        there would be no extra newline in this case.

        Also, we have to be careful with blank lines. The python interpreter,
        running a script, strips them out. That's also what we should do when
        sending python code, otherwise the blank line might accidentally end
        a block.
    """
    r = vim.current.range
    text = "" 

    for line in r:

        # skip empty lines
        if send_vim_patterns['emptyline'].match(line):
            continue 

        # indentation of continuation lines doesn't count: strip it
        if se_state_var('f_lastbackslash'):
            line = line.strip()

        f_backslash = False

        # find out if the current line ends in a backslash, i.e. has a 
        # continuation
        continuation_match = send_vim_patterns['continuation'].search(line)
        f_backslash = False
        if continuation_match:
            f_backslash = True

        # store the number of spaces by which the line is indented in n_indent
        indentation_match = send_vim_patterns['indentation'].match(line)
        n_indent = 0
        if indentation_match:
            n_indent = indentation_match.end()
        if se_state_var('last_indent') == None:
            se_state_var('last_indent', n_indent)
        
        # check the first word of the line to see whether the line is part 
        # of an 'if' or 'try' block
        first_word_match = send_vim_patterns['first_word'].match(line.strip())
        continue_block = False
        if first_word_match:
            continue_block = any(
                     map(lambda word: word==first_word_match.group(),
                         ["elif","else","except","finally"]))

        if ((n_indent == 0)
        and (se_state_var('last_indent') > n_indent) 
        and not continue_block):
            text += "\n"
        text += line + "\n"
        if not se_state_var('f_lastbackslash'):
            se_state_var('last_indent', n_indent)
        se_state_var('f_lastbackslash', f_backslash)

    pipe = subprocess.Popen(program_name, shell=True, bufsize=0, stdin=subprocess.PIPE).stdin
    pipe.write(text)
    pipe.close()


def default_send(program_name=None):
    """ Send current range to STDIN of program_name

        Called from the send() procedure

        If sendSkipBlankLines is set, blank lines are skipped.
        Beyond that, no change is made to the text
    """
    r = vim.current.range
    text = "" 

    for line in r:
        if send_vim_patterns['emptyline'].match(line):
            try:
                if int(se_vim_var("sendSkipBlankLines")) == 1:
                    continue 
            except:
                continue
        text += line + "\n"

    pipe = subprocess.Popen(program_name, shell=True, bufsize=0, stdin=subprocess.PIPE).stdin
    pipe.write(text)
    pipe.close()

EOF

" You may want to use the following mappings:
"nmap <leader>s :. python send()<cr>
"vmap <leader>s : python send()<cr>gv<esc>

endif
