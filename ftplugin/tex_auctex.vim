" Vim filetype plugin
" Language:    LaTeX
" Maintainer:  Michael Goerz <goerz@physik.fu-berlin.de>
" Last Change: Sat 01/14/12 14:07:28 CET

" "========================================================================="
" Explanation and Customization   {{{

let b:AMSLatex = 1

" Set b:AMSLatex to 1 if you are using AMSlatex.  Otherwise, the program will
" attempt to automatically detect the line \usepackage{...amsmath...}
" (uncommented), which would indicate AMSlatex.

" Select which quotes should be used
let b:leftquote = "``"
let b:rightquote = "''"
if &spelllang == 'de_20'
    let b:leftquote = '"`'
    let b:rightquote = "\"'"
endif

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

    let ln = line('.')
    while ln > 1 && getline(ln) !~ '\\begin\|\\end\|\\\]\|\\\['
    let ln = ln - 1
    endwhile

    " Check to see if you're between brackets in \ref{} or \cite{}.
    " Typing q returns you to editing
    " Typing <CR> or Left-clicking takes the data into \ref{} or \cite{}.
    " Within \cite{}, you can enter a regular expression followed by <Tab>,
    " Only the citations with matching authors are shown.
    " \cite{c.*mo<Tab>} will show articles by Mueller and Moolinar, for example.
    " Once the citation is shown, you type <CR> anywhere within the citation.
    " The bibtex files listed in \bibliography{} are the ones shown.
    if (    match(strpart(line,0,column),'\\ref{[^}]*$')    != -1
    \    || match(strpart(line,0,column),'\\Eq{[^}]*$')     != -1
    \    || match(strpart(line,0,column),'\\Eqs{[^}]*$')    != -1
    \    || match(strpart(line,0,column),'\\Fig{[^}]*$')    != -1
    \    || match(strpart(line,0,column),'\\Table{[^}]*$')  != -1 )
        let m = matchstr(strpart(line,0,column),'[^{]*$')
        if strpart(line,column,1) == '}'
            normal dF{i{
        else
            normal dF{a{
        endif
        let name = bufname(1)
        let short = substitute(name, ".*/", "", "")
        let tmp = tempname()
        execute "below split ".tmp
        execute "0r ! cat `find . | grep \.aux$`"
        g!/^\\newlabel{/delete
        %s/}.*//g
        %s/.*{//g
        execute "% sort u"
        if m != ''
            execute "% g!/".m."/delete"
        endif
        execute 0 "s/^/% press 'q' to close, 'f' to filter/"
        execute "write! ".tmp
        noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>RefInsertion()<CR>a
        noremap <buffer> <CR> :call <SID>RefInsertion()<CR>a
        noremap <buffer> q :bwipeout!<CR>a
        noremap <buffer> f :% ! ack
        return "\<Esc>"
    elseif match(strpart(line,0,column),'\\cite[tp*]*{[^}]*$') != -1
        let m = matchstr(strpart(line,0,column),'[^{]*$')
        if strpart(line,column,1) == '}'
            normal dF{i{
        else
            normal dF{a{
        endif
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
                let f = glob("*.bib")
            else
                let s = getline(l)
                let beginning = matchend(s, '\\bibliography{')
                let ending = matchend(s, '}', beginning)
                let f = strpart(s, beginning, ending-beginning-1)
            endif
            let tmp = tempname()
            execute "below split ".tmp
            let file_exists = 0

            let name = bufname(1)
            let base = substitute(name, "[^/]*$", "", "")
            while f != ''
                let comma = match(f, ',[^,]*$')
                if comma == -1
                    let file = base.f
                    if filereadable(file)
                        let file_exists = 1
                        execute "0r ".file
                    else
                        let file = file.'.bib'
                        if filereadable(file)
                            let file_exists = 1
                            execute "0r ".file
                        endif
                    endif
                    let f = ''
                else
                    let file = strpart(f, comma+1)
                    let file = base.file
                    if filereadable(file)
                        let file_exists = 1
                        execute "0r ".file
                    else
                        let file = file.'.bib'
                        if filereadable(file)
                            let file_exists = 1
                            execute "0r ".file
                        endif
                    endif
                    let f = strpart(f, 0, comma)
                endif
            endwhile

            if file_exists == 1
                if strlen(m) != 0
                    %g/author\c/call <SID>BibPrune(m)
                endif
                execute "g/^@string/delete"
                execute "g/^%/delete"
                normal gg
                while getline('.') == ""
                    normal dd
                endwhile
                execute 0 "s/^/% press 'q' to close/"
                noremap <buffer> <LeftRelease> <LeftRelease>:call <SID>CiteInsertion("@")<CR>a
                noremap <buffer> <CR> :call <SID>CiteInsertion("@")<CR>a
                noremap <buffer> q :bwipeout!<CR>a
                return "\<Esc>"
            else
                bwipeout!
                return ''
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
function! s:RefInsertion()
    normal 0y$
    bwipeout!
    let thisline = getline('.')
    let thiscol  = col('.')
    if thisline[thiscol-1] == '{'
        normal p
    else
        normal P
    endif
    normal f}
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
        normal l
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
" Greek letters, AucTex style bindings   {{{

" No timeout.  Applies to mappings such as `a for \alpha
set notimeout

inoremap <buffer> `` `
inoremap <buffer> `a \alpha
inoremap <buffer> `b \beta
inoremap <buffer> `c \chi
inoremap <buffer> `d \delta
inoremap <buffer> `e \epsilon
inoremap <buffer> `f \phi
inoremap <buffer> `g \gamma
inoremap <buffer> `h \eta
inoremap <buffer> `i \iota
inoremap <buffer> `k \kappa
inoremap <buffer> `l \lambda
inoremap <buffer> `m \mu
inoremap <buffer> `n \nu
inoremap <buffer> `o \omega
inoremap <buffer> `p \pi
inoremap <buffer> `q \theta
inoremap <buffer> `r \rho
inoremap <buffer> `s \sigma
inoremap <buffer> `t \tau
inoremap <buffer> `u \upsilon
inoremap <buffer> `v \vee
inoremap <buffer> `w \omega
inoremap <buffer> `x \xi
inoremap <buffer> `y \psi
inoremap <buffer> `z \zeta
inoremap <buffer> `D \Delta
inoremap <buffer> `I \int\limits_{}^{}<Esc>F}i
inoremap <buffer> `E \varepsilon
inoremap <buffer> `F \Phi
inoremap <buffer> `G \Gamma
inoremap <buffer> `G \varphi
inoremap <buffer> `L \Lambda
inoremap <buffer> `N \nabla
inoremap <buffer> `O \Omega
inoremap <buffer> `P \Pi
inoremap <buffer> `Q \Theta
inoremap <buffer> `R \varrho
inoremap <buffer> `S \Sigma
inoremap <buffer> `T \vartheta
inoremap <buffer> `Z \sum\limits_{}^{}<Esc>F}i
inoremap <buffer> `U \Upsilon
inoremap <buffer> `X \Xi
inoremap <buffer> `Y \Psi
inoremap <buffer> `0 \emptyset
inoremap <buffer> `1 \unity
inoremap <buffer> `6 \difquo
inoremap <buffer> `8 \infty
inoremap <buffer> `/ \frac{}{}<Esc>F}i
inoremap <buffer> `% \frac{}{}<Esc>F}i
inoremap <buffer> `@ \circ
inoremap <buffer> `\| \Big\|
inoremap <buffer> `= \equiv
inoremap <buffer> `\ \setminus
inoremap <buffer> `. \cdot
inoremap <buffer> `* \times
inoremap <buffer> `& \wedge
inoremap <buffer> `- \bigcap
inoremap <buffer> `+ \bigcup
inoremap <buffer> `( \left(  \right)<++><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
inoremap <buffer> `[ \left[  \right]<++><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
imap <buffer> <C-L>o \Op{}
imap <buffer> <C-L>2 \sqrt{}
imap <buffer> <C-L>k \Ket{}
imap <buffer> <C-L>h \hat{}
imap <buffer> <C-L>v \vec{}
nmap <silent> <buffer> <Leader>o ysiwf\op{<CR>
vmap <silent> <buffer> <Leader>o sf\op{<CR>
imap <buffer> <C-L>e \emph{}
imap <buffer> <C-L>t \text{}
nmap <silent> <buffer> <Leader>e ysiwf\emph{<CR>
vmap <silent> <buffer> <Leader>e sf\emph{<CR>
inoremap <buffer> {} {}<Left>
inoremap <buffer> () ()<Left>
inoremap <buffer> $$ $$<Left>
inoremap <buffer> `< \leq
inoremap <buffer> `> \geq
inoremap <buffer> `, \nonumber
inoremap <buffer> `: \cdots
inoremap <buffer> `~ \tilde{}<Left>
inoremap <buffer> `^ \op{}<Left>
inoremap <buffer> `; \dot{}<Left>
inoremap <buffer> `_ \bar{}<Left>
inoremap <buffer> `<C-E> \exp\left(\right)<Esc>F(a
inoremap <buffer> `<C-L> \lim_{}<Left>
inoremap <buffer> `<Up> \uparrow
inoremap <buffer> `<Down> \downarrow
inoremap <buffer> `<Right> \longrightarrow
inoremap <buffer> `<Left> \leftarrow
inoremap <buffer> `<C-F> \to

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

" vim:fdm=marker
