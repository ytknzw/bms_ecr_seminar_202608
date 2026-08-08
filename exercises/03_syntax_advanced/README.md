# Ex3 文法（応用）

ペンギンデータは使いません（合成例: Alice / Bob / scores）。

## 問題と正解の対応

- **1行目**で問題か正解かを示します: `# 【問題】…` / `# 【正解】…`
- `python/` と `solutions/` は **構造が同一**です。違いは解答スロットが空か埋まっているかだけです
  - 例外: Stretch の `check_score.py` は問題側も**実装済み**（テスト作成が主課題）
- 各 `# 問題N: …する。` の直後の空行スロットに書いてください（「TODO」は使いません）
- 対訳（`r/`）は埋め済みの参照用です

| ファイル | 内容 |
|----------|------|
| Must `01_classes.py` / `01_s3_class.R` | Student / TransferStudent（継承） |
| Must `02_logging.py` / `02_messaging.R` | logging（logger） / message・warning |
| Stretch `check_score.py`（実装済み）+ `03_test_check_score.py` / `check_score.R` | check_score（優・良・可・不可）。pytest / testthat を書く |

```bash
uv run python exercises/03_syntax_advanced/python/01_classes.py
uv run python exercises/03_syntax_advanced/python/02_logging.py
# ファイル名が test_*.py でないため、パスを明示する
uv run pytest exercises/03_syntax_advanced/python/03_test_check_score.py -q
```

正解は `solutions/`。対訳は `r/`。
