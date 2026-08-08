# 【正解】check_score.R — check_score + testthat（Stretch）
# 実行: Rscript exercises/03_syntax_advanced/r/check_score.R

#' 点数を評語に変換する
#'
#' @param score 点数。0以上100以下であること。
#' @return 評語。「優」「良」「可」「不可」のいずれか。
#'   優: 80以上 / 良: 70以上80未満 / 可: 50以上70未満 / 不可: 50未満
#' @examples
#' check_score(80)
check_score <- function(score) {
  if (score < 0 || score > 100) stop("score out of range")
  if (score >= 80) {
    "優"
  } else if (score >= 70) {
    "良"
  } else if (score >= 50) {
    "可"
  } else {
    "不可"
  }
}

if (!requireNamespace("testthat", quietly = TRUE)) {
  stop("Please install testthat: install.packages('testthat')")
}

library(testthat)

# 問題2: 優・良・可・不可・範囲外をtestthatで検証する。
test_that("check_score works", {
  expect_equal(check_score(80), "優")
  expect_equal(check_score(90), "優")
  expect_equal(check_score(79.9), "良")
  expect_equal(check_score(70), "良")
  expect_equal(check_score(69.9), "可")
  expect_equal(check_score(50), "可")
  expect_equal(check_score(49.9), "不可")
  expect_error(check_score(-1))
  expect_error(check_score(101))
})

message("All tests passed")
