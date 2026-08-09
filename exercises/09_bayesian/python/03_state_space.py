"""【問題】（Stretch）Species_short × yearの平均Body_Massパネルで、
種ごとのローカルレベル状態空間をPyMCで推定してください。
あわせてpm.model_to_graphviz(model)でモデル図をPNG保存し、
種別levelの事後平均・区間と観測平均を重ねた図をPlotlyでPNG保存してください。

種混合の年次平均は使わず、種別系列にする。
coords["time"] の年ラベルは Python の int にしてください（nutpie 対策）。
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

# TODO: Species×yearパネル → species_idx / time_idx / coords（years は int）
# TODO: 種別ローカルレベル → model_to_graphviz → OUT/state_space_graph.png → sample(random_seed=SEED)
# TODO: sigma_level / sigma_obs / mu0 の summary と R-hat
# TODO: level の事後平均・94%区間と観測平均を Plotly で重ね、OUT/state_space_levels.png
