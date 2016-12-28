" Theme: goerz
" Author: Michael Goerz <mail@michaelgoerz.net>
" License: MIT

" Default GUI Colours
"set background=dark
if &background=='light'
    "light background is preferred
    let s:foreground = ""
    let s:background = ""
    let s:normal     = ""
    let s:gray40     = "666666"
    let s:gray50     = "808080"
    let s:gray75     = "bfbfbf"
    let s:gray90     = "e5e5e5"
    let s:black      = "000000"
    let s:white      = "ffffff"
    let s:red        = "af0000"
    let s:lightred   = "d7005f"
    let s:orange     = "d75f00"
    let s:yellow     = "ffff00"
    let s:green      = "718c00"
    let s:darkgreen  = "008700"
    let s:lightgreen = "d7ffd7"
    let s:pink       = "5f0086"
    let s:lightpink  = "b190a1"
    let s:blue       = "4271ae"
    let s:darkblue   = "005f87"
    let s:purple     = "8959a8"
else
    "adaptation of the "standard" colors to a dark background
    let s:foreground = ""
    let s:background = ""
    let s:normal     = "bfbfbf"
    let s:gray40     = "999999"
    let s:gray50     = "808080"
    let s:gray75     = "404040"
    let s:gray90     = "1a1a1a"
    let s:black      = "ffffff"
    let s:white      = "000000"
    let s:red        = "af0000"
    let s:lightred   = "ba0052"
    let s:orange     = "d75f00"
    let s:yellow     = "b7b700"
    let s:green      = "718c00"
    let s:darkgreen  = "006e00"
    let s:lightgreen = "8ea88e"
    let s:pink       = "6c495a"
    let s:lightpink  = "5f005f"
    let s:blue       = "4271ae"
    let s:darkblue   = "005f87"
    let s:purple     = "8959a8"
endif

hi clear
syntax reset

