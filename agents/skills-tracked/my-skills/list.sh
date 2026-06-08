#!/usr/bin/env bash
# List Claude skills + slash commands that are symlinked from the
# rondale-sc dotfiles, grouped by their source root:
#
#   pinned   -- claude/skills/         (upstream, pinned via claude/skills.json)
#   tracked  -- claude/skills-tracked/ (committed to the dotfiles repo)
#   local    -- claude/skills-local/   (machine-local, gitignored)
#
# Anything under ~/.claude/skills that is NOT a symlink into the dotfiles
# repo is treated as third-party (plugins, ad-hoc installs) and listed
# separately so it's obvious which skills are "mine".
set -euo pipefail

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

# Derive the dotfiles root from this script's real location:
#   <dotfiles>/claude/skills-tracked/my-skills/list.sh
script="$(realpath "${BASH_SOURCE[0]}")"
claude_src="$(cd "$(dirname "$script")/../.." && pwd)"   # -> <dotfiles>/claude

pinned=()
tracked=()
local_=()
foreign=()

for dst in "$CLAUDE_HOME"/skills/*; do
  [ -e "$dst" ] || continue
  name="$(basename "$dst")"
  if [ -L "$dst" ]; then
    tgt="$(realpath "$dst" 2>/dev/null || true)"
    case "$tgt" in
      "$claude_src"/skills/*)         pinned+=("$name");  continue;;
      "$claude_src"/skills-tracked/*) tracked+=("$name"); continue;;
      "$claude_src"/skills-local/*)   local_+=("$name");  continue;;
    esac
  fi
  foreign+=("$name")
done

print_group() {
  local title="$1"; shift
  local count=$#
  printf '\n%s (%d)\n' "$title" "$count"
  if [ "$count" -eq 0 ]; then
    printf '  (none)\n'
    return
  fi
  printf '  %s\n' "$@"
}

mine_total=$(( ${#pinned[@]} + ${#tracked[@]} + ${#local_[@]} ))

printf '== Skills from my dotfiles (%d) ==\n' "$mine_total"
print_group "pinned   [claude/skills.json]"   ${pinned[@]+"${pinned[@]}"}
print_group "tracked  [claude/skills-tracked]" ${tracked[@]+"${tracked[@]}"}
print_group "local    [claude/skills-local]"   ${local_[@]+"${local_[@]}"}

print_group "third-party (not from dotfiles)" ${foreign[@]+"${foreign[@]}"}

# Slash commands exposed by dotfile skills (a skill's commands/ dir is
# symlinked to ~/.claude/commands/<skill>, surfacing as /<skill>:<cmd>).
cmd_links=()
if [ -d "$CLAUDE_HOME/commands" ]; then
  for dst in "$CLAUDE_HOME"/commands/*; do
    [ -L "$dst" ] || continue
    tgt="$(realpath "$dst" 2>/dev/null || true)"
    case "$tgt" in
      "$claude_src"/skills*/*) cmd_links+=("$(basename "$dst")");;
    esac
  done
fi
print_group "command bundles from dotfiles (/<name>:<cmd>)" ${cmd_links[@]+"${cmd_links[@]}"}
