# Data Centers and the 2026 Midterms: Pre-registration

Written on 2026-11-14, before looking at any 2026 results. The commit date of this file records when these choices were made. Any later change is logged in the change log at the bottom, with its date and reason.

The full project plan and data model are in [BRIEF.md](BRIEF.md).

## Project layout

| Path | What it holds |
|------|---------------|
| `README.md` | This pre-registration |
| `BRIEF.md` | Project plan, data model, stages, visualization plan |
| `docs/data_availability.md` | Task 2: which states publish county-level results, and where |
| `docs/data_quality_notes.md` | One note per source, plus the dropped-observations log |
| `docs/data_dictionary.md` | Columns of every table in the data model |
| `docs/dag.md` | The causal diagram and what it means for each stage |
| `notebooks/01_collect.ipynb` … `05_robustness.ipynb` | Collect, prepare, explore, test, robustness |
| `scripts/` | Repeatable downloads, the R hex grid, the Tableau Hyper export |
| `data/raw/`, `data/clean/` | Downloaded and cleaned data (gitignored) |
| `output/` | Figures and tables |

## 1. Question

Did the change in the Republican House vote share from 2024 to 2026 differ between US counties that host data centers and counties that don't?

## 2. Unit of observation

The county, identified by its FIPS code. Census controls exist at this level, and election results are published by county across the country.

### Decisions

- **Alaska is excluded.** It has one at-large House seat and reports results by state legislative district, not by borough. These districts don't line up with the Census county-equivalents.
- **Connecticut is kept.** Since 2022 the Census uses 9 planning regions as Connecticut's county-equivalents, in place of the 8 old counties, so the FIPS codes changed. Results are reported by town, so town votes are added up into planning regions.
- **Virginia's independent cities** each have their own FIPS code. Each one is treated as a separate county-equivalent.
- **TIGER county shapes** must be from the same year as the FIPS codes in the election data. Otherwise data centers get assigned to the wrong counties, mainly in Connecticut.

## 3. Outcome

**Swing** = Republican two-party share in the 2026 House race minus the same share in 2024, where two-party share = R / (R + D).

A negative swing means Republicans lost share.

### Decisions

- **Counties split across districts.** R and D votes are added up across all district pieces in a county, and the two-party share is computed from these totals.
- **Uncontested races.** A race is uncontested when one of the two major parties has no candidate. Races between two candidates of the same party (D vs. D or R vs. R, possible in the top-two states California and Washington) also count as uncontested.
  - A county-district piece is used only if its race was contested in **both** 2024 and 2026. A race that is uncontested in one year makes the swing meaningless, because the change comes from the ballot and not from voters.
  - If a district's boundaries changed, so its piece of the county can't be matched across the two years, the whole county is dropped.
  - All dropped counties and pieces are listed in the data-quality note.

## 4. Treatment

**Main definition:** the county hosts at least one operating data center in the **PNNL IM3 Open Source Data Center Atlas**, of any size.

The atlas is built from OpenStreetMap, which is mapped by volunteers but not driven by news coverage. This makes it less likely that the treatment is measured through the outcome (see open question 4).

### Robustness versions

1. **Large facilities only.** The size threshold is set after looking at the size distribution in the atlas, before computing any swing.
2. **Distance instead of county borders:** a data center within 5, 10 or 25 miles of the county.
3. **Operating and proposed facilities.** Current best source: the FracTracker data center database, which has a status column (proposed, operating, cancelled). Its records come from media monitoring and crowdsourcing, so they may favor controversial projects. Entries created after election day are excluded.

These data sources are not final. If a better source is found, it can replace one of them, and the change is logged below with its date and reason.

## 5. Hypotheses

Let **d** = mean swing in counties with data centers − mean swing in counties without data centers.

- **H₀: d = 0.** On average, Republicans' vote share changed the same way in both groups.
- **H₁: d ≠ 0.** On average, Republicans' vote share changed differently in the two groups.

**Why two-sided:** before seeing the data, there is no reason of my own to expect a specific direction. Republicans could have done worse near data centers (electricity bills, water use) or better (jobs, tax revenue). A large result in either direction would be worth reporting.

**Why the national wave doesn't matter here:** the test compares two groups. If every county shifted the same amount toward Democrats, both group means move by the same amount and d doesn't change.

## 6. Significance level and test

- **Significance level:** α = 0.05. Reject H₀ if p < 0.05 (two-sided), or equivalently if the t-statistic is below −1.96 or above 1.96.
- **Test:** Welch's two-sample t-test (unequal variances).
- **Why Welch:** the two groups will be very different in size (likely a few hundred treated counties against a few thousand untreated ones). Their variances are also likely to differ, because the untreated group has many small rural counties, where a share computed from few votes is noisier. With unequal sizes and unequal variances, the pooled t-test gives a wrong standard error. Welch uses each group's own variance: SE = √(s₁²/n₁ + s₂²/n₂).
- **Report:** the difference d, its 95% confidence interval, the t-statistic and the p-value, plus the group sizes and means.

## 7. Sample

The state inclusion rule will be set after the data-availability check (Task 2) and before any swing is computed. Checking whether data exist is allowed; looking at results is not.

The download date of the 2026 results is recorded, because provisional numbers can change until each state certifies.

## 8. What would change my mind

