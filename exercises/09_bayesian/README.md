# Ex9 ベイズ統計

## 問題（`python/`）

| ファイル | 内容 |
|----------|------|
| 例 `00_glm_flipper.ipynb` | **完成例**（スライドで読む・実行可）。種を混ぜた体重〜ひれの単回帰 |
| 例 `01_hierarchical_flipper.ipynb` | **完成例**（スライドで読む・実行可）。体重〜ひれの階層回帰 |
| Must `02_hierarchical_culmen_flipper.ipynb` | 体重〜くちばし・ひれ（例に culmen を追加して自分で実装） |
| Stretch `03_state_space.ipynb` | 種別×年次の状態空間 + graphviz + level 図 |

`model_to_graphviz` には Python の `graphviz` パッケージ（`uv sync`）と、OS に Graphviz（`dot`）が必要です。参加要件の OS ごとの入れ方は [env/SETUP.md](../../env/SETUP.md) §4.5 を参照。

| OS | コマンド |
|----|----------|
| Windows 11（64-bit） | `winget install --id Graphviz.Graphviz -e` → ターミナル再起動 → `dot -V` |
| macOS Sonoma 以上（Apple Silicon） | `brew install graphviz` → `dot -V` |

```bash
cd exercises/09_bayesian/python
# 例（スライド説明用・完成済み）
uv run jupyter execute 00_glm_flipper.ipynb
uv run jupyter execute 01_hierarchical_flipper.ipynb
# Must
uv run jupyter execute 02_hierarchical_culmen_flipper.ipynb
```

00 / 01 はスライド説明用の完成例（そのままでよい）。Must は 02。Stretch の正解は `solutions/*.ipynb`。対訳は `r/`（`00_glm_flipper.R` / `glm_flipper.stan` など）。

同内容の `.py` も残してあります（レガシー／代替）。当日の主経路は Notebook です。

- Notebook: 図はセル内表示（`fig.show()` / `pc.show()` / `display(graph)`）。`out/` は書きません。
- `.py`: 同じ解析ロジックで、図の表示箇所ごとに Plotly（または ArviZ `backend="plotly"`）で PNG を `out/` に保存します（要 kaleido）。graphviz モデル図のみ Graphviz の PNG です。

```bash
cd exercises/09_bayesian/python
uv run python 00_glm_flipper.py   # → python/out/*.png
uv run python 01_hierarchical_flipper.py
```
