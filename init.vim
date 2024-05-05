" Main VIM Configuration File
" Author: Michael Goerz <mail@michaelgoerz.net>
scriptencoding utf-8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python interpreter (neovim)
if $TERM_PROGRAM != "a-Shell" && !has('win32')
  let s:python_venv2 = system('pyenv whence python2.7 | head -1 | tr -d ''\n''')
  let s:python_venv3 = system('pyenv whence python3.7 | head -1 | tr -d ''\n''')
  let s:pyenv_root = system('pyenv root | tr -d ''\n''')
  let s:pyenv_versions = s:pyenv_root . '/versions'
  let g:python_host_prog = s:pyenv_versions.'/'.s:python_venv2.'/bin/python'
  let g:python3_host_prog = s:pyenv_versions.'/'.s:python_venv3.'/bin/python'
  let g:notedown_enable = 1
endif

" enable per-directory .vimrc files
set exrc

" disable unsafe commands in local .vimrc files
set secure

" Work around neovim not running bang commands in the current tty
" https://github.com/neovim/neovim/issues/1496
if has('nvim')
  cnoremap <expr> !<space> strlen(getcmdline())?'!':('!tmux split-window -c '.getcwd().' -p 90 ')
endif

" persistent undo
if has('persistent_undo')
  if $TERM_PROGRAM == "a-Shell"
    set undodir=~/Documents/.vim/undo/
  else
    if has('nvim-0.5')
      " newer nvim writes undo files that are incompatible with older versions
      " or standard vim
      set undodir=~/.vim/undo-nvim5/
    else
      set undodir=~/.vim/undo/
    endif
  endif
  set undofile
  augroup persistent_undo
    autocmd!
    autocmd BufWritePre /tmp/* setlocal noundofile
  augroup END
endif

" swap and backup
if $TERM_PROGRAM == "a-Shell"
  set backupdir=~/Documents/.vim/backup/
  set directory=~/Documents/.vim/backup/
else
  set backupdir=~/.vim/backup/
  set directory=~/.vim/backup/
endif

" Reload the file if it changes outside of vim
set autoread

" select case-insenitiv search
set ignorecase
set smartcase

" Search the first 5 lines for modelines
set modelines=5

" Temporary files
set wildignore+=*.o,*.obj
set wildignore+=*.bak,*~,*.tmp,*.backup

" My default language is American English
set spelllang=en_us

if $TERM_PROGRAM == "a-Shell"
  set grepprg=~/Documents/.vim/scripts/ack
else
  set grepprg=~/.vim/scripts/ack
endif

" enable filetype detection:
filetype plugin on
filetype plugin indent on
" Custom mappings between extensions and filetypes are done by the scripts in
" the ftdetect folder

" Leader keys
let mapleader = ','
let g:mapleader = ','
let maplocalleader = '\\'
let g:maplocalleader = '\\'

" For some programming languages, delete trailing spaces on save
if has('autocmd')
  augroup removetrailingspaces
    autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
    autocmd BufWritePre *.pl normal m`:%s/\s\+$//e ``
  augroup END
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Interface Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enable syntax highlighting
syntax on
syntax sync fromstart

" Fix non-standard neovim mapping
" https://github.com/neovim/neovim/pull/13268
" https://github.com/neovim/neovim/issues/416
if has('nvim-0.6')
  unmap Y
endif

" use the mouse in xterm (or other terminals that support it)
" Toggle with ,m
set mouse=
"set ttymouse=xterm2
fun! s:ToggleMouse()
    if !exists('s:old_mouse')
        let s:old_mouse = 'a'
    endif
    if empty(&mouse)
        let &mouse = s:old_mouse
        echo 'Mouse is for Vim (' . &mouse . ')'
    else
        let s:old_mouse = &mouse
        let &mouse=''
        echo 'Mouse is for terminal'
    endif
endfunction
nnoremap <Leader>m :call <SID>ToggleMouse()<CR>

" windowing commands -- I prefer vertical splits
" however, keep all CTRL-W CTRL-XX commands at the default!
set splitright
set splitbelow
map <c-w>f :vertical wincmd f<CR>
map <c-w>gf :vertical wincmd f<CR>
map <c-w>] :vertical wincmd ]<CR>
map <c-w>n :vnew<CR>
" Wrap window-move-cursor
" http://stackoverflow.com/questions/13848429
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

" Always show sign column.
augroup mine
    au BufWinEnter * sign define mysign
    au BufWinEnter * exe 'sign place 1337 line=1 name=mysign buffer=' . bufnr('%')
augroup END

" indicate textwidth with color column
if exists('+colorcolumn')
    set colorcolumn=+1
endif

" enable incremental search, and search highlighting by default
set hlsearch " opposite of set nohlsearch
set incsearch
" Disable search highlighting by pressing ESC twice in normal mode
nnoremap <esc><esc> :nohlsearch<return><esc>
" Note that the nohlsearch *command* is different from the nohlsearch
" *option*: the command just switches off the hightlighting, but it will
" appear again on the next search command. The option switches if off
" permanently
" Also, trying to map this to a *single* ESC can cause strange problems like
" vim being in REPLACE mode on startup

" always show status line
set laststatus=2

" show cursor line and column, if no statusline
set ruler

" shorten message so that we don't have to press Enter so much
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
set listchars=tab:>-,trail:-,nbsp:~
set nolist

" Required to be able to use keypad keys and map missed escape sequences
if !has('nvim')
    set esckeys
endif

" Don't show folds by default
set nofoldenable

"Display the tabbar if there are multiple tabs. Use :tab ball or invoke Vim
"with -p
set showtabline=1

"allows opening a new buffer in place of an existing one without first saving
"the existing one
set hidden

" No bells
set noerrorbells
if has('autocmd')
  augroup clearvisualbell
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=
  augroup END
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Complete longest common string, then each full match
" (bash compatible behavior)
set wildmode=longest,full

" go to defn of tag under the cursor (case sensitive)
" adapted from http://tartley.com/?p=1277
fun! MatchCaseTag()
    let ignorecase = &ignorecase
    set noignorecase
    try
        exe 'tjump ' . expand('<cword>')
    catch /.*/
        echo v:exception
    finally
       let &ignorecase = ignorecase
    endtry
