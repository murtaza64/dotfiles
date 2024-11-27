#!/bin/zsh
set -e
DOTFILES_ROOT=${0:a:h}

echo "export ZSH_ROOT=$DOTFILES_ROOT/zsh" > $HOME/.zshenv
echo "export PATH=$DOTFILES_ROOT/bin:\$PATH" >> $HOME/.zshenv
echo 'source $ZSH_ROOT/zshrc-global' >> $HOME/.zshrc

mkdir -p $HOME/.config

for subdir (nvim qmk tmux kitty git) do
    if [ -d $HOME/.config/$subdir ]; then
        echo $HOME/.config/$subdir already exists
        continue
    fi
    ln -s $DOTFILES_ROOT/$subdir $HOME/.config/$subdir
done

ln -s $HOME/.config/tmux/tmux.conf $HOME/.tmux.conf

echo "install the following packages:"
echo "git tmux neovim ripgrep fd delta fzf gitmux eza gh"
