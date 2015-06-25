#!/usr/bin/env bash
set -e

working_dir=$PWD

mkdir -p ~/.vim/bundle
mkdir -p ~/.ssh
ln -s $working_dir/vimrc ~/.vimrc
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

ln -s $working_dir/ackrc ~/.ackrc
ln -s $working_dir/gemrc ~/.gemrc
ln -s $working_dir/gitconfig ~/.gitconfig
ln -s $working_dir/gitignore ~/.gitignore
ln -s $working_dir/gitprompt.sh ~/.gitprompt.sh
ln -s $working_dir/inputrc ~/.inputrc
ln -s $working_dir/profile ~/.profile
ln -s $working_dir/ssh/config ~/.ssh/config

source ~/.profile
