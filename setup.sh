#!/usr/bin/env bash

set -eo pipefail

function ensure_brew_exists {
  echo "ensuring brew exists"
  if [[ ! -x /usr/local/bin/brew ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

function update_brew_bundle {
  echo "updating brew bundle"
  brew update
  brew tap Homebrew/bundle

  if [ -f '/usr/local/bin/gpg-agent' ]; then
    rm /usr/local/bin/gpg-agent
  fi

  set +e
  brew bundle -v
  set -e
}

function install_luanvim {
  echo "Ensuring that we have neovim python plugins..."
  pip3 install neovim
  echo "installing luanvim..."
  if [[ ! -d "$HOME/.config/nvim" ]] ; then
    git clone https://github.com/luan/vimfiles.git ~/.vim
    git clone https://github.com/luan/nvim ~/.config/nvim
  fi
}

function main {
  ensure_brew_exists
  update_brew_bundle
  install_luanvim

  echo "All done 🥳"
}

main
