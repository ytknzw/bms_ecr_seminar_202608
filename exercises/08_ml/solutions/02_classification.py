"""正解 — Must 02 — 分類（k近傍法: 形態 → Species_short）"""
import pandas as pd
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier

df = pd.read_parquet("../../../data/penguins.parquet").dropna(
    subset=["Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass", "Species_short"]  # 欠損を除去
)

X = df.loc[:, ["Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass"]]
y = df.loc[:, "Species_short"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=123
)

model_cls = KNeighborsClassifier()
model_cls.fit(X_train, y_train)
y_predicted = model_cls.predict(X_test)

print(f"{accuracy_score(y_test, y_predicted)=}")
print(f"{classification_report(y_test, y_predicted)=}")
