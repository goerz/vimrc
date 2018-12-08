scriptencoding utf-8

let s:pyver_ok = 1
python3 << endpython3
import sys
import vim

pyver = sys.version_info[:2]
if pyver < (3, 6):
    vim.command("let s:pyver_ok = 0")
endpython3

if !s:pyver_ok
    function! black#Black()
        echo 'Sorry, Black requires python 3.6+ to run'
    endfunc

    function! black#BlackUpgrade()
        echo 'Sorry, Black requires python 3.6+ to run'
    endfunc

    function! black#BlackVersion()
        echo 'Sorry, Black requires python 3.6+ to run'
    endfunc

    finish
endif

python3 << endpython3
def _get_python_binary(exec_prefix):
    if sys.platform[:3] == "win":
        return exec_prefix / "python.exe"
    return exec_prefix / "bin" / "python3"


def _get_pip(venv_path):
    if sys.platform[:3] == "win":
        return venv_path / "Scripts" / "pip.exe"
    return venv_path / "bin" / "pip"


def _get_virtualenv_site_packages(venv_path, pyver):
    if sys.platform[:3] == "win":
        return venv_path / "Lib" / "site-packages"
    return venv_path / "lib" / f"python{pyver[0]}.{pyver[1]}" / "site-packages"


def _initialize_black_env(upgrade=False):
    from pathlib import Path
    import subprocess
    import venv

    pyver = sys.version_info[:2]
    virtualenv_path = Path(vim.eval("g:black_virtualenv")).expanduser()
    virtualenv_site_packages = str(
        _get_virtualenv_site_packages(virtualenv_path, pyver)
    )
    first_install = False
    if not virtualenv_path.is_dir():
        print("Please wait, one time setup for Black.")
        _executable = sys.executable
        try:
            sys.executable = str(_get_python_binary(Path(sys.exec_prefix)))
            print(f"Creating a virtualenv in {virtualenv_path}...")
            print(
                "(this path can be customized in .vimrc by setting g:black_virtualenv)"
            )
            venv.create(virtualenv_path, with_pip=True)
        finally:
            sys.executable = _executable
        first_install = True
    if first_install:
        print("Installing Black with pip...")
    if upgrade:
        print("Upgrading Black with pip...")
    if first_install or upgrade:
        subprocess.run(
            [str(_get_pip(virtualenv_path)), "install", "-U", "black"],
            stdout=subprocess.PIPE,
        )
        print("DONE! You are all set, thanks for waiting ✨ 🍰 ✨")
    if first_install:
        print(
            "Pro-tip: to upgrade Black in the future, use the :BlackUpgrade command "
            "and restart Vim.\n"
        )
    if sys.path[0] != virtualenv_site_packages:
        sys.path.insert(0, virtualenv_site_packages)
    return True


if _initialize_black_env():
    import black
    import time


def Black():
    start = time.time()
    fast = bool(int(vim.eval("g:black_fast")))
    line_length = int(vim.eval("g:black_linelength"))
    mode = black.FileMode.AUTO_DETECT
    if bool(int(vim.eval("g:black_skip_string_normalization"))):
        mode |= black.FileMode.NO_STRING_NORMALIZATION
    if bool(int(vim.eval("g:black_skip_numeric_underscore_normalization"))):
        mode |= black.FileMode.NO_NUMERIC_UNDERSCORE_NORMALIZATION
    if vim.current.buffer.name.endswith(".pyi"):
        mode |= black.FileMode.PYI
    buffer_str = "\n".join(vim.current.buffer) + "\n"
    try:
        new_buffer_str = black.format_file_contents(
            buffer_str, line_length=line_length, fast=fast, mode=mode
        )
    except black.NothingChanged:
        print(f"Already well formatted, good job. (took {time.time() - start:.4f}s)")
    except Exception as exc:
        print(exc)
    else:
        cursor = vim.current.window.cursor
        vim.current.buffer[:] = new_buffer_str.split("\n")[:-1]
        vim.current.window.cursor = cursor
        print(f"Reformatted in {time.time() - start:.4f}s.")


def BlackUpgrade():
    _initialize_black_env(upgrade=True)


def BlackVersion():
    print(f"Black, version {black.__version__} on Python {sys.version}.")
endpython3

function! black#Black()
    py3 Black()
endfunc

function! black#BlackUpgrade()
    py3 BlackUpgrade()
endfunc

function! black#BlackVersion()
    py3 BlackVersion()
endfunc
