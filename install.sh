#!/bin/bash

#
# Configure an OSX system for my preferences.
#
# Alex McHale (alex@anticlever.com)
#

## Define some constants ##

MACVIM_TBZ="MacVim-snapshot-64"
MACVIM_URL="https://github.com/downloads/b4winckler/macvim/$MACVIM_TBZ.tbz"
MASTER_URL="https://github.com/alexmchale/shell-files/tarball/master"

## Define some useful functions for installation ##

function install_or_clone {
  echo "hi"
}

function announce {
  echo
  echo
  echo "====> $1"
  echo
}

## Install or update Homebrew ##

announce "Setting up Homebrew"
if [ -x /usr/local/bin/brew ]; then
  brew update
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
fi

## Install various Homebrew apps ##

announce "Installing tools from Homebrew"
brew install coreutils
brew install wget
brew install mysql
brew install postgresql

## Install MacVim ##

announce "Installing MacVim"
if [ ! -d /Applications/MacVim.app ] || [ ! -x /usr/local/bin/mvim ]; then
  cd /tmp
  curl $MACVIM_URL | tar xj
  cd $MACVIM_TBZ
  cp -a MacVim.app /Applications/
  cp -a mvim /usr/local/bin/
fi

## Install dotfiles ##

announce "Loading dot files"
cd /tmp
curl "$MASTER_URL" | tar xz
cd shell-files
ls


#   Dir.glob("home-dotfiles/*").each do |src|
#     dst = src.scan(/home-dotfiles\/(.*)/).first.first
#     dst = "#{ENV["HOME"]}/.#{dst}"
#
#     puts "#{src} => #{dst}"
#     rm_rf dst
#     sh "cp -rp #{src} #{dst}"
#   end

# require "fileutils"
#
# include FileUtils
#
# def install_or_clone(git, path)
#   path = File.expand_path(path)
#   if File.exists? path
#     system "cd #{path} ; git pull origin master"
#   else
#     system "git clone #{git} #{path}"
#   end
# end
#
# desc "Install all files"
# task :install => [ :xcode, :homebrew, :dotfiles, :rbenv, :rubybuild, :cmdt ] do
# end
#
# desc "Check for Xcode"
# task :xcode do
#   if File.exists?("/Applications/Xcode.app")
#     sh "sudo /usr/bin/xcode-select -switch /Applications/Xcode.app/Contents/Developer"
#   else
#     sh "You must have Xcode installed to proceed."
#     exit
#   end
# end
#
# desc "Install or update homebrew"
# task :homebrew do
#   if File.exists?("/usr/local/bin/brew")
#     sh "brew update"
#   else
#     sh '/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"'
#     sh 'brew install coreutils'
#   end
# end
#
# desc "Update this project"
# task :update do
#   sh "git pull origin master"
#   sh "git submodule update --init"
#   sh "git submodule foreach git reset --hard"
#   sh "git submodule foreach git co ."
#   sh "git submodule foreach git pull origin master"
# end
#
# desc "Install dotfiles"
# task :dotfiles do
#   Dir.glob("home-dotfiles/*").each do |src|
#     dst = src.scan(/home-dotfiles\/(.*)/).first.first
#     dst = "#{ENV["HOME"]}/.#{dst}"
#
#     puts "#{src} => #{dst}"
#     rm_rf dst
#     sh "cp -rp #{src} #{dst}"
#   end
# end
#
# desc "Install/Update rbenv"
# task :rbenv do
#   install_or_clone "https://github.com/sstephenson/rbenv.git", "~/.rbenv"
# end
#
# desc "Install/Update ruby-build"
# task :rubybuild do
#   install_or_clone "https://github.com/sstephenson/ruby-build.git", "~/.ruby-build"
# end
#
# desc "Install command-t plugin for vim"
# task :cmdt do
#   cd File.expand_path "~/.vimbundles/command-t/ruby/command-t"
#   sh "/usr/bin/ruby extconf.rb"
#   sh "make clean && make"
# end
