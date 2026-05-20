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

# ccusage drives the Claude Code statusline (claude/statusline.sh).
if ! command -v ccusage >/dev/null 2>&1; then
  echo "installing ccusage"
  $HOME/.volta/bin/volta install ccusage
fi
