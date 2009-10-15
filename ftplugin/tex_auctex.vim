" Vim filetype plugin
" Language:	LaTeX
" Maintainer: Michael Goerz <goerz@physik.fu-berlin.de>
" Last Change:	Thu 10/15/09 20:37:53 CEST

" "========================================================================="
" Explanation and Customization   {{{

let b:AMSLatex = 1
let b:DoubleDollars = 0
" prefix for the "Greek letter" macros (For personal macros, it is ';')
let mapleader = '`'

" Set b:AMSLatex to 1 if you are using AMSlatex.  Otherwise, the program will 
" attempt to automatically detect the line \usepackage{...amsmath...} 
" (uncommented), which would indicate AMSlatex.  This is mainly for the 
" function keys F1 - F5, which insert the most common environments, and 
" C-F1 - C-F5, which change them.  See "Inserting and Changing Environments"
" for information.
" Set b:DoubleDollars to 1 if you use $$...$$ instead of \[...\]
" With b:DoubleDollars = 1, C-F1 - C-F5 will not work in nested environments.

" Auctex-style macros for Latex typing.
" You will have to customize the functions RunLatex(), Xdvi(), 

" Thanks to Peppe Guldberg for important suggestions.
"
" Please read the comments in the file for an explanation of all the features.
" One of the main features is that the "mapleader" (set to "`" see above),
" triggers a number of macros (see "Embrace the visual region" and 
" "Greek letters".  For example, `a would result in \alpha.  
" There are many other features;  read the file.

" Vim commands to run latex and the dvi viewer.
" Must be of the form "! ... % ..."
" The following command may make xdvi automatically update.
"let b:latex_command = "! xterm -bg ivory -fn 7x14 -e latex \\\\nonstopmode \\\\input\\{%\\}; cat %<.log"
"let b:latex_command = "! xterm -e latex \\\\nonstopmode \\\\input\\{%\\}"
let b:latex_command = "!latex \\\\nonstopmode \\\\input\\{%\\}"
let b:dvi_viewer_command = "! xdvi -expert -s 6 -margins 2cm -geometry 750x950 %< &"
"let b:dvi_viewer_command = "! kdvi %< &"

" Switch to the directory of the tex file.  Thanks to Fritz Mehner.
" This is useful for starting xdvi, or going to the next tex error.
" autocmd BufEnter *.tex :cd %:p:h

" If you are using Windows, modify b:latex_command above, and set 
" b:windows below equal to 1
let b:windows = 0

" Select which quotes should be used
let b:leftquote = "``"
let b:rightquote = "''"
if &spelllang == 'de_20'
    let b:leftquote = '"`'
    let b:rightquote = "\"'"
endif

" }}}
" "========================================================================="
" Mapping for Xdvi Search   {{{

noremap <buffer> <C-LeftMouse> :execute "!xdvi -name -xdvi -sourceposition ".line(".").expand("%")." ".expand("%:r").".dvi"<CR><CR>

" }}}
" "========================================================================="
" Tab key mapping   {{{
" In a math environment, the tab key moves between {...} braces, or to the end
" of the line or the end of the environment.  Otherwise, it does word
" completion.  But if the previous character is a blank, or if you are at the
" end of the line, you get a tab.  If the previous characters are \ref{
" then a list of \label{...} completions are displayed.  Choose one by
" clicking on it and pressing Enter.  q quits the display.  Ditto for 
" \cite{, except you get to choose from either the bibitem entries, if any,
" or the bibtex file entries.
" This was inspired by the emacs package Reftex.

inoremap <buffer><silent> <Tab> <C-R>=<SID>TexInsertTabWrapper('backward')<CR>
inoremap <buffer><silent> <M-Space> <C-R>=<SID>TexInsertTabWrapper('backward')<CR>
inoremap <buffer><silent> <C-Space> <C-R>=<SID>TexInsertTabWrapper('forward')<CR>

