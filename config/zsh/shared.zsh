# vim:set ft=sh sw=2 sts=2:

[ -e "$SOURCE_DIR" ] || SOURCE_DIR="$HOME/Code/rondale-sc/dotfiles"
export SOURCE_DIR

# Paths for prepending
#
for dir in /usr/local/bin "$HOME/bin" .git/safe/../../bin; do
  case "$PATH:" in
  *:"$dir":*) PATH="$(echo "$PATH" | sed -e "s#:$dir##")" ;;
  esac
  case "$dir" in
  /*) [ ! -d "$dir" ] || PATH="$dir:$PATH" ;;
  *) PATH="$dir:$PATH" ;;
  esac
done

# Paths for appending
#
for dir in /usr/local/sbin /opt/local/sbin /usr/X11/bin; do
  case ":$PATH:" in
  *:"$dir":*) ;;
  *) [ ! -d "$dir" ] || PATH="$PATH:$dir" ;;
  esac
done

# File management aliases
#
alias ..='cd ..'
alias cd..='cd ..'
alias l="ls -F -G -lah"
alias la="ls -a"
alias ll='ls -l'
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'

# File management functions
#
function l {
  ls -ld "${1:-$PWD}"/.[^.]*
}

# Git functions
#
if command -v hub >/dev/null; then
  git() {
    command hub "$@"
  }
fi

gcr() {
  git checkout -b $1 origin/$1
}

# git reset empty files
gref() {
  command git --no-pager diff --cached --stat | command grep "|\s*0$" | awk '{system("command git reset " $1)}'
}

# git fix up commits
gfix() {
  if (($# < 1)); then
    log_error "Usage:\n"
    echo "  gfix <git-sha>"
    return 0
  fi

  git_sha=$1
  git cat-file -t "${git_sha}"
  if [[ $? -eq 0 ]]; then
    git commit --fixup ${git_sha} && git stash && git rebase -i --autosquash ${git_sha}~1 && git stash pop
  else
    log_error "Invalid git commit sha: '${git_sha}'"
  fi
}

# Summary: Kill a process that is listening a port
#
# Help: Don't know where that Rails server is listening? Just freethousand!
# This command takes a port as an argument, otherwise defaulting to 3000.

freethousand() {
  port="${1:-3000}"
  pid="$(lsof -t -i tcp:$port | sed 's/p//')"

  if [ -n "$pid" ]; then
    echo "Killing process with PID $pid listening on port $port..." >&2
    kill -9 $pid
  else
    echo "No process listening on port $port" >&2
  fi
}

# Git aliases
#
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gcl='git clean -f -d'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gnap='git add -N --ignore-removal . && gap && gref'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i master'
alias gst='git status'
alias reset-authors='git commit --amend --reset-author -C HEAD'

# Docker aliases
#
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"
alias dcs="docker-compose stop"
alias dcp="docker-compose ps"
alias dcl="docker-compose logs -f"
alias dcr="docker-compose run"
alias dce="docker-compose exec"

# Aliases
#
alias vi='nvim'
