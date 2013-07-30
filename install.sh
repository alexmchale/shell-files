#!/bin/bash



#
# Configure an OSX system for my preferences.
#
# Alex McHale (alex@anticlever.com)
#



## Set up the environment ##

MASTER_URL="https://nodeload.github.com/alexmchale/shell-files/tarball/master"
MACVIM_TBZ="MacVim-snapshot-64"
MACVIM_URL="http://cloud.github.com/downloads/b4winckler/macvim/$MACVIM_TBZ.tbz"
OS="`uname -s`"

set -e



## Define some useful functions for installation ##

function clone_or_update {
  local name=$1
  local repository=$2

  if [ ! -d $name ]; then
    git clone $repository $name
  else
    cd $name
    git reset --hard
    git clean -df
    git pull --rebase origin master
    cd ..
  fi
}

function brew_if_missing {
  if [ -d "/usr/local/Cellar/$1" ]; then
    echo "..... $1 is already installed"
  else
    brew install "$1"
  fi
}

function announce {
  echo
  echo
  echo "====> $1"
  echo
}


if [ "$OS" = "Darwin" ]; then

  ## Configure Xcode for local development ##

  announce "Configuring Xcode"

  if [ -d /Applications/Xcode.app ]; then
    echo "Xcode is installed!"
    # sudo "/usr/bin/xcode-select" -switch "/Applications/Xcode.app/Contents/Developer"
  else
    echo "You must have Xcode installed to proceed."
    exit
  fi


  ## Install or update Homebrew ##

  announce "Setting up Homebrew"

  if [ -x /usr/local/bin/brew ]; then
    brew update
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  fi


  ## Install various Homebrew apps ##

  announce "Installing tools from Homebrew"

  brew_if_missing coreutils
  brew_if_missing wget
  brew_if_missing git


  ## Install MacVim ##

  announce "Installing MacVim"

  if [ ! -d /Applications/MacVim.app ] || [ ! -x /usr/local/bin/mvim ]; then
    cd /tmp
    echo $MACVIM_URL
    curl $MACVIM_URL | tar xj
    cd $MACVIM_TBZ
    rm -rf /Applications/MacVim.app
    cp -a MacVim.app /Applications/
    cp -a mvim /usr/local/bin/
  fi


  ## Configure Lion options ##

  announce "Configuring OSX Lion"

  # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
  # Enable the 2D Dock
  #defaults write com.apple.dock no-glass -bool true
  # Disable menu bar transparency
  #defaults write -g AppleEnableMenuBarTransparency -bool false
  # Expand save panel by default
  defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
  # Expand print panel by default
  defaults write -g PMPrintingExpandedStateForPrint -bool true
  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true
  # Enable highlight hover effect for the grid view of a stack (Dock)
  defaults write com.apple.dock mouse-over-hilte-stack -bool true
  # Enable spring loading for all Dock items
  defaults write enable-spring-load-actions-on-all-items -bool true
  # Disable press-and-hold for keys in favor of key repeat
  defaults write -g ApplePressAndHoldEnabled -bool false
  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  # Disable window animations
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
  # Disable disk image verification
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  # Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  # Avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # Disable Safari’s thumbnail cache for History and Top Sites
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeDebugMenu -bool true
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  # Remove useless icons from Safari’s bookmarks bar
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"
  # Disable Safari sending what we type in the address bar to Google.
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  # Disable send and reply animations in Mail.app
  defaults write com.apple.Mail DisableReplyAnimations -bool true
  defaults write com.apple.Mail DisableSendAnimations -bool true
  # Disable Resume system-wide
  defaults write com.apple.Safari NSQuitAlwaysKeepsWindows -bool false
  defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false
  defaults write com.apple.QuickTimePlayerX NSQuitAlwaysKeepsWindows -bool false
  defaults write com.google.Chrome NSQuitAlwaysKeepsWindows -bool false
  defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false
  # Disable dock auto-hide delay
  defaults write com.apple.Dock autohide -bool true
  defaults write com.apple.Dock autohide-delay -float 0
  # Reset Launchpad
  rm ~/Library/Application\ Support/Dock/*.db
  # Show the ~/Library folder
  chflags nohidden ~/Library
  # Disable local Time Machine backups
  sudo tmutil disablelocal
  # Kill affected applications
  for app in Safari Finder Dock Mail; do killall "$app" 2> /dev/null; done
  # Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)
  echo "0x08000100:0" > ~/.CFUserTextEncoding
  # Configure TextMate to open with Markdown by default.
  defaults write com.macromates.textmate OakDefaultLanguage 0A1D9874-B448-11D9-BD50-000D93B6E43C
  # Configure optimal TCP settings.
  sudo sysctl -w net.inet.tcp.delayed_ack=0
  sudo sysctl -w net.inet.tcp.slowstart_flightsize=10
  # Disable iCloud being the default for save dialogs.
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

fi



## Install dotfiles ##

announce "Loading dot files"

if [ -d home-dotfiles ]; then
  cd home-dotfiles
else
  cd /tmp
  rm -rf shell-files
  git clone https://github.com/alexmchale/shell-files.git
  cd shell-files/home-dotfiles
fi

for file in *; do
  rm -rf ~/.$file
  cp -Ra $file ~/.$file
done

cd ~
rm -rf /tmp/alexmchale-shell-files*



## Install Vim plugins ##

echo "Installing vundler."
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
clone_or_update "vundle" "https://github.com/gmarik/vundle.git"
cd ~
vim +BundleInstall +qall



## Install rbenv ##

announce "Installing rbenv"

cd ~
clone_or_update ".rbenv" "https://github.com/sstephenson/rbenv.git"
clone_or_update ".ruby-build" "https://github.com/sstephenson/ruby-build.git"



# We're done!

announce "Configuration complete!"
