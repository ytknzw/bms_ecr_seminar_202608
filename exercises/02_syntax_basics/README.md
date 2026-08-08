# Ex2 文法（基礎）

スライド p27 / 31–33 / 36–40 に対応。ペンギンデータは使いません。

## 実行前提（対話モード）

この演習は **対話モード（REPL）** で進めることを前提とします。値の確認に `print` / `message` は不要です（ただし R の `for` 内は自動表示されないため、対訳では必要箇所だけ `print` を使います）。値を確認したい行は、式や変数名をそのまま書いてください（対話環境が結果を表示します）。

```bash
# Python: 対話モードで起動し、python/ の内容を貼り付けて実行
uv run python -i
# または
uv run python

# R: 対話モードで起動し、r/ の内容を貼り付けて実行
R
```

## 問題と正解の対応

- **1行目**で問題か正解かを示します: `# 【問題】…` / `# 【正解】…`
- `python/` と `solutions/` は **構造が同一**です。違いは解答スロットが空か埋まっているかだけです
- 各 `# 問題N: …する。` の直後の空行スロットに書いてください（「TODO」は使いません）
- 対訳（`r/`）は埋め済みの参照用です（`solutions/` の R 対はなし）。API は R 向けに読み替え（`library` / `<-` / `%/%` / named list など）

| ファイル | 内容 | 対応スライド |
|----------|------|--------------|
| Must `01_objects.py` / `01_objects.R` | 型・代入・演算・import / library | データ型 / 演算子 / 代入 / パッケージ / f文字列 |
| Must `02_control_flow.py` / `02_control_flow.R` | for / while / if / def・function | 繰り返し・条件分岐・関数定義 |
| Must `03_collections.py` / `03_collections.R` | list・dict / ベクトル・named list | Pythonのイテラブル |
| Must `04_functions.py` / `04_functions.R` | standardize | 関数の切り出し |
| Stretch `05_io.py` / `05_io.R` | pathlib + `with open` / `dir.create` + connection | with によるファイル読み書き |

正解は `solutions/`（Python）。対訳は `r/`。
