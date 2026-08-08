# メンテ用: R 対訳スクリプトを一通り実行して動作確認する
# リポジトリールートで: Rscript env/verify_r.R
# 各スクリプトは、そのファイルがあるディレクトリーを cwd にして実行する（相対パス前提）

fail <- character()

run_one <- function(rel) {
  message("\n===== ", rel, " =====")
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(dirname(rel))
  status <- system2("Rscript", basename(rel), stdout = "", stderr = "")
  if (!identical(status, 0L)) {
    fail <<- c(fail, rel)
    message("FAILED: ", rel, " (status=", status, ")")
  } else {
    message("OK: ", rel)
  }
}

scripts <- c(
  "exercises/02_syntax_basics/r/01_objects.R",
  "exercises/02_syntax_basics/r/02_control_flow.R",
  "exercises/02_syntax_basics/r/03_collections.R",
  "exercises/02_syntax_basics/r/04_functions.R",
  "exercises/02_syntax_basics/r/05_io.R",
  "exercises/03_syntax_advanced/r/01_s3_class.R",
  "exercises/03_syntax_advanced/r/02_messaging.R",
  "exercises/03_syntax_advanced/r/check_score.R",
  "exercises/04_wrangling_basics/r/01_read_describe.R",
  "exercises/04_wrangling_basics/r/02_groupby.R",
  "exercises/04_wrangling_basics/r/03_duplicates.R",
  "exercises/04_wrangling_basics/r/04_matrix_basics.R",
  "exercises/05_wrangling_advanced/r/01_join.R",
  "exercises/05_wrangling_advanced/r/02_pivot.R",
  "exercises/06_visualisation/r/01_scatter.R",
  "exercises/06_visualisation/r/02_line.R",
  "exercises/06_visualisation/r/03_bar.R",
  "exercises/06_visualisation/r/04_histogram.R",
  "exercises/06_visualisation/r/05_box.R",
  "exercises/07_stats/r/01_anscombe.R",
  "exercises/07_stats/r/02_describe.R",
  "exercises/07_stats/r/03_tests_regression.R",
  "exercises/07_stats/r/04_distributions.R",
  "exercises/08_ml/r/01_regression.R",
  "exercises/08_ml/r/02_classification.R",
  "exercises/08_ml/r/03_unsupervised.R",
  "exercises/08_ml/r/04_lightgbm.R",
  "exercises/09_bayesian/r/01_hierarchical_flipper.R",
  "exercises/09_bayesian/r/02_hierarchical_culmen_flipper.R",
  "exercises/09_bayesian/r/03_state_space.R"
)

for (s in scripts) {
  run_one(s)
}

if (length(fail) > 0) {
  stop("R verify failed:\n  - ", paste(fail, collapse = "\n  - "))
}
message("\nAll R translation scripts OK")
