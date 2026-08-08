# Exercise 4対訳: 重複の確認
# r/ に入って実行: Rscript 03_duplicates.R
library(readr)
library(dplyr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)
df_adelie <- df |> filter(Species_short == "Adelie")
message("Adelie shape: ", paste(dim(df_adelie), collapse = " x "))
print(sapply(df_adelie, function(col) dplyr::n_distinct(col, na.rm = FALSE)))
message("full-row duplicated: ", sum(duplicated(df_adelie)))
is_dup_id <- duplicated(df_adelie$Individual_ID) | duplicated(df_adelie$Individual_ID, fromLast = TRUE)
message("Individual_ID duplicated rows: ", sum(is_dup_id))
print(head(df_adelie[is_dup_id, ][order(df_adelie$Individual_ID[is_dup_id]), ], 5))
