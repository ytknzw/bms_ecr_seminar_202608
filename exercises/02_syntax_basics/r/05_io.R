# 【正解】05_io.R — ディレクトリ作成 + ファイル読み書き（Stretch）

# このファイルと同じディレクトリ配下の out/（対話貼り付け時は getwd() をフォールバック）
this_dir <- tryCatch(
  dirname(normalizePath(sys.frame(1)$ofile)),
  error = function(e) getwd()
)
out_dir <- file.path(this_dir, "out")

# 問題1: out_dirが無ければ作成する（dir.create）。
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 問題2: connection + on.exit（with相当）でnote.txtに数行書き込み、続けて読み戻して表示する。
note_path <- file.path(out_dir, "note.txt")
local({
  con <- file(note_path, open = "wt", encoding = "UTF-8")
  on.exit(close(con))
  writeLines(c("Ex2 Stretch", "score=72.5"), con)
})
local({
  con <- file(note_path, open = "rt", encoding = "UTF-8")
  on.exit(close(con))
  readLines(con)
})

# 問題3: connection + on.exitでmini.csvを書く（ヘッダname,scoreとデータ2行）。
#         その後1行ずつ読み出して表示する。
csv_path <- file.path(out_dir, "mini.csv")
local({
  con <- file(csv_path, open = "wt", encoding = "UTF-8")
  on.exit(close(con))
  writeLines(c("name,score", "Alice,72", "Bob,55"), con)
})
local({
  con <- file(csv_path, open = "rt", encoding = "UTF-8")
  on.exit(close(con))
  for (line in readLines(con)) {
    # for内は自動表示されないためprintが必要（Pythonの line.rstrip() 相当の改行除去は readLines が行う）。
    print(line)
  }
})
