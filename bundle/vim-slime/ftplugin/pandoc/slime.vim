if !exists("g:slime_dispatch_ipython_pause")
  let g:slime_dispatch_ipython_pause = 100
end

let b:slime_pandoc_language_is_python = 0

function! s:_CheckLanguage() abort
  let found = 0
  let lnum = 1
  while lnum <= line("$") && !found
    let line_content = getline(lnum)
    if line_content =~ '^\s*language:\s*python\s*$'
      let b:slime_pandoc_language_is_python = 1
      let found = 1
    endif
    let lnum += 1
  endwhile
endfunction


function! _EscapeText_pandoc(text)
  if b:slime_pandoc_language_is_python == 1
    if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--\n"]
    else
      let empty_lines_pat = '\(^\|\n\)\zs\(\s*\n\+\)\+'
      let no_empty_lines = substitute(a:text, empty_lines_pat, "", "g")
      let dedent_pat = '\(^\|\n\)\zs'.matchstr(no_empty_lines, '^\s*')
      let dedented_lines = substitute(no_empty_lines, dedent_pat, "", "g")
      let except_pat = '\(elif\|else\|except\|finally\)\@!'
      let add_eol_pat = '\n\s[^\n]\+\n\zs\ze\('.except_pat.'\S\|$\)'
      return substitute(dedented_lines, add_eol_pat, "\n", "g")
    end
  else
    return a:text
  end
endfunction

call s:_CheckLanguage()
