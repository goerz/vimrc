let g:airline#themes#goerz#inactive = { 'mode': [ '#d0d0d0' , '#444444' , 252 , 238 , '' ] }

let s:file = [ '#ffffff' , '#1c1c1c' , 255 , 234 ] " e.g. read-only symbol
let s:N1   = [ '#ffffff' , '#005fd7' , 255 , 26  ]
let s:N2   = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:N3   = [ '#ffffff' , '#1c1c1c' , 255 , 234 ]
let g:airline#themes#goerz#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)


let s:I1 = [ '#000000' , '#ffaf00' ,  16 , 214 ]
let s:I2 = [ '#000000' , '#ff5f00' ,  16  , 202 ]
let s:I3 = [ '#ffffff' , '#1c1c1c' ,  255, 234 ]
let g:airline#themes#goerz#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)


let g:airline#themes#goerz#replace = copy(g:airline#themes#goerz#insert)

let s:V1   = [ '#000000' , '#d0d0d0' , 16  , 252 ]
let s:V2   = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:V3   = [ '#ffffff' , '#1c1c1c' , 255 , 234 ]
let g:airline#themes#goerz#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
