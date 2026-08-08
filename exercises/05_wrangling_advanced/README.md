# Ex5 データ加工（応用）

`python/`（または `r/`）に入ってから実行する。データは `../../../data/` を相対参照する。
Python は Notebook（`.ipynb`）。

## 問題（`python/`）

| ファイル | 内容 |
|----------|------|
| Must `01_join.ipynb` | left / inner / right / outer merge |
| Must `02_pivot.ipynb` | melt / pivot |
| Stretch `03_image_array.ipynb` | `../../../data/4.2.07.tiff` を Pillow + NumPy で扱う |

```bash
cd exercises/05_wrangling_advanced/python
uv run jupyter execute 01_join.ipynb
uv run jupyter execute 02_pivot.ipynb
```

正解は `solutions/`。対訳は `r/`（画像 Stretch は Python のみ）。
