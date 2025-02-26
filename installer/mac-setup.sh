#!/bin/bash

if [ "$(hidutil property --get 'UserKeyMapping')" == '(null)' ]; then
  echo 'Remapping macOS modifiers...'
  # remap CapsLock to Escape (now)
  ./scripts/remap_macos_modifiers.sh

  # remap CapsLock to Escape (survives system restarts)
  # this was generated using https://hidutil-generator.netlify.app/
  PLIST_TARGET="$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"

  if [ ! -f "$PLIST_TARGET" ]; then
    sudo cp ./macos/com.local.KeyRemapping.plist "$PLIST_TARGET"
  fi
fi

# install homebrew
if ! command -v brew &>/dev/null; then
  echo 'Homebrew not installed, installing...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo 'Setting up App Shortcuts...'

# ^ for Control, @ for Command, $ for shift
set_app_shortcut() {
  defaults write "$1" NSUserKeyEquivalents -dict-add "$2" "$3"
}

# Disable default shortcuts for tabs in wezterm
set_app_shortcut "$app_id" 'Activate the tab to the left' '\0'
set_app_shortcut "$app_id" 'Activate the tab to the right' '\0'

echo 'Getting brew packages...'
brew bundle
