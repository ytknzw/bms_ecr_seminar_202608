"""正解 — Must 01 — 線形回帰（Culmen + Flipper → Body_Mass）"""
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_percentage_error, mean_squared_error
from sklearn.model_selection import train_test_split

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Culmen_Length", "Flipper_Length", "Body_Mass"]  # 欠損を除去
)

X = df.loc[:, ["Culmen_Length", "Flipper_Length"]]
y = df.loc[:, "Body_Mass"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=123
)

model_reg = LinearRegression()
model_reg.fit(X_train, y_train)
y_predicted = model_reg.predict(X_test)

print(f"{mean_squared_error(y_test, y_predicted)=}")
print(f"{mean_absolute_percentage_error(y_test, y_predicted)=}")
