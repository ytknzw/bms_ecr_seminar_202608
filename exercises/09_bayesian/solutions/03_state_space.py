"""【正解】Stretch: 状態空間（種別・年次平均Body_Mass）

種混合の年次平均ではなく、Species_short × yearのパネルで
種ごとのローカルレベル（共有のsigma）を推定する。

ノートブック表示の代わりに、図は都度 Plotly で PNG を out/ に書き出します
（graphviz モデル図のみ Graphviz PNG）。
"""
from pathlib import Path

import arviz as az
import numpy as np
import pandas as pd
import plotly.graph_objects as go
import pymc as pm

OUT = Path("out")
OUT.mkdir(parents=True, exist_ok=True)

SEED = 123

df = pd.read_parquet("../../../data/penguins.parquet")

df = df.dropna(subset=["Date_Egg", "Body_Mass", "Species_short"])
panel = (
    df.assign(year=lambda d: d["Date_Egg"].dt.year)
    .groupby(["Species_short", "year"], observed=True)["Body_Mass"]
    .mean()
    .reset_index()
    .sort_values(["Species_short", "year"])
)
panel["species_idx"], species_levels = pd.factorize(panel["Species_short"].astype(str))
# nutpie rejects np.int32 coord labels; use plain Python ints
years = sorted(int(y) for y in panel["year"].unique())
panel["time_idx"] = panel["year"].map({y: i for i, y in enumerate(years)})
n_species = len(species_levels)
T = len(years)
y = panel["Body_Mass"].to_numpy()

coords = {
    "species": list(species_levels),
    "time": years,
    "obs": np.arange(len(panel)),
}

with pm.Model(coords=coords) as model:
    sigma_level = pm.HalfNormal("sigma_level", 100)
    sigma_obs = pm.HalfNormal("sigma_obs", 200)
    # 種ごとの初期水準（固定効果に近い役割）
    mu0 = pm.Normal("mu0", 4000, 500, dims="species")

    innov = pm.Normal("innov", 0, 1, dims=("species", "time"))
    level = pm.Deterministic(
        "level",
        mu0[:, None] + pm.math.cumsum(innov, axis=1) * sigma_level,
        dims=("species", "time"),
    )
    mu_obs = level[panel["species_idx"].to_numpy(), panel["time_idx"].to_numpy()]
    pm.Normal("y", mu=mu_obs, sigma=sigma_obs, observed=y, dims="obs")

    graph = pm.model_to_graphviz(model)
    graph_path = OUT / "state_space_graph"
    graph.render(str(graph_path), format="png", cleanup=True)
    print("wrote model graph:", graph_path.with_suffix(".png"))

    idata = pm.sample(
        draws=400,
        tune=400,
        chains=4,
        target_accept=0.95,
        random_seed=SEED,
        progressbar=True,
    )

summary = az.summary(idata, var_names=["sigma_level", "sigma_obs", "mu0"], round_to=2)
print(f"{summary=}")
max_rhat = float(summary["r_hat"].max())
if max_rhat > 1.05:
    print(
        f"NOTE: {max_rhat=:.3f} (>1.05). "
        "デモ設定のため不安定なことがあります。講師デモを参照して構いません。"
    )
else:
    print(f"R-hat OK ({max_rhat=:.3f})")
print(f"{list(species_levels)=}, {years=}, {len(panel)=}, {n_species=}, {T=}")

# 推定結果の可視化: 種別 level の事後平均・94% 区間と観測平均（Plotly）
level_da = idata.posterior["level"]  # chain, draw, species, time
level_mean = level_da.mean(dim=("chain", "draw"))
level_lo = level_da.quantile(0.03, dim=("chain", "draw"))
level_hi = level_da.quantile(0.97, dim=("chain", "draw"))
year_x = np.asarray(years, dtype=float)

colors = ["#0072B2", "#E69F00", "#009E73"]  # Okabe–Ito 系
fig = go.Figure()
for s_i, sp in enumerate(species_levels):
    means = np.asarray(level_mean.sel(species=sp).values, dtype=float)
    lo = np.asarray(level_lo.sel(species=sp).values, dtype=float)
    hi = np.asarray(level_hi.sel(species=sp).values, dtype=float)
    c = colors[s_i % len(colors)]
    fig.add_trace(
        go.Scatter(
            x=np.concatenate([year_x, year_x[::-1]]),
            y=np.concatenate([hi, lo[::-1]]),
            fill="toself",
            fillcolor=c,
            opacity=0.2,
            line={"width": 0},
            name=f"{sp} 94% interval",
            showlegend=False,
            hoverinfo="skip",
        )
    )
    fig.add_trace(
        go.Scatter(
            x=year_x,
            y=means,
            mode="lines+markers",
            line={"color": c},
            marker={"color": c},
            name=f"{sp} level",
        )
    )
    obs = panel.loc[panel["Species_short"] == sp].sort_values("year")
    fig.add_trace(
        go.Scatter(
            x=obs["year"].to_numpy(dtype=float),
            y=obs["Body_Mass"].to_numpy(dtype=float),
            mode="markers",
            marker={"color": c, "symbol": "x", "size": 10},
            name=f"{sp} observed",
            showlegend=False,
        )
    )
fig.update_layout(
    template="plotly_white",
    title="State-space levels (mean + 94% interval) vs observed yearly means",
    xaxis_title="year",
    yaxis_title="Body_Mass (g)",
)
fig.write_image(OUT / "state_space_levels.png", width=900, height=480, scale=2)
print("wrote level plot:", OUT / "state_space_levels.png")
