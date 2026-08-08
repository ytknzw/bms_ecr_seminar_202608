"""【例】Rdatasetsのpenguins_raw CSVを読み、前処理して
../../../data/penguins.parquetに保存する（実装済み・実行用）。

python/ に入って実行してください:
  uv run python 00_fetch_penguins.py

データ取得手順:
  1. https://vincentarelbundock.github.io/Rdatasets/articles/data.html
  2. penguinsを検索し、Package = datasetsの行を選ぶ
  3. Item = penguins_raw (penguins) のCSVを../../../data/penguins_raw.csvに置く
     （直リンク: https://vincentarelbundock.github.io/Rdatasets/csv/datasets/penguins_raw.csv）

rawにはstudyName等の余分な列がある。講座で使う列だけ選び、
Culmen Length (mm) → Culmen_Lengthのようにリネームし、Species_shortを追加する。
"""
from pathlib import Path

import pandas as pd


def main() -> None:
    Path("../../../data").mkdir(parents=True, exist_ok=True)
    df = pd.read_csv(
        "../../../data/penguins_raw.csv",
        usecols=[
            "Species",
            "Island",
            "Individual ID",
            "Date Egg",
            "Culmen Length (mm)",
            "Culmen Depth (mm)",
            "Flipper Length (mm)",
            "Body Mass (g)",
            "Sex",
            "Comments",
        ],
    ).rename(
        columns={
            "Individual ID": "Individual_ID",
            "Date Egg": "Date_Egg",
            "Culmen Length (mm)": "Culmen_Length",
            "Culmen Depth (mm)": "Culmen_Depth",
            "Flipper Length (mm)": "Flipper_Length",
            "Body Mass (g)": "Body_Mass",
        }
    )
    df["Date_Egg"] = pd.to_datetime(df.loc[:, "Date_Egg"], format="%Y-%m-%d")
    df["Species"] = df.loc[:, "Species"].astype("category")
    df["Island"] = df.loc[:, "Island"].astype("category")
    df["Sex"] = df.loc[:, "Sex"].astype("category")
    df["Species_short"] = (
        df.loc[:, "Species"].str.extract(r"^(\w+)", expand=False).astype("category")
    )
    df.to_parquet("../../../data/penguins.parquet")
    df.to_csv("../../../data/penguins.csv", index=False)
    print(f"{df.shape=}")
    print(f"{list(df['Species_short'].cat.categories)=}")


if __name__ == "__main__":
    main()
