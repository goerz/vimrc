runtime syntax/diff.vim

syntax match gitDiffStatLine /^ .\{-}\zs[+-]\+$/ contains=gitDiffStatAdd,gitDiffStatDelete
syntax match gitDiffStatAdd    /+/ contained
syntax match gitDiffStatDelete /-/ contained

highlight diffAdded   ctermfg=2
highlight diffRemoved ctermfg=1