- **Smallest difference that matters:** 2 percentage points. A smaller difference would not be meaningful in practice, even if it were statistically significant.
- **No evidence for a difference:** p ≥ 0.05, meaning the t-statistic falls between −1.96 and 1.96.
- **Failing to reject H₀ does not prove there is no effect.** The confidence interval tells which case applies:
  - A narrow CI around zero (for example, −0.3 to +0.4 points) means any effect is small. This is a real finding.
  - A wide CI (for example, −3 to +2 points) means the data can't tell. The result is inconclusive.
- **Power check, once the data are in:** compute the SE of the difference. If 2 points is well above 2 × SE, the test can detect a meaningful effect. If not, a non-significant result says little.
- **Robustness:** if the main result disappears in the within-state tests (open question 1) or also shows up in the 2020 → 2022 placebo (open question 2), it is probably not about data centers.

## 9. Pre-registered robustness checks

1. The test repeated within a few large states with many treated counties.
2. **Placebo:** the same test on the 2020 → 2022 swing, before data centers were a political issue. A difference there would suggest a long-running trend, not a reaction to data centers.
3. Only counties that lie entirely inside one district whose boundaries didn't change between 2024 and 2026. Both results are reported. Whether they agree is part of the finding.
4. The treatment versions in section 4.
5. **Check on dropped races:** compare the share of county-district pieces dropped as uncontested in counties with and without data centers. If the shares are similar, dropping them doesn't bias the comparison. If they differ, data centers may have affected whether races were contested (open question 13), and this is reported as a limitation.

## Open questions

Each question says what is asked, why it matters, and when it can be addressed (stage and book chapter).

### A. Threats to the Stage 1 test

1. **Are swings within a state independent?** Counties in the same state share Senate and governor races, redistricting and local media, so their swings move together. The t-test assumes independent observations, so its SE is too small and the p-value looks better than it should. Data centers cluster in a few states, so part of the gap may just be a state gap.
   - Stage 1: the within-state tests (section 9).
   - Stage 2 (Ch. 9–10): state fixed effects and standard errors clustered by state.
2. **Did data center counties already swing differently before 2026?** If they did, the 2026 gap may be a long-running suburban trend.
   - Stage 1: the 2020 → 2022 placebo test (section 9). Caution: districts were redrawn after the 2020 census.
   - Stage 3 (Ch. 22): parallel trends for difference-in-differences.
3. **Do candidates, not voters, drive part of the swing?** Open seats, retiring incumbents, scandals and redrawn districts change a county's swing for reasons unrelated to data centers.
   - Stage 1: the single-district robustness check (section 9).
   - Stage 2: controls for open seats and incumbency.
4. **Is the treatment measured through the outcome?** Sources built from news coverage and crowdsourcing (like FracTracker) record controversial projects more often, and controversy may also move votes.
   - Stage 1: compare coverage between PNNL and FracTracker (what share of each source appears in the other), and describe it in the data-quality note.

### B. Mechanisms: why an effect could exist

5. **Electricity and water bills: confounder or mediator?** If data centers raise bills and bills move votes, bills sit on the causal path. Controlling for them would hide part of the effect being measured. Data: EIA retail electricity prices by utility or state.
   - Stage 2: decide with the DAG whether to control for them.
6. **Employment: confounder, mediator or both?** Strong local economies attract data centers (confounder), and data centers bring construction jobs (mediator). Data: BLS LAUS county unemployment rates.
   - Stage 2: draw both arrows in the DAG before choosing controls.
7. **Does the effect fade with distance or grow with size?** If voters react to data centers, the effect should be larger near big facilities. This would support a causal reading.
   - Stage 1: the distance and size treatment versions (section 4).
   - Stage 2 (Ch. 8): nonlinear patterns in distance and MW.

### C. Heterogeneity: who reacts

8. **Do deep-red counties react differently?** This is the Humans First split (Trump +20 or more in 2024). Counties near 80–90% R have less room to fall (a ceiling). Each extra subgroup raises the chance of a false positive (multiple testing), so this is **exploratory only** and is reported as such.
9. **Does organized local resistance matter?** FracTracker's `community_pushback` column could show whether counties with contested projects swung differently from counties with quiet ones. Exploratory, and the most exposed to the selection problem in question 4.

### D. Better comparison groups

10. **Compare with counties that could have hosted a data center but didn't.** PNNL's projected data center sites (IM3 Projected US Data Center Locations) mark places with suitable power, water and fiber. Comparing treated counties with suitable but untreated ones is a fairer comparison.
    - Stage 3 (Ch. 21, 24): matching and appropriate control groups.

### E. What county data can never say

11. **Did Republicans switch parties or stay home?** County shares can't separate the two. The change in total votes (turnout) gives a partial hint.
12. **Ecological fallacy:** a pattern across counties says nothing certain about individual voters.

### F. Effects on the ballot itself

13. **Did data centers change whether races were contested?** Local anger about a data center could push a party to field a candidate in a district it used to skip. If so, contested races are partly a result of data centers, and dropping uncontested races removes exactly the places where that effect happened.
    - Stage 1: the check on dropped races (section 9, item 5).
    - Later: candidate entry as an outcome of its own.

## Change log

| Date | Change | Reason |
|------|--------|--------|
| 2026-11-14 | First version | Pre-registration before looking at results |
