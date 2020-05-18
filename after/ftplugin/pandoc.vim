set textwidth=0

" use indents of 4 spaces:
setlocal tabstop=4
setlocal shiftwidth=4
setlocal shiftround
setlocal expandtab
setlocal wrap

let b:showwordcount=1

" use spell checking
setlocal spell

" when not wrapping lines, keep the cursor at the center of the screen once
" you moved it horizontally beyond the first half screen horizontally
setlocal sidescrolloff=1000

noremap <silent> <leader>t :Voom markdown<CR>:vertical resize 80<CR>
