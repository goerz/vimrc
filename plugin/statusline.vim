scriptencoding utf-8

"------------------------------------------------------------------------------
" STATUS LINE CUSTOMIZATION
"------------------------------------------------------------------------------


" Auxilliary functions are in autoload/statusline.vim


function! StatusLine(mode) abort
  let l:line=''
  let l:editor_mode_and_code = statusline#getMode()
  let l:editormode = l:editor_mode_and_code[0]
  let l:colorcode = l:editor_mode_and_code[1]
  let l:colorPrimary = "%#StatusLinePrimary".l:colorcode."#"
  let l:colorSecondary = "%#StatusLineSecondary".l:colorcode."#"

  if exists("w:statusline")
      let l:line = w:statusline
  elseif exists("b:statusline")
      let l:line = b:statusline

  " active
  elseif a:mode ==# 'active'

    " help or man pages
    if &filetype ==# 'help' || &filetype ==# 'man'
      let l:line.=' %#StatusLineNC# ['. &filetype .'] %f '
    else

      let l:line.=colorPrimary
      let l:line.=l:editormode
      if &paste
        let l:line.='(paste)'
      endif
      let l:line.=' %3p%% ¶ %3l/%L:%2c'  " pos line/of:column
      let l:line.='⟩'

      let l:line.=colorSecondary
      let l:line.=statusline#AsciiCheck()
      let l:line.=statusline#WhitespaceCheck()
      let l:line.='%3R%4W' " read-only and preview flag

      let l:line.='%*'  " color reset
      let l:line.=' %m' " modified flag
      let l:line.=' %<' " where to truncate the line
      let l:line.='%{statusline#StatusCwd()}%f'  " filename

      let l:line.='%= ' " horizontal fill

      let l:line.=colorSecondary
      let l:line.='⟨'
      let l:line.=&filetype
      if &fileencoding !=# 'utf-8' || &fileformat !=# 'unix'
        let l:line.=' %{&fenc}[%{&ff}]'
      endif

      let l:line.=colorPrimary
      let l:line.='⟨%{statusline#gitInfo()}%*'
    endif

  " inactive
  else

    let l:line.='%#StatusLineNC#'
    let l:line.='%m%{statusline#StatusCwd()}%f'

  endif

  let l:line.='%*'
  return l:line


endfunction

set statusline=%!StatusLine('active')
augroup MyStatusLine
  autocmd!
  autocmd WinLeave * setl statusline=%!StatusLine('inactive')
  autocmd WinEnter,BufWinEnter,BufWritePost,FileWritePost,WinEnter,InsertEnter,InsertLeave,CmdWinEnter,CmdWinLeave,ColorScheme * setl statusline=%!StatusLine('active')
augroup END
