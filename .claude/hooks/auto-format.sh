#!/bin/bash
# ファイル保存後の自動フォーマット
set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('path',''))" 2>/dev/null || echo "")

if [ -z "$FILE" ]; then
  exit 0
fi

# Markdownファイルの場合：末尾の空白を除去
if [[ "$FILE" == *.md ]]; then
  if [ -f "$FILE" ]; then
    sed -i 's/[[:space:]]*$//' "$FILE"
  fi
fi

# Pythonファイルの場合：black/isortが利用可能なら実行
if [[ "$FILE" == *.py ]]; then
  if command -v black &>/dev/null; then
    black --quiet "$FILE" 2>/dev/null || true
  fi
fi

exit 0
