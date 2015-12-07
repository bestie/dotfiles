#!/usr/bin/env bash
set -e

working_dir=$PWD

mkdir -p ~/.vim/bundle
mkdir -p ~/.ssh
ln -s $working_dir/vimrc ~/.vimrc
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Installing ackrc"
ln -s $working_dir/ackrc ~/.ackrc
echo "Installing gemrc"
ln -s $working_dir/gemrc ~/.gemrc
echo "Installing gitconfig"
ln -s $working_dir/gitconfig ~/.gitconfig
echo "Installing gitignore"
ln -s $working_dir/gitignore ~/.gitignore
echo "Installing gitprompt"
ln -s $working_dir/gitprompt.sh ~/.gitprompt.sh
echo "Installing inputrc"
ln -s $working_dir/inputrc ~/.inputrc
echo "Installing profile"
ln -s $working_dir/profile ~/.profile
echo "Installing ssh config"
ln -s $working_dir/ssh/config ~/.ssh/config

for f in $working_dir/bin/*
do
  echo "Installing $(basename $f)"
  ln -s $f ~/bin
done

source ~/.profile
