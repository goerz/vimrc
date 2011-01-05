" Vim compiler file
" Compiler:     Pandoc
" Maintainer:   Michael Goerz

if exists("current_compiler")
  finish
endif
let current_compiler = "pandoc"

if has("win32")
	setlocal shellpipe=1>&2\ 2>
endif

setlocal makeprg=~/.vim/scripts/make_pandoc.pl\ \"%\"

" Sample errors:
" Type of arg 1 to push must be array (not hash element) at NFrame.pm line 129, near ");"
" Useless use of a constanst at test.pl line 5.
"setlocal efm=%C\|\ %.%#,%A\|\ Pandoc\ tells\ you%.%#
