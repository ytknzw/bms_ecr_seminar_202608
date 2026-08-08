# Exercise 4対訳: penguinsの読込と加工
# r/ に入って実行: Rscript 01_read_describe.R
library(readr)
library(dplyr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)
message("shape: ", paste(dim(df), collapse = " x "))
print(sapply(df, class))
print(head(df, 10))

print(df |> select(Culmen_Length, Culmen_Depth) |> head())
print(df |> pull(Body_Mass) |> head())

df2 <- df |> mutate(flipper_bill_ratio = Flipper_Length / Culmen_Length)
print(head(df2))

df_male_biscoe <- df |> filter(Sex == "MALE", Island == "Biscoe")
message("df_male_biscoe: ", nrow(df_male_biscoe))
print(head(df_male_biscoe))

print(df |> arrange(Body_Mass) |> head())
print(df |> arrange(Body_Mass, desc(Culmen_Length)) |> head())
