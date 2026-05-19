# dotfiles

## Installation

So far the installation should be pretty straightforward on Darwin:

```sh
./setup.sh
```

This is very much under construction. Will likely clean things up a bit with
references so I can find things over time. But for now, this is just tryin' to
get my personal machine in line with my work machine

## Local-only zsh customizations

Some shell helpers shouldn't live in a public dotfiles repo — work-specific
functions that reference internal hostnames, throwaway experiments, machine-
specific quirks, etc. This repo supports a drop-in directory pattern for
those:

```
~/.zshrc                  # tracked (symlink -> repo/zshrc)
~/.zshrc.local            # tracked loader (symlink -> repo/zshrc.local)
~/.zshrc.local.d/         # LOCAL only — created by `task install`, never symlinked
~/.zshrc.local.d/foo      # your private function `foo()`
~/.zshrc.local.d/bar      # your private function `bar()`
```

`~/.zshrc` sources `~/.zshrc.local`, which iterates every readable file in
`~/.zshrc.local.d/` and sources them in sorted order. To add a new function,
drop a file into `~/.zshrc.local.d/` named after the function (one function
per file) and open a new shell — or run `source ~/.zshrc`.

### Why the contents stay private

- `task install` creates `~/.zshrc.local.d/` as a **plain local directory**.
  It is never symlinked from this repo, so files you drop there live only on
  your machine.
- The repo's `.gitignore` additionally excludes `zshrc.local.d/*` (except
  `README.md`), so even if you accidentally copy a function file into the
  repo's `zshrc.local.d/` directory, git refuses to track it.

See [`zshrc.local.d/README.md`](zshrc.local.d/README.md) for conventions and
examples.
