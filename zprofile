if [[ "$(uname -s)" == "Darwin" && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Mason (neovim package manager) bins — needs to be in PATH for GUI-launched
# neovim so lspconfig can resolve servers like gopls without Mason loading first.
if [[ -d "$HOME/.local/share/nvim/mason/bin" ]]; then
  export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi
