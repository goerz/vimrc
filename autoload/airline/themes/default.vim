let g:airline#themes#default#normal = {
      \ 'mode':           [ '#ffffff' , '#0078d9' , 255 , 27 , 'bold' ] ,
      \ 'mode_separator': [ '#0078d9' , '#444444' , 27 , 238 , 'bold' ] ,
      \ 'info':           [ '#ffffff' , '#444444' , 255 , 238 , ''     ] ,
      \ 'info_separator': [ '#444444' , '#202020' , 238 , 234 , 'bold' ] ,
      \ 'statusline':     [ '#9cffd3' , '#202020' , 85  , 234 , ''     ] ,
      \ 'statusline_nc':  [ '#000000' , '#202020' , 232 , 234 , ''     ] ,
      \ 'file':           [ '#ff0000' , '#1c1c1c' , 160 , 233 , ''     ] ,
      \ 'inactive':       [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , ''     ] ,
      \ }
let g:airline#themes#default#normal_modified = copy(g:airline#themes#default#normal)
let g:airline#themes#default#normal_modified.info_separator = [ '#444444' , '#5f005f' , 238 , 53 , '' ]
let g:airline#themes#default#normal_modified.statusline     = [ '#ffffff' , '#5f005f' , 255 , 53 , '' ]

let g:airline#themes#default#insert = {
      \ 'mode':           [ '#000000' , '#ffaf00' , 232 , 214 , 'bold' ] ,
      \ 'mode_separator': [ '#ffaf00' , '#ff5f00' , 214 , 202 , 'bold' ] ,
      \ 'info':           [ '#000000' , '#ff5f00' , 232 , 202 , ''     ] ,
      \ 'info_separator': [ '#ff5f00' , '#5f0000' , 202 , 52  , 'bold' ] ,
      \ 'statusline':     [ '#ffffff' , '#5f0000' , 15  , 52  , ''     ] ,
      \ }
let g:airline#themes#default#insert_modified = copy(g:airline#themes#default#insert)
let g:airline#themes#default#insert_modified.info_separator = [ '#005fff' , '#5f005f' , 27  , 53 , '' ]
let g:airline#themes#default#insert_modified.statusline     = [ '#ffffff' , '#5f005f' , 255 , 53 , '' ]

let g:airline#themes#default#visual = {
      \ 'mode':           [ '#000000' , '#ffaf00' , 232 , 214 , 'bold' ] ,
      \ 'mode_separator': [ '#ffaf00' , '#ff5f00' , 214 , 202 , 'bold' ] ,
      \ 'info':           [ '#000000' , '#ff5f00' , 232 , 202 , ''     ] ,
      \ 'info_separator': [ '#ff5f00' , '#5f0000' , 202 , 52  , 'bold' ] ,
      \ 'statusline':     [ '#ffffff' , '#5f0000' , 15  , 52  , ''     ] ,
      \ }
let g:airline#themes#default#visual_modified = copy(g:airline#themes#default#visual)
let g:airline#themes#default#visual_modified.info_separator = [ '#ff5f00' , '#5f005f' , 202 , 53 , '' ]
let g:airline#themes#default#visual_modified.statusline     = [ '#ffffff' , '#5f005f' , 255 , 53 , '' ]
