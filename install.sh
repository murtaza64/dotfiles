#!/bin/zsh
set -x
DOTFILES_ROOT=${0:a:h}

echo "export ZSH_ROOT=$DOTFILES_ROOT/zsh" > $HOME/.zshenv
echo 'source $ZSH_ROOT/zshrc-global' >> $HOME/.zshrc

mkdir -p $HOME/.config

for subdir (nvim qmk tmux) do
    ln -s $DOTFILES_ROOT/$subdir $HOME/.config/$subdir
done

ln -s $HOME/.config/tmux/tmux.conf $HOME/.tmux.conf
