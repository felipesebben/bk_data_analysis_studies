# Data Analysis for Business, Economics, and Policy: study repo

My replications, exercise solutions and projects while working through [*Data Analysis for Business, Economics, and Policy*](https://gabors-data-analysis.com/) by Gábor Békés and Gábor Kézdi, in Python.

- `chapters/chNN-<topic>/case_studies/`: replications of the book's case studies.
- `chapters/chNN-<topic>/exercises/`: my answers to the end-of-chapter data exercises, plus `extra-*` spin-offs on my own data (often Brazilian football and municipalities).
- `projects/`: end-to-end projects applying the methods to real problems.
- [`PROGRESS.md`](PROGRESS.md): where I am in the book.

## Setup

Uses [uv](https://docs.astral.sh/uv/). The book's datasets are not committed: download them from the [book's data page](https://gabors-data-analysis.com/datasets/) into `data/<dataset>/{raw,clean}/`.

```bash
uv sync                    # add --extra scraping for the web-scraping exercises
```

Then open a notebook in VS Code and select the `.venv` kernel.
