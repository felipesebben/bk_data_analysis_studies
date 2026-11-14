# Progress

Resume point for study sessions. Update it at the end of each session: what was finished, and the very next step.

Legend: ✅ done · 🟡 in progress · ⬜ not started

## Now

**Chapter 6, Testing Hypotheses.** Case studies 6.A1 and 6.B1 done. Data exercise skeletons for Ex 1-5 are in `chapters/ch06-testing_hypotheses/exercises/`. **In progress: Exercise 1** (billion-prices, another country), which the user is writing on their own. Status: checking how `PRICETYPE` and `sale_online` are filled per country (`value_counts(dropna=False)`, `crosstab` with `fillna("missing")`, share missing via `groupby(...).agg(lambda s: s.isna().mean())`). Key facts: `PRICETYPE` is filled only for the USA, BRAZIL, CHINA, GERMANY, JAPAN and SOUTHAFRICA, and is fully missing for ARGENTINA, AUSTRALIA, CANADA and the UK, so the 6.A1 filter would wipe those countries out. `sale_online` is coded 1/NaN only, so NaN may mean "not on sale". Next: pick the country and a replacement filter, then run the test. After that: Ex 4 (sp500: pick the loss size and tolerated frequency; the real 3% count is 50 days, about 1.99%), then Ex 2, 3, 5. Mode for ch06: code walked through cell by cell in chat. Practice questions: Q1–Q7 done (worked by hand). **Next: Q8 (p-hacking and how to minimize its perils, with an example)**, then Q9 (p-hacking's effect on the published literature), then the applied Q10–Q15 (Q14–Q15 are computable t-test questions).

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
| 06 | Testing hypotheses | ✅ 6.A1 online/offline prices · ✅ 6.B1 stock market loss test | 🟡 skeletons for 1–5 ready | 🟡 Q1–7 done, Q8 next | ⬜ |
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
