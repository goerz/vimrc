" Vim compiler file
" Compiler:     Maruku
" Maintainer:   Michael Goerz

if exists("current_compiler")
  finish
endif
let current_compiler = "maruku"

if has("win32")
	setlocal shellpipe=1>&2\ 2>
endif

setlocal makeprg=~/.vim/scripts/make_maruku.pl\ \"%\"

" Sample errors:
" Type of arg 1 to push must be array (not hash element) at NFrame.pm line 129, near ");"
" Useless use of a constanst at test.pl line 5.
setlocal efm=%C\|\ %.%#,%A\|\ Maruku\ tells\ you%.%#
