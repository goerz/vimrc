set textwidth=0
compiler pandoc

" use indents of 4 spaces:
setlocal tabstop=4
setlocal shiftwidth=4
setlocal shiftround
setlocal expandtab

" Tex files can use spell checking
setlocal spell

noremap <silent> <leader>t :Voom markdown<CR>:vertical resize 80<CR>
