let g:ackprg="~/.vim/scripts/ack\\ -H\\ --nocolor\\ --nogroup"

function! Ack(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:ackprg
    execute "silent! grep " . a:args
    botright copen
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

function! AckAdd(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:ackprg
    execute "silent! grepadd " . a:args
    botright copen
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

function! LAck(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:ackprg
    execute "silent! lgrep " . a:args
    botright lopen
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

function! LAckAdd(args)
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:ackprg
    execute "silent! lgrepadd " . a:args
    botright lopen
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

command! -nargs=* -complete=file Ack call Ack(<q-args>)
cabbr ack Ack
command! -nargs=* -complete=file AckAdd call AckAdd(<q-args>)
command! -nargs=* -complete=file LAck call LAck(<q-args>)
command! -nargs=* -complete=file LAckAdd call LAckAdd(<q-args>)
