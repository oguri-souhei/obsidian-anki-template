#!/usr/bin/env bash
# Anki カード化の対象ノートを抽出する。
#
# 対象の条件（両方を満たすもの）:
#   - frontmatter の tags に Anki が含まれる
#   - flashcard_created が未チェック（キーなし / 空 / false）
#
# 使い方: find-targets.sh [検索ルート]   ※デフォルトは Study
# 出力  : 対象ノートのパスを1行に1件

set -euo pipefail

root="${1:-Study}"

if [ ! -d "$root" ]; then
  echo "ディレクトリがありません: $root" >&2
  exit 1
fi

# frontmatter を読み、対象なら終了ステータス 0 を返す
is_target() {
  awk '
    # tags の値からタグ名を切り出し、Anki があれば印を付ける
    function mark_anki(s,   n, arr, i) {
      gsub(/[][,"\047]/, " ", s)
      n = split(s, arr, /[ \t]+/)
      for (i = 1; i <= n; i++) if (arr[i] == "Anki") has_anki = 1
    }

    NR == 1 { if ($0 != "---") exit 1; in_fm = 1; next }

    in_fm && ($0 == "---" || $0 == "...") { in_fm = 0; next }

    # トップレベルのキー行
    in_fm && /^[A-Za-z_][A-Za-z0-9_-]*[ \t]*:/ {
      key = $0; sub(/[ \t]*:.*/, "", key)
      val = $0; sub(/^[^:]*:[ \t]*/, "", val); sub(/[ \t]+$/, "", val)
      if (key == "tags") mark_anki(val)
      if (key == "flashcard_created" && val != "" && val !~ /^(false|False|FALSE|null|~)$/) created = 1
      next
    }

    # tags のリスト項目行
    in_fm && key == "tags" && /^[ \t]*-[ \t]*/ {
      item = $0; sub(/^[ \t]*-[ \t]*/, "", item)
      mark_anki(item)
    }

    END { exit (has_anki && !created) ? 0 : 1 }
  ' "$1"
}

while IFS= read -r note; do
  if is_target "$note"; then
    echo "$note"
  fi
done < <(find "$root" -type f -name '*.md' | sort)
