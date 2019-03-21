" mails should have shorter lines
setlocal formatoptions+=t 
setlocal textwidth=0
setlocal spell 
setlocal keywordprg='$HOME/.vim/scripts/wn_dict.sh'
set wrap
let b:statusline='%#StatusLineNC#%='
Goyo 80
