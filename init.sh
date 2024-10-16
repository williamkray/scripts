#!/usr/bin/env bash
## This script aims to download and configure basic settings
## on a fresh linux system. I'm intentionally avoiding complex
## bits like setting up openbox as this depends on lots of 
## extra packages, focusing on primarily core level functionality.

set -ex

if ! [[ $(which git) ]]; then
  echo "git is not installed. please install it and try running this script again."
  exit 1
fi

lnss() {
  ## ln -s safely
  ## create symbolic link only if non existent, a conflicting file doesn't exist,
  ## or the link exists but points to the wrong location
  src="$1"
  dst="$2"

  if [[ -e "$dst" ]]; then
    if [[ -L "$dst" ]]; then
      loc=$(readlink "$dst")
      if [[ "$loc" == "$src" ]]; then
        echo "symlink exists and points to correct location already ($dst -> $src)"
        return 0
      else
        echo "symlink exists at $dst but points to $loc. recreating."
        rm "$dst"
      fi
    elif [[ -f "$dst" ]]; then
      echo "conflicting file exists at $dst, backing it up"
      mv "$dst" "${dst}.orig"
    elif [[ -d "$dst" ]]; then
      echo "conflicting directory exists at $dst, renaming it"
      mv "$dst" "${dst}.dir"
    else
      echo "a conflicting file exists, which is of a type i have not encountered before. poop."
      exit 1
    fi
  fi
  
  echo "creating symlink from $src to $dst"
  ln -s "$src" "$dst"
}

## first thing's first, we need to download some git repos
mkdir -p ~/Code

pushd ~/Code
  # getting rid of st and dwm repos because i've moved away from them
  #for repo in scripts dotfiles st dwm-wreck; do
  for repo in scripts dotfiles; do
    if [[ -d ${repo} ]]; then
      pushd ./${repo}
        git pull
      popd
    else
      ## use http for initial clone to prevent permission errors
      ## and switch to ssh auth for later uploading.
      ## this will obviously fail until i add my ssh key
      ## to my github account.
      git clone https://github.com/williamkray/${repo}.git
      pushd ./${repo}
        git remote set-url origin git@github.com:williamkray/${repo}.git
      popd
    fi
  done
popd

## create some symlinks to things if they don't already exist
lnss ~/Code/scripts ~/.local/bin ## this one is important so things work right
lnss ~/Code/dotfiles/bashrc ~/.bashrc
lnss ~/Code/dotfiles/bash_profile ~/.bash_profile
lnss ~/Code/dotfiles/bash_aliases ~/.bash_aliases

## do the needful for vim configuration
mkdir -p ~/.vim/{colors,bundle,autoload}
mkdir -p ~/.config/nvim # for neovim init

## download pathogen, my vimrc, and the hybrid colorscheme
wget -O ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
wget -O ~/.vim/colors/hybrid.vim https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim
lnss ~/Code/dotfiles/vimrc ~/.vim/vimrc
lnss ~/Code/dotfiles/config-nvim-init.vim ~/.config/nvim/init.vim

pushd ~/.vim/bundle/
  for pkg in \
    https://github.com/Yggdroot/indentLine.git \
    https://github.com/vim-scripts/LargeFile.git \
    https://github.com/vim-airline/vim-airline.git \
    https://github.com/vim-airline/vim-airline-themes.git \
    https://github.com/tpope/vim-fugitive.git \
    https://github.com/elzr/vim-json.git \
    https://github.com/mhinz/vim-startify.git \
    https://github.com/triglav/vim-visual-increment.git ; do
      pkgdir=$(echo ${pkg} | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')
      if [[ -d ./${pkgdir} ]]; then
        pushd ./${pkgdir}
          git pull
        popd
      else
        git clone "$pkg"
      fi
  done
popd

## xinitrc
#lnss ~/Code/dotfiles/xinitrc ~/.xinitrc

## tmux!
lnss ~/Code/dotfiles/tmux.conf ~/.tmux.conf

## rofi!
#mkdir -p ~/.config
#lnss ~/Code/dotfiles/rofi ~/.config/rofi

## desktop theme stuff!
#lnss ~/Code/dotfiles/themes ~/.themes

## urlscan!
#lnss ~/Code/dotfiles/urlscan ~/.config/urlscan

## mutt!
#lnss ~/Code/dotfiles/mutt ~/.mutt

## mako!
#mkdir -p ~/.config/mako
#lnss ~/Code/dotfiles/mako.config ~/.config/mako/config

## i3!
#mkdir -p ~/.config/i3
#lnss ~/Code/dotfiles/i3.config ~/.config/i3/config

## sway!
#mkdir -p ~/.config/sway
#lnss ~/Code/dotfiles/sway.config ~/.config/sway/config

## kitty!
mkdir -p ~/.config/kitty
lnss ~/Code/dotfiles/kitty.conf ~/.config/kitty/kitty.conf

## git configs
lnss ~/Code/dotfiles/gitconfig.global ~/.gitconfig
lnss ~/Code/dotfiles/gitconfig.personal ~/Code/.gitconfig.inc
## do something similar for work-related gitconfig include file in work directory

## removing these because i don't use them anymore
### dwm
#pushd ~/Code/dwm-wreck
#sudo make clean install
#popd
#
### st
#pushd ~/Code/st
#sudo make clean install
#popd
