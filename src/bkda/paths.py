"""Repo locations, independent of the notebook's working directory.

The ``*_DIR`` strings end with "/" so notebooks can keep building paths
with f-strings (``f"{DATA_DIR}hotels-vienna/clean/"``). Use the ``Path``
objects in new code.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "data"  # book datasets (gitignored), one folder per dataset
CHAPTERS = ROOT / "chapters"
PROJECTS = ROOT / "projects"

ROOT_DIR = f"{ROOT.as_posix()}/"
DATA_DIR = f"{DATA.as_posix()}/"
CHAPTERS_DIR = f"{CHAPTERS.as_posix()}/"
PROJECTS_DIR = f"{PROJECTS.as_posix()}/"
