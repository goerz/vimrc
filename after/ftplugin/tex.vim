" Author: Michael Goerz
" Description: This file contains my local settings for latex files.

" General layout settings
setlocal textwidth=80  formatoptions=tcl12
setlocal shiftwidth=2 tabstop=2
setlocal wildignore+=*.aux,*.blg,*.log,*.out,*.snm,*.idx
setlocal wildignore+=*.ilg,*.ind,*.nav,*.lot,*.lof,*.toc
setlocal wildignore+=*.bbl,*.ent,*.svn
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
setlocal suffixesadd=.tex,.tikz
compiler tex
setlocal makeprg=pdflatex\ -interaction=nonstopmode\ %
setlocal autoindent

" Tex files can use spell checking
setlocal spell

