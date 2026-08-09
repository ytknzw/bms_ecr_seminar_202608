# Ex7 統計解析

`python/`（または `r/`）に入ってから実行する。データは `../../../data/` を相対参照する。
Python は Notebook（`.ipynb`）。

## 問題（`python/`）

| ファイル | 内容 |
|----------|------|
| Must `01_anscombe.ipynb` | Anscombe: ワイド→縦持ち + Plotly + 平均・分散・相関 |
| Must `02_describe.ipynb` | 要約統計・分位点・欠測 |
| Must `03_tests_regression.ipynb` | Welch t + OLS |
| Stretch `04_distributions.ipynb` | 平均・標準偏差・種ごと分位点・IQR・|z|>3外れ値 |

```bash
cd exercises/07_stats/python
uv run jupyter execute 01_anscombe.ipynb
uv run jupyter execute 02_describe.ipynb
uv run jupyter execute 03_tests_regression.ipynb
```

正解は `solutions/`。対訳は `r/`。
