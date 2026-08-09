"""【例】体重Body_Massをひれ長Flipper_Lengthで説明し、
切片intercept・傾きbeta_flipperに種差（Adelie / Chinstrap / Gentoo）を入れた階層モデル。

  y_n ~ Normal(intercept[s] + beta_flipper[s]*flipper_n, sigma_y)
  intercept[s] ~ Normal(intercept_all, sigma_intercept)
  beta_flipper[s] ~ Normal(beta_flipper_all, sigma_flipper)

スライドで読む完成例。実行してmodel_to_graphviz・forest・posterior・trace_dist・
種ごとの事後回帰（中央値と94% ETI）と、事後中央値・94% ETI・種ごとの回帰式を確認してください。

ノートブック表示の代わりに、図は都度 Plotly で PNG を out/ に書き出します
（graphviz モデル図のみ Graphviz PNG）。
"""
from pathlib import Path

import arviz as az
import arviz_plots as azp
import numpy as np
import pandas as pd
import plotly.express as px
import pymc as pm
from arviz_base import from_dict
from arviz_plots import plot_trace_dist

OUT = Path("out")
OUT.mkdir(parents=True, exist_ok=True)

azp.style.use("arviz-variat")

SPECIES_ORDER = ["Adelie", "Chinstrap", "Gentoo"]
SEED = 123

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Body_Mass", "Flipper_Length", "Species_short"]
)
df["species_idx"], species_levels = pd.factorize(df["Species_short"].astype(str))
flipper = df["Flipper_Length"].to_numpy()
body_mass = df["Body_Mass"].to_numpy()
species_idx = df["species_idx"].to_numpy()

coords = {
    "species": list(species_levels),
    "obs": np.arange(len(df)),
}

with pm.Model(coords=coords) as model:
    intercept_all = pm.Normal("intercept_all", 0, 5000)
    beta_flipper_all = pm.Normal("beta_flipper_all", 0, 20)

    sigma_intercept = pm.HalfNormal("sigma_intercept", 1000)
    sigma_flipper = pm.HalfNormal("sigma_flipper", 10)

    intercept = pm.Normal("intercept", intercept_all, sigma_intercept, dims="species")
    beta_flipper = pm.Normal(
        "beta_flipper", beta_flipper_all, sigma_flipper, dims="species"
    )

    mu_n = intercept[species_idx] + beta_flipper[species_idx] * flipper
    sigma_y = pm.HalfNormal("sigma_y", 400)
    pm.Normal("y", mu=mu_n, sigma=sigma_y, observed=body_mass, dims="obs")

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
    pm.sample_posterior_predictive(
        idata, extend_inferencedata=True, random_seed=SEED, progressbar=False
    )

summary = az.summary(
    idata,
    var_names=[
        "intercept_all",
        "beta_flipper_all",
        "sigma_intercept",
        "sigma_flipper",
        "sigma_y",
    ],
    round_to=2,
)
print(f"{summary=}")
print(f"{float(summary['r_hat'].max())=:.3f}")
print(f"{int(idata.sample_stats['diverging'].sum())=}")
print(f"{list(species_levels)=}, {len(df)=}")

coef_summary = az.summary(
    idata,
    var_names=["intercept", "beta_flipper"],
    kind="all_median",
    ci_prob=0.94,
    round_to=1,
)
print("coefficients (posterior median + 94% ETI):")
print(f"{coef_summary=}")

print("Body_Mass ≈ intercept + beta_flipper·Flipper")
for sp in species_levels:
    intercept_m = float(idata.posterior["intercept"].sel(species=sp).median())
    flipper_m = float(idata.posterior["beta_flipper"].sel(species=sp).median())
    print(f"  {sp}: {intercept_m:.1f} + {flipper_m:.1f}·Flipper")

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
    var_names=["beta_flipper"],
    combined=True,
    backend="plotly",
)
pc.add_title("Posterior: species-specific slope (flipper)")
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "hierarchical_forest_slopes.png", width=900, height=360, scale=2)
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
    var_names=["beta_flipper"],
    ci_prob=0.94,
    backend="plotly",
)
fig = pc.viz["figure"].values.item()
fig.write_image(OUT / "hierarchical_posterior_slopes.png", width=900, height=360, scale=2)
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
    idata, var_names=["beta_flipper"], backend="plotly", compact=True
)
fig = pc.viz["figure"].values.item()
fig.write_image(
    OUT / "hierarchical_trace_dist_slopes.png", width=1000, height=480, scale=2
)
print("wrote", OUT / "hierarchical_trace_dist_slopes.png")

# --- 種ごとの회귀선 ---
fig = px.scatter(
    df,
    x="Flipper_Length",
    y="Body_Mass",
    color="Species_short",
    symbol="Species_short",
    category_orders={"Species_short": SPECIES_ORDER},
    color_discrete_sequence=px.colors.qualitative.Dark2,
    opacity=0.7,
    title="Posterior regression by species (px.scatter + plot_lm)",
    labels={
        "Flipper_Length": "Flipper_Length (mm)",
        "Body_Mass": "Body_Mass (g)",
        "Species_short": "Species",
    },
)
fig.update_traces(marker={"size": 9})
fig.update_layout(template="plotly_white")

for sp, color in zip(SPECIES_ORDER, px.colors.qualitative.Dark2):
    if sp not in set(species_levels):
        continue
    mask = df["Species_short"].to_numpy() == sp
    idx = np.flatnonzero(mask)
    dt_sp = from_dict(
        {
            "posterior_predictive": {
                "y": idata.posterior_predictive["y"].isel(obs=idx).values
            },
            "observed_data": {"y": body_mass[mask]},
            "constant_data": {"flipper": flipper[mask]},
        },
        dims={"y": ["obs"], "flipper": ["obs"]},
        coords={"obs": idx},
    )
    pc = azp.plot_lm(
        dt_sp,
        x="flipper",
        y="y",
        backend="plotly",
        point_estimate="median",
        ci_prob=0.94,
        smooth=True,
        visuals={
            "observed_scatter": False,
            "pe_line": {"color": color, "width": 6},
            "ci_band": {"color": color, "alpha": 0.1},
        },
    )
    for tr in pc.get_viz("plot", "flipper").figure.data:
        fig.add_trace(tr)

fig.write_image(OUT / "hierarchical_lines.png", width=900, height=560, scale=2)
print("wrote", OUT / "hierarchical_lines.png")
