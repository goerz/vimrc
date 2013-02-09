" Vim syntax file
" Language: TeX/LaTeX log
" Maintainer: glts <676c7473@gmail.com>
" Last Change: 2013-02-01
" GetLatestVimScripts: 4421 1 :AutoInstall: texlog.vim

if exists('b:current_syntax')
  finish
endif

syntax case match
syntax sync fromstart
syntax spell notoplevel

setlocal iskeyword+=@-@     " @ is in keywords
setlocal iskeyword-=48-57,_ " digits and underscore are not in keywords

syn cluster texlogFileGroup contains=@texlogMessageGroup,texStatement,texSpecialChar,texlogPageNumber
syn cluster texlogMessageGroup contains=texlogLaTeXInfo,texlogLaTeXWarning,texlogLaTeXError,texlogTeXError,texlogTeXWarning

syn match texlogFirstline /^This is \S*TeX[^,]*, Version .\+$/ contains=texlogTeXDialect,texlogTeXVersion
syn match texlogTeXDialect /\S*TeX[^,]*\ze,/ contained
syn match texlogTeXVersion /\<Version \S\+/ contained
syn match texlogJob /^\*\*\f\+\(\s\+\f\+\)*$/

" It is difficult to construct a regex that matches all and only file sections
" (parenthesised sections of files read by the *TeX program).  This compromise
" here matches whatever starts with an opening bracket and then either looks
" like a file path with a file extension or extends to the end of the line.
syn region texlogFile matchgroup=texlogFileSection start=/(\(\f\+\.\f\+\|\f\+$\)/ end=/)/ contains=texlogFile,texlogParen,@texlogFileGroup,@texlogTeXTraceGroup fold

" In order to keep the file section brackets matching all other parenthesised
" material gets its own syntax group.
syn region texlogParen start=/(\(\f\+$\|\f\+\.\f\+\)\@!/ end=/)/ contained

syn match texlogPageNumber   /\[\d\+\n*]/ contained

syn match texStatement       /\\\k\+/
syn match texSpecialChar     /\\[-!-?[-`{-~]/

syn match texlogLaTeXInfo    /^Document Class:/
syn match texlogLaTeXInfo    /^LaTeX Font Info:/
syn match texlogLaTeXInfo    /^Font Info:/
syn match texlogLaTeXInfo    /^Package:/
syn match texlogLaTeXInfo    /^File:/
syn match texlogLaTeXInfo    /^Language:/

syn match texlogLaTeXInfo    /^LaTeX Info:/
syn match texlogLaTeXInfo    /^Class \w\+ Info:/
syn match texlogLaTeXInfo    /^Package \w\+ Info:/

syn region texlogTeXWarning matchgroup=texlogWarningLabel start=/^\(Over\|Under\)full \\\(h\|v\)box .\+$/ end=/^$/ contains=texStatement,texSpecialChar
syn match texlogLaTeXWarning /^LaTeX Warning:/
syn match texlogLaTeXWarning /^Class \w\+ Warning:/
syn match texlogLaTeXWarning /^Package \w\+ Warning:/

syn match texlogTeXError     /^!\ze \w\+/
syn match texlogLaTeXError   /^LaTeX Error:/
syn match texlogLaTeXError   /^Class \w\+ Error:/
syn match texlogLaTeXError   /^Package \w\+ Error:/

" Special TeX stuff
syn cluster texlogTeXTraceGroup contains=texlogTeXTracePara
syn region texlogTeXTracePara start=/^\zs@firstpass$/ end=/^$/ contains=texStatement,texSpecialChar,texlogTeXTracePass fold
syn match texlogTeXTracePass /@\(first\|second\)pass/

syn region texlogLastline start=/^Output written on / start=/^No pages of output/ end=/\.$/

hi def link texStatement       Statement
hi def link texSpecialChar     Statement

hi def link texlogFirstline    PreProc
hi def link texlogTeXDialect   Type
hi def link texlogTeXVersion   PreProc
hi def link texlogJob          Special

hi def link texlogPageNumber   Constant

hi def link texlogLaTeXInfo    Identifier
hi def link texlogLaTeXWarning Constant
hi def link texlogTeXError     Todo
hi def link texlogLaTeXError   Todo

hi def link texlogWarningLabel Statement
hi def link texlogTeXWarning   Normal
hi def link texlogLastline     Type

hi def link texlogFile         Normal
hi def link texlogParen        Normal
hi def link texlogFileSection  PreProc

hi def link texlogTeXTracePara Normal
hi def link texlogTeXTracePass Constant

let b:current_syntax = 'texlog'
