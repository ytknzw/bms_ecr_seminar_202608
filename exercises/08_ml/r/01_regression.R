# 対訳 — Must 01 — 線形回帰（Culmen + Flipper → Body_Mass）
# Culmen_LengthとFlipper_LengthからBody_Massを予測し、テストデータのMSEとMAPEを表示してください。
library(readr)
library(dplyr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE) |>
  tidyr::drop_na(Culmen_Length, Flipper_Length, Body_Mass)

set.seed(123)
n <- nrow(df)
test_idx <- sample.int(n, size = floor(0.3 * n))
train <- df[-test_idx, ]
test <- df[test_idx, ]

fit <- lm(Body_Mass ~ Culmen_Length + Flipper_Length, data = train)
y_hat <- predict(fit, newdata = test)

mse <- mean((test$Body_Mass - y_hat)^2)
mape <- mean(abs((test$Body_Mass - y_hat) / test$Body_Mass))
cat("MSE:", round(mse, 3), "\n")
cat("MAPE:", round(mape, 4), "\n")
