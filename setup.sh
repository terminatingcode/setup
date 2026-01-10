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
  if [ -f '/usr/local/bin/gpg-agent' ]; then
    rm /usr/local/bin/gpg-agent
  fi

  set +e
  brew bundle -v
  set -e
}

function install_oh_my_zsh {
  echo "installing oh my zsh"
  if [ -d ~/.oh-my-zsh ]; then
    echo "oh my zsh already installed 👍"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

function move_dot_files {
  echo "symlinking dot files to home"
  ln -s ~/setup/.aliases ~/.aliases
  ln -s ~/setup/.gitconfig ~/.gitconfig
  ln -s ~/setup/.zshrc ~/.zshrc
}

function main {
  ensure_brew_exists
  install_oh_my_zsh
  update_brew_bundle
  move_dot_files
  echo "All done 🥳"
}

main
