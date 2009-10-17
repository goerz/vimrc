" Author: Michael Goerz
" Description: This file contains my local settings for latex files.

" General layout settings
setlocal shiftwidth=2 tabstop=2
setlocal wildignore+=*.aux,*.blg,*.log,*.out,*.snm,*.idx
setlocal wildignore+=*.ilg,*.ind,*.nav,*.lot,*.lof,*.toc
setlocal wildignore+=*.bbl,*.ent,*.pdf,*.svn
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
compiler tex
setlocal makeprg=pdftex\ -interaction=nonstopmode\ %
setlocal autoindent

