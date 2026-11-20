# Go check shortcuts. Run from a module root.
# Prefix "go" because g* is taken by the git aliases.

# Full check chain; prints a header per step and names the step that failed.
gochk() {
  local step
  for step in "go build ./..." "go vet ./..." "go test -count=1 ./..." "go test -count=1 -race ./..."; do
    print -P "%F{cyan}== ${step}%f"
    if ! eval "$step"; then
      print -P "%F{red}✗ FAILED: ${step}%f"
      return 1
    fi
  done
  print -P "%F{green}✓ gochk: build, vet, test, race all passed%f"
}
alias gotst='go test -count=1 ./...'
alias gorace='go test -count=1 -race ./...'
alias govet='go vet ./...'
alias golint='golangci-lint run --no-config ./...'
# Lint only the uncommitted change (what a diff under review added).
alias golintn='golangci-lint run --no-config --new ./...'

# gotone <TestName> [pkg]: one test, verbose, with -race. pkg defaults to ./...
gotone() {
  if [[ -z "$1" ]]; then
    echo "usage: gotone <TestName regexp> [package, default ./...]" >&2
    return 2
  fi
  go test -count=1 -race -v -run "$1" "${2:-./...}"
}

# Preview autofixes; changes nothing.
gofixp() {
  echo "== gofmt -l (files needing format)"; gofmt -l .
  echo "== go fix -diff"; go fix -diff ./...
  echo "== golangci-lint (fixable issues show here)"; golangci-lint run --no-config ./...
}

# Apply autofixes, then show what changed.
gofixa() {
  goimports -w . && go fix ./... && golangci-lint run --no-config --fix ./...
  git diff --stat
}
