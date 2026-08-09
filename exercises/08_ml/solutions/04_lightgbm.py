"""正解 — Stretch 04 — LightGBM（penguins）"""
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

X_train, X_test, y_train, y_test = train_test_split(
    X, y_reg, test_size=0.25, random_state=123
)
lgbm_reg = Pipeline(
    [
        ("pre", pre),
        ("model", LGBMRegressor(n_estimators=50, learning_rate=0.1, random_state=123, verbose=-1)),
    ]
)
lgbm_reg.fit(X_train, y_train)
y_predicted = lgbm_reg.predict(X_test)
print(f"{r2_score(y_test, y_predicted)=}")

Xc_train, Xc_test, yc_train, yc_test = train_test_split(
    X, y_cls, test_size=0.25, random_state=123, stratify=y_cls
)
lgbm_cls = Pipeline(
    [
        ("pre", pre),
        (
            "model",
            LGBMClassifier(n_estimators=50, learning_rate=0.1, random_state=123, verbose=-1),
        ),
    ]
)
lgbm_cls.fit(Xc_train, yc_train)
yc_predicted = lgbm_cls.predict(Xc_test)
print(f"{accuracy_score(yc_test, yc_predicted)=}")

cv = cross_val_score(lgbm_cls, X, y_cls, cv=5, scoring="accuracy")
print(f"{cv.mean()=}, {cv.std()=}")
