" Main VIM Configuration File
" Author: Michael Goerz <goerz@physik.uni-kassel.de>

" * Interface Settings {{{1

" switch ' and `
nnoremap ' `
nnoremap ` '

" Leader keys
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"
let g:maplocalleader = "\\"

set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" use the mouse in xterm (or other terminals that support it)
" Toggle with ,m
set mouse=
set ttymouse=xterm2
fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse=""
        echo "Mouse is for terminal"
    endif
endfunction
nnoremap <Leader>m :call <SID>ToggleMouse()<CR>

" pastetoggle
set pastetoggle=<C-L>p
nnoremap <Leader>p :set invpaste<CR>

" Save
nnoremap <leader>w :w!<cr>

" paste without cutting
vnoremap p "_dP

" Up/down, j/k key behaviour
" -- Changes up/down arrow keys to behave screen-wise, rather than file-wise.
"    Behaviour is unchanged in operator-pending mode.
if version >= 700
    " Stop remapping from interfering with Omni-complete popup
    inoremap <silent><expr><Up> pumvisible() ? "<Up>" : "<C-O>gk"
    inoremap <silent><expr><Down> pumvisible() ? "<Down>" : "<C-O>gj"
else
    inoremap <silent><Up> <C-O>gk
    inoremap <silent><Down> <C-O>gj
endif

nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap <silent><Up> gk
nnoremap <silent><Down> gj
vnoremap <silent>j gj
vnoremap <silent>k gk
vnoremap <silent><Up> gk
vnoremap <silent><Down> gj

" windowing commands -- I prefer vertical splits
" however, keep all CTRL-W CTRL-XX commands at the default!
set splitright
set splitbelow
:map <c-w>f :vertical wincmd f<CR>
:map <c-w>gf :vertical wincmd f<CR>
:map <c-w>] :vertical wincmd ]<CR>
:map <c-w>n :vnew<CR>

" persistent undo
if has("persistent_undo")
    set undodir=~/.vim/undo/
    set undofile
    au BufWritePre /tmp/* setlocal noundofile
endif

" swap and backup
set backupdir=~/.vim/backup/
set directory=~/.vim/backup/

" indicate textwidth with color column
if exists("+colorcolumn")
    set colorcolumn=+1
endif

" enable syntax highlighting
syntax on
syntax sync fromstart

" enable incremental search, and search highlighting by default
set hlsearch " opposite of set nohlsearch
set incsearch
" Disable search highlighting by pressing ESC in normal mode
:nnoremap <esc> :nohlsearch<return><esc>
" Note that the nohlsearch *command* is different from the nohlsearch
" *option*: the command just switches off the hightlighting, but it will
" appear again on the next search command. The option switches if off
" permanently

" Reload the file if it changes outside of vim
set autoread

" select case-insenitiv search
set ignorecase
set smartcase

" Trailing whitespace detection
function! WhitespaceCheck()
  if &readonly || mode() != 'n'
    return ''
  endif
  let trailing = search(' $', 'nw')
  let indents = [search('^ ', 'nb'), search('^ ', 'n'), search('^\t', 'nb'), search('^\t', 'n')]
  let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
  if trailing != 0 || mixed
    return "(!) "
  endif
  return ''
endfunction!

" statusline is set by the airline plugin
" You may only set the powerline fonts to 1 if you have insalled  the
" powerline fonts, https://github.com/Lokaltog/powerline-fonts
let g:airline_theme='goerz'
let g:airline_powerline_fonts=0
"
let g:airline_enable_syntastic=0
let g:airline_modified_detection=0
if (g:airline_powerline_fonts==0)
    "let g:airline_left_sep=''
    "let g:airline_right_sep=''
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_linecolumn_prefix = '¶ '
    let g:airline_fugitive_prefix = ''
endif
let g:airline_section_b='%{WhitespaceCheck()}%f%m'
let g:airline_section_c='%3p%% '.g:airline_linecolumn_prefix.'%3l/%L:%3c'
let g:airline_section_z='%{g:airline_externals_fugitive}'

" Use proper highlighting for the active status line (otherwise font colors
" are messed up)
set highlight+=sr
set laststatus=2 " always show status line

" set the terminal title
set title
set titleold=xterm

" show cursor line and column, if no statusline
set ruler

" shorten command-line text and other info tokens
set shortmess=atI

" don't jump between matching brackets while typing
set noshowmatch

" display mode INSERT/REPLACE/...
set showmode

" When selecting blocks, allow to move the cursor beyond the end of the line
set virtualedit=block

" remember more commands and search patterns
set history=1000

" changes special characters in search patterns (default)
" set magic

" define some listchars, but keep 'list' disabled by default
set lcs=tab:>-,trail:-,nbsp:~
set nolist

" Required to be able to use keypad keys and map missed escape sequences
set esckeys

" get easier to use and more user friendly Vim defaults
" CAUTION: This option breaks some vi compatibility.
"          Switch it off if you prefer real vi compatibility
set nocompatible

" Enabled XSMP connection. This seems to enable the X clipboard when vim
" is called with the -X option
call serverlist()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Complete longest common string, then each full match
" (bash compatible behavior)
set wildmode=longest,full

" No bells
set noerrorbells
if has('autocmd')
  autocmd GUIEnter * set vb t_vb=
endif

" Show Buffer Tabs
set showtabline=1               "Display the tabbar if there are multiple tabs. Use :tab ball or invoke Vim with -p
set hidden                      "allows opening a new buffer in place of an existing one without first saving the existing one

" Search the first 5 lines for modelines
set modelines=5

" Folding settings
set nofoldenable " Don't show folds by default
autocmd BufWinLeave ?* mkview          " Store fold settings for all buffers ...
"autocmd BufWinEnter ?* silent loadview " ... and reload them


" Taglist plugin
let Tlist_Inc_Winwidth = 0 " Don't enlarge the terminal
noremap <silent> <leader>t :TlistToggle<CR><C-W>h

" Gundo plugin
nnoremap <silent> <leader>u :GundoToggle<CR>

" Syntastic plugin
let g:syntastic_check_on_open=1
let g:syntastic_echo_current_error=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump=0
let g:syntastic_auto_loc_list=2
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

" pylint compiler settings
let g:pylint_onwrite = 0  " Don't call pylint every time file is saved
let g:pylint_cwindow = 0  " Don't open QuickFix Window automatically

" Nerd_commenter plugin
let g:NERDShutUp = 1

" vmath plugin
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

" Activate 256 colors independently of terminal. Most of my terms are 256
" colors. For those cases where I'm running vim in a low-color terminal, this
" is only safe if I'm using screen (which I always am).
set t_Co=256

" Default Color Scheme
colorscheme goerz
autocmd FileType tex hi! texSectionTitle gui=underline term=bold cterm=underline,bold
autocmd FileType tex hi! Statement gui=none term=none cterm=none

" Forward SyncTeX
autocmd FileType tex nnoremap <Leader>s :w<CR>:silent !$SYNCTEXREADER -g <C-r>=line('.')<CR> %<.pdf %<CR><C-l>

" Datestamps
if exists("*strftime")
    nmap <leader>d a<c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
    imap <C-L>d <c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
endif

" abbreviations / commands
command German set spell spelllang=de_20
command English set spell spelllang=en
command Python set nospell ft=python
command ManualFolding set foldenable foldmethod=manual
command WriteDark set background=dark | colorscheme peaksea | Goyo 80
command WriteLight set background=light | colorscheme peaksea | Goyo 80
command Dark set background=dark | colorscheme peaksea
cabbr AB 'a,'b

" Activate wildmenu
set wildmenu

" Hide Toolbar in Macvim
if has("gui_running")
    set guioptions=egmrt
endif


" * Text Formatting -- General {{{1

" don't make it look like there are line breaks where there aren't:
set nowrap
" but if we wrap, use a nice unicode character to indicate the linebreak, and
" don't break in the middle of a word
set showbreak=↪
set linebreak

" tab stops should be at 4 spaces
set tabstop=4

" use indents of 4 spaces:
set shiftwidth=4
set shiftround
set expandtab
set noautoindent

" don't break text by default:
set formatoptions=tcql
set textwidth=0

" My default language is American English
set spelllang=en_us

set grepprg=~/.vim/scripts/ack

" Use # without VIM moving it to the first column
inoremap # X<C-H>#

" Temporary files
set wildignore+=*.o,*.obj
set wildignore+=*.bak,*~,*.tmp,*.backup


" Printing settings
set printoptions=paper:a4,number:y,left:25pt,right:40pt
set printheader=%<%f%h%m\ \ (%{strftime('%m/%d/%y\ %X')})%=Page\ %N


" * Text Formatting -- Specific File Formats {{{1

" enable filetype detection:
filetype plugin on
filetype plugin indent on

augroup filetype
  autocmd BufNewFile,BufRead */.Postponed/* set filetype=mail textwidth=71
  autocmd BufNewFile,BufRead *.txt set filetype=human
  autocmd BufNewFile,BufRead *.mail set filetype=mail
  autocmd BufNewFile,BufRead Safari*Google*Mail*.txt set filetype=mail
  autocmd BufNewFile,BufRead Notational*Velocity*.txt set filetype=pandoc
  autocmd BufNewFile,BufRead *mailplane* set filetype=mail
  autocmd BufNewFile,BufRead *ipython-desktop* set filetype=python
  autocmd BufNewFile,BufRead *.wordpress set filetype=html
  autocmd BufNewFile,BufRead *.fionacms set filetype=html
  autocmd BufNewFile,BufRead *.tikz set filetype=plaintex
  autocmd BufNewFile,BufRead *.sty set filetype=plaintex
  autocmd BufNewFile,BufRead *.fi set filetype=fortran
  autocmd BufNewFile,BufRead *.plt set filetype=gnuplot
  autocmd BufNewFile,BufRead README.* set filetype=human
  autocmd BufNewFile,BufRead INSTALL set filetype=human
  autocmd BufNewFile,BufRead *vimperatorrc*,*.vimp set filetype=vimperator
  autocmd BufNewFile,BufRead *.viki set filetype=viki
  autocmd BufNewFile,BufRead *.dat set filetype=csv
  autocmd BufNewFile,BufRead *.markdown set filetype=markdown
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.pdc set filetype=pandoc
  autocmd BufNewFile,BufRead *.pandoc set filetype=pandoc
augroup END

" For some programming languages, delete trailing spaces on save
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufWritePre *.pl normal m`:%s/\s\+$//e ``

