"""【問題】（Stretch）`LightGBM`で回帰（R2）と分類（accuracy + CV）を行ってください。
特徴例: `Culmen_Length` / `Culmen_Depth` / `Flipper_Length` / `Island` → `Body_Mass` / `Species_short`
"""
import pandas as pd
from lightgbm import LGBMClassifier, LGBMRegressor
from sklearn.compose import ColumnTransformer
from sklearn.metrics import accuracy_score, r2_score
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Body_Mass", "Culmen_Length", "Culmen_Depth", "Flipper_Length", "Island", "Species_short"]  # 欠損を除去
)

features = ["Culmen_Length", "Culmen_Depth", "Flipper_Length", "Island"]
X = df.loc[:, features]
y_reg = df.loc[:, "Body_Mass"]
y_cls = df.loc[:, "Species_short"].astype(str)

pre = ColumnTransformer(
    [
        ("num", "passthrough", ["Culmen_Length", "Culmen_Depth", "Flipper_Length"]),
        ("cat", OneHotEncoder(handle_unknown="ignore"), ["Island"]),
    ]
)

# TODO: LGBMRegressor（n_estimators=50, learning_rate=0.1, random_state=123）をPipelineで学習しR2を表示（test_size=0.25）
# TODO: LGBMClassifierで同様に学習し、accuracyと5-fold CV（accuracy）の平均・標準偏差を表示（stratify=y_cls）
