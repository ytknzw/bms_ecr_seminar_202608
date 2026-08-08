"""環境構築の動作確認: 主要パッケージの import 可否。

必須パッケージが欠けていると終了コード 1。
LightGBM / PyMC / nutpie / ArviZ / graphviz は推奨（警告のみ）。
Ex8 / Ex9 の前に揃えておくと安心です。
"""
import importlib
import sys

REQUIRED = [
    "numpy",
    "pandas",
    "pyarrow",
    "plotly",
    "statsmodels",
    "sklearn",
]

OPTIONAL = [
    "lightgbm",
    "pymc",
    "nutpie",
    "arviz",
    "graphviz",  # Ex9 の model_to_graphviz（システムに dot も必要）
]


def check(name: str) -> tuple[bool, str]:
    try:
        mod = importlib.import_module(name)
        ver = getattr(mod, "__version__", "(no __version__)")
        return True, ver
    except Exception as exc:  # noqa: BLE001 - 環境確認用に広く捕捉
        return False, str(exc)


failed_required: list[str] = []
warned_optional: list[str] = []

print("--- required ---")
for name in REQUIRED:
    ok, detail = check(name)
    if ok:
        print(f"OK  {name:12s} {detail}")
    else:
        failed_required.append(name)
        print(f"NG  {name:12s} {detail}")

print("--- optional (Ex8/Ex9) ---")
for name in OPTIONAL:
    ok, detail = check(name)
    if ok:
        print(f"OK  {name:12s} {detail}")
    else:
        warned_optional.append(name)
        print(f"WARN {name:12s} {detail}")

if warned_optional:
    print(
        "Optional missing (install via `uv sync` before Ex8/Ex9): "
        + ", ".join(warned_optional)
    )

if failed_required:
    raise SystemExit(f"required import failed: {', '.join(failed_required)}")

print("Required packages OK")
sys.exit(0)
