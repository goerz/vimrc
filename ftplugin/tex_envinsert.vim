" File: tex_envinsert.vim
" Author: Michael Goerz (goerz AT physik DOT fu MINUS berlin DOT de)
" Version: 0.9
" Copyright: Copyright (C) 2009 Michael Goerz
"    This program is free software: you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation, either version 3 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
" Description: 
"    This maps the <leader>i key to a latex environment inserter. When you
"    press <leader>i while the cursor is on or directly after a word, that
"    word is transformed into a latex environment tag, When the cusor is not
"    over a word, you will be prompted for an environment name. In insert
"    mode, the mapping <C-L>i is used.
"
"    This plugin depends on the imaps plugin that comes with the vim
"    latex-suite (vim-latex)
"
" Acknowlegements:
"    This script adapts some code from the latex-suite set of plugins.
"
" Installation:
"    Copy this file into your ftplugin directory. 

function! LATEX_PutEnv(indent, com)
    echo a:com
    return IMAP_PutTextWithMovement('\begin{'.a:com.'}'.a:indent.'  <++>'.a:indent.'\end{'.a:com.'}<++>')
endfunction 

function! LATEX_CreateEnv()
	if getline('.') == ''
		let com = input('Choose an environment to insert: ')
		if com != ''
			return LATEX_PutEnv('', com)
		else
			return ''
		endif
	else
		" We want to find out the word under the cursor without issuing
		" any movement commands.
		let presline = getline('.')
		let c = col('.')

		let indent = matchstr(presline, '^\s*')
		let wordbef = matchstr(strpart(presline, 0, c-1), '\k\+\*\?$')
		let wordaft = matchstr(strpart(presline, c-1), '^\k\+\*\?')

		let word = wordbef . wordaft

		if word != ''
			return substitute(wordbef, '.', "\<Left>", 'g')
				\ . substitute(word, '.', "\<Del>", 'g')
				\ . LATEX_PutEnv(indent, word)
		else
			let cmd = input('Choose an environment to insert: ')
			if cmd != ''
				return LATEX_PutEnv(indent, cmd)
			else
				return ''
			endif
		endif
	endif
endfunction  


imap <silent> <buffer> <C-L>i  <C-r>=LATEX_CreateEnv()<cr>
nmap <silent> <buffer> <leader>i  i<C-r>=LATEX_CreateEnv()<cr>

