au BufRead *.log call s:FTlog()

function! s:FTlog()
  if exists("g:filetype_log")
    exe "setfiletype " . g:filetype_log
  elseif getline(1) =~# '^This is \S*TeX[^,]*, Version .\+$'
    setfiletype texlog
  else
    return
  endif
endfunction
