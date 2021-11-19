#!/usr/bin/env bash

working_dir=$PWD

mkdir -p ~/.vim/bundle
cp -r $working_dir/vim/colors ~/.vim
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
echo "Installing Rails config"
ln -s $working_dir/railsrc ~/.railsrc
echo "Installing ssh config"
ln -s $working_dir/ssh/config ~/.ssh/config
echo "Installing Karabiner config"
mkdir -p ~/.config/karabiner
ln -s $working_dir/karabiner.json ~/.config/karabiner/karabiner.json

mkdir -p ~/bin

for f in $working_dir/bin/*
do
  echo "Installing $(basename $f)"
  ln -s $f ~/bin
done

source ~/.profile