endfun
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

" Activate wildmenu
set wildmenu

" don't make it look like there are line breaks where there aren't:
set nowrap
" but if we wrap, use a nice unicode character to indicate the linebreak, and
" don't break in the middle of a word
set showbreak=∟
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

" Printing settings
if !has('nvim')
  " removed in vim 0.9
  set printoptions=paper:a4,number:y,left:25pt,right:40pt
  set printheader=%<%f%h%m\ \ (%{strftime('%m/%d/%y\ %X')})%=Page\ %N
endif

" Follow symlink for current file
" Sources:
"  - https://github.com/tpope/vim-fugitive/issues/147#issuecomment-7572351
"  - http://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
" Echoing a warning does not appear to work:
"   echohl WarningMsg | echo "Resolving symlink." | echohl None |
function! MyFollowSymlink(...)
  let fname = a:0 ? a:1 : expand('%')
  if getftype(fname) !=? 'link'
    if exists('+autochdir')
      if &autochdir
        let b:StatusLineCwdString = '"' . getcwd() . '"/'
      endif
    endif
    return
  endif
  let resolvedfile = fnameescape(resolve(fname))
  exec 'file ' . resolvedfile
  lcd %:p:h
  let b:followed_symlink = 1
  let b:StatusLineCwdString = '"' . getcwd() . '"/'
endfunction
command! FollowSymlink call MyFollowSymlink()
if has('autocmd')
  augroup followsymlink
    autocmd!
    autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))
  augroup END
endif

" Hide Toolbar and use mouse in Macvim or other GUIs
if has('gui_running')
  set encoding=utf-8
  set guioptions=egmrt
  set mouse=a
  if !has('gui_vimr')
    set guifont=JuliaMono,Courier:h15
  endif
endif

if exists("g:neovide")
  let g:neovide_cursor_animation_length = 0
  let g:neovid_scroll_animation_length = 0
  nnoremap <D-s> :w<CR>
  vnoremap <D-c> "*y
  nnoremap <D-v> "*P
  vnoremap <D-v> "*P
  cnoremap <D-v> <C-R>*
  inoremap <D-v> <ESC>l"*Plie
endif

