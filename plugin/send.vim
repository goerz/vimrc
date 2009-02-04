let sendToProgramName=""

if has("python")
python << EOF
import subprocess
import vim

def send(program_name=None):
    if program_name is None:
        try:
            program_name = vim.eval("sendToProgramName")
        except:
            program_name = ""
    if program_name == "":
        print "Please set the 'sendToProgramName' variable."
        print "E.g."
        print "for ipython: let sendToProgramName=\"~/.vim/scripts/send2screen.py -p 1\""
        print "for MacOS clibpoard: let sendToProgramName=\"pbcopy\""
        return 1
    print ( "sendToProgramName=%s" % program_name )[:80]
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
"else
  "echo "Can't use send plugin: no python"
endif
