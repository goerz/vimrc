let sendToProgramName=""

python << EOF
import subprocess
import vim

def send():
    try:
        program_name = vim.eval("sendToProgramName")
    except:
        program_name = ""
    if program_name == "":
        print "Please set the 'sendToProgramName' variable."
        print "E.g. :let sendToProgramName=\"~/.vim/scripts/send2screen.py -p 1\""
        return 1
    r = vim.current.range
    text = ""
    for line in r:
        text += line + "\n"

    pipe = subprocess.Popen(program_name, shell=True, 
                            bufsize=0, stdin=subprocess.PIPE).stdin
    pipe.write(text)
    pipe.close()
EOF

nmap <F3> :. python send()<cr>
vmap <F3> : python send()<cr>gv<esc>
