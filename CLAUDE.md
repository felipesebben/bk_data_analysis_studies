# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal study repo for *Data Analysis for Business, Economics, and Policy* (Békés & Kézdi). The book PDF sits in the repo root (gitignored). The user replicates the case studies, solves the end-of-chapter data exercises in Python, and at least once per chapter builds an end-to-end real-world project (ingestion → transformation → analysis → dataviz storytelling). It is published on GitHub as a portfolio.

Act as a teacher. The user either asks to be taught how to solve something (explain the reasoning and the math, guide rather than hand over a solution) or writes the code and asks for a review. Written practice questions are answered by hand and are not stored in the repo. Don't write their answers unless asked.

No emojis anywhere: replies, notebooks, markdown files or commit messages.

**Start every session by reading `PROGRESS.md`** and update it at the end (what was finished, the next step).

## Environment

- uv, Python 3.12. `uv sync` installs everything (`--extra scraping` adds selenium/bs4/etc. for the web-scraping exercises). Run anything with `uv run ...`. Add deps with `uv add <pkg>`.
- `pandas` is pinned `<3` and `matplotlib <3.9.1` on purpose: notebooks were written against those. Upgrading is a deliberate, separate task.
- The project installs itself as the `bkda` package (`src/bkda/`), so `import bkda` works from any notebook without `sys.path` hacks.
- No tests or linter. Verify notebook changes by executing them, e.g. with `nbclient` (in the dev group); executed output doesn't need saving.

## Layout

- `chapters/chNN-<topic>/case_studies/<name>/`: case study replications.
- `chapters/chNN-<topic>/exercises/`: data exercises. ch01–02 are flat (notebooks share an `exercises/data/` folder); ch03+ use one `NN-<name>/` folder per exercise with its own `data/{raw,clean,output}/` and often a `README.md`. `extra-*`/`EXTRA-*` folders are the user's spin-offs.
- `projects/<name>/`: end-to-end real-world projects (see `projects/README.md`).
- `src/bkda/helpers.py`: the authors' Python helpers (`seq`, `skew`, `lspline`, `poly`, `create_calibration_plot`, `color`), formerly `py_helper_functions.py`.
- `src/bkda/paths.py`: repo locations resolved from the package file, not the cwd.
- `data/<dataset>/{raw,clean}/`: the book's datasets. Gitignored, never commit it.
- `reference/`: the authors' official R/Stata/Python case study code. Gitignored. Use it to check replications.

## Notebook conventions

Every notebook's setup cell follows this pattern; keep new notebooks consistent:

```python
from bkda.paths import DATA_DIR, ROOT_DIR

HERE = f"{ROOT_DIR}chapters/ch06-testing_hypotheses/case_studies/online_offline_price_test/"
data_in = f"{DATA_DIR}billion-prices/clean/"
data_out = f"{HERE}data/clean/"
output = f"{HERE}output/"

from bkda.helpers import *
```

The `*_DIR` strings end in `/` because existing code concatenates (`data_in + "file.csv"`). New code may use the `Path` objects (`bkda.paths.ROOT`, `DATA`, `CHAPTERS`, `PROJECTS`). If a folder is moved, update its `HERE` line. Some book CSVs need `encoding="latin1"`. Plotting defaults to plotnine (mirrors the book's ggplot style). Scripts (`.py`) locate files relative to `Path(__file__)`. Secrets live in gitignored `config/config.yaml` or `.env` files next to the scripts.

## Git workflow

Work on a branch per task or chapter (e.g. `ch06/practice-simulations`, `chore/...`), then open a PR with `gh` and merge it. The user has authorized Claude to commit, push and merge PRs in this repo. Commit messages use Conventional Commit prefixes (`feat:`, `docs:`, `chore:`), e.g. `feat: finish case study 6.A1`.
