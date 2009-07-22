" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
setlocal formatoptions=tl
" for CSS, HTML, XML, use only two spaces of indentation:
setlocal tabstop=2
setlocal shiftwidth=2
setlocal shiftround
setlocal expandtab
let b:SuperTabDefaultCompletionType = "<c-x><c-o>"
