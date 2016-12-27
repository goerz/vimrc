# Vim/Neovim Configuration

This configuration is intended to work with both traditional [vim][1] and
[neovim][2].

First, clone the repository to `~/.vim`:

    user@host:~> git clone https://github.com/goerz/vimrc.git .vim

Then, for traditional vim, link `.vim/init.vim` to `.vimrc`:

    user@host:~> ln -s .vim/init.vim .vimrc

For neovim, link the entire folder to `~/.config/nvim` ([or more generally to
`$XDG_CONFIG_HOME/nvim`][3]):

    user@host:~> mkdir ~/.config
    user@host:~> ln -s ~/.vim ~/.config/nvim

Update at any time by running `git pull` inside the `~/.vim` folder.

If you only want neovim support, you could directly clone this repository to
`~/.config/nvim`.

[1]: http://www.vim.org
[2]: https://neovim.io
[3]: https://neovim.io/doc/user/nvim.html#nvim-from-vim
