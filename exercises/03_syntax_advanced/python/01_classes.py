# 【問題】01_classes.py — クラスと継承

# 問題1: 点数を持つ生徒を表す Student クラスを定義する。
#   - __init__(self, name, score): 氏名 name（str）と点数 score（float）を
#     インスタンス属性 self.name / self.score に保存する。
#   - passed(self, threshold=60): score が threshold 以上なら True、未満なら False を返す。
#     threshold の既定値は 60.0 とする。
#   - __repr__(self): 対話表示や print で分かりやすい文字列を返す
#     （例: Student(name='Alice', score=72)）。











# 問題2: 転入生を表す TransferStudent を、Student を継承して定義する。
#   - __init__(self, name, score, school): 転入元の学校名 school（str）を追加する。
#   - name と score の初期化は super().__init__(name, score) に任せる。
#   - school は self.school に保存する。
#   - __repr__ をオーバーライドし、school も含めて表示する
#     （例: TransferStudent(name='Bob', score=55, school='North High')）。











# 問題3: 次のインスタンスを作り、passed の結果を表示する。
#   - Student("Alice", 72)
#   - TransferStudent("Bob", 55, "North High")
#   - それぞれのオブジェクト本体と passed()（既定の threshold）
#   - Bob について passed(50) も試し、閾値を変えたときの結果を確認する。





