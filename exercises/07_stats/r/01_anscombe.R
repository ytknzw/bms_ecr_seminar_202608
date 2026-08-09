# 対訳 — Must 01 — Anscombe
# Anscombeの数値例を描き、データセットごとの平均・分散・相関係数を表示してください。
# r/ に入って実行: Rscript 01_anscombe.R
# データ: ../../../data/anscombe.csv（Rdatasets Package=datasets; ワイド x1,y1…）
library(dplyr)
library(tidyr)
library(ggplot2)

df_org <- read.csv("../../../data/anscombe.csv")
print(dim(df_org))
print(head(df_org, 10))
print(table(df_org$rownames))

df <- df_org |>
  select(-any_of("rownames")) |>
  pivot_longer(
    everything(),
    names_to = c(".value", "dataset"),
    names_pattern = "([xy])(\\d)"
  )

print("--- mean / var by dataset ---")
df |>
  group_by(dataset) |>
  summarise(
    x_mean = mean(x), x_var = var(x),
    y_mean = mean(y), y_var = var(y),
    .groups = "drop"
  ) |>
  print()

print("--- Pearson corr by dataset ---")
df |>
  group_by(dataset) |>
  summarise(r = cor(x, y), .groups = "drop") |>
  print()

# 図は ggplot（当日は Python / Plotly を実装）
print(
  ggplot(df, aes(x, y, color = dataset)) +
    geom_point() +
    facet_wrap(~dataset) +
    labs(title = "Anscombe's quartet")
)
