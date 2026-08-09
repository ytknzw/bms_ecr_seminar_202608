# 対訳 — Stretch 03 — 状態空間モデル
# Species_short × yearの平均Body_Massパネルで、種ごとのローカルレベル状態空間をStanで推定してください。
# r/ に入って実行: Rscript 03_state_space.R
# Python: 03_state_space.ipynb（PyMC）。graphviz は Python 側。
library(readr)
library(dplyr)
library(cmdstanr)
library(ggplot2)

path <- "../../../data/penguins.csv"
stan_path <- "state_space.stan"
dir.create("out", showWarnings = FALSE)

panel <- read_csv(path, show_col_types = FALSE) |>
  filter(!is.na(Date_Egg), !is.na(Body_Mass), !is.na(Species_short)) |>
  mutate(year = as.integer(format(as.Date(Date_Egg), "%Y"))) |>
  group_by(Species_short, year) |>
  summarise(y = mean(Body_Mass), .groups = "drop") |>
  arrange(Species_short, year) |>
  # pandas.factorize と同じく出現順
  mutate(
    Species_short = factor(Species_short, levels = unique(as.character(Species_short))),
    species_id = as.integer(Species_short),
    time_id = as.integer(factor(year, levels = sort(unique(year))))
  )

species_levels <- levels(panel$Species_short)
years <- sort(unique(panel$year))

stan_data <- list(
  S = max(panel$species_id),
  T = max(panel$time_id),
  N = nrow(panel),
  species = panel$species_id,
  time = panel$time_id,
  y = panel$y
)

mod <- cmdstan_model(stan_path)
fit <- mod$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 2,
  iter_warmup = 400,
  iter_sampling = 400,
  adapt_delta = 0.95,
  refresh = 0
)

sum_ss <- fit$summary(variables = c("sigma_level", "sigma_obs", "mu0"))
print(sum_ss)
max_rhat <- max(sum_ss$rhat, na.rm = TRUE)
if (max_rhat > 1.05) {
  message(sprintf(
    "NOTE: max_rhat=%.3f (>1.05). デモ設定のため不安定なことがあります。講師デモを参照して構いません。",
    max_rhat
  ))
} else {
  message(sprintf("R-hat OK (max_rhat=%.3f)", max_rhat))
}
message(
  "species: ", paste(species_levels, collapse = ", "),
  " | years: ", paste(years, collapse = ", "),
  " | N: ", nrow(panel)
)

# 種別 level の事後平均・94%区間と観測平均（Python の level 図に対応）
draws <- fit$draws(variables = "level", format = "df")
level_cols <- grep("^level\\[", names(draws), value = TRUE)
level_df <- lapply(level_cols, function(col) {
  m <- regmatches(col, regexec("^level\\[(\\d+),(\\d+)\\]$", col))[[1]]
  s <- as.integer(m[2])
  t <- as.integer(m[3])
  vals <- draws[[col]]
  data.frame(
    species = species_levels[s],
    year = years[t],
    mean = mean(vals),
    lo = as.numeric(quantile(vals, 0.03)),
    hi = as.numeric(quantile(vals, 0.97)),
    stringsAsFactors = FALSE
  )
}) |>
  bind_rows()

obs_df <- panel |>
  transmute(species = as.character(Species_short), year, y)

p <- ggplot() +
  geom_ribbon(
    data = level_df,
    aes(x = year, ymin = lo, ymax = hi, fill = species),
    alpha = 0.2
  ) +
  geom_line(
    data = level_df,
    aes(x = year, y = mean, color = species)
  ) +
  geom_point(
    data = level_df,
    aes(x = year, y = mean, color = species),
    size = 2
  ) +
  geom_point(
    data = obs_df,
    aes(x = year, y = y, color = species),
    shape = 4,
    size = 2.5
  ) +
  labs(
    x = "year",
    y = "Body_Mass (g)",
    title = "State-space levels (mean + 94% interval) vs observed yearly means",
    color = "species",
    fill = "species"
  ) +
  theme_minimal()

ggsave("out/state_space_levels.png", p, width = 9, height = 4.8, dpi = 150)
message("wrote out/state_space_levels.png")