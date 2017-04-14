#!/usr/bin/env bash

set -euf -o pipefail

function usage() {
    printf 'Usage: %s\n' "$0"
    printf '    -c use current ~/dotfiles\n'
}

cflag=''

while getopts 'hc' flag; do
  case "${flag}" in
    h) usage; exit 0 ;;
    c) cflag='true' ;;
    *) usage; exit 1 ;;
  esac
done

# From HOME
pushd ~ 2>&1 > /dev/null

# Install and update latest homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
brew update

# Install git and fetch latest dotfiles
brew install git
if [[ -z "${cflag}" ]]; then
  git clone https://github.com/rymir/dotfiles.git
fi

# Run OSX config
bash -x dotfiles/scripts/osx.sh

# From dotfiles
pushd dotfiles 2>&1 > /dev/null

# Use stow (https://www.gnu.org/software/stow/) to link dotfiles
stow -v bash
stow -v brew
stow -v git

popd 2>&1 > /dev/null

# Run homebrew from Brewfile
brew bundle

popd 2>&1 > /dev/null

exit 0
