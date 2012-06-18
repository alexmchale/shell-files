#!/bin/sh

echo "Fetching vimrc from GitHub."
cd ~
which wget && wget -O .vimrc https://raw.github.com/alexmchale/shell-files/master/home-dotfiles/vimrc
which curl && curl -o .vimrc https://raw.github.com/alexmchale/shell-files/master/home-dotfiles/vimrc

echo "Installing vundler."
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
if [ ! -d vundle ]; then
  git clone https://github.com/gmarik/vundle.git
else
  cd vundle
  git reset --hard
  git clean -df
  git pull --rebase origin master
fi
cd ~
vim +BundleInstall +qall
