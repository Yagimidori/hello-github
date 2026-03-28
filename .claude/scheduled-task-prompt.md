# 週次note記事ドラフト自動生成タスク

## このファイルについて
Claude Code の `/schedule` コマンドで設定するクラウドスケジュールタスクのプロンプトテンプレート。

## セットアップ方法

1. Claude Code のターミナルで実行:
   ```
   /schedule 毎週月曜9時にnote記事ドラフトを自動生成
   ```

2. または `claude.ai/code/scheduled` で手動作成時の設定:
   - **名前**: 週次note記事ドラフト生成
   - **頻度**: Weekly（月曜 09:00）
   - **リポジトリ**: yagimidori/hello-github
   - **環境変数**: NOTE_AUTHOR_ID を設定

## スケジュールタスクのプロンプト

```
以下の手順でnote.com記事のドラフトを1本生成してください。

1. note-researcherサブエージェントを使い、今週のトレンドトピックを3つ調査する
2. 最もエンゲージメントが見込めるトピックを1つ選定し、理由を説明する
3. note-writerサブエージェントを使い、選定したトピックで2000〜3000文字の記事本文を執筆する
4. 記事を以下のフォーマットで drafts/YYYY-MM-DD-[タイトルのスラッグ].md に保存する:
   - frontmatter: title, tags(最大5個), created, status: draft, estimated_read
   - 本文はMarkdown形式
5. git add drafts/ && git commit -m "自動ドラフト: [記事タイトル]" を実行
6. git push origin claude/auto-draft-[YYYY-MM-DD] を実行
7. 生成した記事のサマリー（タイトル・タグ・文字数・要約）を報告する

注意: 投稿（/note-post）は実行しないこと。ドラフト生成のみ行う。
```

## 環境変数設定
スケジュールタスクの Environment に以下を追加:
- `NOTE_AUTHOR_ID`: あなたのnote.comユーザーID
