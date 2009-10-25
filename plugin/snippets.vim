" Filename:      snippets.vim
" Description:   Simple snippet storage and retrieval separated by filetype
" Maintainer:    Original: Jeremy Cantrell <jmcantrell@gmail.com>
"                Modified: Michael Goerz <goerz@gmail.com>
" Last Modified: Sun 10/25/09 16:18:40 CET
"
" Usage: 'InsertSnippet' inserts a snippet and sets the cursor to the end of
" the snippet. 'AppendSnippet' inserts a snippet and leavs the cursor at the
" current position (before the snippet). A snippet is always inserted beneath
" the current line, except when the current line is empty, in which case the
" snippet is inserted *at* the current line.

if exists('loaded_snippets')
	finish
endif
let loaded_snippets = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:snippets_base_directory")
	let g:snippets_base_directory = split(&rtp,',')[0].'/snippets'
endif

let s:snippet_filetype = ""

" Mappings {{{
if !hasmapto('<Plug>SnippetsInsertSnippet', 'n')
	nmap <silent> <unique> <leader>ni <Plug>SnippetsInsertSnippet
	imap <silent> <unique> <C-L>ni <Plug>SnippetsInsertSnippet
endif

if !hasmapto('<Plug>SnippetsAppendSnippet', 'n')
	nmap <silent> <unique> <leader>na <Plug>SnippetsAppendSnippet
	imap <silent> <unique> <C-L>na <Plug>SnippetsAppendSnippet
endif

if !hasmapto('<Plug>SnippetsListSnippets', 'n')
	nmap <silent> <unique> <leader>nl <Plug>SnippetsListSnippets
	imap <silent> <unique> <C-L>nl <Plug>SnippetsListSnippet
endif
nnoremap <unique> <script> <Plug>SnippetsAppendSnippet <SID>AppendSnippet
nnoremap <unique> <script> <Plug>SnippetsInsertSnippet <SID>InsertSnippet
nnoremap <unique> <script> <Plug>SnippetsListSnippets  <SID>ListSnippets

nnoremap <SID>AppendSnippet :AppendSnippet<cr>
nnoremap <SID>InsertSnippet :InsertSnippet<cr>
nnoremap <SID>ListSnippets  :ListSnippets<cr>

command -bar -range AppendSnippet :<line1>,<line2>call s:PutSnippet(0, 0)
command -bar -range InsertSnippet :<line1>,<line2>call s:PutSnippet(0, 1)
command -bar ListSnippets  :call s:ListSnippets()
"}}}

function s:SID() "{{{1
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function s:ListSnippets() "{{{1
	if !s:InitSnippets()
		return
	endif
	if len(s:GetSnippetDirs("")) == 0
		call s:Warn("No snippets available")
	endif
	let filetype = s:GetFiletype()
	if len(filetype) == 0
		call s:Warn("No filetype entered")
	endif
	if !s:HasFiletype(filetype)
		call s:Warn("Filetype '".filetype."' does not exist")
	endif
	let snippet_files = s:GetSnippetFiles(filetype, "")
	if len(snippet_files) == 0
		call s:Warn("No snippets for filetype '".filetype."'")
		return
	endif
	echo join(s:GetSnippetNames(snippet_files), "\n")
endfunction

function s:PutSnippet(offset, put_cursor_after) range "{{{1
	if !s:InitSnippets()
		return
	endif
	let filetype = s:GetFiletype()
	if len(filetype) == 0
		call s:Warn("No filetype entered")
	endif
	if !s:HasFiletype(filetype)
		call s:Warn("Filetype '".filetype."' does not exist")
	endif
	let snippet_files = s:GetSnippetFiles(filetype, "")
	if len(snippet_files) == 0
		call s:Warn("No snippets for filetype '".filetype."'")
		return
	endif
	let snippet_names = s:GetSnippetNames(snippet_files)
	let name = s:GetSnippet(filetype)
	if len(name) == 0
		call s:Warn("No snippet name entered")
		return
	endif
	if count(snippet_names, name) == 0
		call s:Warn("Snippet '".name."' does not exist")
		return
	endif
	let snippet_file = snippet_files[index(snippet_names, name)]
	if strlen(snippet_file) == 0
		return
	endif
	let lines = readfile(snippet_file)
	call append(a:firstline+a:offset, lines)
    let inserted = len(lines)
    if a:offset == 0
        let line = getline(".")
        if line == ''
            execute ".delete"
            let inserted = inserted-1
        endif
    endif
    if a:put_cursor_after == 1
        call cursor(a:firstline+inserted, 0)
    endif
endfunction

function s:AddSnippet() range "{{{1
	if !s:InitSnippets()
		return
	endif
	let filetype = s:GetFiletype()
	if !s:HasFiletype(filetype)
		if s:GetConfirmation("Create filetype directory for '".filetype."'?")
			call mkdir(g:snippets_base_directory.'/'.filetype)
		else
			call s:Warn("Directory for filetype '".filetype."' does not exist")
			return
		endif
	endif
	let name = s:GetSnippet(filetype)
	if len(name) == 0
		call s:Warn("No snippet name entered")
		return
	endif
	let filename = g:snippets_base_directory.'/'.filetype.'/'.name
	let filenames = s:GetSnippetFiles(filetype, "")
	if count(filenames, filename) > 0 && !s:GetConfirmation("Overwrite current '".name."' snippet?")
		return
	endif
	call writefile(getline(a:firstline, a:lastline), filename)
	echo "Snippet '".name."' added for filetype '".filetype."'"
endfunction

