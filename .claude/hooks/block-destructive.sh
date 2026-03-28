#!/bin/bash
# 破壊的なコマンドをブロックするフック
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# rm -rf のブロック
if echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f|rm\s+-[a-zA-Z]*f[a-zA-Z]*r'; then
  python3 -c "
import json
print(json.dumps({
  'hookSpecificOutput': {
    'hookEventName': 'PreToolUse',
    'permissionDecision': 'deny',
    'permissionDecisionReason': 'rm -rf は危険なため自動ブロックしました。手動で実行してください。'
  }
}))
"
  exit 0
fi

# published/ への上書き防止
if echo "$COMMAND" | grep -qE '>\s*published/'; then
  python3 -c "
import json
print(json.dumps({
  'hookSpecificOutput': {
    'hookEventName': 'PreToolUse',
    'permissionDecision': 'deny',
    'permissionDecisionReason': 'published/ フォルダへの直接書き込みは禁止です。drafts/ を使用してください。'
  }
}))
"
  exit 0
fi

exit 0
