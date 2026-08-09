"""【問題】体重Body_Massをくちばし長Culmen_Lengthとひれ長Flipper_Lengthで説明し、
切片intercept・傾きbeta_culmen / beta_flipperに種差（Adelie / Chinstrap / Gentoo）を入れた階層モデルを推定してください。
（例01_hierarchical_flipper に culmen を追加した拡張）

  y_n ~ Normal(intercept[s] + beta_culmen[s]*culmen_n + beta_flipper[s]*flipper_n, sigma_y)
  intercept[s] ~ Normal(intercept_all, sigma_intercept)
  beta_culmen[s] ~ Normal(beta_culmen_all, sigma_culmen)
  beta_flipper[s] ~ Normal(beta_flipper_all, sigma_flipper)

ノートブックと同じ手順で実装してください（random_seed=123）。
スクリプト版ではノートブックの表示箇所で、都度 Plotly 図を out/ に PNG 保存してください
（forest / posterior / trace_dist は intercept と slopes の2枚ずつ。graphviz は Graphviz PNG）。
"""
from pathlib import Path

import arviz as az
import arviz_plots as azp
import numpy as np
import pandas as pd
import pymc as pm
from arviz_plots import plot_trace_dist

OUT = Path("out")
OUT.mkdir(parents=True, exist_ok=True)

azp.style.use("arviz-variat")
SEED = 123

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Body_Mass", "Culmen_Length", "Flipper_Length", "Species_short"]
)

# TODO: factorize Species_short、culmen / flipper / species_idx と coords
# TODO: PyMC階層モデル、model_to_graphviz → OUT/hierarchical_graph.png、sample(random_seed=SEED)
# TODO: ハイパーパラメータの az.summary と R-hat
# TODO: intercept / beta_culmen / beta_flipper の kind="all_median", ci_prob=0.94 と種ごとの回帰式
# TODO: az.plot_forest(..., backend="plotly") → pc.viz["figure"].values.item().write_image(...)
# TODO: az.plot_dist(..., backend="plotly", ci_prob=0.94) → write_image
# TODO: plot_trace_dist(..., backend="plotly") → write_image
