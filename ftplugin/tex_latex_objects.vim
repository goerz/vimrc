" Adapted from https://github.com/gibiansky/vim-latex-objects/blob/491fab0af54428b3fe5676ba6533d35648c3534b/ftplugin/tex.vim
"
"
vnoremap <buffer> im <ESC>:call SelectInMath(0)<CR>
vnoremap <buffer> am <ESC>:call SelectInMath(1)<CR>
omap <buffer> im :normal vim<CR>
omap <buffer> am :normal vam<CR>

" Operate on LaTeX quotes
vmap <buffer> iq <ESC>?``<CR>llv/''<CR>h
omap <buffer> iq :normal viq<CR>
vmap <buffer> aq <ESC>?``<CR>v/''<CR>l
omap <buffer> aq :normal vaq<CR>

map <buffer> % :call MatchedBlock()<CR>
vmap <buffer> % :call VisualMatchedBlock()<CR>