" Viki bugfix
" Remove space from vikiMapKeys, which causes abbreviations not to work. Must
" be set befor the viki plugin is loaded, i.e. here.
let g:vikiMapKeys = "]).,;:!?\"'"


" * Terminal Specific Settings {{{1

if &term =~ "linux$"
    colorscheme default
    set t_Co=8
endif

" Try to get the correct main terminal type
if &term =~ "xterm"
    let myterm = "xterm"
else
    let myterm =  &term
endif
let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

" Here we define the keys of the NumLock in keyboard transmit mode of xterm
" which misses or hasn't activated Alt/NumLock Modifiers.  Often not defined
" within termcap/terminfo and we should map the character printed on the keys.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <ESC>Oo  :
    map! <ESC>Oj  *
    map! <ESC>Om  -
    map! <ESC>Ok  +
    map! <ESC>Ol  ,
    map! <ESC>OM  
    map! <ESC>Ow  7
    map! <ESC>Ox  8
    map! <ESC>Oy  9
    map! <ESC>Ot  4
    map! <ESC>Ou  5
    map! <ESC>Ov  6
    map! <ESC>Oq  1
    map! <ESC>Or  2
    map! <ESC>Os  3
    map! <ESC>Op  0
    map! <ESC>On  .
    " keys in normal mode
    map <ESC>Oo  :
    map <ESC>Oj  *
    map <ESC>Om  -
    map <ESC>Ok  +
    map <ESC>Ol  ,
    map <ESC>OM  
    map <ESC>Ow  7
    map <ESC>Ox  8
    map <ESC>Oy  9
    map <ESC>Ot  4
    map <ESC>Ou  5
    map <ESC>Ov  6
    map <ESC>Oq  1
    map <ESC>Or  2
    map <ESC>Os  3
    map <ESC>Op  0
    map <ESC>On  .
