set textwidth=80
let g:vikiNameSuffix=".viki"
let g:vikiUseParentSuffix = 1
let g:deplatePrg = "deplate --pdf -f latex -m particle-math -d ./tex -R -X"
compiler deplate
