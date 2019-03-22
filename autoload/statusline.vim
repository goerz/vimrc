scriptencoding utf-8


function! statusline#gitInfo() abort
  if !exists('*fugitive#head')
    return ''
  endif
  let l:out = fugitive#head(10)
  return l:out
endfunction


function! statusline#WordCount()
  let s:old_status = v:statusmsg
  let position = getpos(".")
  exe ":silent normal g\<c-g>"
  let stat = v:statusmsg
  let s:word_count = 0
  if stat != '--No lines in buffer--'
    let s:word_count = str2nr(split(v:statusmsg)[11])
    let v:statusmsg = s:old_status
  end
  call setpos('.', position)
  return s:word_count
endfunction


function! statusline#WhitespaceCheck()
  if &readonly || mode() == 'i'
    return ''
  endif
  let trailing = search(' $', 'nw')
  let indents = [search('^ ', 'nb'), search('^ ', 'n'), search('^\t', 'nb'), search('^\t', 'n')]
  let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
  if trailing != 0 || mixed
    return " ␣"
  endif
  return ''
endfunction!


function! statusline#AsciiCheck()
  let nonascii = search('[^\x00-\x7F]', 'nw')
  let l:flags = ''
  if nonascii != 0
    let l:flags = ' '
    let l:latin_extended = search('[\u00C0-\u017F]', 'nw')
    let l:punctuation = search('[\u00A0-\u00BB\u2010-\u203A]', 'nw')
    let l:nonlatin = search('[^\x00-\x7F\u00C0-\u017F\u00A0-\u00BB\u2010-\u203A]', 'nw')
    if l:punctuation != 0
      let l:flags .= "‟"
    endif
    if l:latin_extended != 0
      let l:flags .= "ä"
    endif
    if l:nonlatin != 0
      let l:flags .= "α"
    endif
  endif
  return l:flags
endfunction!


function! statusline#RefreshFlags()
  let b:statuslineAsciiCheck = statusline#AsciiCheck()
  let b:statuslineWhitespaceCheck = statusline#WhitespaceCheck()
  if exists("b:showwordcount")
    if b:showwordcount
      let b:statuslineWordCount = statusline#WordCount()."w"
    endif
  endif
  let b:statuslineGitInfo = statusline#gitInfo()
  if !(empty(b:statuslineGitInfo))
    let b:statuslineGitInfo = "⟨".b:statuslineGitInfo
  endif
endfunction!


" Return current working directory (in quotes) if either autochdir is on or a
" symlink has been followed. Otherwise, return empty string. To be used for
" display in the status line
function! statusline#StatusCwd()
  if exists("+autochdir")
    if &autochdir
      return '"' . getcwd() . '"/'
    endif
  endif
  if exists("b:followed_symlink")
    return '"' . getcwd() . '"/'
  endif
  return ''
endfunction!


" mode ->  mode str, color suffix
" :h mode() to see all modes
" The "color suffix" is usd in the syntax highlighting
let s:dictmode= {
      \ 'no'     : ['N', 'N'],
      \ 'v'      : ['V', 'V'],
      \ 'V'      : ['V', 'V'],
      \ "\<C-V>" : ['V', 'V'],
      \ 's'      : ['S', 'V'],
      \ 'S'      : ['S', 'V'],
      \ "\<C-S>" : ['S', 'V'],
      \ 'i'      : ['I', 'I'],
      \ 'ic'     : ['I', 'I'],
      \ 'ix'     : ['I', 'I'],
      \ 'R'      : ['R', 'I'],
      \ 'Rc'     : ['R', 'I'],
      \ 'Rx'     : ['R', 'I'],
      \ 'Rv'     : ['R', 'I'],
      \ 'c'      : ['C', 'N'],
      \ 'cv'     : ['C', 'N'],
      \ 'ce'     : ['C', 'N'],
      \ 'r'      : ['r', 'N'],
      \ 'rm'     : ['r', 'N'],
      \ 'r?'     : ['r', 'N'],
      \ '!'      : ['S', 'N'],
      \ 't'      : ['T', 'N']
      \ }


function! statusline#getMode() abort
  let l:modenow = mode()
  if has_key(s:dictmode, l:modenow)
    return get(s:dictmode, l:modenow, [l:modenow, 'N'])
  endif
  return ['N', 'N']
endfunction

"Most colorschemes (except for 'goerz') don't define the highlight groups for
"the different parts of the status line. This will cause the statusline to
"become completely unhighlighted. We can avoid this by relinking all the
"custom highlight groups back to StatusLine. This should be done before
"loading any new colorscheme.
function! statusline#clearHighlights() abort
  for group in ["StatusLine1N", "StatusLine2N", "StatusLine3N", "StatusLine1I", "StatusLine2I",  "StatusLine3I", "StatusLine1V", "StatusLine2V",  "StatusLine3V"]
    if hlexists(group)
      exe "hi clear ".group
      exe "hi link ".group." StatusLine"
    endif
  endfor
endfunction

"Set the highlight groups for the status line to a uniform gray. This is for
"use with Goyo and colorschemes that don't define the statusline highlight
"codes
function! statusline#grayStatusLine() abort
  for group in ["StatusLine1N", "StatusLine2N", "StatusLine3N", "StatusLine1I", "StatusLine2I",  "StatusLine3I", "StatusLine1V", "StatusLine2V",  "StatusLine3V"]
    exec "hi! " . group . " guifg=black  ctermfg=black"
    exec "hi! " . group . " guibg=gray ctermbg=gray"
    exec "hi! " . group . " gui=NONE cterm=NONE"
  endfor
endfunction
