# Progress

Resume point for study sessions. Update it at the end of each session: what was finished, and the very next step.

Legend: ✅ done · 🟡 in progress · ⬜ not started

## Now

**Chapter 6, Testing Hypotheses.** Case studies 6.A1 and 6.B1 done. Data exercise skeletons for Ex 1-5 are in `chapters/ch06-testing_hypotheses/exercises/`. **In progress: Exercise 1** (billion-prices, another country), which the user is writing on their own. Status: checking how `PRICETYPE` and `sale_online` are filled per country (`value_counts(dropna=False)`, `crosstab` with `fillna("missing")`, share missing via `groupby(...).agg(lambda s: s.isna().mean())`). Key facts: `PRICETYPE` is filled only for the USA, BRAZIL, CHINA, GERMANY, JAPAN and SOUTHAFRICA, and is fully missing for ARGENTINA, AUSTRALIA, CANADA and the UK, so the 6.A1 filter would wipe those countries out. `sale_online` is coded 1/NaN only, so NaN may mean "not on sale". Next: pick the country and a replacement filter, then run the test. After that: Ex 4 (sp500: pick the loss size and tolerated frequency; the real 3% count is 50 days, about 1.99%), then Ex 2, 3, 5. Mode for ch06: code walked through cell by cell in chat. Practice questions: Q1–Q7 done (worked by hand). **Next: Q8 (p-hacking and how to minimize its perils, with an example)**, then Q9 (p-hacking's effect on the published literature), then the applied Q10–Q15 (Q14–Q15 are computable t-test questions).

**Real-world project: data centers and the 2026 midterms** (`projects/data_centers_midterms/`, branch `ch06/project-data-centers`). Question: did Republicans lose more House vote share (2024 → 2026, two-party, county level) in counties that host data centers? Plan and data model are in `BRIEF.md`. Mode: Claude is instructor only and writes no code unless asked. ✅ Task 1: pre-registration committed in `README.md` (two-sided Welch test, α = 0.05, PNNL atlas as main treatment, uncontested pieces dropped if uncontested in either year, 2020 → 2022 placebo, deep-red split exploratory only). ✅ Project scaffold: `docs/` templates (data availability, data quality notes, data dictionary, DAG), skeleton notebooks `01_collect` … `05_robustness`, `scripts/README.md`. No free national county-level 2026 House file exists yet (MEDSL, electiondata.dev and OpenElections lag; news sites' terms forbid scraping), so the user builds the dataset from state sites. Study board (private artifact, pinned in the claude.ai sidebar as "Békés Study Board"): https://claude.ai/artifact/2efS1beo5cKd7Er383FBUw, with three tabs: project kanban, book chapters kanban (each with Board / List / Timeline views; task dates backfilled from git history on 2026-11-20), and a learning path graph of chapter prerequisites. Virginia and Texas availability done. Texas 2026 has no download button: the SOS app has a JSON API (base64 payload, `election/countyInfo/53815`, county × district pieces). SOS county IDs do not map to FIPS by formula (fails for the 9 Ma/Mc counties): join on name (fix LASALLE). MEDSL 2024 TX: drop `special = TRUE` rows (same-day special House election). Texas redistricting confirmed (new map in 2026: Anderson 6 → 5, Angelina 17 → 15/27); plan a per-county `districts_changed` flag in Prepare. **Next: Task 2, Georgia** (tip: if the results site is a JS app, open its main JS file and search for `api`), then OH, AZ, OR, IA. Fill `docs/data_availability.md` for each state: official results link, by county?, format (CSV / Excel / Clarity / HTML), provisional or certified, date checked; plus 2024 county source (MEDSL precinct vs. OpenElections). Then set the state inclusion rule.

Ideas parked for after the questions:
- Simulate 20 or 100 true-null t-tests and plot the p-value distribution and the share below 0.05 (illustrates multiple testing, Q7).
- Simulate a power vs. sample-size curve for a fixed true effect (Q5).
- Data exercises: Ex 1–3 reuse billion-prices (see the 6.A1 case study), Ex 4 reuses S&P 500 (see ch05 case study), Ex 5 uses hotels-europe.

## By chapter

| Ch | Topic | Case studies | Data exercises | Practice Qs | Real-world project |
|----|-------|--------------|----------------|-------------|--------------------|
| 01 | Origins of data | ✅ hotels data collect | ✅ 01, 04 | ✅ | — |
| 02 | Preparing data for analysis | ✅ hotels prep, immunization, football managers | ✅ 01, 02, 04, 05 | ✅ | ✅ Brazilian football managers (EXTRA) |
| 03 | Exploratory data analysis | ✅ all 5 | ✅ 01–05 | ✅ | ✅ Brazilian football EDA (Tableau), Brazilian city sizes |
| 04 | Comparison and correlation | ✅ management & firm size | ✅ 01–05 | ✅ | ✅ football team performance |
| 05 | Generalizing from data | ✅ stock market loss | ✅ 01, 03, 04, 05 | ✅ | ✅ CO2 vs GDP (WDI, Tableau) |
| 06 | Testing hypotheses | ✅ 6.A1 online/offline prices · ✅ 6.B1 stock market loss test | 🟡 skeletons for 1–5 ready | 🟡 Q1–7 done, Q8 next | 🟡 data centers & 2026 midterms (pre-registration) |
| 07 | Simple regression | ⬜ | ⬜ | ⬜ | ⬜ |
| 08 | Complicated patterns and messy data | ⬜ | ⬜ | ⬜ | ⬜ |
| 09 | Generalizing results of a regression | ⬜ | ⬜ | ⬜ | ⬜ |
| 10 | Multiple linear regression | ⬜ | ⬜ | ⬜ | ⬜ |
| 11 | Modeling probabilities | ⬜ | ⬜ | ⬜ | ⬜ |
| 12 | Regression with time series data | ⬜ | ⬜ | ⬜ | ⬜ |
| 13 | A framework for prediction | ⬜ | ⬜ | ⬜ | ⬜ |
| 14 | Model building for prediction | ⬜ | ⬜ | ⬜ | ⬜ |
| 15 | Regression trees | ⬜ | ⬜ | ⬜ | ⬜ |
| 16 | Random forest and boosting | ⬜ | ⬜ | ⬜ | ⬜ |
| 17 | Probability prediction and classification | ⬜ | ⬜ | ⬜ | ⬜ |
| 18 | Forecasting from time series data | ⬜ | ⬜ | ⬜ | ⬜ |
| 19 | A framework for causal analysis | ⬜ | ⬜ | ⬜ | ⬜ |
| 20 | Designing and analyzing experiments | ⬜ | ⬜ | ⬜ | ⬜ |
| 21 | Regression and matching with observational data | ⬜ | ⬜ | ⬜ | ⬜ |
| 22 | Difference-in-differences | ⬜ | ⬜ | ⬜ | ⬜ |
| 23 | Methods for panel data | ⬜ | ⬜ | ⬜ | ⬜ |
| 24 | Appropriate control groups for panel data | ⬜ | ⬜ | ⬜ | ⬜ |

Practice-question status for ch01–05 is assumed done; correct it if not.
