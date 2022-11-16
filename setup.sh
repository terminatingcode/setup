#!/usr/bin/env bash

set -eo pipefail

function update_bash_it {
  echo "update bash-it"
  git submodule update --init

  "$HOME/.bash_it/install.sh" --silent --no-modify-config

  set +e
  export BASH_IT="$HOME/.bash_it"
  # shellcheck disable=1090
  source "$HOME/.bash_it/bash_it.sh"
  set -e
}

function configure_bash_it {
  echo "configure bash-it"
  set +e
  for completion in bash-it brew docker git ssh terraform; do
    bash-it enable completion $completion
  done

  # shellcheck disable=SC1090
  source "$HOME/.bash_profile"
  set -e
}

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

function ensureLatestBashShell {
  if [[ ! $SHELL = "/usr/local/bin/bash" ]] ; then
    echo "changing shell to bash"
    if ! grep -q /usr/local/bin/bash /private/etc/shells ; then
      echo "adding bash ${bash --version} to /etc/shells"
      echo $(brew --prefix)/bin/bash | sudo tee -a /private/etc/shells
    fi
    chsh -s /usr/local/bin/bash
  fi
}

function install_golang {
  echo "installing Go"
  local version="1.19.3"
  gimme $version
  # shellcheck disable=SC1090
  source "$HOME/.gimme/envs/go$version.env"
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

function install_cred_alert_cli {
  if ! curl -f "https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_darwin" > "$HOME/bin/cred-alert-cli"; then
    echo -n "Failed to get the most recent version of the cred-alert-cli, continuing..."
  fi

  chmod +x "$HOME/bin/cred-alert-cli"
  cred-alert-cli update
}

function install_ginkgo_gomega {
   go install github.com/onsi/ginkgo/v2/ginkgo@latest
}

function install_code_extensions {
  code --install-extension esbenp.prettier-vscode
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension jebbs.platnuml
}

function main {
  update_bash_it
  configure_bash_it
  ensure_brew_exists
  update_brew_bundle
  ensureLatestBashShell
  install_golang
  install_luanvim
  install_cred_alert_cli
  install_ginkgo_gomega

  echo "All done 🥳"
}

main