if has('autocmd')
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  augroup jumptolastpos
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" switch ' and `
nnoremap ' `
nnoremap ` '

" pastetoggle
set pastetoggle=<C-L>p
nnoremap <Leader>p :set invpaste<CR>

" Save
nnoremap <leader>w :w!<cr>

" Align to mark 'a
nnoremap <leader>a :call AlignToMark('a')<CR>

" paste without cutting
vnoremap p "_dP

" Open file in external program
nnoremap go :!open <cfile><CR>

" Up/down, j/k key behaviour
" -- Changes up/down arrow keys to behave screen-wise, rather than file-wise.
"    Behaviour is unchanged in operator-pending mode.
if v:version >= 700
    " Stop remapping from interfering with Omni-complete popup
    inoremap <silent><expr><Up> pumvisible() ? "<Up>" : "<C-O>gk"
    inoremap <silent><expr><Down> pumvisible() ? "<Down>" : "<C-O>gj"
else
    inoremap <silent><Up> <C-O>gk
    inoremap <silent><Down> <C-O>gj
endif

" Make hjkl work on visual (wrapped) lines, not actual lines
nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap <silent><Up> gk
nnoremap <silent><Down> gj
vnoremap <silent>j gj
vnoremap <silent>k gk
vnoremap <silent><Up> gk
vnoremap <silent><Down> gj

" Use emacs-style shortcuts, remap diagraph-insertion to <C-D>
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <C-K>
cnoremap <C-K> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" Datestamps
if exists('*strftime')
    nmap <leader>d a<c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
    imap <C-L>d <c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Abbreviations and Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! Noindent setl noai nocin nosi inde=
command! German set spell spelllang=de_20
command! English set spell spelllang=en
command! Python set nospell ft=python
command! ManualFolding set foldenable foldmethod=manual
function! GoyoShowSigncolumn()
  " re-enable the sign-column after Goyo has made it invisible:
  " I like to still see my linter (ALE) signs
  hi! SignColumn ctermfg=fg guifg=fg
  hi! NonText ctermfg=gray guifg=gray
endfunction
command! WriteDark set background=dark spell wrap | colorscheme peaksea | Goyo 100x100% | call statusline#grayStatusLine() | call GoyoShowSigncolumn()
command! WriteLight set background=light spell wrap | Goyo 100x100% | call statusline#grayStatusLine()| call GoyoShowSigncolumn()
" note: peaksea colorscheme is also OK for low contrast light background for low contrast
command! GoyoSplit Goyo 160x100% | vsplit
command! Dark set background=dark | colorscheme peaksea
cabbr AB 'a,'b

" Use # without VIM moving it to the first column
inoremap # X<C-H>#

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Activate 256 colors independently of terminal. Most of my terms are 256
" colors. For those cases where I'm running vim in a low-color terminal, this
" is only safe if I'm using screen (which I always am).
set t_Co=256

" Default Color Scheme
colorscheme goerz
" it's better to set the background after loading the colorscheme, as some
" colorschemes perform a reset of &bg.
set background=light
if !empty($COLORFGBG)
    let s:bg_color_code = split($COLORFGBG, ';')[-1]
    if s:bg_color_code == 8 || s:bg_color_code  <= 6
        set background=dark
    else
        set background=light
    endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pathogen --allows to install plugins in .vim/bundle
execute pathogen#infect()

" ALE plugin
let g:ale_completion_enabled = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0   " quickfix is better used for :make
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '△'
if has('win32')
  let g:ale_sign_error = 'x'
  let g:ale_sign_warning = '!'
endif
let g:ale_set_highlights = 0  " these are highlights inside the buffer
let g:ale_warn_about_trailing_whitespace = 0  " I have my own way for dealing with this (in the statusline)
let g:ale_linter_aliases = {
\   'human': 'text',
\   'pandoc': 'markdown'
\}
let g:ale_linters = {
\   'python': ['flake8', 'pydocstyle', 'pylint'],
\}
" The sign-column highlights for ALE are best left unintrusive:
hi link ALEWarningSign SignColumn
hi link ALEErrorSign SignColumn

" Fugitive mappings
if $TERM_PROGRAM == "a-Shell"
  " disable fugitive by telling it it was already loaded
  let g:loaded_fugitive = 1
  let g:loaded_gitgutter = 1
else
  nnoremap <Leader>gd :Gdiff<Enter>
  nnoremap <Leader>gD :Gdiff HEAD<Enter>
  nnoremap <Leader>gs :Gstatus<Enter>
  nnoremap <Leader>ga :Gwrite<Enter>
  nnoremap <Leader>gc :Gcommit<Enter>
  nnoremap <Leader>gb :Gblame<Enter>
endif

" Tagbar (and legacy Taglist ) plugin
let Tlist_Inc_Winwidth = 0 " Taglist: Don't enlarge the terminal
"noremap <silent> <leader>t :TlistToggle<CR><C-W>h
noremap <silent> <leader>t :TagbarToggle<CR>
let g:tagbar_ctags_bin = 'ctags'
if $TERM_PROGRAM == "a-Shell"
  " https://github.com/holzschu/a-Shell-commands
  let g:tagbar_ctags_bin = 'ctags.wasm'
endif
let g:tagbar_show_linenumbers = 0
let g:tagbar_sort = 0
let g:tagbar_left = 1
let g:tagbar_foldlevel = 2
"use ~/.vim/ctags.cnf This depends on a patched version of the tagbar plugin
"(pull request #476)
let g:tagbar_ctags_options = ['NONE', split(&runtimepath,',')[0].'/ctags.cnf']
" the definition below depend on the settings in ctags.cnf
let g:tagbar_type_make = {
            \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
            \ ]
\}
let g:tagbar_type_julia = {
    \ 'ctagstype' : 'julia',
    \ 'kinds'     : [
        \ 't:struct', 'f:function', 'm:macro', 'c:const']
    \ }

" LaTeX to Unicode substitutions
"  This is mainly for Julia, but I also like to use it for Python and others
let g:latex_to_unicode_file_types = [
    \ 'julia', 'python', 'mail', 'markdown', 'pandoc', 'human']
noremap <silent> <leader>l :call LaTeXtoUnicode#Toggle()<CR>

" Julia
let g:julia_indent_align_import = 0
let g:julia_indent_align_brackets = 0
let g:julia_indent_align_funcargs = 0
let g:julia_blocks_mappings = {
  \  "move_n" : "",
  \  "move_N" : "",
  \  "move_p" : "",
  \  "move_P" : "",
  \
  \  "moveblock_n" : "",
  \  "moveblock_N" : "",
  \  "moveblock_p" : "",
  \  "moveblock_P" : "",
  \
  \  "select_a" : "ab",
  \  "select_i" : "ib",
  \
  \  "whereami" : "",
  \  }

" signify
let g:signify_realtime = 0

" Black formatter
let g:black_linelength = 79
let g:black_skip_string_normalization = 1

" SLIME
let g:slime_target = 'tmux'
let g:slime_no_mappings = 1
let g:slime_python_ipython = 1
nnoremap <silent> <leader>s :SlimeSend<CR>
xnoremap <silent> <leader>s :'<,'>SlimeSend<CR>'>

" Undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" Jupytext
"let g:jupytext_fmt = 'jl'
let g:jupytext_print_debug_msgs = 0
let g:jupytext_command = 'jupytext'
let g:jupytext_filetype_map = {
\      'md': 'pandoc',
\      'py': 'python',
\      'jl': 'julia',
\   }

" CtrlP
let g:ctrlp_max_files = 10000
if has('unix') " Optimize file searching
    let g:ctrlp_user_command = {
    \   'types': {
    \       1: ['.git/', 'cd %s && git ls-files']
    \   },
    \   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
    \ }
endif

" Nerd_commenter plugin
let g:NERDShutUp = 1

" vmath plugin
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

" pydoc
let g:pydoc_open_cmd = 'vsplit'

" Goyo
let g:goyo_height=100
nnoremap <Leader>G :Goyo<Enter>

" plugin/statusline.vim can set a different status line when Goyo is active
let g:goyo_use_custom_status = 1

" Hiding of quotes in json files
let g:vim_json_syntax_conceal=0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal fixes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" These originate from some linux distribution's system vimrc. I can't say
" that I understand the details what's going on here, but without these
" settings, I've had problems like vim starting in REPLACE mode for
" TERM=xterm-256color (neovim is fine)

if &term =~? 'xterm'
    let s:myterm = 'xterm'
else
    let s:myterm =  &term
endif
let s:myterm = substitute(s:myterm, 'cons[0-9][0-9].*$',  'linux', '')
let s:myterm = substitute(s:myterm, 'vt1[0-9][0-9].*$',   'vt100', '')
let s:myterm = substitute(s:myterm, 'vt2[0-9][0-9].*$',   'vt220', '')
let s:myterm = substitute(s:myterm, '\\([^-]*\\)[_-].*$', '\\1',   '')

" Here we define the keys of the NumLock in keyboard transmit mode of xterm
" which misses or hasn't activated Alt/NumLock Modifiers.  Often not defined
" within termcap/terminfo and we should map the character printed on the keys.
if s:myterm ==? 'xterm' || s:myterm ==? 'kvt' || s:myterm ==? 'gnome'
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
if s:myterm ==? 'xterm' || s:myterm ==? 'kvt' || s:myterm ==? 'gnome'
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
if s:myterm ==? 'xterm' || s:myterm ==? 'kvt' || s:myterm ==? 'gnome'
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

if s:myterm ==? 'linux'
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
