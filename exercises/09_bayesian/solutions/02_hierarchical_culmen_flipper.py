"""【正解】体重Body_Massをくちばし長Culmen_Lengthとひれ長Flipper_Lengthで説明し、
切片intercept・傾きbeta_culmen / beta_flipperに種差を入れた階層モデル。
（例01_hierarchical_flipper に culmen を追加した拡張）

ノートブック表示の代わりに、図は都度 Plotly で PNG を out/ に書き出します
（graphviz モデル図のみ Graphviz PNG）。
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

df["species_idx"], species_levels = pd.factorize(df["Species_short"].astype(str))
culmen = df["Culmen_Length"].to_numpy()
flipper = df["Flipper_Length"].to_numpy()
species_idx = df["species_idx"].to_numpy()

coords = {
    "species": list(species_levels),
    "obs": np.arange(len(df)),
}

with pm.Model(coords=coords) as model:
    # くちばし・ひれは mm のままなので、切片は 0 mm への外挿になりうる（弱情報事前）
    intercept_all = pm.Normal("intercept_all", 0, 5000)
    beta_culmen_all = pm.Normal("beta_culmen_all", 0, 50)
    beta_flipper_all = pm.Normal("beta_flipper_all", 0, 20)

    sigma_intercept = pm.HalfNormal("sigma_intercept", 1000)
    sigma_culmen = pm.HalfNormal("sigma_culmen", 30)
    sigma_flipper = pm.HalfNormal("sigma_flipper", 10)

    intercept = pm.Normal("intercept", intercept_all, sigma_intercept, dims="species")
    beta_culmen = pm.Normal("beta_culmen", beta_culmen_all, sigma_culmen, dims="species")
    beta_flipper = pm.Normal(
        "beta_flipper", beta_flipper_all, sigma_flipper, dims="species"
    )

    mu_n = (
        intercept[species_idx]
        + beta_culmen[species_idx] * culmen
        + beta_flipper[species_idx] * flipper
    )
    sigma_y = pm.HalfNormal("sigma_y", 400)
    pm.Normal("y", mu=mu_n, sigma=sigma_y, observed=df["Body_Mass"].to_numpy(), dims="obs")

    graph = pm.model_to_graphviz(model)
    graph_path = OUT / "hierarchical_graph"
    graph.render(str(graph_path), format="png", cleanup=True)
    print("wrote model graph:", graph_path.with_suffix(".png"))

    idata = pm.sample(
        draws=500,
        tune=500,
        chains=4,
        target_accept=0.99,
        random_seed=SEED,
        progressbar=True,
    )

summary = az.summary(
    idata,
    var_names=[
        "intercept_all",
        "beta_culmen_all",
        "beta_flipper_all",
        "sigma_intercept",
        "sigma_culmen",
        "sigma_flipper",
        "sigma_y",
    ],
    round_to=2,
)
print(f"{summary=}")
max_rhat = float(summary["r_hat"].max())
if max_rhat > 1.05:
    print(
        f"NOTE: {max_rhat=:.3f} (>1.05). "
        "デモ設定のため不安定なことがあります。講師デモを参照して構いません。"
    )
else:
    print(f"R-hat OK ({max_rhat=:.3f})")
print(f"{list(species_levels)=}, {len(df)=}")

coef_summary = az.summary(
    idata,
    var_names=["intercept", "beta_culmen", "beta_flipper"],
    kind="all_median",
    ci_prob=0.94,
    round_to=1,
)
print("\ncoefficients (posterior median + 94% ETI):")
print(f"{coef_summary=}")

print("\nspecies regression (posterior median):")
print("Body_Mass ≈ intercept + beta_culmen·Culmen + beta_flipper·Flipper")
for sp in species_levels:
    intercept_m = float(idata.posterior["intercept"].sel(species=sp).median())
    culmen_m = float(idata.posterior["beta_culmen"].sel(species=sp).median())
    flipper_m = float(idata.posterior["beta_flipper"].sel(species=sp).median())
    print(f"  {sp}: {intercept_m:.0f} + {culmen_m:.1f}·Culmen + {flipper_m:.1f}·Flipper")

# --- forest ---
pc = az.plot_forest(
    idata,
    var_names=["intercept"],
    combined=True,
    backend="plotly",
)
pc.add_title("Posterior: species-specific intercept")
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "hierarchical_forest_intercept.png", width=900, height=360, scale=2)
print("wrote", OUT / "hierarchical_forest_intercept.png")

pc = az.plot_forest(
    idata,
    var_names=["beta_culmen", "beta_flipper"],
    combined=True,
    backend="plotly",
)
pc.add_title("Posterior: species-specific slopes (culmen, flipper)")
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "hierarchical_forest_slopes.png", width=900, height=480, scale=2)
print("wrote", OUT / "hierarchical_forest_slopes.png")

# --- 事後分布 ---
pc = az.plot_dist(
    idata,
    var_names=["intercept"],
    ci_prob=0.94,
    backend="plotly",
)
fig = pc.viz["figure"].values.item()
fig.write_image(
    OUT / "hierarchical_posterior_intercept.png", width=900, height=360, scale=2
)
print("wrote", OUT / "hierarchical_posterior_intercept.png")

pc = az.plot_dist(
    idata,
    var_names=["beta_culmen", "beta_flipper"],
    ci_prob=0.94,
    backend="plotly",
)
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "hierarchical_posterior_slopes.png", width=900, height=480, scale=2)
print("wrote", OUT / "hierarchical_posterior_slopes.png")

# --- trace_dist ---
pc = plot_trace_dist(
    idata, var_names=["intercept"], backend="plotly", compact=True
)
fig = pc.viz["figure"].values.item()
fig.write_image(
    OUT / "hierarchical_trace_dist_intercept.png", width=1000, height=480, scale=2
)
print("wrote", OUT / "hierarchical_trace_dist_intercept.png")

pc = plot_trace_dist(
    idata,
    var_names=["beta_culmen", "beta_flipper"],
    backend="plotly",
    compact=True,
)
fig = pc.viz["figure"].values.item()
fig.write_image(
    OUT / "hierarchical_trace_dist_slopes.png", width=1000, height=560, scale=2
)
print("wrote", OUT / "hierarchical_trace_dist_slopes.png")
