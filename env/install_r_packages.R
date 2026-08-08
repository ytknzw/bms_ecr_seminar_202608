# R 対訳コード用パッケージ一括インストール（メンテ・自己学習向け）
#
# 参加者の当日必須手順ではありません。
# 共有リポジトリーのメンテ時、および対訳を自分で動かす場合に実行します。
#
# 使い方（リポジトリールートで）:
#   Rscript env/install_r_packages.R
#
# Ex9 は Stan（cmdstanr）。未導入なら CmdStan も入れます（時間がかかります）。

pkgs <- c(
  "tidyverse",
  "readr",
  "dplyr",
  "tidyr",
  "ggplot2",
  "stringr",
  "purrr",
  "broom",
  "testthat",
  "tidymodels",
  "rpart",
  "lightgbm",
  "cmdstanr",
  "arrow"
)

install_if_missing <- function(pkg) {
  if (pkg == "cmdstanr") {
    # CmdStan 2.3x 系との相性のため、r-universe から入れる（古い 0.5.x は CSV 読込で落ちることがある）
    need <- TRUE
    if (requireNamespace("cmdstanr", quietly = TRUE)) {
      ver <- as.character(utils::packageVersion("cmdstanr"))
      need <- utils::compareVersion(ver, "0.8.0") < 0
      if (!need) {
        message("OK (already installed): cmdstanr ", ver)
      }
    }
    if (need) {
      message("Installing/updating cmdstanr from Stan repository...")
      install.packages(
        "cmdstanr",
        repos = c("https://stan-dev.r-universe.dev", "https://cloud.r-project.org")
      )
    }
    return(invisible(NULL))
  }
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing: ", pkg)
    install.packages(pkg, repos = "https://cloud.r-project.org")
  } else {
    message("OK (already installed): ", pkg)
  }
}

invisible(lapply(pkgs, install_if_missing))

if (!requireNamespace("cmdstanr", quietly = TRUE)) {
  stop("cmdstanr failed to install")
}
library(cmdstanr)
cmd_path <- tryCatch(cmdstan_path(), error = function(e) NULL)
cores <- max(1L, parallel::detectCores() - 1L)

ensure_cmdstan_compiles <- function() {
  tmp_stan <- tempfile(fileext = ".stan")
  on.exit(unlink(tmp_stan), add = TRUE)
  writeLines("parameters { real x; } model { x ~ normal(0, 1); }", tmp_stan)
  tryCatch(
    {
      invisible(cmdstan_model(tmp_stan, quiet = TRUE))
      TRUE
    },
    error = function(e) FALSE
  )
}

if (is.null(cmd_path)) {
  message("Installing CmdStan (first time; may take several minutes)...")
  install_cmdstan(cores = cores)
} else {
  message("OK CmdStan at: ", cmd_path, " (version ", cmdstan_version(), ")")
  if (!ensure_cmdstan_compiles()) {
    message("Compile check failed; installing/updating CmdStan...")
    install_cmdstan(cores = cores, overwrite = TRUE)
  }
}

if (!ensure_cmdstan_compiles()) {
  stop("CmdStan still fails to compile a minimal model after install")
}

message("Done.")
