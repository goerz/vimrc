" Main VIM Configuration File
" Author: Michael Goerz <mail@michaelgoerz.net>
scriptencoding utf-8

" Python interpreter (neovim)
let g:python_host_prog = $HOME.'/anaconda3/envs/py27/bin/python'
let g:python3_host_prog = $HOME.'/anaconda3/bin/python'
let g:notedown_enable = 1

" Pathogen --allows to install plugins in .vim/bundle
execute pathogen#infect()

" * Interface Settings {{{1

" switch ' and `
nnoremap ' `
nnoremap ` '

" Leader keys
let mapleader = ','
let g:mapleader = ','
let maplocalleader = '\\'
let g:maplocalleader = '\\'

set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

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

" Always show sign column.
augroup mine
    au BufWinEnter * sign define mysign
    au BufWinEnter * exe 'sign place 1337 line=1 name=mysign buffer=' . bufnr('%')
augroup END

" ALE plugin
let g:ale_completion_enabled = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0   " quickfix is better used for :make
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '△'
let g:ale_set_highlights = 0  " these are highlights inside the buffer
let g:ale_warn_about_trailing_whitespace = 0  " I have my own way for dealing with this (in the statusline)
let g:ale_linter_aliases = {
\   'human': 'text'
\}
let g:ale_linters = {
\   'python': ['flake8', 'pydocstyle', 'pylint'],
\}
" The sign-column highlights for ALE are best left unintrusive:
hi link ALEWarningSign SignColumn
hi link ALEErrorSign SignColumn

" Work around neovim not running bang commands in the current tty
" https://github.com/neovim/neovim/issues/1496
if has('nvim')
  cnoremap <expr> !<space> strlen(getcmdline())?'!':('!tmux split-window -c '.getcwd().' -p 90 ')
endif

" persistent undo
if has('persistent_undo')
    set undodir=~/.vim/undo/
    set undofile
    au BufWritePre /tmp/* setlocal noundofile
endif

" swap and backup
set backupdir=~/.vim/backup/
set directory=~/.vim/backup/

" indicate textwidth with color column
if exists('+colorcolumn')
    set colorcolumn=+1
endif

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
set listchars=tab:>-,trail:-,nbsp:~
set nolist

" Required to be able to use keypad keys and map missed escape sequences
if ! has('nvim')
    set esckeys
endif

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


" Fugitive mappings
nnoremap <Leader>gd :Gdiff<Enter>
nnoremap <Leader>gD :Gdiff HEAD<Enter>
nnoremap <Leader>gs :Gstatus<Enter>
nnoremap <Leader>ga :Gwrite<Enter>
nnoremap <Leader>gc :Gcommit<Enter>
nnoremap <Leader>gb :Gblame<Enter>


" Tagbar (and legacy Taglist ) plugin
let Tlist_Inc_Winwidth = 0 " Taglist: Don't enlarge the terminal
"noremap <silent> <leader>t :TlistToggle<CR><C-W>h
noremap <silent> <leader>t :TagbarToggle<CR>
let g:tagbar_ctags_bin = 'ctags'
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

" signify plugin
let g:signify_realtime = 0

" Black formatter
let g:black_linelength = 79
let g:black_skip_string_normalization = 1


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

" SLIME plugin
let g:slime_target = 'tmux'
let g:slime_no_mappings = 1
nnoremap <silent> <leader>s :SlimeSend<CR>
xnoremap <silent> <leader>s :'<,'>SlimeSend<CR>

" Undotree plugin
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" Jupytext plugin
let g:jupytext_fmt = 'md'
let g:jupytext_print_debug_msgs = 0
let g:jupytext_command = 'jupytext'
let g:jupytext_filetype_map = {
\      'md': 'pandoc',
\      'py': 'python',
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

" pydoc plugin
let g:pydoc_open_cmd = 'vsplit'

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
autocmd FileType tex hi! texSectionTitle gui=underline term=bold cterm=underline,bold
autocmd FileType tex hi! Statement gui=none term=none cterm=none

" Forward SyncTeX
autocmd FileType tex nnoremap <Leader>s :w<CR>:silent !$SYNCTEXREADER -g <C-r>=line('.')<CR> %<.pdf %<CR><C-l>

" Datestamps
if exists('*strftime')
    nmap <leader>d a<c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
    imap <C-L>d <c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
endif

" abbreviations / commands
command Noindent setl noai nocin nosi inde=
command German set spell spelllang=de_20
command English set spell spelllang=en
command Python set nospell ft=python
command ManualFolding set foldenable foldmethod=manual
command WriteDark set background=dark spell wrap | colorscheme peaksea | Goyo 100 | call statusline#grayStatusLine()
command WriteLight set background=light spell wrap | colorscheme peaksea | Goyo 100 | call statusline#grayStatusLine()
command Dark set background=dark | colorscheme peaksea
cabbr AB 'a,'b

" plugin/statusline.vim can set a different status line when Goyo is active
let g:goyo_use_custom_status = 1

" Activate wildmenu
set wildmenu

" Hide Toolbar and mouse usage in Macvim
if has('gui_running')
    set guioptions=egmrt
    set mouse=a
endif


" VimR specific settings
if has('gui_vimr')
  set background=light
endif


" * Text Formatting -- General {{{1

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

" enable syntax highlighting
syntax on
syntax sync fromstart


if has('autocmd')
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " automatically follow symlinks
  autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))

endif " has("autocmd")
