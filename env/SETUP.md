# 環境構築手順（当日はPythonのみ）

対象OS（サポート）:

- **Windows 11**（64-bit / x86_64。ARM は非サポート）
- **macOS Sonoma 以上**（Apple Silicon / ARM64。Intel Mac は非サポート）

共通要件: メモリー 16GB 以上、Wi-Fi、管理者権限あり

## これから入れる道具の役割

これから入れる道具の役割です（どれか1つでは足りません）。

- **VS Code**: コードを書くエディター
- **Git**: 教材リポジトリーを取得する
- **uv**: Python本体とパッケージ・仮想環境を用意する
- **Python**: スクリプトを実行する本体（インタープリター）

バージョン目安（当日時点の最新に合わせて更新）:

- 本講座では**Python 3.13**を用いる
- エディター: **VS Code**（推奨）

Rのインストールは **不要** です。リポジトリー内の `.R` / `.stan` は、Pythonの理解を助ける**対訳資料**であり、当日は実行しません。

Ex1 は環境構築のみで演習スクリプトはありません。Ex2 以降のPythonは **`exercises/*/python/` が問題（実装する）**、**`solutions/` が正解**です。事前確認では `python/` の完成想定として `solutions/` を実行しても構いません。

手順の流れ（スライドの Ex1 と同じ順）:

1. VS Code → 2. Gitとclone → 3. uv → 4. Python 3.13と仮想環境（`uv sync`）→ 5. 動作確認

---

## 1. VS Code（推奨エディター）

1. ダウンロード: https://code.visualstudio.com/
2. インストール:
   - macOS: https://code.visualstudio.com/docs/setup/mac
   - Windows: https://code.visualstudio.com/docs/setup/windows
3. 拡張機能: **Python（Microsoft）**を入れる  
   https://marketplace.visualstudio.com/items?itemName=ms-python.python
4. 教材リポジトリーを取得したあと、リポジトリールートを「フォルダーを開く」で開く
5. Pythonインタープリターは `uv` が作った仮想環境（`.venv`）を選択

実行はターミナルで（リポジトリールートから）:

```bash
uv run python exercises/<dir>/python/<file>.py
```

---

## 2. Gitとリポジトリーの取得

公開リポジトリー（**これから作成。URL はプレースホルダー**）:

```text
https://github.com/<OWNER>/<REPO>.git
```

`<OWNER>` / `<REPO>` は公開用リポジトリー作成後に差し替えてください（スライド `PUBLIC_REPO_URL` も同様）。

### 2.1 Gitのインストール

VS CodeやuvにはGitは同梱されません。公式: https://git-scm.com/downloads

**macOS:**

- `brew install git`
- または `xcode-select --install`（Command Line Tools）
- または https://git-scm.com/download/mac

**Windows:**

- https://git-scm.com/download/win のインストーラー

インストール後、ターミナルを開き直して確認:

```bash
git --version
```

### 2.2 git clone（推奨）

書き込み可能な場所（例: `Documents`）で:

```bash
git clone https://github.com/<OWNER>/<REPO>.git
cd <REPO>
```

配置例:

- Windows: `C:\Users\<ユーザー名>\Documents\<REPO>`
- Mac: `~/Documents/<REPO>`

以降、このフォルダーを **リポジトリールート** と呼びます。ターミナル操作はルートで行ってください。

### 2.3 代替: ZIP

`git clone` が難しい場合は、GitHubの **Code → Download ZIP** で取得し、解凍したフォルダーをリポジトリールートとして使います。

---

## 3. uvのインストール

公式手順: https://docs.astral.sh/uv/getting-started/installation/

**macOS:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

https://docs.astral.sh/uv/getting-started/installation/#__tabbed_1_1

**Windows**（PowerShell）:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

https://docs.astral.sh/uv/getting-started/installation/#__tabbed_1_2

インストール後、ターミナルを開き直して確認:

```bash
uv --version
```

`uv: command not found` のときは PATH を確認します（Windows例: `C:\Users\<ユーザー名>\.local\bin`。PowerShellでは一時的に `$env:Path = "C:\Users\<ユーザー名>\.local\bin;$env:Path"`）。

---

## 4. Pythonのインストールと仮想環境

本講座では**Python 3.13**を用います。リポジトリールート（`cd <REPO>` 済み）で操作してください。

### 4.1 Python 3.13

```bash
uv python install 3.13
```

もしくはPython公式サイトからインストーラーをダウンロードしても構いません。

### 4.2 本講座での同期（推奨）

本講座リポジトリーでは**`uv sync` / `uv run`で足ります**（仮想環境の作成と依存の導入をまとめて行います）。

```bash
uv sync
```

