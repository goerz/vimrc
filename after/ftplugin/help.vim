" help files should not use spellchecking, but provide access to the
" dictionary
setlocal nospell 
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
if exists("+colorcolumn")
    set colorcolumn=0
endif