function s:EditSnippet() "{{{1
	if !s:InitSnippets()
		return
	endif
	let filetype = s:GetFiletype()
	if len(filetype) == 0
		call s:Warn("No filetype entered")
		return
	endif
	if !s:HasFiletype(filetype)
		call s:Warn("Filetype '".filetype."' does not exist")
		return
	endif
	let snippet_files = s:GetSnippetFiles(filetype, "")
	if len(snippet_files) == 0
		call s:Warn("No snippets for filetype '".filetype."'")
		return
	endif
	let snippet_names = s:GetSnippetNames(snippet_files)
	let name = s:GetSnippet(filetype)
	if len(name) == 0
		call s:Warn("No snippet name entered")
		return
	endif
	if count(snippet_names, name) == 0
		call s:Warn("Snippet '".name."' does not exist")
		return
	endif
	let snippet_file = snippet_files[index(snippet_names, name)]
	if strlen(snippet_file) == 0
		return
	endif
	execute "tabedit ".snippet_file." | set ft=".filetype
endfunction

function s:DeleteSnippet() "{{{1
	if !s:InitSnippets()
		return
	endif
	let filetype = s:GetFiletype()
	if len(filetype) == 0
		call s:Warn("No filetype entered")
		return
	endif
	if !s:HasFiletype(filetype)
		call s:Warn("Filetype '".filetype."' does not exist")
		return
	endif
	let snippet_files = s:GetSnippetFiles(filetype, "")
	if len(snippet_files) == 0
		call s:Warn("No snippets for filetype '".filetype."'")
		return
	endif
	let snippet_names = s:GetSnippetNames(snippet_files)
	let name = s:GetSnippet(filetype)
	if len(name) == 0
		call s:Warn("No snippet name entered")
		return
	endif
	if count(snippet_names, name) == 0
		call s:Warn("Snippet '".name."' does not exist")
		return
	endif
	let snippet_file = snippet_files[index(snippet_names, name)]
	if strlen(snippet_file) == 0
		return
	endif
	if !s:GetConfirmation("Delete snippet '".name."'?")
		return
	endif
	call delete(snippet_file)
	echo "Snippet '".name."' for filetype '".filetype."' deleted"
endfunction

function s:InitSnippets() "{{{1
	if !isdirectory(g:snippets_base_directory)
		if s:GetConfirmation("Create snippet directory '".g:snippets_base_directory."'?")
			call mkdir(g:snippets_base_directory, "p")
		else
			return 0
		endif
	endif
	return 1
endfunction

function s:HasFiletype(filetype) "{{{1
	if isdirectory(g:snippets_base_directory.'/'.a:filetype)
		return 1
	endif
	return 0
endfunction

function s:Strip(str) "{{{1
	return substitute(substitute(a:str, '\s*$', '', 'g'), '^\s*', '', 'g')
endfunction

function s:Warn(message) "{{{1
	echohl WarningMsg | echo a:message | echohl None
endfunction

function s:Error(message) "{{{1
	echohl ErrorMsg | echo a:message | echohl None
endfunction

function s:GetSnippet(filetype) "{{{1
	let s:snippet_filetype = a:filetype
	let snippet = input("Snippet: ", "", "customlist,".s:SID()."CompleteSnippetName")
	unlet! s:snippet_filetype
	return s:Strip(snippet)
endfunction

function s:GetFiletype() "{{{1
	if len(&filetype) == 0
		return s:Strip(input("Filetype: ", "", "customlist,".s:SID()."CompleteSnippetFiletype"))
	else
		return &filetype
	endif
endfunction

function s:GetConfirmation(prompt) "{{{1
	if confirm(a:prompt, "Yes\nNo") == 1
		return 1
	endif
	return 0
endfunction

function s:CompleteSnippetName(arg_lead, cmd_line, cursor_pos) "{{{1
	if len(s:snippet_filetype) == 0
		return
	endif
	return s:GetSnippetNames(s:GetSnippetFiles(s:snippet_filetype, a:arg_lead))
endfunction

function s:CompleteSnippetFiletype(arg_lead, cmd_line, cursor_pos) "{{{1
	return s:GetSnippetFiletypes(s:GetSnippetDirs(a:arg_lead))
endfunction

function s:GetSnippetNames(snippet_files) "{{{1
	let snippet_names = []
	for snippet_file in a:snippet_files
		let tokens = split(snippet_file, '/')
		call add(snippet_names, split(tokens[len(tokens)-1], '\.')[0])
	endfor
	return snippet_names
endfunction

function s:GetSnippetFiletypes(snippet_dirs) "{{{1
	let snippet_filetypes = []
	for snippet_dir in a:snippet_dirs
		let tokens = split(snippet_dir, '/')
		call add(snippet_filetypes, tokens[len(tokens)-1])
	endfor
	return snippet_filetypes
endfunction

function s:GetSnippetFiles(filetype, arg_lead) "{{{1
    let snippet_files = []
    for snippet_file in split(glob(g:snippets_base_directory.'/'.a:filetype.'/'.a:arg_lead.'*'),"\n")
        call add(snippet_files, snippet_file)
    endfor
    for snippet_file in split(glob(g:snippets_base_directory.'/all/'.a:arg_lead.'*'),"\n")
        call add(snippet_files, snippet_file)
    endfor
	return snippet_files
endfunction

function s:GetSnippetDirs(arg_lead) "{{{1
	return split(glob(g:snippets_base_directory.'/'.a:arg_lead.'*'), "\n")
endfunction

let &cpo = s:save_cpo
