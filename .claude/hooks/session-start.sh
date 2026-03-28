#!/bin/bash
# セッション開始時のコンテキスト読み込み
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

echo "=== note.com 自動運用セッション ==="
echo "日時: $(date '+%Y-%m-%d %H:%M')"
echo ""

# draftsフォルダの状況
DRAFT_COUNT=$(find "$PROJECT_DIR/drafts" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "未投稿ドラフト数: $DRAFT_COUNT 件"

# 直近の投稿確認
LATEST=$(ls -t "$PROJECT_DIR/published/"*.md 2>/dev/null | head -1 || echo "なし")
if [ "$LATEST" != "なし" ]; then
  echo "最新投稿: $(basename $LATEST)"
fi

# 環境変数チェック
MISSING_VARS=""
[ -z "${NOTE_EMAIL:-}" ] && MISSING_VARS="$MISSING_VARS NOTE_EMAIL"
[ -z "${NOTE_PASSWORD:-}" ] && MISSING_VARS="$MISSING_VARS NOTE_PASSWORD"
[ -z "${NOTE_AUTHOR_ID:-}" ] && MISSING_VARS="$MISSING_VARS NOTE_AUTHOR_ID"

if [ -n "$MISSING_VARS" ]; then
  echo ""
  echo "⚠️  未設定の環境変数:$MISSING_VARS"
  echo "   note投稿機能を使う場合は設定してください"
fi

echo ""
echo "利用可能なスキル: /note-draft, /note-post"
echo "==============================="

exit 0
