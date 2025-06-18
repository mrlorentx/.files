#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gpg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install gmp

# Install general tooling.
brew install fzf
brew install gh
brew install jq
brew install nvm
brew install node
brew install direnv
brew install autojump
brew install ripgrep
brew install pngpaste
brew install lsd
brew install gum

# Install general casks.
brew install --cask raycast
brew install --cask font-fira-code
brew install --cask mouseless

# Remove outdated versions from the cellar.
brew cleanup
