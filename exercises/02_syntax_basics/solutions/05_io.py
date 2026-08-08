# 【正解】05_io.py — pathlib + with open（Stretch）

from pathlib import Path

out_dir = Path("out")

# 問題1: out_dirが無ければ作成する（mkdir）。
out_dir.mkdir(parents=True, exist_ok=True)

# 問題2: withを使いnote.txtに数行書き込み、続けて読み戻して表示する。
note_path = out_dir / "note.txt"
with note_path.open("w", encoding="utf-8") as f:
    f.write("Ex2 Stretch\nscore=72.5\n")

with note_path.open(encoding="utf-8") as f:
    f.read()

# 問題3: withを使いmini.csvを書く（ヘッダname,scoreとデータ2行）。
#         その後1行ずつ読み出して表示する。
csv_path = out_dir / "mini.csv"
with csv_path.open("w", encoding="utf-8") as f:
    f.write("name,score\n")
    f.write("Alice,72\n")
    f.write("Bob,55\n")

with csv_path.open(encoding="utf-8") as f:
    for line in f:
        line.rstrip()
