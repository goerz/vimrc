" Vim global plugin for aligning
" Maintainer:	Michael Goerz
" License:	This file is placed in the public domain.
"
" Usage:
"
" Set mark (e.g. ma in normal mode) to mark a column. Go to some other line,
" and run e.g. :call AlignToMark('a'). This will cause spaces to be added
" before the current cursor, so that the text under thecursor will be moved to
" start at the same column as mark a
"
" It's probably a good idea to record a macro to make this useful

" If already loaded, we're done...
if exists("loaded_align_to_mark")
    finish
endif
let loaded_align_to_mark = 1

function! AlignToMark(markname)
    let l:mark_col = col("'".a:markname)
    let l:cur_col = col(".")
    let l:diff = l:mark_col - l:cur_col " number of spaces to insert
    let l:count = l:diff
    while l:count > 0
        execute "normal i \<Esc>"
        let l:count = l:count - 1
    endwhile
    "execute "normal" l:diff-1 "l"
endfunction
