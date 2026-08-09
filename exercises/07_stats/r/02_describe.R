# 対訳 — Must 02 — 要約・分位点・欠測
# penguinsを読み、定量列の要約・Body_Massの分位点・欠測の多い列を確認してください。
# r/ に入って実行: Rscript 02_describe.R
library(readr)
library(dplyr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)
print(summary(df[, c("Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass")]))
print(quantile(df$Body_Mass, probs = c(0.05, 0.5, 0.95, 0.99), na.rm = TRUE))
miss <- sort(colMeans(is.na(as.data.frame(df))), decreasing = TRUE)
print(head(miss, 5))
