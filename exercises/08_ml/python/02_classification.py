"""【問題】`Culmen_Length` / `Culmen_Depth` / `Flipper_Length` / `Body_Mass`から
`Species_short`を`KNeighborsClassifier()`で予測し、
テストデータのaccuracyとclassification_reportを表示してください。
"""
import pandas as pd
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass", "Species_short"]  # 欠損を除去
)

# TODO: 特徴量Xと目的変数yを用意
# TODO: train_test_split（test_size=0.3, random_state=123）
# TODO: KNeighborsClassifierで学習・予測し、accuracyとclassification_reportを表示
