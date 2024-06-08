#!/usr/bin/env bash

working_dir=$(dirname $0)

mkdir -p ~/.ssh

ln -s $working_dir/vim ~/.vim
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Installing .config"
mkdir -p ~/.config
echo "  fish"
ln -s $working_dir/fish/ ~/.config
echo "  NeoVim"
ln -s $working_dir/nvim/ ~/.config
echo "  Karibiner"
mkdir -p ~/.config/karabiner
ln -s $working_dir/karabiner.json ~/.config/karabiner/karabiner.json
echo "  fzf"
ln -s $working_dir/fzf/ ~/.config

echo "Installing gemrc"
ln -s $working_dir/gemrc ~/.gemrc
echo "Installing irbrc"
ln -s $working_dir/irbrc ~/.irbrc
echo "Installing pryrc"
ln -s $working_dir/pryrc ~/.pryrc
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
echo "Installing job_control.bash"
ln -s $working_dir/job_control.bash ~/.job_control.bash
echo "Installing Rails config"
ln -s $working_dir/railsrc ~/.railsrc
echo "Installing tmux.conf"
ln -s $working_dir/tmux.conf ~/.tmux.conf
echo "Installing ssh config"
ln -s $working_dir/ssh/config ~/.ssh/config

mkdir -p ~/bin

for f in $working_dir/bin/*
do
  echo "Installing $(basename $f)"
  ln -s $f ~/bin
done

echo "Installing job_glyphs"
cd job_glyphs/c
make
mv job_glyphs ~/bin

source ~/.profile
