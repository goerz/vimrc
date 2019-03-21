scriptencoding utf-8


function! statusline#gitInfo() abort
  if !exists('*fugitive#head')
    return ''
  endif
  let l:out = fugitive#head(10)
  return l:out
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
  if nonascii != 0
    return " α"
  endif
  return ''
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
