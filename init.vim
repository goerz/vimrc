" Main VIM Configuration File
" Author: Michael Goerz <goerz@physik.uni-kassel.de>

" Python interpreter (neovim)
"let g:python_host_prog = $HOME.'/anaconda/bin/python'

" Pathogen --allows to install plugins in .vim/bundle
execute pathogen#infect()

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

" pastetoggle
set pastetoggle=<C-L>p
nnoremap <Leader>p :set invpaste<CR>

" Save
nnoremap <leader>w :w!<cr>

" Align to mark 'a
nnoremap <leader>a :call AlignToMark('a')<CR>

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

" command mode mappings
" Use emacs-style shortcuts, remap diagraph-insertion to <C-D>
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <C-K>
cnoremap <C-K> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>


" windowing commands -- I prefer vertical splits
" however, keep all CTRL-W CTRL-XX commands at the default!
set splitright
set splitbelow
:map <c-w>f :vertical wincmd f<CR>
:map <c-w>gf :vertical wincmd f<CR>
:map <c-w>] :vertical wincmd ]<CR>
:map <c-w>n :vnew<CR>
" Wrap window-move-cursor
" http://stackoverflow.com/questions/13848429/is-there-a-way-to-have-window-navigation-wrap-around-in-vim<Paste>
function! s:GotoNextWindow( direction, count )
  let l:prevWinNr = winnr()
  execute a:count . 'wincmd' a:direction
  return winnr() != l:prevWinNr
endfunction
function! s:JumpWithWrap( direction, opposite )
  if ! s:GotoNextWindow(a:direction, v:count1)
    call s:GotoNextWindow(a:opposite, 999)
  endif
endfunction
nnoremap <silent> <C-w>h :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w>j :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w>k :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w>l :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>
nnoremap <silent> <C-w><Left> :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w><Down> :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w><Up> :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w><Right> :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>

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
let g:airline_section_b='%{WhitespaceCheck()}%{StatusCwd()}%f%m'
let g:airline_section_c='%3p%% '.g:airline_linecolumn_prefix.'%3l/%L:%3c'
let g:airline_section_z='%{g:airline_externals_fugitive}'

" Use proper highlighting for the active status line (otherwise font colors
" are messed up)
if !has('nvim')
    set highlight+=sr
endif
set laststatus=2 " always show status line

" set the terminal title
"set title
"set titleold=xterm

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
if ! has('nvim')
    set esckeys
endif

" get easier to use and more user friendly Vim defaults
" CAUTION: This option breaks some vi compatibility.
"          Switch it off if you prefer real vi compatibility
set nocompatible

" Enabled XSMP connection. This seems to enable the X clipboard when vim
" is called with the -X option
"call serverlist()

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
if !empty($COLORFGBG)
    let s:bg_color_code = split($COLORFGBG, ";")[-1]
    if s:bg_color_code == 8 || s:bg_color_code  <= 6
        set background=dark
    else
        set background=light
    endif
endif
colorscheme goerz
autocmd FileType tex hi! texSectionTitle gui=underline term=bold cterm=underline,bold
autocmd FileType tex hi! Statement gui=none term=none cterm=none

" Datestamps
if exists("*strftime")
    nmap <leader>d a<c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
    imap <C-L>d <c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
endif

" abbreviations / commands
command Noindent setl noai nocin nosi inde=
command German set spell spelllang=de_20
command English set spell spelllang=en
command Python set nospell ft=python
command ManualFolding set foldenable foldmethod=manual
command WriteDark set background=dark | colorscheme peaksea | Goyo 100
command WriteLight set background=light | colorscheme peaksea | Goyo 100
command Dark set background=dark | colorscheme peaksea
cabbr AB 'a,'b

" Activate wildmenu
set wildmenu

" Hide Toolbar and mouse usage in Macvim
if has("gui_running")
    set guioptions=egmrt
    set mouse=a
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
" Custom mappings between extensions and filetypes are done by the scripts in
" the ftdetect folder

" Hiding of quotes in json files
let g:vim_json_syntax_conceal=0

" For some programming languages, delete trailing spaces on save
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufWritePre *.pl normal m`:%s/\s\+$//e ``
