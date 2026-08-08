# Ex4 データ加工（基礎）

`python/`（または `r/`）に入ってから実行する。データは `../../../data/` を相対参照する。
`00_fetch_penguins.py` のみスクリプト。それ以外の Python は Notebook（`.ipynb`）。

## 問題（`python/`）

| ファイル | 内容 |
|----------|------|
| 例 `00_fetch_penguins.py` | Rdatasets raw CSV → 整形 → parquet（実装済み・実行用） |
| Must `01_read_describe.ipynb` | 読込・確認、列/行の抽出・追加・ソート |
| Must `02_groupby.ipynb` | 島×種の平均、種ごとの件数・平均体重・Flipper中央値 |
| Must `03_duplicates.ipynb` | Adelie: shape・nunique・完全重複・Individual_ID重複 |
| Stretch `04_numpy_basics.ipynb` | 固定4×3行列の参照・reshape・対角・arange・ブール索引・行/列の追加 |

```bash
cd exercises/04_wrangling_basics/python
uv run python 00_fetch_penguins.py
uv run jupyter execute 01_read_describe.ipynb
uv run jupyter execute 02_groupby.ipynb
uv run jupyter execute 03_duplicates.ipynb
```

正解は `solutions/`。対訳は `r/`。
