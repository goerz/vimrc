set textwidth=0

" use indents of 4 spaces:
setlocal tabstop=4
setlocal shiftwidth=4
setlocal shiftround
setlocal expandtab
setlocal wrap

let b:showwordcount=1

" Tex files can use spell checking
setlocal spell

noremap <silent> <leader>t :Voom markdown<CR>:vertical resize 80<CR>
