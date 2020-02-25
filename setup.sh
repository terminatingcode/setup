#!/usr/bin/env bash

set -eo pipefail

function update_bash_it {
  git submodule update --init

  "$HOME/.bash_it/install.sh" --silent --no-modify-config

  set +e
  export BASH_IT="$HOME/.bash_it"
  # shellcheck disable=1090
  source "$HOME/.bash_it/bash_it.sh"
  set -e
}

function configure_bash_it {
  set +e
  for completion in bash-it brew docker git ssh terraform; do
    bash-it enable completion $completion
  done

  # shellcheck disable=SC1090
  source "$HOME/.bash_profile"
  set -e
}

function ensure_brew_exists {
  if [[ ! -x /usr/local/bin/brew ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

function update_brew_bundle {
  brew update
  brew tap Homebrew/bundle

  if [ -f '/usr/local/bin/gpg-agent' ]; then
    rm /usr/local/bin/gpg-agent
  fi

  set +e
  brew bundle -v
  set -e
}

function ensureLatestBashShell {
  chsh -s /usr/local/bin/bash
}

function install_golang {
  local version="1.12.6"
  gimme $version
  # shellcheck disable=SC1090
  source "$HOME/.gimme/envs/go$version.env"
}

function update_luanvim {
  echo "Ensuring that we have neovim python plugins..."
  pip3 install neovim
  echo "Updating luanvim..."
  if [[ ! -d "$HOME/.vim" ]] ; then
    git clone https://github.com/luan/vimfiles.git ~/.vim
  fi
  (
    cd "$HOME/.vim"
    git checkout master
    git pull -r
    ~/.vim/update
  )
}

function install_cred_alert_cli {
  if ! curl -f "https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_darwin" > "$HOME/bin/cred-alert-cli"; then
    echo -n "Failed to get the most recent version of the cred-alert-cli, continuing..."
  fi

  chmod +x "$HOME/bin/cred-alert-cli"
  cred-alert-cli update
}

function install_ginkgo_gomega {
   go get github.com/onsi/ginkgo/ginkgo
   go get github.com/onsi/gomega/...
}

function main {
  update_bash_it
  configure_bash_it
  ensure_brew_exists
  update_brew_bundle
  ensureLatestBashShell
  install_golang
  update_luanvim
  install_cred_alert_cli
  install_ginkgo_gomega
}

main
