# 応用情報 勉強テンプレート（Obsidian + Anki）

勉強メモから暗記カードを自動で作るためのテンプレートです。

Obsidian に学んだことを蓄え、Claude Code でカードに変換し、Anki で復習します。カードを手で作る必要はありません。

## 全体の流れ

```
Study/ に勉強メモを書く（タグに Anki を付ける）
   │
   │  Claude Code で /anki-flashcard
   ↓
Flashcards/ に暗記カードができる
   │
   │  Obsidian のコマンドで同期
   ↓
Anki で復習する
```

## 用意するもの

- [Obsidian](https://obsidian.md/) — メモを書く
- [Anki](https://apps.ankiweb.net/) — 暗記カードで復習する
- [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) — メモをカードに変換する
  - ※ Claude Code以外でも `.claude/skills/anki-flashcard/` を適切な場所に置くことで使用可能

## 初期設定

初回だけの作業です。10分ほどで終わります。

### 1. リポジトリを取得する

```bash
git clone https://github.com/oguri-souhei/obsidian-anki-template.git
```

### 2. Obsidian で開く

Obsidian を起動し、「Open folder as vault」でクローンしたフォルダを選びます。

コミュニティプラグインを有効にするか聞かれたら、有効にしてください。

### 3. Flashcards プラグインを入れる

プラグイン本体はリポジトリに含めていないので、各自でインストールします。

1. 設定 → コミュニティプラグイン → 「閲覧」
2. `Flashcards` （作者: Alex Colucci）を検索してインストール
3. 有効化する

**設定はすべて初期値のままで動きます。** 変更しないでください。

### 4. Anki に AnkiConnect を入れる

Obsidian から Anki を操作するためのアドオンです。

1. Anki を起動し、ツール → アドオン → 「新たにアドオンを取得」
2. コード `2055492159` を入力して OK
3. アドオン一覧で AnkiConnect を選び、「設定」を開く
4. `webCorsOriginList` に `app://obsidian.md` を追加する

```json
"webCorsOriginList": ["http://localhost", "app://obsidian.md"]
```

5. Anki を再起動する

初期設定はここまでです。接続の確認は、次の「使い方」で初めて同期するときに行います。

## 使い方

例）応用情報の勉強

### 1. メモを書く

`Study/応用情報技術者試験/` の下に、学んだ内容をメモします。

このとき、プロパティの `tags` に `Anki` を追加してください。これがカード化の目印になります。

サンプル: [メモリインターリーブ.md](Study/応用情報技術者試験/メモリインターリーブ.md)

### 2. カードに変換する

このリポジトリで `claude` を起動し、`/anki-flashcard` を実行します。

`Flashcards/` の下にカードが作られ、元メモの `flashcard_created` にチェックが入ります。

### 3. Anki に同期する

**Anki を起動した状態で**、Obsidian のコマンドパレット（`cmd + P`）から `Flashcards: Update Anki from vault` を実行します。

初回だけ、Anki 側に接続を許可するかのダイアログが出ます。許可してください。

あとは Anki で復習するだけです。

### 2回目以降

メモを増やして `/anki-flashcard` を実行する、を繰り返してください。

一度カード化したメモは `flashcard_created` にチェックが付くので、二重にカードが作られることはありません。

## フォルダ構成

```
Study/              勉強メモを書く場所
  応用情報技術者試験/
    Attachments/    貼り付けた画像の置き場
Flashcards/         カードの置き場（自動生成。手で書かない）
.claude/skills/     /anki-flashcard の中身
```

`Study/` 直下のフォルダ名が、そのまま `Flashcards/` のファイル名になります。

- `Study/応用情報技術者試験/` のメモ → `Flashcards/応用情報技術者試験.md`

科目を増やしたいときは、`Study/` の下にフォルダを作るだけです。

## つまずいたら

**同期でエラーが出る**

Anki が起動しているか確認してください。AnkiConnect は Anki が起動している間しか動きません。

**`cannot create note because it is a duplicate` と出る**

同じ内容のカードが Anki に残っています。もう一度同期すると通ることが多いです。

**カードが作られない**

メモの `tags` に `Anki` が入っているか、`flashcard_created` にチェックが付いていないかを確認してください。

次のコマンドで、カード化の対象になっているメモを一覧できます。

```bash
.claude/skills/anki-flashcard/scripts/find-targets.sh
```

## 参考

- [ObsidianとAnkiの連携解説記事](https://note.com/ks_blog_park/n/ne9e01fcfd6b2) — 画面つきで詳しいです。ただしプラグインが古いバージョン（v1）の解説なので、設定画面は今と違います。Anki 側の準備の参考にしてください。
