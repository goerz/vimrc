" Vim color file (goerzcolors.vim)
" Maintainer:    Michael Goerz <goerz@physik.fu-berlin.de>
" Last Change:    2008 May 25
"
" This color scheme uses a light grey background.  It is my personal variation
" of the 256 automation color scheme.
" As opposed to the original theme, this one draws attention away from
" comments
"

" First remove all existing highlighting.
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "goerzcolors"


" Note on 256 color terminals:
" A decent compilation of xterm and other terminals should have support
" for 256 colors, instead of the standard 16. Test this with the scripts
" in the ~/.vim/scripts directory. If you have 256 colors, you can let vim
" know by either setting $TERM to 'xterm-256color' or calling vim as
" 'vim -T xterm-256color'. You might want to use that as an alias.
" See http://www.frexx.de/xterm-256-notes/  for further information.

if has("gui_running")
    " My settings for gvim are very similar to the settings for a 256 color
    " terminal
    let colors_name = "goerzcolors_gui"
    hi Comment          gui=none       guifg=#808080
    hi Constant         gui=none       guifg=#000087   guibg=#ffffff
    hi CursorColumn     gui=none                       guibg=#bcbcbc
    hi Cursor           gui=none       guifg=#000000   guibg=#000000
    hi CursorIM         gui=none                       guibg=#262626
    hi CursorLine       gui=underline

    hi Directory        gui=none       guifg=#000087
    hi Error            gui=none       guifg=#ffffff   guibg=#af0000
    hi ErrorMsg         gui=none       guifg=#ffffff   guibg=#af0000
    hi FoldColumn       gui=none       guifg=#000087   guibg=#bcbcbc
    hi Folded           gui=none       guifg=#000087   guibg=#ffffff
    hi Identifier       gui=none       guifg=#005f87
    hi Ignore           gui=none       guifg=#e5e5e5
    hi IncSearch        gui=bold
    hi Label            gui=bold       guifg=#000087
    hi lCursor          gui=none       guifg=#000000   guibg=#00ffff
    hi MatchParen       gui=none                       guibg=#cdcd00
    hi ModeMsg          gui=bold
    hi MoreMsg          gui=bold       guifg=#00875f
    hi NonText          gui=bold       guifg=#005f00   guibg=#dadada
    hi Normal           gui=none       guifg=#000000   guibg=#ffffff
    hi PreProc          gui=none       guifg=#8700af
    hi Question         gui=bold       guifg=#00ff00
    hi Search           gui=none       guifg=#000000   guibg=#ffff00
    hi SignColumn       gui=none       guifg=#626262   guibg=#dadada
    hi Special          gui=none       guifg=#000087   guibg=#ffffff
    hi SpecialKey       gui=none       guifg=#000087
    hi StatusLine       gui=bold
    hi StatusLineNC     gui=bold
    hi String           gui=none       guifg=#00af00
    hi TabLineFill      gui=reverse
    hi TabLine          gui=none                       guibg=#e5e5e5
    hi TabLineSel       gui=bold
    hi Title            gui=bold       guifg=#000087
    hi Todo             gui=none                       guibg=#ffff00
    hi Type             gui=none       guifg=#005f00
    hi Underlined       gui=underline
    hi VertSplit        gui=bold
    hi Visual           gui=bold       guifg=#808080   guibg=#e5e5e5
    hi VisualNOS        gui=none       guifg=#808080   guibg=#e5e5e5
    hi WarningMsg       gui=none       guifg=#ff0000
    hi WildMenu         gui=none       guifg=#000000   guibg=#ffff00
    hi Statement        gui=bold       guifg=#0000d7
    " second, non-88color-compatible colors
    hi DiffAdd      gui=none                       guibg=#d7ffd7
    hi DiffChange   gui=none                       guibg=#ffafff
    hi DiffDelete   gui=bold       guifg=#005f00   guibg=#dadada
    hi DiffText     gui=bold                       guibg=#ff87ff
    hi LineNr       gui=none       guifg=#626262   guibg=#eeeeee
    if v:version >= 700
        hi Pmenu        gui=none                   guibg=#ffafd7
        hi PmenuSbar    gui=none                   guibg=#9e9e9e
        hi PmenuSel     gui=none                   guibg=#9e9e9e
        hi PmenuThumb   gui=reverse
        hi spellbad     gui=none                   guibg=#ffd7ff
        hi SpellCap     gui=none                   guibg=#d7ffff
        hi SpellLocal   gui=none                   guibg=#ffd7ff
        hi SpellRare    gui=none                   guibg=#ffd7ff
    endif
