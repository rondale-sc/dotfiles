#==============================================================================
# linkedin.zsh — LinkedIn-flavored shell setup for Go (and friends)
#==============================================================================
#
# WHAT THIS FILE IS
#   Per-machine zsh config that wires LinkedIn's Native-Go toolchain (golnkd-core)
#   and direnv into the shell. Auto-sourced by the loop in `zshrc:93-95`:
#
#       for f in ${XDG_CONFIG_HOME}/zsh/*; do source $f; done
#
#   Every block is guarded by a path/binary check, so this file is safe to keep
#   in the dotfiles repo even on a non-LinkedIn machine — blocks whose tools
#   are absent simply no-op.
#
# WHY IT EXISTS
#   Without this file, `go` commands hit the public proxy (proxy.golang.org),
#   GOPRIVATE is empty, and the Homebrew Go drifts from per-MP pins (e.g.
#   observe-grafana-image-renderer pins go 1.25 in go.mod, but Homebrew may
#   have 1.26.x). gopls in Neovim then resolves the wrong GOROOT/GOPROXY and
#   can't fetch internal modules under `golnkd.in/*`.
#
# COMPANION DECISIONS (dotfiles-level)
#   • Homebrew Go has been removed from Brewfile (line 100). The only Go on
#     this machine should come from `golnkd-core install`, which writes to
#     $HOME/.go/<VERSION>. The last block below puts the newest such version
#     on PATH for ad-hoc work.
#   • No Neovim changes — LazyVim's `lang.go` and `lang.typescript.biome`
#     extras already provide gopls, goimports, gofumpt, neotest-golang,
#     nvim-dap-go, typescript-language-server, biome, eslint, prettier.
#     gopls just needs the right env in the shell when nvim launches, which
#     this file (plus per-MP .envrc) provides.
#
# PREREQUISITES (already present on a Phoenix-managed LinkedIn Mac)
#   • /usr/local/linkedin/bin/golnkd-core   — LinkedIn Native-Go toolchain
#   • direnv on PATH (Homebrew or Phoenix)  — per-MP env auto-loader
#
# PER-MP WORKFLOW (do this once per Go multiproduct you work in)
#   Inside the MP root:
#
#       echo 'source <(golnkd-core shell-env)' > .envrc
#       direnv allow
#
#   After that, `cd`-ing into the MP exports the right GOROOT/GOPATH/GOPROXY/
#   GOPRIVATE/GOSUMDB/GOBIN for that MP (the version pinned in
#   product-spec.json:build.versions.golang). Launch nvim from inside the MP
#   so gopls inherits the env. Outside any MP, the fallback values below apply.
#
# CANONICAL VALUES (sources)
#   linkedin-multiproduct/go-at-linkedin/docs/native-go/envvars.md
#   linkedin-multiproduct/go-at-linkedin/docs/native-go/adhoc.md
#   linkedin-multiproduct/go-at-linkedin/docs/native-go/installing.md
#   linkedin-multiproduct/go-proxy-athens/README.md
#
#   Note: envvars.md still lists `custom-goproxy.corp.linkedin.com` for
#   GOPROXY, but that's the *legacy* Gradle-Go proxy serving only
#   `golang.linkedin.com/*` modules. Native-Go uses the `golnkd.in/*`
#   prefix and the `gomodproxy.corp.linkedin.com` host. Everything in this
#   workspace (observe-ingraphs, observe-grafana-image-renderer, the
#   grafana-plugin-* MPs) is Native-Go.
#
# OPT OUT
#   Comment out the source line in ~/.zshrc.local or rename this file to
#   anything not matching `${XDG_CONFIG_HOME}/zsh/*`. No other dotfile
#   touches LinkedIn-specific paths.
#
# SUPPORT
#   #golang-support on Slack, si-go@linkedin.com, go/supportal/go
#==============================================================================

# --- 1. LinkedIn CLI tools (golnkd-core, mint, lix-cli, nimbus, ...) on PATH
[[ -d /usr/local/linkedin/bin ]] && path=(/usr/local/linkedin/bin $path)

# --- 2. direnv: auto-source per-MP `.envrc` on `cd`.
# Each Go MP's .envrc runs `source <(golnkd-core shell-env)` which exports
# the correct GOROOT/GOPATH/GOPROXY/GOPRIVATE/GOSUMDB/GOBIN for that MP.
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# --- 3. Global Go fallbacks for ad-hoc `go` calls outside any MP.
# Inside an MP, direnv + golnkd-core override these with per-MP values.
export GOPROXY="gomodproxy.corp.linkedin.com"
export GOSUMDB="off"
export GOPRIVATE="*"
export GONOPROXY="none"

# --- 4. Put the newest golnkd-core-managed Go on PATH for scratch work
# outside an MP. Inside an MP, direnv prepends the MP-pinned version, which
# wins because direnv runs after this file is sourced.
if [[ -d "$HOME/.go" ]]; then
  latest_go=$(ls -1 "$HOME/.go" 2>/dev/null | sort -V | tail -1)
  [[ -n "$latest_go" ]] && path=("$HOME/.go/$latest_go/bin" $path)
  unset latest_go
fi
