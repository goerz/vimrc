scriptencoding utf-8

"------------------------------------------------------------------------------
" STATUS LINE CUSTOMIZATION
"------------------------------------------------------------------------------


" Auxilliary functions are in autoload/statusline.vim


" Function that dynamically generates the statusline
"
" It gets evaluated every time the statusline is redrawn.
"
" The only way to override the statusline is to set local variables
" `w:statusline` or `b:statusline`. An optional word counter may be shown in
" the status line by setting `b:showwordcount=1` (word counts only make sense
" for some filetypes)
function StatusLine(mode) abort

  if exists("t:goyo_dim") && g:goyo_use_custom_status
    return s:GoyoStatusLine(a:mode)
  endif

  let l:line=''
  let l:editor_mode_and_code = statusline#getMode()
  let l:editormode = l:editor_mode_and_code[0]
  let l:colorcode = l:editor_mode_and_code[1]
  let l:color1 = "%#StatusLine1".l:colorcode."#"
  let l:color2 = "%#StatusLine2".l:colorcode."#"
  let l:color3 = "%#StatusLine3".l:colorcode."#"

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

      let l:line.=l:color1
      let l:line.=l:editormode
      if &paste
        let l:line.='(paste)'
      endif
      let l:line.=' %3p%% ¶ %3l/%L:%2c'  " pos line/of:column
      let l:line.='⟩'

      let l:line.=l:color2
      if exists("b:showwordcount")
        if b:showwordcount ==# 1
          if exists("b:statuslineWordCount")
            " Set in statusline#RefreshFlags
            let l:line.=b:statuslineWordCount
          endif
        endif
      endif
      if exists("b:statuslineAsciiCheck")
        " Set in statusline#RefreshFlags
        let l:line.=b:statuslineAsciiCheck
      endif
      if exists("b:statuslineWhitespaceCheck")
        " Set in statusline#RefreshFlags
        let l:line.=b:statuslineWhitespaceCheck
      endif
      let l:line.='%3R%4W' " read-only and preview flag

      let l:line.=l:color3
      let l:line.=' %m' " modified flag
      let l:line.=' %<' " where to truncate the line
      if exists("b:StatusLineCwdString")
        " Defined in MyFollowSymlink in init.vim
        let l:line.=b:StatusLineCwdString
      endif
      let l:line.='%f'  " filename

      let l:line.='%= '  " horizontal fill

      let l:line.=l:color2
      let l:line.='⟨'
      let l:line.=&filetype
      if &fileencoding !=# 'utf-8' || &fileformat !=# 'unix'
        let l:line.=' %{&fenc}[%{&ff}]'
      endif

      let l:line.=l:color1
      if exists("b:statuslineGitInfo")
        " Set in statusline#RefreshFlags
        let l:line.=b:statuslineGitInfo
      endif
    endif

  " inactive
  else

    let l:line.='%#StatusLineNC#'
    let l:line.=' %m' " modified flag
    if exists("b:StatusLineCwdString")
      " Defined in MyFollowSymlink in init.vim
      let l:line.=b:StatusLineCwdString
    endif
    let l:line.='%f'  " filename
    if exists("t:goyo_dim")
      " I use a modified goyo that keeps the statusline. This includes the
      " status lines of the "buffer" scratch windows, so we have to turn off
      " the statusline for inactive windows here, whenever we're in goyo
      let l:line=''
    endif

  endif

  let l:line.='%*'
  return l:line

endfunction

function s:GoyoStatusLine(mode) abort
  let l:line=''
  let l:editor_mode_and_code = statusline#getMode()
  let l:editormode = l:editor_mode_and_code[0]
  let l:colorcode = l:editor_mode_and_code[1]
  let l:color1 = "%#StatusLine1".l:colorcode."#"
  let l:color2 = "%#StatusLine2".l:colorcode."#"
  let l:color3 = "%#StatusLine3".l:colorcode."#"

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

      let l:line.=l:color3
      let l:line.=l:editormode
      if &paste
        let l:line.='(paste)'
      endif
      let l:line.=' %3p%% %Ll'  " pos and lines
      let l:line.=' '

      let b:showwordcount = 1
      if exists("b:statuslineWordCount")
        " Set in statusline#RefreshFlags
        let l:line.=b:statuslineWordCount
      endif
      if exists("b:statuslineWhitespaceCheck")
        " Set in statusline#RefreshFlags
        let l:line.=b:statuslineWhitespaceCheck
      endif
      let l:line.='%3R%4W' " read-only and preview flag

      let l:line.=' %m' " modified flag
      let l:line.=' %<' " where to truncate the line
      if exists("b:StatusLineCwdString")
        " Defined in MyFollowSymlink in init.vim
        let l:line.=b:StatusLineCwdString
      endif
      let l:line.='%f'  " filename

      let l:line.='%= '  " horizontal fill

    endif

  " inactive
  else

      let l:line=''

  endif

  return l:line
endfunction


call statusline#RefreshFlags()
set statusline=%!StatusLine('active')
augroup MyStatusLine
  autocmd!
  " The exclamation point below ensures that the StatusLine function is
  " re-evaluated every time the statusline is redrawn. The autocmmands just
  " change which version (active/inactive) of the function will be used.
  autocmd WinLeave * setl statusline=%!StatusLine('inactive')
  autocmd WinEnter * setl statusline=%!StatusLine('active')
  if exists("##BufWinEnter")
    autocmd BufWinEnter * setl statusline=%!StatusLine('active')
  endif
  " Some of the "flags", e.g. the analysis which unicode symbols are present
  " in the buffer are relatively slow. If they they are re-calculated at every
  " refresh of the status line, this slows down cursor movement in standard
  " vim noticeably (neovim is better). Therefore, we only recalculated the
  " flags when something beyond cursor movements happens.
  for event in ["BufWinEnter", "BufWritePost", "InsertEnter", "InsertLeave", "CmdWinEnter", "CmdWinLeave", "CursorHold", "CursorHoldI", "FileAppendPost", "FileReadPost", "TextChanged", "CmdlineEnter", "CmdlineLeave"]
    if exists("##".event)
      exe "autocmd ".event." * call statusline#RefreshFlags()"
    endif
  endfor
  if exists("##ColorSchemePre")
    autocmd ColorSchemePre * call statusline#clearHighlights()
  endif
augroup END
