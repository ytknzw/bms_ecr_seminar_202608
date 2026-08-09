# 対訳 — 例 01 — 階層回帰（ひれのみ）
# 体重Body_Massをひれ長で説明し、切片・傾きに種差を入れた階層モデルをStanで推定してください。
# r/ に入って実行: Rscript 01_hierarchical_flipper.R
# Python: 01_hierarchical_flipper.ipynb（PyMC）。graphviz / forest / plot_dist / trace は Python 側。
library(readr)
library(dplyr)
library(cmdstanr)

path <- "../../../data/penguins.csv"
stan_path <- "hierarchical_flipper.stan"

df <- read_csv(path, show_col_types = FALSE) |>
  filter(
    !is.na(Body_Mass),
    !is.na(Flipper_Length),
    !is.na(Species_short)
  ) |>
  # pandas.factorize と同じく出現順（アルファベット順にしない）
  mutate(
    Species_short = factor(Species_short, levels = unique(as.character(Species_short))),
    species_id = as.integer(Species_short)
  )

species_levels <- levels(df$Species_short)

stan_data <- list(
  N = nrow(df),
  S = max(df$species_id),
  species = df$species_id,
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
  adapt_delta = 0.99,
  refresh = 0
)

print(fit$summary(variables = c(
  "intercept_all", "beta_flipper_all",
  "sigma_intercept", "sigma_flipper", "sigma_y"
)))
print(fit$summary(
  variables = c("intercept", "beta_flipper"),
  "median",
  ~quantile(.x, probs = c(0.03, 0.97))
))

med <- fit$summary(
  variables = c("intercept", "beta_flipper"),
  "median"
)
message("Body_Mass ≈ intercept + beta_flipper·Flipper")
for (i in seq_along(species_levels)) {
  sp <- species_levels[[i]]
  intercept_m <- med$median[med$variable == sprintf("intercept[%d]", i)]
  flipper_m <- med$median[med$variable == sprintf("beta_flipper[%d]", i)]
  message(sprintf("  %s: %.1f + %.1f·Flipper", sp, intercept_m, flipper_m))
}
message(
  "species: ", paste(species_levels, collapse = ", "),
  " | N: ", nrow(df)
)
