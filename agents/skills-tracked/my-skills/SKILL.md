---
name: my-skills
description: List the Claude skills (and slash commands) installed from my rondale-sc dotfiles, grouped by source — pinned (skills.json), tracked, and local — so I can tell which skills are mine versus third-party plugins. Use when asked "which skills are mine", "what skills do I symlink", "list my dotfile skills", or to audit dotfile skill installs.
---

# My Skills — dotfile skill inventory

## Overview
Skills from the rondale-sc dotfiles are symlinked into `~/.claude/skills/` by
`task claude:install` from three source roots:

- **pinned** — `claude/skills/` (upstream skills pinned via `claude/skills.json`)
- **tracked** — `claude/skills-tracked/` (committed to the dotfiles repo)
- **local** — `claude/skills-local/` (machine-local, gitignored)

This skill reports which installed skills trace back to those sources, so it's
easy to distinguish dotfile-managed skills from third-party plugin skills.

## How to run
Execute the bundled script and show its output verbatim:

```bash
bash "$(dirname "$(realpath ~/.claude/skills/my-skills/SKILL.md)")/list.sh"
```

The script resolves the dotfiles root from its own symlinked location, so it
works on any machine regardless of where the dotfiles repo is checked out.

## What it reports
- Each dotfile skill grouped under **pinned / tracked / local**, with counts.
- A **third-party** group: skills in `~/.claude/skills/` that are *not* symlinks
  into the dotfiles repo (plugins, ad-hoc installs).
- **command bundles** — skills whose `commands/` dir is symlinked into
  `~/.claude/commands/<skill>`, surfacing slash commands as `/<skill>:<cmd>`.

## Notes
- Read-only: it only inspects symlinks under `~/.claude/`. It changes nothing.
- If a skill you expect is missing from the dotfile groups, it's likely not
  symlinked yet — re-run `task claude:install` in the dotfiles repo.
