"""【問題】（Stretch）標準化後に`PCA(2)`・`KMeans(3)`・`Ridge`の置換重要度を求めてください。
"""
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

# TODO: StandardScalerで標準化
# TODO: PCA(n_components=2, random_state=123)のexplained_variance_ratio_を表示
# TODO: KMeans(n_clusters=3, random_state=123, n_init=10)のクラスターサイズを表示
# TODO: Body_Massを目的にしたRidge + permutation_importance（n_repeats=10, random_state=123）