else
    if &t_Co >= 256
        let colors_name = "goerzcolors_256"
        " this is for 256 color terminals
        " first, the colors that are compatible to a 88-color terminal
        hi Normal           cterm=none       ctermfg=0
        hi Comment          cterm=none       ctermfg=244
        hi Constant         cterm=none       ctermfg=18
        hi CursorColumn     cterm=none                    ctermbg=250
        hi Cursor           cterm=none       ctermfg=0    ctermbg=0
        hi CursorIM         cterm=none                    ctermbg=235
        hi CursorLine       cterm=underline

        hi Directory        cterm=none       ctermfg=18
        hi Error            cterm=none       ctermfg=15   ctermbg=124
        hi ErrorMsg         cterm=none       ctermfg=15   ctermbg=124
        hi FoldColumn       cterm=none       ctermfg=18   ctermbg=250
        hi Folded           cterm=none       ctermfg=18
        hi Identifier       cterm=none       ctermfg=24
        hi Ignore           cterm=none       ctermfg=7
        hi IncSearch        cterm=bold
        hi Label            cterm=bold       ctermfg=18
        hi lCursor          cterm=none       ctermfg=0    ctermbg=14
        hi MatchParen       cterm=none                    ctermbg=3
        hi ModeMsg          cterm=bold
        hi MoreMsg          cterm=bold       ctermfg=29
        hi NonText          cterm=bold       ctermfg=22   ctermbg=253
        hi PreProc          cterm=none       ctermfg=91
        hi Question         cterm=bold       ctermfg=10
        hi Search           cterm=none       ctermfg=0    ctermbg=11
        hi SignColumn       cterm=none       ctermfg=241  ctermbg=253
        hi Special          cterm=none       ctermfg=18
        hi SpecialKey       cterm=none       ctermfg=18
        hi StatusLine       cterm=bold
        hi StatusLineNC     cterm=bold
        hi String           cterm=none       ctermfg=34
        hi TabLineFill      cterm=reverse
        hi TabLine          cterm=none                    ctermbg=7
        hi TabLineSel       cterm=bold
        hi Title            cterm=bold       ctermfg=18
        hi Todo             cterm=none                    ctermbg=11
        hi Type             cterm=none       ctermfg=22
        hi Underlined       cterm=underline
        hi VertSplit        cterm=bold
        hi Visual           cterm=bold       ctermfg=244  ctermbg=7
        hi VisualNOS        cterm=none       ctermfg=244  ctermbg=7
        hi WarningMsg       cterm=none       ctermfg=9
        hi WildMenu         cterm=none       ctermfg=0    ctermbg=11
        hi Statement        cterm=bold       ctermfg=12
        " second, non-88color-compatible colors
        hi DiffAdd      cterm=none                    ctermbg=194
        hi DiffChange   cterm=none                    ctermbg=219
        hi DiffDelete   cterm=bold       ctermfg=22   ctermbg=253
        hi DiffText     cterm=bold                    ctermbg=213
        hi LineNr       cterm=none       ctermfg=241  ctermbg=255
        if v:version >= 700
            hi Pmenu        cterm=none                    ctermbg=218
            hi PmenuSbar    cterm=none                    ctermbg=247
            hi PmenuSel     cterm=none                    ctermbg=247
            hi PmenuThumb   cterm=reverse
            hi spellbad     cterm=none                    ctermbg=225
            hi SpellCap     cterm=none                    ctermbg=195
            hi SpellLocal   cterm=none                    ctermbg=225
            hi SpellRare    cterm=none                    ctermbg=225
        endif
    elseif &t_Co >= 88
        let colors_name = "goerzcolors_88"
        " this is for 88 color terminals
        " first, the "compatible" colors: these were automatically converted
        " from the colors for 256-color terminals
        hi Comment          cterm=none       ctermfg=84
        hi Constant         cterm=none       ctermfg=18
        hi CursorColumn     cterm=none                    ctermbg=86
        hi Cursor           cterm=none       ctermfg=0    ctermbg=0
        hi CursorIM         cterm=none                    ctermbg=81
        hi CursorLine       cterm=underline

        hi Directory        cterm=none       ctermfg=18
        hi Error            cterm=none       ctermfg=15   ctermbg=64
        hi ErrorMsg         cterm=none       ctermfg=15   ctermbg=64
        hi FoldColumn       cterm=none       ctermfg=18   ctermbg=86
        hi Folded           cterm=none       ctermfg=18
        hi Identifier       cterm=none       ctermfg=22
        hi Ignore           cterm=none       ctermfg=7
        hi IncSearch        cterm=bold
        hi Label            cterm=bold       ctermfg=18
        hi lCursor          cterm=none       ctermfg=0    ctermbg=14
        hi MatchParen       cterm=none                    ctermbg=3
        hi ModeMsg          cterm=bold
        hi MoreMsg          cterm=bold       ctermfg=25
        hi NonText          cterm=bold       ctermfg=20   ctermbg=87
        hi Normal           cterm=none       ctermfg=0
        hi PreProc          cterm=none       ctermfg=51
        hi Question         cterm=bold       ctermfg=10
        hi Search           cterm=none       ctermfg=0    ctermbg=11
        hi SignColumn       cterm=none       ctermfg=83   ctermbg=87
        hi Special          cterm=none       ctermfg=18
        hi SpecialKey       cterm=none       ctermfg=18
        hi StatusLine       cterm=bold
        hi StatusLineNC     cterm=bold
        hi String           cterm=none       ctermfg=28
        hi TabLineFill      cterm=reverse
        hi TabLine          cterm=none                    ctermbg=7
        hi TabLineSel       cterm=bold
        hi Title            cterm=bold       ctermfg=18
        hi Todo             cterm=none                    ctermbg=11
        hi Type             cterm=none       ctermfg=20
        hi Underlined       cterm=underline
        hi VertSplit        cterm=bold
        hi Visual           cterm=bold       ctermfg=84   ctermbg=7
        hi VisualNOS        cterm=none       ctermfg=84   ctermbg=7
        hi WarningMsg       cterm=none       ctermfg=9
        hi WildMenu         cterm=none       ctermfg=0    ctermbg=11
        hi Statement        cterm=bold       ctermfg=12
        " second, non-compatible colors, these were set manually
        hi DiffAdd          cterm=none                    ctermbg=10
        hi DiffChange       cterm=none                    ctermbg=13
        hi DiffDelete       cterm=bold       ctermfg=20   ctermbg=87
        hi DiffText         cterm=bold                    ctermbg=9
        hi LineNr           cterm=none       ctermfg=83   ctermbg=87
        if v:version >= 700
            hi Pmenu        cterm=none                    ctermbg=74
            hi PmenuSbar    cterm=none                    ctermbg=85
            hi PmenuSel     cterm=none                    ctermbg=85
            hi PmenuThumb   cterm=reverse
            hi spellbad     cterm=none                    ctermbg=69
            hi SpellCap     cterm=none                    ctermbg=87
            hi SpellLocal   cterm=none                    ctermbg=69
            hi SpellRare    cterm=none                    ctermbg=69
        endif
    else
        " There's no point in setting anything for low color terminals
        " The defaults are good enough in that case
        let colors_name = "goerzcolors_default"
    endif
endif

hi link Boolean Constant
hi link Character Constant
hi link Conditional Statement
hi link Debug Special
hi link Define PreProc
hi link Delimiter Special
hi link Exception Statement
hi link Float Constant
hi link Function Identifier
hi link Include PreProc
hi link Keyword Statement
hi link Label Statement
hi link Macro PreProc
hi link Number Constant
hi link Operator Statement
hi link PreCondit PreProc
hi link Repeat Statement
hi link SpecialChar Special
hi link SpecialComment Special
hi link StorageClass Type
hi link String Constant
hi link Structure Type
hi link Tag Special
hi link Typedef Type
