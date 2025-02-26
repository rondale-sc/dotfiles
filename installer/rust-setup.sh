#!/bin/bash

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
