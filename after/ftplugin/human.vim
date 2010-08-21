setlocal formatoptions+=t 
setlocal textwidth=79 
setlocal spell 
if exists("+colorcolumn")
    set colorcolumn=0
endif

" Use Wordnet as a dictionary
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
