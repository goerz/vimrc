" Author: Michael Goerz
" Description: This file contains my local settings for latex files.
"   This includes extensions to the Latex-Suite

" General layout settings
setlocal textwidth=79  formatoptions=tcl12
setlocal shiftwidth=2 tabstop=2
setlocal wildignore+=*.aux,*.blg,*.log,*.out,*.snm,*.idx
setlocal wildignore+=*.ilg,*.ind,*.nav,*.lot,*.lof,*.toc
setlocal wildignore+=*.bbl,*.ent,*.pdf,*.svn
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'

" Make the LaTeX plugin recognize all files with a tex ending
let g:tex_flavor = "latex"

" Tex files can use spell checking
setlocal spell

" Folding
let Tex_FoldedSections="part,chapter,section,subsection,%%fakesection"
let Tex_FoldedEnvironments="figure,table,thebibliography,keywords,abstract,titlepage"
let Tex_FoldedMisc="preamble,<<<"

" My environment definitions, on top of latex-suite
call IMAP('EEQ', "\\begin{equation}\<CR><++>\<CR>\\end{equation}<++>", 'tex')
call IMAP('*EEQ', "\\begin{equation*}\<CR><++>\<CR>\\end{equation*}<++>", 'tex')
call IMAP('ESPL', "\\begin{split}\<CR><++>\<CR>\\end{split}<++>", 'tex')
call IMAP('EMU', "\\begin{multline}\<CR><++>\<CR>\\end{multline}<++>", 'tex')
call IMAP('*EMU', "\\begin{multline*}\<CR><++>\<CR>\\end{multline*}<++>", 'tex')
call IMAP('EGA', "\\begin{gather}\<CR><++>\<CR>\\end{gather}<++>", 'tex')
call IMAP('*EGA', "\\begin{gather*}\<CR><++>\<CR>\\end{gather*}<++>", 'tex')
call IMAP('EAL', "\\begin{align}\<CR><++>\<CR>\\end{align}<++>", 'tex')
call IMAP('*EAL', "\\begin{align*}\<CR><++>\<CR>\\end{align*}<++>", 'tex')

" Some more automatic expansions
call IMAP('\left(', '\left( <++> \right)<++>', 'tex')

" Use the latex-suite folding
call MakeTexFolds(1)
