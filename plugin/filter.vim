" Filename:      filter.vim
" Description:   Simple filter storage and retrieval separated by filetype
" Maintainer:    Michael Goerz <goerz@physik.fu-berlin.de>
" Last Modified: Wed 10/14/09 16:16:11 CEST

if exists('loaded_filter')
	finish
endif
let loaded_filters = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:filter_base_directory")
	let g:filters_base_directory = split(&rtp,',')[0].'/filters'
endif

let s:filter_filetype = ""

" Mappings {{{
nnoremap <unique> <script> <Plug>FiltersAppendFilter <SID>AppendFilter
nnoremap <unique> <script> <Plug>FiltersInsertFilter <SID>InsertFilter
nnoremap <unique> <script> <Plug>FiltersListFilters  <SID>ListFilters

nnoremap <SID>AppendFilter :AppendFilter<cr>
nnoremap <SID>InsertFilter :InsertFilter<cr>
nnoremap <SID>ListFilters  :ListFilters<cr>

command -bar -range AppendFilter :<line1>,<line2>call s:PutFilter(0)
command -bar -range InsertFilter :<line1>,<line2>call s:PutFilter(-1)
command -bar ListFilters  :call s:ListFilters()
"}}}

function s:SID() "{{{1
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function s:ListFilters() "{{{1
	if !s:InitFilters()
		return
	endif
	if len(s:GetFilterDirs("")) == 0
		call s:Warn("No filters available")
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
	let filter_files = s:GetFilterFiles(filetype, "")
	if len(filter_files) == 0
		call s:Warn("No filters for filetype '".filetype."'")
		return
	endif
	echo join(s:GetFilterNames(filter_files), "\n")
endfunction

function s:PutFilter(offset) range "{{{1
	if !s:InitFilters()
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
	let filter_files = s:GetFilterFiles(filetype, "")
	if len(filter_files) == 0
		call s:Warn("No filters for filetype '".filetype."'")
		return
	endif
	let filter_names = s:GetFilterNames(filter_files)
	let name = s:GetFilter(filetype)
	if len(name) == 0
		call s:Warn("No filter name entered")
		return
	endif
	if count(filter_names, name) == 0
		call s:Warn("Filter '".name."' does not exist")
		return
	endif
	let filter_file = filter_files[index(filter_names, name)]
	if strlen(filter_file) == 0
		return
	endif
	let lines = readfile(filter_file)
	call append(a:firstline+a:offset, lines)
endfunction

function s:AddFilter() range "{{{1
	if !s:InitFilters()
		return
	endif
	let filetype = s:GetFiletype()
	if !s:HasFiletype(filetype)
		if s:GetConfirmation("Create filetype directory for '".filetype."'?")
			call mkdir(g:filters_base_directory.'/'.filetype)
		else
			call s:Warn("Directory for filetype '".filetype."' does not exist")
			return
		endif
	endif
	let name = s:GetFilter(filetype)
	if len(name) == 0
		call s:Warn("No filter name entered")
		return
	endif
	let filename = g:filters_base_directory.'/'.filetype.'/'.name
	let filenames = s:GetFilterFiles(filetype, "")
	if count(filenames, filename) > 0 && !s:GetConfirmation("Overwrite current '".name."' filter?")
		return
	endif
	call writefile(getline(a:firstline, a:lastline), filename)
	echo "Filter '".name."' added for filetype '".filetype."'"
endfunction

function s:EditFilter() "{{{1
	if !s:InitFilters()
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
	let filter_files = s:GetFilterFiles(filetype, "")
	if len(filter_files) == 0
		call s:Warn("No filters for filetype '".filetype."'")
		return
	endif
	let filter_names = s:GetFilterNames(filter_files)
	let name = s:GetFilter(filetype)
	if len(name) == 0
		call s:Warn("No filter name entered")
		return
	endif
	if count(filter_names, name) == 0
		call s:Warn("Filter '".name."' does not exist")
		return
	endif
	let filter_file = filter_files[index(filter_names, name)]
	if strlen(filter_file) == 0
		return
	endif
	execute "tabedit ".filter_file." | set ft=".filetype
endfunction

function s:DeleteFilter() "{{{1
	if !s:InitFilters()
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
	let filter_files = s:GetFilterFiles(filetype, "")
	if len(filter_files) == 0
		call s:Warn("No filters for filetype '".filetype."'")
		return
	endif
	let filter_names = s:GetFilterNames(filter_files)
	let name = s:GetFilter(filetype)
	if len(name) == 0
		call s:Warn("No filter name entered")
		return
	endif
	if count(filter_names, name) == 0
		call s:Warn("Filter '".name."' does not exist")
		return
	endif
	let filter_file = filter_files[index(filter_names, name)]
	if strlen(filter_file) == 0
		return
	endif
	if !s:GetConfirmation("Delete filter '".name."'?")
		return
	endif
	call delete(filter_file)
	echo "Filter '".name."' for filetype '".filetype."' deleted"
endfunction

function s:InitFilters() "{{{1
	if !isdirectory(g:filters_base_directory)
		if s:GetConfirmation("Create filter directory '".g:filters_base_directory."'?")
			call mkdir(g:filters_base_directory, "p")
		else
			return 0
		endif
	endif
	return 1
endfunction

function s:HasFiletype(filetype) "{{{1
	if isdirectory(g:filters_base_directory.'/'.a:filetype)
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

function s:GetFilter(filetype) "{{{1
	let s:filter_filetype = a:filetype
	let filter = input("Filter: ", "", "customlist,".s:SID()."CompleteFilterName")
	unlet! s:filter_filetype
	return s:Strip(filter)
endfunction

function s:GetFiletype() "{{{1
	if len(&filetype) == 0
		return s:Strip(input("Filetype: ", "", "customlist,".s:SID()."CompleteFilterFiletype"))
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

function s:CompleteFilterName(arg_lead, cmd_line, cursor_pos) "{{{1
	if len(s:filter_filetype) == 0
		return
	endif
	return s:GetFilterNames(s:GetFilterFiles(s:filter_filetype, a:arg_lead))
endfunction

function s:CompleteFilterFiletype(arg_lead, cmd_line, cursor_pos) "{{{1
	return s:GetFilterFiletypes(s:GetFilterDirs(a:arg_lead))
endfunction

function s:GetFilterNames(filter_files) "{{{1
	let filter_names = []
	for filter_file in a:filter_files
		let tokens = split(filter_file, '/')
		call add(filter_names, split(tokens[len(tokens)-1], '\.')[0])
	endfor
	return filter_names
endfunction

function s:GetFilterFiletypes(filter_dirs) "{{{1
	let filter_filetypes = []
	for filter_dir in a:filter_dirs
		let tokens = split(filter_dir, '/')
		call add(filter_filetypes, tokens[len(tokens)-1])
	endfor
	return filter_filetypes
endfunction

function s:GetFilterFiles(filetype, arg_lead) "{{{1
	return split(glob(g:filters_base_directory.'/'.a:filetype.'/'.a:arg_lead.'*'),"\n")
endfunction

function s:GetFilterDirs(arg_lead) "{{{1
	return split(glob(g:filters_base_directory.'/'.a:arg_lead.'*'), "\n")
endfunction

let &cpo = s:save_cpo
