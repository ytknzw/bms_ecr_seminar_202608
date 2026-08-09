# 対訳 — 例 00 — ベイズ単回帰（プール）
# 体重Body_Massをひれ長Flipper_Lengthで説明するプール単回帰をStanで推定してください。
# r/ に入って実行: Rscript 00_glm_flipper.R
# Python: 00_glm_flipper.ipynb（PyMC）。散布図・事後図は Python 側（Plotly / ArviZ）。
library(readr)
library(dplyr)
library(cmdstanr)

path <- "../../../data/penguins.csv"
stan_path <- "glm_flipper.stan"

df <- read_csv(path, show_col_types = FALSE) |>
  filter(
    !is.na(Body_Mass),
    !is.na(Flipper_Length),
    !is.na(Species_short)
  )

stan_data <- list(
  N = nrow(df),
  flipper = as.numeric(df$Flipper_Length),
  y = df$Body_Mass
)

mod <- cmdstan_model(stan_path)
fit <- mod$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 2,
  iter_warmup = 500,
  iter_sampling = 500,
  adapt_delta = 0.95,
  refresh = 0
)

print(fit$summary(variables = c("intercept", "beta_flipper", "sigma")))
# 事後中央値 + おおむね 94% ETI（3% / 97% 分位点）
print(fit$summary(
  variables = c("intercept", "beta_flipper"),
  "median",
  ~quantile(.x, probs = c(0.03, 0.97))
))

med <- fit$summary(
  variables = c("intercept", "beta_flipper"),
  "median"
)
med_i <- med$median[med$variable == "intercept"]
med_b <- med$median[med$variable == "beta_flipper"]
message(sprintf(
  "median equation: Body_Mass ≈ %.0f + %.1f·Flipper",
  med_i, med_b
))