let g:colors_name = "PaperColor"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
  " Returns an approximate grey index for the given grey level
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " Returns the palette index for the given grey index
  fun <SID>grey_colour(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " Returns an approximate colour index for the given colour level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual colour level for the given colour index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " Returns the palette index for the given R/G/B colour indices
  fun <SID>rgb_colour(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " Returns the palette index to approximate the given R/G/B colour levels
  fun <SID>colour(r, g, b)
    " Get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " Get the closest colour
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " There are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " Use the grey
        return <SID>grey_colour(l:gx)
      else
        " Use the colour
        return <SID>rgb_colour(l:x, l:y, l:z)
      endif
    else
      " Only one possibility
      return <SID>rgb_colour(l:x, l:y, l:z)
    endif
  endfun

  " Returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

    return <SID>colour(l:r, l:g, l:b)
  endfun

  " Sets the highlighting for the given group
  fun <SID>X(group, fg, bg, attr)
    if a:fg != ""
      exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif
    if a:bg != ""
      exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
  endfun

  "           type               foreground    background     attribute
  call <SID>X("Normal",          s:normal,     s:background,  "none")
  call <SID>X("Comment",         s:gray50,     s:background,  "none")
  call <SID>X("Constant",        s:darkblue,   s:background,  "none")
  call <SID>X("Directory",       s:blue,       s:background,  "none")
  call <SID>X("Error",           s:white,      s:red,         "none")
  call <SID>X("ErrorMsg",        s:white,      s:red,         "none")
  call <SID>X("FoldColumn",      s:darkblue,   s:gray75,      "none")
  call <SID>X("Folded",          s:darkblue,   s:gray75,      "none")
  call <SID>X("Identifier",      s:lightred,   s:background,  "none")
  call <SID>X("Ignore",          s:gray90,     s:background,  "none")
  call <SID>X("IncSearch",       s:foreground, s:yellow,      "none")
  call <SID>X("Search",          s:foreground, s:yellow,      "none")
  call <SID>X("Label",           s:blue,       s:background,  "none")
  call <SID>X("MatchParen",      s:foreground, s:orange,      "none")
  call <SID>X("ModeMsg",         s:foreground, s:background,  "bold")
  call <SID>X("MoreMsg",         s:foreground, s:background,  "bold")
  call <SID>X("NonText",         s:darkgreen,  s:gray90,      "none")
  call <SID>X("PreProc",         s:blue,       s:background,  "none")
  call <SID>X("Question",        s:green,      s:background,  "bold")
  call <SID>X("Special",         s:darkblue,   s:background,  "none")
  call <SID>X("SpecialKey",      s:darkblue,   s:background,  "none")
  call <SID>X("StatusLine",      s:foreground, s:background,  "bold")
  call <SID>X("StatusLineNC",    s:foreground, s:background,  "reverse")
  call <SID>X("String",          s:darkgreen,  s:background,  "none")
  call <SID>X("TabLineFill",     s:foreground, s:background,  "reverse")
  call <SID>X("TabLine",         s:foreground, s:gray75,      "none")
  call <SID>X("TabLineSel",      s:foreground, s:background,  "bold")
  call <SID>X("Title",           s:black,      s:background,  "bold")
  call <SID>X("Todo",            s:foreground, s:yellow,      "none")
  call <SID>X("Type",            s:lightred,   s:background,  "bold")
  call <SID>X("Underlined",      s:foreground, s:background,  "underline")
  call <SID>X("VertSplit",       s:foreground, s:background,  "bold")
  call <SID>X("Visual",          s:foreground, s:gray75,      "none")
  call <SID>X("WarningMsg",      s:lightred,   s:background,  "none")
  call <SID>X("Statement",       s:lightred,   s:background,  "none")
  call <SID>X("DiffAdd",         s:foreground, s:lightgreen,  "none")
  call <SID>X("DiffChange",      s:foreground, s:lightpink,   "none")
  call <SID>X("DiffText",        s:foreground, s:gray75,   "none")
  call <SID>X("DiffDelete",      s:darkgreen,  s:gray75,      "bold")
  call <SID>X("LineNr",          s:gray50,     s:gray90,      "none")
  call <SID>X("Conditional",     s:purple,     s:background,  "bold")
  call <SID>X("Repeat",          s:purple,     s:background,  "bold")
  call <SID>X("Structure",       s:blue,       s:background,  "bold")
  call <SID>X("Function",        s:lightred,   s:background,  "none")
  call <SID>X("Keyword",         s:darkblue,   s:background,  "none")
  call <SID>X("Global",          s:blue,       s:background,  "none")
  call <SID>X("Operator",        s:lightred,   s:background,  "none")
  call <SID>X("Define",          s:purple,     s:background,  "none")
  call <SID>X("Include",         s:red,        s:background,  "none")
  call <SID>X("PreCondit",       s:darkblue,   s:background,  "bold")
  call <SID>X("StorageClass",    s:darkblue,   s:background,  "none")
  if version >= 700
    call <SID>X("CursorColumn",    s:foreground, s:gray90,      "none")
    call <SID>X("CursorLine",      s:foreground, s:gray90,      "none")
    call <SID>X("SignColumn",      s:gray50,     s:gray90,      "none")
    call <SID>X("PMenu",           s:foreground, s:gray90,      "none")
    call <SID>X("PMenuSbar",       s:foreground, s:gray90,      "reverse")
    call <SID>X("PMenuThumb",      s:foreground, s:gray90,      "none")
    call <SID>X("PMenuSel",        s:foreground, s:gray90,      "reverse")
  endif
  if version >= 703
    call <SID>X("ColorColumn",     s:foreground, s:lightpink,    "none")
    call <SID>X("CursorLineNr",    s:gray50,     s:gray90,      "bold")
  end


  " Makefile Highlighting
  call <SID>X("makeIdent",       s:blue,       s:background,  "none")
  call <SID>X("makeSpecTarget",  s:green,      s:background,  "none")
  call <SID>X("makeTarget",      s:red,        s:background,  "bold")
  call <SID>X("makeStatement",   s:darkblue,   s:background,  "bold")

  " HTML Highlighting
  call <SID>X("htmlH1",          s:black,      s:background,  "bold")
  call <SID>X("htmlH2",          s:darkblue,   s:background,  "bold")
  call <SID>X("htmlH3",          s:purple,     s:background,  "bold")
  call <SID>X("htmlH4",          s:lightred,   s:background,  "bold")
  call <SID>X("htmlTag",         s:lightred,   s:background,  "none")
  call <SID>X("htmlBold",        s:black,      s:background,  "none")
  call <SID>X("htmlItalic",      s:gray50,     s:background,  "none")
  call <SID>X("htmlBoldItalic",  s:darkblue,   s:background,  "none")

  " Markdown/Pandox Highlighting
  call <SID>X("markdownH1",            s:black,      s:background,  "bold")
  call <SID>X("markdownH2",            s:darkblue,   s:background,  "bold")
  call <SID>X("markdownH3",            s:purple,     s:background,  "bold")
  call <SID>X("markdownH4",            s:lightred,   s:background,  "bold")
  call <SID>X("markdownCode",          s:foreground, s:gray90,      "none")
  call <SID>X("pandocNoFormatted",     s:foreground, s:gray90,      "none")
  call <SID>X("markdownItalic",        s:foreground, s:background,  "underline")
  call <SID>X("markdownLinkText",      s:blue,       s:background,  "bold")
  call <SID>X("pandocReferenceLabel",  s:blue,       s:background,  "bold")
  call <SID>X("markdownURL",           s:gray50,     s:background,  "none")
  call <SID>X("pandocReferenceURL",    s:gray50,     s:background,  "none")
  call <SID>X("markdownCodeBlock",     s:foreground, s:background,  "none")
  hi def link markdownError Normal
  hi def link pandocCodeblock String

  " LaTeX Highlighting
  call <SID>X("bibKey",          s:darkblue,   s:background,  "bold")


   " Plugin: Netrw
   call <SID>X("netrwVersion",   s:red,        s:background,  "none")
   call <SID>X("netrwList",      s:lightred,   s:background,  "none")
   call <SID>X("netrwHidePat",   s:green,      s:background,  "none")
   call <SID>X("netrwQuickHelp", s:blue,       s:background,  "none")
   call <SID>X("netrwHelpCmd",   s:blue,       s:background,  "none")
   call <SID>X("netrwDir",       s:darkblue,   s:background,  "bold")
   call <SID>X("netrwClassify",  s:lightred,   s:background,  "none")
   call <SID>X("netrwExe",       s:darkgreen,  s:background,  "none")
   call <SID>X("netrwSuffixes",  s:gray50,     s:background,  "none")

   " Plugin: gitgutter
  call <SID>X("GitGutterAdd",          s:darkgreen,     s:gray90,      "none")
  call <SID>X("GitGutterChange",       s:red,           s:gray90,      "none")
  call <SID>X("GitGutterDelete",       s:darkblue,      s:gray90,      "none")
  call <SID>X("GitGutterChangeDelete", s:gray50,        s:gray90,      "none")

  " Delete Functions
  delf <SID>X
  delf <SID>rgb
  delf <SID>colour
  delf <SID>rgb_colour
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_colour
  delf <SID>grey_level
  delf <SID>grey_number
endif
