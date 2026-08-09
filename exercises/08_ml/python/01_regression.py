"""【問題】`Culmen_Length`と`Flipper_Length`から`Body_Mass`を
`LinearRegression()`で予測し、テストデータのMSEとMAPEを表示してください。
"""
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_percentage_error, mean_squared_error
from sklearn.model_selection import train_test_split

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Culmen_Length", "Flipper_Length", "Body_Mass"]  # 欠損を除去
)

# TODO: 特徴量Xと目的変数yを用意
# TODO: train_test_split（test_size=0.3, random_state=123）
# TODO: LinearRegressionで学習・予測し、MSEとMAPEを表示
