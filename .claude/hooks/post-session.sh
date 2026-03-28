#!/bin/bash
# セッション終了後の後処理
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# 未コミットのドラフトがあれば通知
UNTRACKED=$(git -C "$PROJECT_DIR" status --porcelain drafts/ 2>/dev/null || echo "")
if [ -n "$UNTRACKED" ]; then
  echo "📝 未コミットのドラフトがあります。git commit を検討してください:"
  echo "$UNTRACKED"
fi

exit 0
