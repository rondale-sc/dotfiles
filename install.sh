#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f /etc/rdev.conf ]]; then
  exec "$DOTFILES_DIR/rdev-install.sh" "$@"
fi

exec "$DOTFILES_DIR/setup.sh" "$@"
