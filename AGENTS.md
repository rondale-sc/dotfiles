# AGENTS.md

Guidance for AI coding agents working in this repository. This file follows the
generic [AGENTS.md](https://agents.md) convention so any agent (Claude Code,
and others as they adopt it) can pick it up. There is intentionally no
tool-specific instructions file — keep agent guidance here.

## What this repo is

Personal dotfiles for macOS (Darwin), installed with
[Task](https://taskfile.dev). Entry point: `./setup.sh`, which bootstraps Task
and runs `task install` (an alias for `dot:install`).

## Layout

- `Taskfile.dist.yml` — root task definitions; includes the files under `taskfiles/`.
- `taskfiles/` — one taskfile per concern (`dotfiles.yml`, `brew.yml`, `shell.yml`,
  `completions.yml`, `nvim.yml`, `agents.yml`).
- `agents/` — agent tooling: skills manifest, skill sources, and the statusline script.
- `config/` — XDG config dirs symlinked into `~/.config/`.
- `installer/`, `scripts/`, `macos/` — install helpers and macOS defaults.
- `zshrc`, `zprofile`, `gitconfig`, etc. — dotfiles symlinked into `$HOME`.

## Agent skills (`agents/` + `taskfiles/agents.yml`)

`task agents:install` loads skills from three sources and symlinks them into the
active agent's home. **Claude Code is the only supported agent for now**, so the
target is `~/.claude/skills/` (override with `AGENT_HOME`, or the legacy
`CLAUDE_HOME`). The `claude:` task alias still works.

Skill sources, all symlinked into the agent home:

1. `agents/skills.json` — pinned upstream skills fetched from GitHub by
   `github_path` + `sha`. Fetched copies land in `agents/skills/` (gitignored).
2. `agents/skills-tracked/<skill>/` — skill folders committed to this repo
   (versioned across machines).
3. `agents/skills-local/<skill>/` — machine-local skills (gitignored except
   `.gitkeep`).

Each skill folder must contain `SKILL.md`; a `commands/` subdir is exposed under
the agent's `commands/` dir. Skill names must be unique across all three sources.

Useful tasks:

- `task agents:install` — fetch pinned skills and (re)symlink all sources.
- `task agents:sync-upstream` — diff pinned skills against upstream HEAD
  (read-only; add `-- --apply` to bump SHAs in `agents/skills.json`).

## Conventions

- Prefer `task` targets over ad-hoc scripts; add new concerns as a file under
  `taskfiles/` and include it from `Taskfile.dist.yml`.
- Keep machine- or work-specific shell code out of the tracked tree — drop it in
  `~/.zshrc.local.d/` (see `README.md`). Never commit secrets.
- The install is symlink-based: edits to tracked files take effect immediately.
- When generalizing agent tooling, keep it agent-agnostic in naming but keep
  Claude working until another agent is actually wired up.
