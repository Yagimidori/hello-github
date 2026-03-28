# Claude Code 運用ガイド

## プロジェクト概要
note.com記事の自動生成・投稿パイプラインと、GitHub学習リポジトリの管理。

## ワークフロー

### note記事の自動運用
- `/note-draft` でトピック調査→記事ドラフト生成
- `/note-post` でdrafts/フォルダの記事をnote.comに投稿
- スケジュールタスク: 毎週月曜9時に自動ドラフト生成

### Git運用
- ブランチ名: `feature/`, `fix/`, `claude/` プレフィックス必須
- コミットメッセージ: 日本語OK、変更の「なぜ」を書く
- PRは必ず説明文にスクリーンショットまたはテスト結果を添付

## ディレクトリ構成
- `drafts/` - note記事のドラフト（Markdown形式）
- `published/` - 投稿済み記事のアーカイブ
- `.claude/skills/` - 再利用可能なワークフロー
- `.claude/agents/` - 専門特化サブエージェント

## コードスタイル（スクリプト類）
- シェルスクリプト: `#!/bin/bash` + `set -euo pipefail`
- Python: f-string使用、型ヒント必須
- エラーメッセージは日本語

## 環境変数（必須）
- `NOTE_EMAIL` - note.comログインメール
- `NOTE_PASSWORD` - note.comパスワード
- `NOTE_AUTHOR_ID` - note.comのユーザーID（URLスラッグ）

## 重要: note.com投稿ルール
- タイトルは30文字以内
- タグは最大5個
- 画像はdrafts/images/に保存してから参照
- 投稿前に必ず`/note-draft`でプレビュー確認

## よくある問題
- Playwright MCPが起動しない → `npx playwright install chromium`
- note.comログイン失敗 → セッションクッキーが期限切れ、再ログイン必要
