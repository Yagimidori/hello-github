---
name: note-post
description: drafts/フォルダのMarkdownをnote.comに投稿する。Playwright MCPでブラウザ自動操作。
disable-model-invocation: true
---

# note.com記事投稿

引数: $ARGUMENTS（ファイルパス。省略時はdrafts/内の最新ドラフトを使用）

## 前提確認

1. 環境変数チェック:
```bash
[ -z "$NOTE_EMAIL" ] && echo "ERROR: NOTE_EMAIL が未設定" && exit 1
[ -z "$NOTE_PASSWORD" ] && echo "ERROR: NOTE_PASSWORD が未設定" && exit 1
[ -z "$NOTE_AUTHOR_ID" ] && echo "ERROR: NOTE_AUTHOR_ID が未設定" && exit 1
```

2. 対象ファイルの特定:
   - 引数ありの場合: 指定ファイルを使用
   - 引数なしの場合: `drafts/` 内の `status: draft` なファイルを一覧表示し選択

## 投稿手順（Playwright MCP使用）

### Step 1: ドラフト内容の読み込み
- 対象Markdownファイルを読み込む
- frontmatterからtitle, tags, 本文を抽出
- タイトルが30文字超の場合は警告して確認

### Step 2: note.comにログイン
Playwright MCPで以下を実行:
1. `https://note.com/login` を開く
2. メールアドレス入力: `$NOTE_EMAIL`
3. パスワード入力: `$NOTE_PASSWORD`
4. ログインボタンクリック
5. ログイン成功確認（マイページURLへのリダイレクト確認）

### Step 3: 新規記事作成ページへ移動
1. `https://note.com/` にアクセス
2. 「投稿」ボタン → 「テキスト」を選択
3. エディタページが開くことを確認

### Step 4: 記事内容の入力
1. タイトル欄に title を入力
2. 本文エリアにMarkdown本文をペースト
   （note.comはMarkdownをそのままペーストするとある程度認識する）
3. タグを1つずつ追加（最大5個）

### Step 5: 投稿前プレビュー確認
1. 「プレビュー」ボタンをクリック
2. スクリーンショットを撮影して表示
3. ユーザーに確認を求める: 「このままnoteに投稿しますか？ (yes/no)」

### Step 6: 投稿実行
ユーザーが `yes` と回答した場合のみ:
1. 「公開」ボタンをクリック
2. 公開確認ダイアログで「公開する」をクリック
3. 投稿完了URLを取得して表示

### Step 7: 後処理
投稿成功後:
1. ドラフトファイルのfrontmatterを更新:
   ```yaml
   status: published
   published_at: YYYY-MM-DD HH:MM
   note_url: https://note.com/...
   ```
2. ファイルを `published/` フォルダに移動:
   ```bash
   mv "drafts/FILENAME.md" "published/FILENAME.md"
   ```
3. git commit:
   ```bash
   git add published/ drafts/
   git commit -m "note投稿完了: [タイトル]"
   ```

## エラーハンドリング
- ログイン失敗: セッションクッキーのリセットを案内
- タイムアウト: リトライ1回まで
- 投稿失敗: エラースクリーンショットを保存して報告