### 4.3 仮想環境を手で作る場合（スライドの手順）

スライドでは次も示しています。すでに §4.2 の `uv sync` が通っていれば、必須ではありません。

```bash
uv venv --python 3.13
```

有効化の例:

- Windows: `.venv\Scripts\activate`（実行ポリシーで止まったら `Set-ExecutionPolicy Unrestricted -Scope CurrentUser`）
- macOS: `source .venv/bin/activate`

（新規プロジェクト向けの `uv init` は、本講座リポジトリーでは不要です。）

### 4.4 動作確認（Ex1 の成功条件）

リポジトリールートで:

```bash
uv python install 3.13 && uv sync
uv run python -c "import sys, platform; print(sys.version); print(platform.platform())"
uv run python env/check_packages.py
```

`env/check_packages.py` の見方:

| 区分 | パッケージ | 欠けたとき |
|------|------------|------------|
| **必須** | numpy, pandas, pyarrow, plotly, statsmodels, sklearn | 失敗（Ex1 未完了） |
| **推奨** | lightgbm（Ex8 Stretch）, pymc / nutpie / arviz / graphviz（Ex9） | 警告のみ。該当コマの前に `uv sync` を再実行。Ex8 Must（LinearRegression / kNN）はsklearnのみで可。Ex9 の `model_to_graphviz` にはOSにGraphviz（`dot`）も必要。nutpieは任意（入っていればPyMCが利用）。入らない場合は `pyproject.toml` から `nutpie[pymc]` の行を削除して `uv sync` |

`pyarrow` は Ex4 以降の主データ `data/penguins.parquet` の読み書きに使います（CSV 併記あり）。

Stretch（余力）: 推奨パッケージも OK になるまで `uv sync` を繰り返します。

### 4.5 Ex9 用: Graphviz（`dot`）※任意だが `model_to_graphviz` に必要

Pythonの `graphviz` パッケージ（`uv sync` で入る）だけでは不十分です。OSにGraphviz本体（`dot` コマンド）が必要です。サポートOSごとの手順:

**Windows 11（64-bit）** — PowerShell:

```powershell
winget install --id Graphviz.Graphviz -e
```

インストール後、ターミナルを開き直して確認:

```powershell
dot -V
```

`dot` が見つからないときは、環境変数 Path に `C:\Program Files\Graphviz\bin` を追加してください（公式 EXE を使う場合は「Add Graphviz to the system PATH」にチェック）。

**macOS Sonoma 以上（Apple Silicon）** — Homebrew:

```bash
brew install graphviz
dot -V
```

Homebrew未導入なら https://brew.sh/ から入れたうえで上記を実行します。

---

## 5. Rの対訳について（参加者の当日対象外）

- 各コマの `exercises/*/r/`（Ex9 は `.stan` 含む）は、同じ処理の対訳です
- **参加者は当日、Rの環境構築・実行をしません**（Pythonのみ）

---

## 6. トラブルシュート（頻出）

| 症状 | 確認すること |
|------|----------------|
| `uv: command not found` | ターミナル再起動、PATH に `~/.local/bin` や `C:\Users\<ユーザー名>\.local\bin` が入っているか |
| Git未インストール / clone 失敗 | §2.1 のインストール、§2.3 のZIPフォールバック |
| 作業ディレクトリーがルートでない | **必ずリポジトリールート** で実行しているか（パスエラーの主因） |
| `uv sync` が失敗 | ネットワーク、プロキシ、Pythonバージョン（3.13）、管理者権限 |
| LightGBM / PyMCのビルド・実行エラー | OS要件、メモリー不足、`uv sync --reinstall`。LightGBMはEx8 Stretch前に推奨 |
| PyMC初回が遅い / 失敗 | `~/.pytensor` への書き込み権限、初回コンパイル待ち（数分かかることがある） |
| Ex9 で R-hat 警告 | デモ設定のため起こりうる。NOTE が出ても講師デモに進んでよい |
| Ex9 で `dot` / graphviz エラー | §4.5 のGraphviz本体を入れ、`dot -V` が通るか確認。ターミナル再起動も試す |
| nutpie のインストールに失敗 | 任意のためスキップ可。`pyproject.toml` から `nutpie[pymc]` の行を削除して `uv sync`。PyMC標準のNUTSで Ex9 を実行 |
| Ex9 が完全に失敗 | 講師が事前実行した出力を投影し、モデル式の読みに進む（Mustの「動かす」は講師側で代替可） |
| 推奨パッケージがWARN | Ex8 Stretch / Ex9 の前に `uv sync`。必須だけ OK なら Ex1 は完了でよい（Ex8 Mustはsklearnのみ） |
