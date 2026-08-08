# Ex6 データ可視化

ハンドブック第5章03（定性的評価／可視化）の表5-5に対応。Plotly のみ（Must）。Stretch なし。

`python/` に入ってから実行する。データは `../../../data/` を相対参照する。

## 問題（`python/`）

| ファイル | 内容 |
|----------|------|
| Must `01_scatter.ipynb` | 散布図（Dark2 + symbol）＋種でファセット |
| Must `02_line.ipynb` | 折れ線（年平均体重） |
| Must `03_bar.ipynb` | 棒（島×種） |
| Must `04_histogram.ipynb` | ヒストグラム＋種でファセット |
| Must `05_box.ipynb` | 箱ひげ図 |

```bash
cd exercises/06_visualisation/python
uv run jupyter execute 01_scatter.ipynb
# … 02_line … 05_box も同様
```

正解は `solutions/*.ipynb`。対訳は `r/`（同番号）。
