setlocal formatoptions+=t
setlocal textwidth=0
setlocal spell

" Use Wordnet as a dictionary
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'

" Show wordcount in statusline (see statusline plugin)
let b:showwordcount=1