endif

" xterm but without activated keyboard transmit mode
" and therefore not defined in termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>[H  <Home>
    map! <Esc>[F  <End>
    " Home/End: older xterms do not fit termcap/terminfo.
    map! <Esc>[1~ <Home>
    map! <Esc>[4~ <End>
    " Up/Down/Right/Left
    map! <Esc>[A  <Up>
    map! <Esc>[B  <Down>
    map! <Esc>[C  <Right>
    map! <Esc>[D  <Left>
    " KP_5 (NumLock off)
    map! <Esc>[E  <Insert>
    " PageUp/PageDown
    map <ESC>[5~ <PageUp>
    map <ESC>[6~ <PageDown>
    map <ESC>[5;2~ <PageUp>
    map <ESC>[6;2~ <PageDown>
    map <ESC>[5;5~ <PageUp>
    map <ESC>[6;5~ <PageDown>
    " keys in normal mode
    map <ESC>[H  0
    map <ESC>[F  $
    " Home/End: older xterms do not fit termcap/terminfo.
    map <ESC>[1~ 0
    map <ESC>[4~ $
    " Up/Down/Right/Left
    map <ESC>[A  k
    map <ESC>[B  j
    map <ESC>[C  l
    map <ESC>[D  h
    " KP_5 (NumLock off)
    map <ESC>[E  i
    " PageUp/PageDown
    map <ESC>[5~ 
    map <ESC>[6~ 
    map <ESC>[5;2~ 
    map <ESC>[6;2~ 
    map <ESC>[5;5~ 
    map <ESC>[6;5~ 
endif

" xterm/kvt but with activated keyboard transmit mode.
" Sometimes not or wrong defined within termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>OH <Home>
    map! <Esc>OF <End>
    map! <ESC>O2H <Home>
    map! <ESC>O2F <End>
    map! <ESC>O5H <Home>
    map! <ESC>O5F <End>
    " Cursor keys which works mostly
    " map! <Esc>OA <Up>
    " map! <Esc>OB <Down>
    " map! <Esc>OC <Right>
    " map! <Esc>OD <Left>
    map! <Esc>[2;2~ <Insert>
    map! <Esc>[3;2~ <Delete>
    map! <Esc>[2;5~ <Insert>
    map! <Esc>[3;5~ <Delete>
    map! <Esc>O2A <PageUp>
    map! <Esc>O2B <PageDown>
    map! <Esc>O2C <S-Right>
    map! <Esc>O2D <S-Left>
    map! <Esc>O5A <PageUp>
    map! <Esc>O5B <PageDown>
    map! <Esc>O5C <S-Right>
    map! <Esc>O5D <S-Left>
    " KP_5 (NumLock off)
    map! <Esc>OE <Insert>
    " keys in normal mode
    map <ESC>OH  0
    map <ESC>OF  $
    map <ESC>O2H  0
    map <ESC>O2F  $
    map <ESC>O5H  0
    map <ESC>O5F  $
    " Cursor keys which works mostly
    " map <ESC>OA  k
    " map <ESC>OB  j
    " map <ESC>OD  h
    " map <ESC>OC  l
    map <Esc>[2;2~ i
    map <Esc>[3;2~ x
    map <Esc>[2;5~ i
    map <Esc>[3;5~ x
    map <ESC>O2A  ^B
    map <ESC>O2B  ^F
    map <ESC>O2D  b
    map <ESC>O2C  w
    map <ESC>O5A  ^B
    map <ESC>O5B  ^F
    map <ESC>O5D  b
    map <ESC>O5C  w
    " KP_5 (NumLock off)
    map <ESC>OE  i
endif

if myterm == "linux"
    " keys in insert/command mode.
    map! <Esc>[G  <Insert>
    " KP_5 (NumLock off)
    " keys in normal mode
    " KP_5 (NumLock off)
    map <ESC>[G  i
endif

" This escape sequence is the well known ANSI sequence for
" Remove Character Under The Cursor (RCUTC[tm])
map! <Esc>[3~ <Delete>
map  <ESC>[3~    x

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

endif " has("autocmd")

