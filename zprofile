eval "$(/opt/homebrew/bin/brew shellenv)"

# Mason (neovim package manager) bins — needs to be in PATH for GUI-launched
# neovim so lspconfig can resolve servers like gopls without Mason loading first.
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
