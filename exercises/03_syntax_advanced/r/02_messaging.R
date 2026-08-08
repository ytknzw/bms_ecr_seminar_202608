# 【正解】02_messaging.R — message / warning（Python logger 相当）

# 問題1: 開始の message を出す（logger.info 相当）。
message("[INFO] 点数分析開始")

# 問題2: 警告と終了を出す（logger.warning / logger.info 相当。DEBUG相当は出さない）。
n <- 5
warning("[WARN] 欠測スコアが 1 件あります（例）", call. = FALSE)
message(sprintf("[INFO] 分析終了: n=%s", n))
