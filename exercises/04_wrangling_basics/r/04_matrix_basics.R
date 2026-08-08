# Exercise 4対訳: 行列の基本（NumPy Stretch と対応）
# r/ に入って実行: Rscript 04_matrix_basics.R
# 行列要素の参照・reshape・対角・seq・論理索引・行/列の追加を確認する

A <- matrix(
  c(1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12),
  nrow = 4,
  ncol = 3,
  byrow = TRUE
)
print(A)
message("dim: ", paste(dim(A), collapse = " x "))

# 参照（indexing; Rは1始まり）
message("A[1, 2] = ", A[1, 2])
message("row1: ", paste(A[1, ], collapse = " "))
message("col2: ", paste(A[, 2], collapse = " "))
print(A[1:2, 1:2])
print(t(A))

# reshape — 行優先（NumPy の reshape(3, 4) デフォルト）
flat_row <- c(t(A))
A_34_row <- matrix(flat_row, nrow = 3, ncol = 4, byrow = TRUE)
print(A_34_row)

# reshape — 列優先（NumPy の reshape(3, 4, order="F")）
A_34_col <- matrix(as.vector(A), nrow = 3, ncol = 4, byrow = FALSE)
print(A_34_col)

# 長さ12の1次元（NumPy の reshape(12) / ravel）
message("as.vector length-12: ", paste(as.vector(A), collapse = " "))

# 対角（長方形でも短い辺まで）
d <- diag(A)
message("diag(A): ", paste(d, collapse = " "))
print(diag(d))

# arange（NumPy の np.arange(1, 13) で1から12を1つずつ表示）
for (i in seq(1, 12)) {
  message(i)
}

# ブール索引（論理索引）
print(A > 6)
print(A[A > 6])
print(A[A[, 1] > 6, , drop = FALSE])

# 行・列の追加（NumPy の hstack / vstack に相当）
print(cbind(A, 0))
print(rbind(A, c(13, 14, 15)))
