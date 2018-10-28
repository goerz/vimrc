if has("ivim")

    let $PATH .= ':'.$HOME.'/../Library/bin:'.$HOME.'/bin'
    let $PYTHONHOME = $HOME.'/../Library/'
    let $SSH_HOME = $HOME
    let $CURL_HOME = $HOME
    let $SSL_CERT_FILE = $HOME.'/cacert.pem'
    let $HGRCPATH = $HOME.'/.hgrc'

    map <D-o> :idocuments <CR>
    map <D-e> :edit . <CR>
    map <D-s> :w <CR>
    map <D-t> :tabnew <CR>
    map <D-w> :bd <CR>
    map <D-q> :quit <CR>
    map <D-}> :tabne <CR>
    map <D-{> :tabprev <CR>

    set background=light
    hi Normal ctermbg=White ctermfg=Black guifg=Black guibg=White

    let g:gitgutter_enabled = 0

endif

