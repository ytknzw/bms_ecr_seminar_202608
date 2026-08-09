"""【例】体重Body_Massをひれ長Flipper_Lengthで説明するベイズ単回帰（PyMCの基本）。

  y ~ Normal(intercept + beta_flipper * flipper, sigma)

出典の流れ: PyMC GLM linear regressionチュートリアルをペンギンデータに置き換えたもの。
スライド説明用の完成例。実行して散布図・事後・回帰線（中央値と94% ETI）を確認してください。
種は点の色・形で区別（モデル自体は種を混ぜたプール単回帰）。

ノートブック表示の代わりに、図は都度 Plotly で PNG を out/ に書き出します。
"""
from pathlib import Path

import arviz as az
import arviz_plots as azp
import numpy as np
import pandas as pd
import plotly.express as px
import pymc as pm

OUT = Path("out")
OUT.mkdir(parents=True, exist_ok=True)

SPECIES_ORDER = ["Adelie", "Chinstrap", "Gentoo"]
SEED = 123

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Body_Mass", "Flipper_Length", "Species_short"]
)
flipper = df["Flipper_Length"].to_numpy()
body_mass = df["Body_Mass"].to_numpy()
coords = {"obs": np.arange(len(df))}

# --- 散布図 ---
fig = px.scatter(
    df,
    x="Flipper_Length",
    y="Body_Mass",
    color="Species_short",
    symbol="Species_short",
    category_orders={"Species_short": SPECIES_ORDER},
    color_discrete_sequence=px.colors.qualitative.Dark2,
    opacity=0.7,
    title="Penguins: Body_Mass ~ Flipper_Length (by species)",
    labels={
        "Flipper_Length": "Flipper_Length (mm)",
        "Body_Mass": "Body_Mass (g)",
        "Species_short": "Species",
    },
)
fig.update_traces(marker={"size": 9})
fig.update_layout(template="plotly_white")
fig.write_image(OUT / "glm_scatter.png", width=900, height=560, scale=2)
print("wrote", OUT / "glm_scatter.png")

# --- モデルとサンプリング ---
with pm.Model(coords=coords) as model:
    flipper_data = pm.Data("flipper", flipper, dims="obs")
    intercept = pm.Normal("intercept", 0, 5000)
    beta_flipper = pm.Normal("beta_flipper", 0, 20)
    sigma = pm.HalfNormal("sigma", 400)
    mu = intercept + beta_flipper * flipper_data
    pm.Normal("y", mu=mu, sigma=sigma, observed=body_mass, dims="obs")
    idata = pm.sample(
        draws=500,
        tune=500,
        chains=4,
        target_accept=0.95,
        random_seed=SEED,
        progressbar=True,
    )
    pm.sample_posterior_predictive(
        idata, extend_inferencedata=True, random_seed=SEED, progressbar=False
    )

# --- 要約と診断 ---
var_names = ["intercept", "beta_flipper", "sigma"]
summary = az.summary(idata, var_names=var_names, round_to=2)
print(f"{summary=}")
print(f"{float(summary['r_hat'].max())=:.3f}")
print(f"{int(idata.sample_stats['diverging'].sum())=}")

# --- 事後分布（ArviZ plot_dist → Plotly PNG） ---
pc = az.plot_dist(
    idata,
    var_names=var_names,
    ci_prob=0.94,
    backend="plotly",
)
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "glm_posterior.png", width=1000, height=360, scale=2)
print("wrote", OUT / "glm_posterior.png")

# --- 回帰線（px.scatter + plot_lm） ---
fig = px.scatter(
    df,
    x="Flipper_Length",
    y="Body_Mass",
    color="Species_short",
    symbol="Species_short",
    category_orders={"Species_short": SPECIES_ORDER},
    color_discrete_sequence=px.colors.qualitative.Dark2,
    opacity=0.7,
    title="Pooled posterior regression (px.scatter + plot_lm)",
    labels={
        "Flipper_Length": "Flipper_Length (mm)",
        "Body_Mass": "Body_Mass (g)",
        "Species_short": "Species",
    },
)
fig.update_traces(marker={"size": 9})
fig.update_layout(template="plotly_white")

pc = azp.plot_lm(
    idata,
    x="flipper",
    y="y",
    backend="plotly",
    point_estimate="median",
    ci_prob=0.94,
    smooth=True,
    visuals={
        "observed_scatter": False,
        "pe_line": {"width": 6},
        "ci_band": {"alpha": 0.1},
    },
)
for tr in pc.get_viz("plot", "flipper").figure.data:
    fig.add_trace(tr)

fig.write_image(OUT / "glm_lines.png", width=900, height=560, scale=2)
print("wrote", OUT / "glm_lines.png")

med_i = float(idata.posterior["intercept"].median())
med_b = float(idata.posterior["beta_flipper"].median())
print(f"median equation: Body_Mass ≈ {med_i:.0f} + {med_b:.1f}·Flipper")
