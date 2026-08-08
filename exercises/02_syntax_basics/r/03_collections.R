# 【正解】03_collections.R — ベクトル / named list（list・dict相当）

nums <- c(3, 1, 2)
names_vec <- c("ぱいそん", "あーる", "じゅりあ")
counts <- list(apple = 2, banana = 0, cherry = 3)

# 問題1: numsの先頭要素と末尾要素を表示する（Rの添字は1始まり）。
nums[1]
nums[length(nums)]

# 問題2: names_vecに"しー"を追加し、結果のベクトルを表示する。
names_vec <- c(names_vec, "しー")
names_vec

# 問題3: sort(nums)の結果と、元のnums（変化していないこと）を両方表示する。
sort(nums)
nums

# 問題4: countsの各名前と値をforで走査し、表示する（named list ≈ dict）。
for (key in names(counts)) {
  value <- counts[[key]]
  # for内は自動表示されないためprintが必要。
  print(list(key = key, value = value))
}
