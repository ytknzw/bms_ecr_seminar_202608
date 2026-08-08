# 演習スクリプト一覧

- **参加者の当日実行は Python のみ**。各コマの **`python/` に入ってから**実行する（データは `../../../data/` を相対参照）
- **Ex4（00以外）・Ex5・Ex6・Ex7** は Jupyter ノートブック（`.ipynb` → `uv run jupyter execute ...`）。それ以外は `.py`
- 各コマの構成:
  - **`python/`** … **問題**（スターター。スライドの簡易サンプルを発展させて実装）
  - **`solutions/`** … **正解**
  - **`r/`**（および Ex9 の `.stan`）… **対訳**（当日は実行しない。内容は `solutions/` と対応）
- 主データ: `data/penguins.parquet`（Rdatasets `penguins_raw.csv` を Ex4 の `00_fetch_penguins` で整形／同梱。以降の Ex で使用）
- メンテ時の R 一括確認: `Rscript env/verify_r.R`
- 各コマ: **Must** を全員で。**Stretch** は余力があるとき

## Must / Stretch

| Ex | Must（`python/`） | Stretch | 対訳（読む） |
|----|-------------------|---------|--------------|
| 1 | 演習スクリプトなし（[env/SETUP.md](../env/SETUP.md) + `env/check_packages.py`） | 推奨パッケージも OK | （なし） |
| 2 | `01_objects`, `02_control_flow`, `03_collections`, `04_functions` | `05_io`（with + pathlib） | 同名の `.R` |
| 3 | `01_classes`, `02_logging` | `check_score` + `03_test_check_score` | `01_s3_class.R` 等 |
| 4 | `00_fetch_penguins.py`（例）／`01_read_describe`・`02_groupby`・`03_duplicates`（`.ipynb`） | `04_numpy`（`.ipynb`） | `01_read_describe.R` 等 |
| 5 | `01_join`・`02_pivot`（`.ipynb`） | `03_image_array`（`.ipynb`） | 同名の `.R`（画像は Python のみ） |
| 6 | `01_scatter.ipynb`〜`05_box.ipynb`（散布・ヒストに種ファセット含む） | （なし） | ggplotの対訳 |
| 7 | `01_anscombe`・`02_describe`・`03_tests_regression`（`.ipynb`） | `04_distributions`（`.ipynb`） | 同名の `.R` |
| 8 | `01_regression` / `02_classification`（LinearRegression / kNN） | `04_lightgbm`、`03_unsupervised_explain` | `.R` |
| 9 | `00_glm_flipper.py`・`01_hierarchical_flipper.py`（例）／`02_hierarchical_culmen_flipper.py`（Must） | `03_state_space.py` | Stan + `.R` |

Ex9 の `model_to_graphviz` は OS の Graphviz（`dot`）が必要（Windows 11: winget / macOS: Homebrew）。[env/SETUP.md](../env/SETUP.md) §2.4。

## 実行例

```bash
cd exercises/04_wrangling_basics/python
uv run python 00_fetch_penguins.py          # 例（実装済み・スクリプト）
uv run jupyter execute 01_read_describe.ipynb
uv run jupyter execute 03_duplicates.ipynb
```

パスエラーが出るときは、カレントディレクトリーが各コマの `python/`（または `r/`）かを確認してください。
