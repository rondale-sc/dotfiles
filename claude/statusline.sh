#!/usr/bin/env bash
# Claude Code statusline. Outputs one compact line: monthly spend / plan cap
# (percent), current period, and active model.
#
# Plan cap is read from $CLAUDE_PLAN_BUDGET (defaults to 200, e.g. Max20x).
# Set to your subscription tier's price for an honest "% of value" reading.
#
# Claude Code pipes session JSON on stdin; we use it for the model name.

set -eu

PLAN_CAP="${CLAUDE_PLAN_BUDGET:-200}"
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
percent=$(awk -v c="$monthly_cost" -v p="$PLAN_CAP" 'BEGIN { if (p+0 == 0) { print "?" } else { printf "%.0f", (c/p)*100 } }')
dollars=$(awk -v c="$monthly_cost" 'BEGIN { printf "%.2f", c }')

if [ "$percent" = "?" ]; then
  color=37
elif [ "$percent" -lt 75 ]; then
  color=32
elif [ "$percent" -lt 100 ]; then
  color=33
else
  color=31
fi

model=$(printf '%s' "$session_json" | jq -r '.model.display_name // .model.id // empty' 2>/dev/null)
[ -z "$model" ] && model="?"

period=$(date +%Y-%m)

printf '\033[%sm$%s/$%s (%s%%)\033[0m %s · %s\n' "$color" "$dollars" "$PLAN_CAP" "$percent" "$period" "$model"
