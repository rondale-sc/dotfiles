#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    echo "missing source: $source" >&2
    return 1
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" || ! -e "$target" ]]; then
    ln -sfn "$source" "$target"
    echo "linked: $target -> $source"
    return 0
  fi

  echo "skipping existing non-symlink: $target" >&2
}

echo "[rdev-install] installing RDev-safe dotfiles from $DOTFILES_DIR"

if [[ ! -f /etc/rdev.conf ]]; then
  echo "[rdev-install] warning: /etc/rdev.conf not found; continuing because this installer is RDev-safe" >&2
fi

mkdir -p "$HOME/.config" "$HOME/.cache/zsh/completions" "$HOME/.local/share/psql" "$HOME/.zshrc.local.d"

link_path "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
link_path "$DOTFILES_DIR/zshrc.local" "$HOME/.zshrc.local"
link_path "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

link_path "$DOTFILES_DIR/config/zsh" "$HOME/.config/zsh"
link_path "$DOTFILES_DIR/config/starship" "$HOME/.config/starship"
link_path "$DOTFILES_DIR/config/nvim-rdev" "$HOME/.config/nvim"

echo "[rdev-install] done"
