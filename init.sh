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

## first thing's first, we need to download some git repos
mkdir -p ~/git

pushd ~/git
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
if ! [[ -L ~/.scripts ]]; then
  ln -s ~/git/scripts ~/.scripts ## this one is important so things work right
fi
if ! [[ -L ~/.bashrc ]]; then
  mv ~/.bashrc ~/.bashrc.orig && ln -s ~/git/dotfiles/bashrc ~/.bashrc
fi
if ! [[ -L ~/.bash_aliases ]]; then
  ln -s ~/git/dotfiles/bash_aliases ~/.bash_aliases
fi

## do the needful for vim configuration
mkdir -p ~/.vim/{colors,bundle,autoload}

## download pathogen, my vimrc, and the hybrid colorscheme
wget -O ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
wget -O ~/.vim/colors/hybrid.vim https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim
if ! [[ -L ~/.vim/vimrc ]]; then
  ln -s ~/git/dotfiles/vimrc ~/.vim/vimrc
fi

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

## tmux!
if ! [[ -L ~/.tmux.conf ]]; then
  ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf
fi

## rofi!
mkdir -p ~/.config
if ! [[ -L ~/.config/rofi ]]; then
  ln -s ~/git/dotfiles/rofi ~/.config/rofi
fi

## desktop theme stuff!
if ! [[ -L ~/.config/themes ]]; then
  ln -s ~/git/dotfiles/themes ~/.themes
fi

