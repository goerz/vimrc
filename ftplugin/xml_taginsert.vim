" File: xml_taginsert.vim
" Author: Michael Goerz (goerz AT physik DOT fu MINUS berlin DOT de)
" Version: 0.9
" Copyright: Copyright (C) 2008 Michael Goerz
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
"    This maps the <leader>i key to an xml tag inserter. When you press
"    <leader>i while the cursor is on or directly after a word, the that word
"    is transformed into an xml tag, complete with closing tag. When the cusor
"    is not over a word, you will be prompted for a tag name. In insert mode,
"    the mapping <C-L>i is used.
"
"    This plugin depends on the imaps plugin that comes with the vim
"    latex-suite (vim-latex)
"
" Acknowlegements:
"    This script adapts some code from the latex-suite set of plugins.
"
" Installation:
"    Copy this file into your ftplugin directory. You may additionally want to
"    create a symlink to it as 'html_taginsert.vim', so that it is also loaded
"    when you edit html files.



function! XML_PutTag(com)
    echo a:com
    return IMAP_PutTextWithMovement('<'.a:com.'<++>><++></'.a:com.'><++>')
endfunction 

function! XML_CreateTag()
	if getline('.') == ''
		let com = input('Choose a tag to insert: ')
		if com != ''
			return XML_PutTag(com)
		else
			return ''
		endif
	else
		" We want to find out the word under the cursor without issuing
		" any movement commands.
		let presline = getline('.')
		let c = col('.')

		let wordbef = matchstr(strpart(presline, 0, c-1), '\k\+\*\?$')
		let wordaft = matchstr(strpart(presline, c-1), '^\k\+\*\?')

		let word = wordbef . wordaft

		if word != ''
			return substitute(wordbef, '.', "\<Left>", 'g')
				\ . substitute(word, '.', "\<Del>", 'g')
				\ . XML_PutTag(word)
		else
			let cmd = input('Choose a tag to insert: ')
			if cmd != ''
				return XML_PutTag(cmd)
			else
				return ''
			endif
		endif
	endif
endfunction  


imap <silent> <buffer> <C-L>i  <C-r>=XML_CreateTag()<cr>
nmap <silent> <buffer> <leader>i  i<C-r>=XML_CreateTag()<cr>

