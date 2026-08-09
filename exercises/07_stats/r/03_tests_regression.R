# 対訳 — Must 03 — t検定と回帰
# Sex間のBody_MassのWelchのt検定と、Body_Mass ~ Culmen_Length + Flipper_LengthのOLSを行い結果を表示してください。
# r/ に入って実行: Rscript 03_tests_regression.R
library(dplyr)
library(readr)
library(broom)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE) |>
  filter(!is.na(Body_Mass), !is.na(Sex), !is.na(Culmen_Length), !is.na(Flipper_Length))

a <- df$Body_Mass[as.character(df$Sex) == "MALE"]
b <- df$Body_Mass[as.character(df$Sex) == "FEMALE"]
tt <- t.test(a, b)  # Welch（等分散を仮定しない）
print(tt)
message(sprintf("mean MALE=%.1f, mean FEMALE=%.1f", mean(a), mean(b)))

fit <- lm(Body_Mass ~ Culmen_Length + Flipper_Length, data = df)
print(tidy(fit))