function! s:TexInsertTabWrapper(direction) 

    " Check to see if you're in a math environment.  Doesn't work for $$...$$.
    let line = getline('.')
    let len = strlen(line)
    let column = col('.') - 1
    let ending = strpart(line, column, len)
    let n = 0

    let dollar = 0
    while n < strlen(ending)
	if ending[n] == '$'
	    let dollar = 1 - dollar
	endif
	let n = n + 1
    endwhile

    let math = 0
    let ln = line('.')
    while ln > 1 && getline(ln) !~ '\\begin\|\\end\|\\\]\|\\\['
	let ln = ln - 1
    endwhile
    if getline(ln) =~ 'begin{\(eq\|arr\|align\|mult\)\|\\\['
	let math = 1
    endif
    let math = 0 " disable this math crap!!!!

    " Check to see if you're between brackets in \ref{} or \cite{}.
    " Inspired by RefTex.
    " Typing q returns you to editing
    " Typing <CR> or Left-clicking takes the data into \ref{} or \cite{}.
    " Within \cite{}, you can enter a regular expression followed by <Tab>,
    " Only the citations with matching authors are shown.
    " \cite{c.*mo<Tab>} will show articles by Mueller and Moolinar, for example.
    " Once the citation is shown, you type <CR> anywhere within the citation.
    " The bibtex files listed in \bibliography{} are the ones shown.
    if strpart(line,column-5,5) == '\ref{'
	let name = bufname(1)
	let short = substitute(name, ".*/", "", "")
	let aux = strpart(short, 0, strlen(short)-3)."aux"
	if filereadable(aux)
	    let tmp = tempname()
	    execute "below split ".tmp
	    execute "0read ".aux
	    g!/^\\newlabel{/delete
	    g/.*/normal 3f{lyt}0Pf}D0f\cf{       
	    execute "write! ".tmp

	    noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>RefInsertion("aux")<CR>a
	    noremap <buffer> <CR> :call <SID>RefInsertion("aux")<CR>a
	    noremap <buffer> q :bwipeout!<CR>i
	    return "\<Esc>"
	else
	    let tmp = tempname()
	    vertical 15split
	    execute "write! ".tmp
	    execute "edit ".tmp
	    g!/\\label{/delete
	    %s/.*\\label{//e
	    %s/}.*//e
	    noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>RefInsertion(0)<CR>a
	    noremap <buffer> <CR> :call <SID>RefInsertion(0)<CR>a
	    noremap <buffer> q :bwipeout!<CR>i
	    return "\<Esc>"
	endif
    elseif match(strpart(line,0,column),'\\cite{[^}]*$') != -1
	let m = matchstr(strpart(line,0,column),'[^{]*$')
	let tmp = tempname()
        execute "write! ".tmp
        execute "split ".tmp

	if 0 != search('\\begin{thebibliography}')
	    bwipeout!
	    execute "below split ".tmp
	    call search('\\begin{thebibliography}')
	    normal kdgg
	    noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>BBLCiteInsertion('\\bibitem')<CR>a
	    noremap <buffer> <CR> :call <SID>CiteInsertion('\\bibitem')<CR>a
	    noremap \<buffer> q :bwipeout!<CR>i
	    return "\<Esc>"
	else
	    let l = search('\\bibliography{')
	    bwipeout!
	    if l == 0
		return ''
	    else
		let s = getline(l)
		let beginning = matchend(s, '\\bibliography{')
		let ending = matchend(s, '}', beginning)
		let f = strpart(s, beginning, ending-beginning-1)
		let tmp = tempname()
		execute "below split ".tmp
		let file_exists = 0

		let name = bufname(1)
		let base = substitute(name, "[^/]*$", "", "")
		while f != ''
		    let comma = match(f, ',[^,]*$')
		    if comma == -1
			let file = base.f.'.bib'
			if filereadable(file)
			    let file_exists = 1
			    execute "0r ".file
			endif
			let f = ''
		    else
			let file = strpart(f, comma+1)
			let file = base.file.'.bib'
			if filereadable(file)
			    let file_exists = 1
			    execute "0r ".file
			endif
			let f = strpart(f, 0, comma)
		    endif
		endwhile

		if file_exists == 1
		    if strlen(m) != 0
			%g/author\c/call <SID>BibPrune(m)
		    endif
		    noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>CiteInsertion("@")<CR>a
		    noremap <buffer> <CR> :call <SID>CiteInsertion("@")<CR>a
		    noremap \<buffer> q :bwipeout!<CR>i
		    return "\<Esc>"
		else
		    bwipeout!
		    return ''
		endif

	    endif
	endif
    elseif dollar == 1   " If you're in a $..$ environment
	if ending[0] =~ ')\|]\||'
	    return "\<Right>"
	elseif ending =~ '^\\}'
	    return "\<Right>\<Right>"
	elseif ending =~ '^\\right\\'
	    return "\<Esc>8la"
	elseif ending =~ '^\\right'
	    return "\<Esc>7la"
	elseif ending =~ '^}\(\^\|_\|\){'
	    return "\<Esc>f{a"
	elseif ending[0] == '}'
	    return "\<Right>"
	else
	    return "\<Esc>f$a"
	end
	"return "\<Esc>f$a"
    elseif math == 1    " If you're in a regular math environment.
	if ending =~ '^\s*&'
	    return "\<Esc>f&a"
        elseif ending[0] =~ ')\|]\||'
	    return "\<Right>"
	elseif ending =~ '^\\}'
	    return "\<Right>\<Right>"
	elseif ending =~ '^\\right\\'
	    return "\<Esc>8la"
	elseif ending =~ '^\\right'
	    return "\<Esc>7la"
	elseif ending =~ '^}\(\^\|_\|\){'
	    return "\<Esc>f{a"
	elseif ending[0] == '}'
	    if line =~ '\\label'
		return "\<Down>"
	    else
		return "\<Esc>f}a"
	    endif
	elseif column == len    "You are at the end of the line.
	    call search("\\\\end\\|\\\\]")
	    return "\<Esc>o"
	else
	    return "\<C-O>$"
	endif
    else   " If you're not in a math environment.
	" Thanks to Benoit Cerrina (modified)
	if ending[0] =~ ')\|}'  " Go past right parentheses.
	    return "\<Right>"
	elseif !column || line[column - 1] !~ '\k' 
	    return "\<Tab>" 
	elseif a:direction == 'backward'
	    return "\<C-P>" 
	else 
	    return "\<C-N>" 
	endif 

    endif
endfunction 

" Inspired by RefTex
function! s:RefInsertion(x)
    if a:x == "aux"
	normal 0Wy$
    else
	normal 0y$
    endif
    bwipeout!
    let thisline = getline('.')
    let thiscol  = col('.')
    if thisline[thiscol-1] == '{'
	normal p
    else
	normal P
	if thisline[thiscol-1] == '}'
	    normal l
	    if thisline[thiscol] == ')'
		normal l
	    endif
	endif
    endif
endfunction

" Inspired by RefTex
function! s:OldRefInsertion()
    normal 0y$
    bwipeout!
    let thisline = getline('.')
    let thiscol  = col('.')
    if thisline[thiscol-1] == '{'
	normal p
    else
	normal P
	if thisline[thiscol-1] == '}'
	    normal l
	    if thisline[thiscol] == ')'
		normal l
	    endif
	endif
    endif
endfunction

" Inspired by RefTex
" Get citations from the .bib file or from the bibitem entries.
function! s:CiteInsertion(x)
    +
    "if search('@','b') != 0
    if search(a:x, 'b') != 0
	if a:x == "@"
	    normal f{lyt,
	else
	    normal f{lyt}
	endif
        bwipeout!
        let thisline = getline('.')
        let thiscol  = col('.')
        if thisline[thiscol-1] == '{'
	    normal p
        else
	    if thisline[thiscol-2] == '{'
	         normal P
	    else
	         normal T{"_dt}P
	    endif
	    normal l
        endif
    else
        bwipeout!
    endif
endfunction

function! s:BibPrune(m)
    if getline(line('.')) !~? a:m
        ?@
        let lfirst = line('.')
        /@
        let lsecond = line('.')
        if lfirst < lsecond
	    execute lfirst.','.(lsecond-1).'delete'
        else
	    execute lfirst.',$delete'
        endif
    endif
endfunction

" }}}
" "========================================================================="
" Run Latex, View, Ispell   {{{

" Key Bindings  {{{

" Run Latex;  change these bindings if you like.
"noremap <buffer><silent> K :call <SID>RunLatex()<CR><Esc>
"noremap <buffer><silent> <C-K> :call <SID>NextTexError()<CR>
"noremap <buffer><silent> <S-Tab> :call <SID>NextTexError()<CR>
"noremap <buffer><silent> <C-Tab> :call <SID>RunLatex()<CR><Esc>
"inoremap <buffer><silent> <C-Tab> <C-O>:call <SID>RunLatex()<CR><Esc>

noremap <buffer><silent> \lr :call <SID>CheckReferences('Reference', 'ref')<CR><Space>
noremap <buffer><silent> \lc :call <SID>CheckReferences('Citation', 'cite')<CR><Space>
noremap <buffer><silent> \lg :call <SID>LookAtLogFile()<CR>gg/LaTeX Warning\\|^!<CR>

" Run the Latex viewer;  change these bindings if you like.
"noremap <buffer><silent> <S-Esc> :call <SID>Xdvi()<CR><Space>
"inoremap <buffer><silent> <S-Esc> <Esc>:call <SID>Xdvi()<CR><Space>

" Run Ispell on either the buffer, or the visually selected word.
"noremap <buffer><silent> <S-Insert> :w<CR>:!xterm -bg ivory -fn 10x20 -e ispell %<CR><Space>:e %<CR>:redraw<CR>:echo "No (more) spelling errors."<CR>
"inoremap <buffer><silent> <S-Insert> <Esc>:w<CR>:!xterm -bg ivory -fn 10x20 -e ispell %<CR><Space>:e %<CR>:redraw<CR>:echo "No (more) spelling errors."<CR>
"vnoremap <buffer><silent> <S-Insert> <C-C>`<v`>s<Space><Esc>mq<C-W>s:e ispell.tmp<CR>i<C-R>"<Esc>:w<CR>:!xterm -bg ivory -fn 10x20 -e ispell %<CR><CR>:e %<CR><CR>ggVG<Esc>`<v`>s<Esc>:bwipeout!<CR>:!rm ispell.tmp*<CR>`q"_s<C-R>"<Esc>:redraw<CR>:echo "No (more) spelling errors."<CR>

" Run Ispell (Thanks the Charles Campbell)
" The first set is for vim, the second set for gvim.
"noremap <buffer> <S-Insert> :w<CR>:silent !ispell %<CR>:e %<CR><Space>
"inoremap <buffer> <S-Insert> <Esc>:w<CR>:silent !ispell %<CR>:e %<CR><Space>
"vnoremap <buffer> <S-Insert> <C-C>'<c'><Esc>:e ispell.tmp<CR>p:w<CR>:silent !ispell %<CR>:e %<CR><CR>ggddyG:bwipeout!<CR>:silent !rm ispell.tmp*<CR>pkdd
"vnoremap <buffer> <S-Insert> <C-C>`<v`>s<Space><Esc>mq:e ispell.tmp<CR>i<C-R>"<Esc>:w<CR>:silent !ispell %<CR>:e %<CR><CR>ggVG<Esc>`<v`>s<Esc>:bwipeout!<CR>:!rm ispell.tmp*<CR>`q"_s<C-R>"<Esc>

" Find Latex Errors
" To find the tex error, first run Latex (see the 2 previous maps).
" If there is an error, press "x" or "r" to stop the Tex processing.
" Then press Shift-Tab to go to the position of the error.
"noremap <buffer><silent> <S-Tab> :call <SID>NextTexError()<CR><Space>
"inoremap <buffer><silent> <S-Tab> <Esc>:call <SID>NextTexError()<CR><Space>

" }}}

" Functions  {{{

function! s:RunLatex()
    update
    execute 'silent ' . b:latex_command
    if b:windows != 1
	call <SID>NextTexError()
    endif
endfunction

" Stop warnings, since the log file is modified externally and then 
" read again.
au BufRead *.log    set bufhidden=unload

function! s:NextTexError()
    silent only
    let name = bufname(1)
    let short = substitute(name, ".*/", "", "")
    let log = strpart(short, 0, strlen(short)-3)."log"
    execute "above split ".log
    if search('^l\.\d') == 0
        if search('LaTeX Warning: .* multiply') == 0
	    bwipeout
	    call input('No (More) Errors Found.')
	else
	    syntax clear
	    syntax match err /^LaTeX Warning: .*/
	    highlight link err ToDo

	    if getline('.') =~ 'multiply'

		let multiply = matchstr(getline('.'), 'Label .* multiply')
		let multiply = strpart(multiply, 7, strlen(multiply)-17)
		let command = "normal! \<C-W>w1G/\\label{" . multiply . "}\<CR>6l\<C-W>Kzz\<C-W>wzz\<C-W>w"
	    else
		let command = "normal! \<C-W>Kzz\<C-W>wzz\<C-W>w"
	    endif

	    execute command
	endif
    else
	syntax clear
	syntax match err /! .*/
	syn match err /^ l\.\d.*\n.*$/
	highlight link err ToDo
	let linenumber = matchstr(getline('.'), '\d\+')
	let errorposition = col('$') - strlen(linenumber) - 5
	if errorposition < 1
	    let command = 'normal! ' . linenumber . "Gzz\<C-W>wzz\<C-W>w"
	else
	    let command = 'normal! ' . linenumber . 'G' . errorposition . "lzz\<C-W>wzz\<C-W>w"
	endif
	    "Put a space in the .log file so that you can see where you were,
	    "and move on to the next latex error.
	s/^/ /
	write
	wincmd x
	execute command
    endif
endfunction

" Run xdvi
function! s:Xdvi()
    update
    execute 'silent ' . b:latex_command
    execute 'silent ' . b:latex_command
    execute b:dvi_viewer_command 
endfunction

function! s:CheckReferences(name, ref)
    "execute "noremap \<buffer> \<C-L> :call \<SID>CheckReferences(\"" . a:name . "\",\"" . a:ref . "\")\<CR>\<Space>"
    only
    edit +1 %<.log
    syntax clear
    syntax match err /LaTeX Warning/
    highlight link err ToDo
    if search('^LaTeX Warning: ' . a:name) == 0
	edit #
	redraw
	call input('No (More) ' . a:name . ' Errors Found.')
    else
	let linenumber = matchstr(getline('.'), '\d\+\.$')
	let linenumber = strpart(linenumber, 0, strlen(linenumber)-1)
	let reference = matchstr(getline('.'), "`.*\'")
	let reference = strpart(reference, 1, strlen(reference)-2)
	    "Put a space in the .log file so that you can see where you were,
	    "and move on to the next latex error.
	s/^/ /
	write
	split #
	execute "normal! " . linenumber . "Gzz\<C-W>wzz\<C-W>w"
	execute "normal! /\\\\" . a:ref . "{" . reference . "}\<CR>"
	execute "normal! /" . reference . "\<CR>"
    endif
endfunction

function! s:LookAtLogFile()
    only
    edit +1 %<.log
    syntax clear
    syntax match err /LaTeX Warning/
    syntax match err /! .*/
    syntax match err /^Overfull/
    syntax match err /^Underfull/
    highlight link err ToDo
    noremap <buffer> K :call <SID>GetLineFromLogFile()<CR>
    split #
    wincmd b
    /LaTeX Warning\|^\s*!\|^Overfull\|^Underfull
    let @/='LaTeX Warning\|^\s*!\|^Overfull\|^Underfull'
    echo "\nGo to the line in the log file which mentions the error\nthen type K to go to the line\nn to go to the next warning\n"
endfunction

function! s:GetLineFromLogFile()
    let line = matchstr(getline('.'), 'line \d\+')
    wincmd t
    execute strpart(line, 5, strlen(line)-5)
endfunction

" }}}

" }}}
" "========================================================================="
" Greek letters, AucTex style bindings   {{{

" No timeout.  Applies to mappings such as `a for \alpha
set notimeout

inoremap <buffer> <Leader><Leader> <Leader>
inoremap <buffer> <Leader>a \alpha
inoremap <buffer> <Leader>b \beta
inoremap <buffer> <Leader>c \chi
inoremap <buffer> <Leader>d \delta
inoremap <buffer> <Leader>e \epsilon
inoremap <buffer> <Leader>f \phi
inoremap <buffer> <Leader>g \gamma
inoremap <buffer> <Leader>h \eta
inoremap <buffer> <Leader>i \iota
inoremap <buffer> <Leader>k \kappa
inoremap <buffer> <Leader>l \lambda
inoremap <buffer> <Leader>m \mu
inoremap <buffer> <Leader>n \nu
inoremap <buffer> <Leader>o \omega
inoremap <buffer> <Leader>p \pi
inoremap <buffer> <Leader>q \theta
inoremap <buffer> <Leader>r \rho
inoremap <buffer> <Leader>s \sigma
inoremap <buffer> <Leader>t \tau
inoremap <buffer> <Leader>u \upsilon
inoremap <buffer> <Leader>v \vee
inoremap <buffer> <Leader>w \wedge
inoremap <buffer> <Leader>x \xi
inoremap <buffer> <Leader>y \psi
inoremap <buffer> <Leader>z \zeta
inoremap <buffer> <Leader>D \Delta
inoremap <buffer> <Leader>I \int\limits_{}^{}<Esc>F}i
inoremap <buffer> <Leader>E \varepsilong
inoremap <buffer> <Leader>F \Phi
inoremap <buffer> <Leader>G \Gamma
inoremap <buffer> <Leader>G \varphi
inoremap <buffer> <Leader>L \Lambda
inoremap <buffer> <Leader>N \nabla
inoremap <buffer> <Leader>O \Omega
inoremap <buffer> <Leader>P \Pi
inoremap <buffer> <Leader>Q \Theta
inoremap <buffer> <Leader>R \varrho
inoremap <buffer> <Leader>S \Sigma
inoremap <buffer> <Leader>T \vartheta
inoremap <buffer> <Leader>Z \sum\limits_{}^{}<Esc>F}i
inoremap <buffer> <Leader>U \Upsilon
inoremap <buffer> <Leader>X \Xi
inoremap <buffer> <Leader>Y \Psi
inoremap <buffer> <Leader>0 \emptyset
inoremap <buffer> <Leader>1 \left
inoremap <buffer> <Leader>2 \right
inoremap <buffer> <Leader>3 \Big
inoremap <buffer> <Leader>6 \difquo
inoremap <buffer> <Leader>8 \infty
inoremap <buffer> <Leader>/ \frac{}{}<Esc>F}i
inoremap <buffer> <Leader>% \frac{}{}<Esc>F}i
inoremap <buffer> <Leader>@ \circ
inoremap <buffer> <Leader>\| \Big\|
inoremap <buffer> <Leader>= \equiv
inoremap <buffer> <Leader>\ \setminus
inoremap <buffer> <Leader>. \cdot
inoremap <buffer> <Leader>* \times
inoremap <buffer> <Leader>& \wedge
inoremap <buffer> <Leader>- \bigcap
inoremap <buffer> <Leader>+ \bigcup
inoremap <buffer> <Leader>( \left(  \right)<++><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
inoremap <buffer> <Leader>[ \left[  \right]<++><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
inoremap <buffer> {} {}<Left>
inoremap <buffer> () ()<Left>
inoremap <buffer> $$ $$<Left>
inoremap <buffer> <Leader>< \leq
inoremap <buffer> <Leader>> \geq
inoremap <buffer> <Leader>, \nonumber
inoremap <buffer> <Leader>: \cdots
inoremap <buffer> <Leader>~ \tilde{}<Left>
inoremap <buffer> <Leader>^ \op{}<Left>
inoremap <buffer> <Leader>; \dot{}<Left>
inoremap <buffer> <Leader>_ \bar{}<Left>
inoremap <buffer> <Leader><C-E> \exp\left(\right)<Esc>F(a
inoremap <buffer> <Leader><C-L> \lim_{}<Left>
inoremap <buffer> <Leader><Up> \uparrow
inoremap <buffer> <Leader><Down> \downarrow
inoremap <buffer> <Leader><Right> \longrightarrow
inoremap <buffer> <Leader><Left> \leftarrow
inoremap <buffer> <Leader><C-F> \to

" }}}
" "========================================================================="
" Smart quotes.   {{{
" Thanks to Ron Aaron <ron@mossbayeng.com>.
function! s:TexQuotes()
    let insert = b:rightquote
    let left = getline('.')[col('.')-2]
    if left =~ '^\(\|\s\)$'
	let insert = b:leftquote
    elseif left == '\'
	let insert = '"'
    endif
    return insert
endfunction
inoremap <buffer> " <C-R>=<SID>TexQuotes()<CR>

" }}}
" "========================================================================="
" Typing ... results in \ldots or \cdots   {{{

" Use this if you want . to result in a just a period, with no spaces.
function! s:Dots(var)
    let column = col('.')
    let currentline = getline('.')
    let left = strpart(currentline ,column-3,2)
    let before = currentline[column-4]
    if left == '..'
        if a:var == 0
        if before == ','
        return "\<BS>\<BS>\\ldots"
        else
        return "\<BS>\<BS>\\cdots"
        endif
        else
        return "\<BS>\<BS>\\dots"
    endif
    else
       return '.'
    endif
endfunction
" Uncomment the next line, and comment out the line after,
" if you want the script to decide between latex and amslatex.
" This slows down the macro.
"inoremap <buffer><silent> . <C-R>=<SID>Dots(<SID>AmsLatex(b:AMSLatex))<CR>
inoremap <buffer><silent> . <Space><BS><C-R>=<SID>Dots(b:AMSLatex)<CR>
" Note: <Space><BS> makes word completion work correctly.

" }}}
" "========================================================================="
" _{} and ^{}   {{{

" Typing __ results in _{}
function! s:SubBracket()
    let insert = '_'
    let left = getline('.')[col('.')-2]
    if left == '_'
	let insert = "{}\<Left>"
    endif
    return insert
endfunction
inoremap <buffer><silent> _ <C-R>=<SID>SubBracket()<CR>

" Typing ^^ results in ^{}
function! s:SuperBracket()
    let insert = '^'
    let left = getline('.')[col('.')-2]
    if left == '^'
	let insert = "{}\<Left>"
    endif
    return insert
endfunction
inoremap <buffer><silent> ^ <C-R>=<SID>SuperBracket()<CR>

" }}}
" "========================================================================="
" Bracket Completion Macros   {{{

" Key Bindings                {{{

" Typing the symbol a second time (for example, $$) will result in one
" of the symbole (for instance, $).  With {, typing \{ will result in \{\}.
"inoremap <buffer><silent> ( <C-R>=<SID>Double('(',')')<CR>
"inoremap <buffer><silent> [ <C-R>=<SID>Double('[',']')<CR>
"inoremap <buffer><silent> [ <C-R>=<SID>CompleteSlash('[',']')<CR>
"inoremap <buffer><silent> $ <C-R>=<SID>Double('$','$')<CR>
"inoremap <buffer><silent> & <C-R>=<SID>DoubleAmpersands()<CR>
"inoremap <buffer><silent> { <C-R>=<SID>CompleteSlash('{','}')<CR>
"inoremap <buffer><silent> \| <C-R>=<SID>CompleteSlash("\|","\|")<CR>

" If you would rather insert $$ individually, the following macro by 
" Charles Campbell will make the cursor blink on the previous dollar sign,
" if it is in the same line.
" inoremap <buffer> $ $<C-O>F$<C-O>:redraw!<CR><C-O>:sleep 500m<CR><C-O>f$<Right>

" }}}

" Functions         {{{

" For () and $$
function! s:Double(left,right)
    if strpart(getline('.'),col('.')-2,2) == a:left . a:right
	return "\<Del>"
    else
	return a:left . a:right . "\<Left>"
    endif
endfunction

" Complete [, \[, {, \{, |, \|
function! s:CompleteSlash(left,right)
    let column = col('.')
    let first = getline('.')[column-2]
    let second = getline('.')[column-1]
    if first == "\\"
	if a:left == '['
	    return "\[\<CR>\<CR>\\]\<Up>"
	else
	    return a:left . "\\" . a:right . "\<Left>\<Left>"
	endif
    else
	if a:left =~ '\[\|{'
	\ && strpart(getline('.'),col('.')-2,2) == a:left . a:right
	    return "\<Del>"
        else
            return a:left . a:right . "\<Left>"
	endif
    endif
endfunction

" Double ampersands, if you are in an eqnarray or eqnarray* environment.
function! s:DoubleAmpersands()
    let stop = 0
    let currentline = line('.')
    while stop == 0
	let currentline = currentline - 1
	let thisline = getline(currentline)
	if thisline =~ '\\begin' || currentline == 0
	    let stop = 1
	endif
    endwhile
    if thisline =~ '\\begin{eqnarray\**}'
	return "&&\<Left>"
    elseif strpart(getline('.'),col('.')-2,2) == '&&'
	return "\<Del>"
    else
	return '&'
    endif
endfunction

" }}}

" }}}
" "========================================================================="
" Menus   {{{

" Menus for running Latex, etc.
nnoremenu 50.401 Latex.run\ latex\ \ \ \ Control-Tab :w<CR>:silent ! xterm -bg ivory -fn 7x14 -e latex % &<CR>
inoremenu 50.401 Latex.run\ latex\ \ \ \ Control-Tab <Esc>:w<CR>:silent ! xterm -bg ivory -fn 7x14 -e latex % &<CR>
nnoremenu 50.402 Latex.next\ math\ error\ \ \ Shift-Tab :call <SID>NextTexError()<CR><Space>
inoremenu 50.402 Latex.next\ math\ error\ \ \ Shift-Tab <Esc>:call <SID>NextTexError()<CR><Space>
nnoremenu 50.403 Latex.next\ ref\ error :call <SID>CheckReferences('Reference', 'ref')<CR><Space>
inoremenu 50.403 Latex.next\ ref\ error <Esc>:call <SID>CheckReferences('Reference', 'ref')<CR><Space>
nnoremenu 50.404 Latex.next\ cite\ error :call <SID>CheckReferences('Citation', 'cite')<CR><Space>
inoremenu 50.404 Latex.next\ cite\ error <Esc>:call <SID>CheckReferences('Citation', 'cite')<CR><Space>
nnoremenu 50.405 Latex.view\ log\ file :call <SID>LookAtLogFile()<CR>
inoremenu 50.405 Latex.view\ log\ file <Esc>:call <SID>LookAtLogFile()<CR>
nnoremenu 50.406 Latex.view\ dvi\ \ \ \ \ Alt-Tab :call <SID>Xdvi()<CR><Space>
inoremenu 50.406 Latex.view\ dvi\ \ \ \ \ Alt-Tab <Esc>:call <SID>Xdvi()<CR><Space>
nnoremenu 50.407 Latex.run\ ispell\ \ \ Shift-Ins :w<CR>:silent ! xterm -bg ivory -fn 10x20 -e ispell %<CR>:e %<CR><Space>
inoremenu 50.407 Latex.run\ ispell\ \ \ Shift-Ins <Esc>:w<CR>:silent ! xterm -bg ivory -fn 10x20 -e ispell %<CR>:e %<CR><Space>
"nnoremenu 50.405 Latex.run\ engspchk :so .Vim/engspchk.vim<CR>
"inoremenu 50.405 Latex.run\ engspchk <C-O>:so .Vim/engspchk.vim<CR>

" }}}
" "========================================================================="

" vim:fdm=marker
