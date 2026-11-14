# Scripts

Repeatable steps that run outside the notebooks. Scripts find files relative to `Path(__file__)`. Planned:

| Script | Language | What it does | Status |
|--------|----------|--------------|--------|
| `download_<source>.py` | Python | Downloads a raw source into `data/raw/`, once the manual steps in `notebooks/01_collect.ipynb` work | not started |
| `hexgrid/` | R (geogrid) | Builds the county hex grid, state by state, as described in BRIEF.md | not started |
| `export_hyper.py` | Python (Tableau Hyper API) | Writes geometry and results into one Hyper extract for Tableau Public | not started |

R needs its own setup (R installed, and a package lock such as `renv`). Decide this when the hex grid task starts.
