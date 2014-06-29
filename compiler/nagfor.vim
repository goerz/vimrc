" Compiler: NAG Fortran Compiler
" Maintainer: Michael Goerz <goerz@physik.uni-kassel.de>
" Version: 0.1
" License: You can redistribute this plugin and/or modify it under the terms
"          of the GNU General Public License as published by the Free Software
"          Foundation; either version 2, or any later version.

if exists('current_compiler')
    finish
endif
let current_compiler = 'nagfor'

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=
            \%EError:\ %f\\,\ line\ %l:\ %m,
            \%WWarning:\ %f\\,\ line\ %l:\ %m
