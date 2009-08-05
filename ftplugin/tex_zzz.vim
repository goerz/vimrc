" Author: Michael Goerz
" Description: This file contains my local settings for latex files.

" General layout settings
setlocal textwidth=79  formatoptions=tcl12
setlocal shiftwidth=2 tabstop=2
setlocal wildignore+=*.aux,*.blg,*.log,*.out,*.snm,*.idx
setlocal wildignore+=*.ilg,*.ind,*.nav,*.lot,*.lof,*.toc
setlocal wildignore+=*.bbl,*.ent,*.pdf,*.svn
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
compiler tex
setlocal makeprg=pdflatex\ -interaction=nonstopmode\ %
setlocal autoindent

" Tex files can use spell checking
setlocal spell

