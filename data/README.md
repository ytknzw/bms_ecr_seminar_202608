# データファイル一覧

- `penguins_raw.csv` … Palmer Penguins の raw（Ex4 `00_fetch_penguins.py` の入力）
  - 出典: [Rdatasets](https://vincentarelbundock.github.io/Rdatasets/articles/data.html) — Package = `datasets`（※ `dataset` ではない）、Item = `penguins_raw (penguins)`
  - CSV: https://vincentarelbundock.github.io/Rdatasets/csv/datasets/penguins_raw.csv
  - seaborn / palmerpenguins パッケージ経由ではなく、上記 CSV を `data/` に置く
- `penguins.parquet` / `penguins.csv` … Ex4 以降の主データ（整形済み）
  - Ex4 の `00_fetch_penguins.py`（実装済み・実行用）が `penguins_raw.csv` を読み、列の選択・リネーム・`Species_short` 追加のうえ書き出す
  - 列名は講座用（`Culmen_Length` 等）。R の `palmerpenguins`（`bill_length_mm` 等）や Rdatasets の簡略版 `penguins` とは異なる
- `anscombe.csv` … Anscombe's quartet（Ex7 Must；ワイド形式のまま同梱）
  - 出典: [Rdatasets](https://vincentarelbundock.github.io/Rdatasets/articles/data.html) — Package = `datasets`、Item = `anscombe`
  - CSV: https://vincentarelbundock.github.io/Rdatasets/csv/datasets/anscombe.csv
  - seaborn / statsmodels 経由ではなく、上記 CSV を `data/` に置く
  - 列はワイド（`x1`–`x4`, `y1`–`y4`）。縦持ちへの整形は演習側で行う
- `4.2.07.tiff` … 画像配列演習（Ex5 Stretch；USC SIPI / ハンドブック第8章と同ファイル）
実行時に生成されるもの（gitignore）:

- `exercises/**/out/` … 図・一時ファイル
