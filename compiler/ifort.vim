" Vim compiler file
" Compiler:		ifort - Intel Fortran Compiler
" Maintainer: Michael Goerz
" Last Change: 7/14/2008

if exists("current_compiler")
  finish
endif
let current_compiler = "ifort"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif


CompilerSet errorformat=%E%.%#rror:\ %f\\,\ line\ %l:\ %m,\%-C%.%#,\%-Z\%p^ 

