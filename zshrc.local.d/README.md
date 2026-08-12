# `~/.zshrc.local.d/`

This directory holds **local-only** zsh customizations that should never be
committed to this public dotfiles repo.

## How it works

`zshrc.local` (in the repo root, symlinked to `~/.zshrc.local`) iterates
every readable file in `~/.zshrc.local.d/` and sources each one in sorted
order. `~/.zshrc` sources `~/.zshrc.local` near the end of its load.

So: drop a file in `~/.zshrc.local.d/`, open a new shell (or run
`source ~/.zshrc`), and the function is available.

## Conventions

- One function per file, named after the function.
  Example: `~/.zshrc.local.d/mp-deploy-state` defines `mp-deploy-state()`.
- Prefix with digits if you need explicit load ordering:
  `00-paths`, `10-aliases`, `20-functions`, …
- Files starting with `.` are skipped by the loader.

## Privacy guarantees

- `~/.zshrc.local.d/` is created locally by `task install` and is **not**
  symlinked from this repo. Files you place there live only on your machine.
- The repo's `.gitignore` additionally excludes everything in
  `zshrc.local.d/` except this README — so even if you accidentally copy a
  function file into the repo's directory, git will refuse to track it.

## Examples of what to put here

- `is-linkedin-work-machine` containing `export LINKEDIN_WORK_MACHINE=1`
  enables the tracked `config/zsh/linkedin.zsh` configuration on a work Mac.
- Work-specific helpers that reference internal hostnames or APIs
- Credentials or tokens (better: use a secrets manager, but in a pinch)
- Per-host quirks you don't want bleeding into your public config
- Throwaway shell experiments
