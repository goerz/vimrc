let g:SimplenoteCachefile = '~/.vim/.simplenote.cache'
let g:SimplenoteTokenfile = '~/.vim/.simplenote.token'
let s:simplenote_bin = '~/.vim/scripts/SimplenoteCLI.py'


function! Simplenote()
    " Load a list of all notes from the server "
    let fname = tempname()
    echo "Getting list of notes from server... "
    let response = system(s:simplenote_bin
                \    ." --cachefile=".g:SimplenoteCachefile
                \    ." --tokenfile=".g:SimplenoteTokenfile
                \    ." list ".fname)
    silent! execute "edit ".fname
    call <SID>AddPreamble()
    if response != ""
        call append(4, response)
    endif
    write
    silent! execute "file Simplenote_Index"
    let b:SimpleNoteIndexFileName = fname
    silent! setlocal noswapfile
    silent! setlocal nowrap
    silent! setlocal nonumber
    silent! setlocal nomodifiable
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>SimpleNote_OpenNote()<CR>
    nnoremap <buffer> <silent> q :bd<CR>
    nnoremap <buffer> <silent> n
                \ :call <SID>SimpleNote_NewFile()<CR>
    nnoremap <buffer> <silent> d
                \ :call <SID>SimpleNote_DeleteNote()<CR>
    nnoremap <buffer> <silent> u
                \ :call <SID>SimpleNote_Update()<CR>
    redraw!
endfunction


function! s:GetSimpleNoteKey()
    "Extract key from current line"
    let line = getline(".")
    let key = matchstr(line, '\v \(.{38}\)$')
    let key = substitute(key, '^ (', "", "")
    let key = substitute(key, ')$', "", "")
    return key
endfunction


function! s:AddPreamble()
    " Add preamble to note listing"
    call append(0, "=== Simplenote Index ===")
    call append(1, "")
    call append(2, "<CR>: Edit Note   a: Add new note   "
                 \."d: Delete note    q: Exit   u: Update")
    call append(3, "")
endfunction


function! s:SimpleNote_Update()
    " Reload Simplenote Listing
    execute "bd!"
    call Simplenote()
endfunction


function! s:SimpleNote_OpenNote()
    " Edit note specified on the current line  "
    let key = <SID>GetSimpleNoteKey()
    if (strlen(key) > 0)
        let fname = tempname()
        echo "Downloading note... "
        silent! execute "! ".s:simplenote_bin
                    \    ." --tokenfile=".g:SimplenoteTokenfile
                    \    ." read ".key." ".fname
        silent! execute "edit ".fname
        silent! execute "set ft=markdown"
        let b:simplenote_key = key
        autocmd BufWriteCmd <buffer> :call <SID>SimpleNote_SaveFile()
        redraw!
    endif
endfunction


function! s:SimpleNote_NewFile()
    " Create a new note
    let fname = tempname()
    silent! execute "edit ".fname
    silent! execute "set ft=markdown"
    let b:simplenote_key = ""
    autocmd BufWriteCmd <buffer> :call <SID>SimpleNote_SaveFile()
endfunction


function! s:SimpleNote_DeleteNote()
    " Delete note specified on the current line  "
    let key = <SID>GetSimpleNoteKey()
    if (strlen(key) > 0)
        let fname = tempname()
        echo "Deleting note... "
        silent! execute "! ".s:simplenote_bin
                    \  ." --tokenfile=".g:SimplenoteTokenfile
                    \  ." delete ".key." ".fname
        silent! setlocal modifiable
        silent! execute ". delete "
        silent! write
        silent! setlocal nomodifiable
        redraw!
        echo "Note ".key." deleted"
    endif
endfunction


function! s:SimpleNote_SaveFile()
    "Update note with text in current file" 
    silent! write
    if b:simplenote_key == ""
        echo "Creating new note on server... "
        let key = system(s:simplenote_bin
                    \    ." --tokenfile=".g:SimplenoteTokenfile
                    \    ." new ".expand('%'))
        let b:simplenote_key = substitute(key, "\n", "", "g")
        redraw!
        echo "Saved as note ".b:simplenote_key
    else
        echo "Writing note to server... "
        silent! execute "! ".s:simplenote_bin
                    \  ." --tokenfile=".g:SimplenoteTokenfile
                    \  ." write ".b:simplenote_key." %"
        redraw!
        echo "Saved as note ".b:simplenote_key
    endif
endfunction


command! Simplenote execute "call Simplenote()"
