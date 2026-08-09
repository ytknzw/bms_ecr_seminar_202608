"""正解 — Stretch 03 — PCA・クラスタリング・置換重要度（penguins）"""
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.inspection import permutation_importance
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

df = pd.read_parquet("../../../data/penguins.parquet")
cols = ["Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass"]
X = df.loc[:, cols].dropna()  # 欠損を除去

scaler = StandardScaler()
Xs = scaler.fit_transform(X)

pca = PCA(n_components=2, random_state=123)
Z = pca.fit_transform(Xs)
print(f"{pca.explained_variance_ratio_.round(3)=}")

km = KMeans(n_clusters=3, random_state=123, n_init=10)
labels = km.fit_predict(Xs)
print(f"{pd.Series(labels).value_counts().sort_index().to_dict()=}")

y = X.loc[:, "Body_Mass"]
Xp = X.drop(columns=["Body_Mass"])
X_train, X_test, y_train, y_test = train_test_split(
    Xp, y, test_size=0.25, random_state=123
)
model = Ridge().fit(X_train, y_train)
imp = permutation_importance(model, X_test, y_test, n_repeats=10, random_state=123)
order = imp.importances_mean.argsort()[::-1]
feat = list(Xp.columns)
print("permutation importance:")
for i in order:
    print(f"{feat[i]=}, {imp.importances_mean[i]=:.3f}")

print("\nMLOpsメモ: 学習コード・データ版・評価指標をセットで残す（再現性）")
