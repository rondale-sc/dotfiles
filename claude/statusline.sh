#!/usr/bin/env bash
set -eu

CACHE_FILE="${TMPDIR:-/tmp}/.ccusage-monthly-${USER}.json"
CACHE_TTL_SECONDS=30

session_json="$(cat || true)"

if ! command -v ccusage >/dev/null 2>&1; then
  echo "ccusage not installed (volta install ccusage)"
  exit 0
fi

now_epoch=$(date +%s)
if [ -f "$CACHE_FILE" ]; then
  mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
  age=$((now_epoch - mtime))
else
  age=$((CACHE_TTL_SECONDS + 1))
fi

if [ "$age" -le "$CACHE_TTL_SECONDS" ]; then
  monthly_json="$(cat "$CACHE_FILE")"
else
  monthly_json="$(ccusage monthly --json 2>/dev/null || echo '{}')"
  printf '%s' "$monthly_json" > "$CACHE_FILE"
fi

monthly_cost=$(printf '%s' "$monthly_json" | jq -r '.totals.totalCost // 0' 2>/dev/null || echo 0)
dollars=$(awk -v c="$monthly_cost" 'BEGIN { printf "%.2f", c }')

model=$(printf '%s' "$session_json" | jq -r '.model.display_name // .model.id // empty' 2>/dev/null)
[ -z "$model" ] && model="?"

period=$(date +%Y-%m)

printf '$%s %s · %s\n' "$dollars" "$period" "$model"
