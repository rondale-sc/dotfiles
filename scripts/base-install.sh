#!/bin/bash

if [[ ! -x "$(command -v volta)" ]]; then
	echo "installing volta"
	curl https://get.volta.sh | bash

	echo "installing current node & yarn"
	$HOME/.volta/volta install node
	$HOME/.volta/volta install yarn
else
	echo "volta already installed, updating node & yarn"
	volta install node
	volta install yarn
fi

if ! which rustup >/dev/null 2>&1; then
	echo "Installing rustup"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. $HOME/.cargo/env
fi

echo "Updating rustup"
rustup self update

echo "Updating rust stable"
rustup update stable

if ! which cargo-binstall >/dev/null 2>&1; then
	echo "Installing cargo-binstall"
	curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
else
	echo "cargo-binstall already installed"
fi

cargo_tools=("cargo-nextest" "cargo-insta")

for tool in "${cargo_tools[@]}"; do
	if ! which "$tool" >/dev/null 2>&1; then
		echo "Installing $tool"
		cargo binstall "$tool"
	else
		echo "$tool already installed"
	fi
done

if [[ "$OSTYPE" == darwin* ]]; then
	if ! command -v brew >/dev/null; then
		echo "Installing Homebrew ..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	brew install fzf tmux starship zoxide gh ripgrep nvim tealdeer eza git git-delta \
		gnu-sed bat atuin sd jj fish ast-grep zig go go-task/tap/go-task watchman
else
	# we are within an rdev if this file exists
	if [ -f /etc/rdev.conf ]; then
		# put any rdev specific setup here
	fi

	if ! which starship >/dev/null 2>&1; then
		echo "Installing starship"
		curl -sS https://starship.rs/install.sh | sh -s -- --force
	else
		echo "starship already installed"
	fi

	if ! which zoxide >/dev/null 2>&1; then
		echo "Installing zoxide"
		curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
	else
		echo "zoxide already installed"
	fi

	if ! which eza >/dev/null 2>&1; then
		echo "Installing eza"
		cargo binstall --locked --no-confirm eza
	else
		echo "eza already installed"
	fi

	if ! which bat >/dev/null 2>&1; then
		echo "Installing bat"
		cargo binstall --locked --no-confirm bat
	else
		echo "bat already installed"
	fi

	if ! which delta >/dev/null 2>&1; then
		echo "Installing delta"
		cargo binstall --locked --no-confirm git-delta
	else
		echo "delta already installed"
	fi

	if ! which sd >/dev/null 2>&1; then
		echo "Installing sd"
		cargo binstall --locked --no-confirm sd
	else
		echo "sd already installed"
	fi

	if [[ ! -d $HOME/.fzf ]]; then
		echo "Installing fzf"
		git clone https://github.com/junegunn/fzf.git $HOME/.fzf
		$HOME/.fzf/install --bin
	else
		echo "fzf already installed"
	fi
fi

# make sure dotvim is setup properly, have to do this after installing the various
# required dependencies first (so neovim is installed and up to date)
if [[ ! -L $HOME/.config/nvim ]] || [[ $(readlink $HOME/.config/nvim) != $DOTFILES/config/nvim ]]; then
	echo "setting up nvim"
	rm -rf $HOME/.config/nvim

	ln -s $DOTFILES/config/nvim $HOME/.config/nvim

	echo "installing deps"
	nvim --headless '+Lazy! restore' '+TSUpdate' '+qa'
else
	echo "nvim already setup"
fi
