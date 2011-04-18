" Compiler: Intel Fortran Compiler
" Maintainer: H Xu <xuhdev@gmail.com>
" Version: 0.1
" Last Change: 12 March 2011
" License: You can redistribute this plugin and/or modify it under the terms 
"          of the GNU General Public License as published by the Free Software 
"          Foundation; either version 2, or any later version. 

if exists('current_compiler')
    finish
endif
let current_compiler = 'ifort'

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=
            \%A%f(%l):\ %trror\ \#%n:\ %m,
            \%A%f(%l):\ %tarning\ \#%n:\ %m,
            \%-Z%p^,
            \%-G%.%#
