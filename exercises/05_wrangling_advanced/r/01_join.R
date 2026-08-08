# Exercise 5対訳: join
# r/ に入って実行: Rscript 01_join.R
library(dplyr)
library(readr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)

# ChinstrapとGentooのデータ
df_chinstrap_gentoo <- df |>
  filter(Species_short %in% c("Chinstrap", "Gentoo")) |>
  select(Species_short, Island, Body_Mass)

# BiscoeとTorgersenの個体数
df_biscoe_torgersen <- df |>
  filter(Island %in% c("Biscoe", "Torgersen")) |>
  count(Island, name = "Individual_ID")

# 左結合
df_chinstrap_gentoo |>
  left_join(df_biscoe_torgersen, by = "Island") |>
  print()

# 内部結合（共通部分）
df_chinstrap_gentoo |>
  inner_join(df_biscoe_torgersen, by = "Island") |>
  print()

# 右結合
df_chinstrap_gentoo |>
  right_join(df_biscoe_torgersen, by = "Island") |>
  print()

# 外部結合
df_chinstrap_gentoo |>
  full_join(df_biscoe_torgersen, by = "Island") |>
  print()
