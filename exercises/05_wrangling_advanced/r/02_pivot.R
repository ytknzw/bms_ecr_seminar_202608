# Exercise 5対訳: pivot
library(dplyr)
library(tidyr)
library(readr)

path <- "../../../data/penguins.csv"
df_wide <- read_csv(path, show_col_types = FALSE) |>
  select(Individual_ID, Species_short, Culmen_Length, Flipper_Length, Body_Mass) |>
  drop_na()
message("df_wide shape: ", paste(dim(df_wide), collapse = " x "))

df_long <- df_wide |>
  pivot_longer(
    cols = c(Culmen_Length, Flipper_Length, Body_Mass),
    names_to = "measure",
    values_to = "value"
  )
message("df_long shape: ", paste(dim(df_long), collapse = " x "))
print(head(df_long))

df_wide_back <- df_long |>
  pivot_wider(
    id_cols = c(Individual_ID, Species_short),
    names_from = measure,
    values_from = value
  )
message("df_wide_back shape: ", paste(dim(df_wide_back), collapse = " x "))
print(head(df_wide_back))

# df_wide と df_wide_back は行数が異なる。原因を調べる。
message("df_wide shape: ", paste(dim(df_wide), collapse = " x "),
        ", df_wide_back shape: ", paste(dim(df_wide_back), collapse = " x "))
print(df_wide |> count(Individual_ID, Species_short) |> arrange(desc(n)) |> head())
print(df_wide_back |> count(Individual_ID, Species_short) |> arrange(desc(n)) |> head())
# 原因は、縦横変換のキー（Individual_ID と Species_short の組）に重複があること。
# キーに重複があると pivot_wider() は値をリスト列にする（values_fn 未指定時）か、
# values_fn で集約する。
