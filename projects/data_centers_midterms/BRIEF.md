# Data Centers & the 2026 Midterms — Project Brief

Nov 14, 2026 · @Felipe

## Context and research question

**Question:** Did Republicans lose more vote share in 2026 House races in US counties that host data centers than in counties that don't?

This is a self-study project. It applies Gabor Békés's *Data Analysis for Business, Economics, and Policy* chapter by chapter and will be published on Tableau Public. Stage 1 covers Ch. 1–6, the chapters read so far, ending at hypothesis testing.

- **Why it matters:** data centers became a bipartisan local issue in 2026 because of electricity bills, water use and tax deals. Voters rejected data center development in nearly every local ballot measure on the topic ([Al Jazeera](https://aljazeera.com/economy/2026/11/7/how-the-us-midterm-elections-reflected-resistance-to-data-centres)).
- **Prior analysis to replicate and improve:** Humans First, a conservative AI safety group, studied 1,540 counties in 16 states. Deep-red counties (Trump +20 or more in 2024) with large data centers swung about 2.1 points more toward Democrats than comparable counties without them. They frame it as an association, not proof of cause ([Fox News](https://www.foxnews.com/politics/red-counties-data-center-projects-swung-away-gop-midterms-analysis-finds.amp)).
- **No central federal election database:** states run elections. The FEC publishes certified results, compiled from the states, every two years. 2026 figures stay provisional until each state certifies ([FEC](https://www.fec.gov/introduction-campaign-finance/election-and-voting-information), [CRS](https://www.everycrsreport.com/files/2026-10-19_R46565_d06613315ec283937d7cf410769714677470cb7f.html)).

## Hypothesis design

The test compares the average swing between two groups of counties. It is not a one-sample test of whether Republicans lost share overall.

- **Why not one sample:** H₀ "change ≥ 0" vs. H₁ "change < 0" only tests the national mood. In a year Republicans lost ground broadly, it would reject everywhere and say nothing about data centers.
- **Unit of analysis: county.** Results are published by county everywhere, data centers can be geocoded to counties, and Census controls exist at that level. States are too few (about 50) and too coarse. Results aren't published by city. Congressional districts were redrawn in several states, which breaks the 2024 → 2026 comparison.
- **Outcome (swing):** Republican two-party share, R / (R + D), in the 2026 House race minus the same in 2024. Use election results, not polls, and drop uncontested races.
- **Treatment:** county hosts at least one data center (main definition). Robustness versions: within 5, 10 or 25 miles; operating vs. planned.

The test is a one-sided two-sample t-test:

- **H₀:** mean swing (data center counties) − mean swing (no data center) ≥ 0
- **H₁:** the difference is < 0, so Republicans lost more where data centers are

Report the confidence interval, not only the p-value. Stage 1 conclusion wording: "Counties with data centers swung X points more against Republicans (95% CI …). This is an association, not proof of cause."

## Data sources and data model

Every table joins on county FIPS (state\_fips for state-level geometry).

| Source | What it gives | Notes |
| --- | --- | --- |
| County election results (MIT Election Data + Science Lab, state election offices) | R and D House votes by county, 2020–2026 | 2026 provisional until certified; flag uncontested races |
| [PNNL IM3 Open Source Data Center Atlas](https://www.osti.gov/biblio/2550666) | Existing data center locations (CSV or GeoPackage, WGS84) | Built from OpenStreetMap; misses smaller facilities |
| Census ACS | Controls: income, education, urban/rural, density | Pull now, even if only used in Stage 2 |
| Census TIGER county shapes | County polygons for building the hex grid | Used only in the grid pipeline |

Data model tables:

| Table | Key | Columns |
| --- | --- | --- |
| fact\_results | fips, year | R votes, D votes, contested flag |
| dim\_county | fips | state\_fips, county name, ACS controls |
| data\_centers | id | lat, lon, county fips, status, distance to nearest |
| hex\_county | fips | hex polygon geometry, hex center lat/lon |
| hex\_state | state\_fips | dissolved state outline geometry, label point |

Sanity checks: county totals sum to state totals, no duplicate FIPS, uncontested races flagged, and the Connecticut and Alaska county quirks handled.

## Staged workflow (follows Békés)

The project grows with the reading. Each stage is a complete, publishable version on Tableau Public.

### Stage 1 — Ch. 1–6 (now)

- [ ] **Frame (Ch. 1):** write the question, unit, outcome and treatment. Pre-register H₀/H₁ and the main treatment definition before looking at results. Sketch the DAG.
- [ ] **Collect (Ch. 1):** election results 2020–2026, PNNL atlas, ACS, TIGER. Write a data-quality note per source (coverage, missing data, biases).
- [ ] **Prepare (Ch. 2):** build the tidy data model keyed on FIPS and run the sanity checks.
- [ ] **Build the hex grid pipeline** alongside data prep. The state-region layout is the fiddliest part.
- [ ] **Explore (Ch. 3):** distribution of swing, outliers, raw swing map, counts of treated counties by state.
- [ ] **Compare and test (Ch. 4–6):** group means, one-sided two-sample t-test, confidence interval.
- [ ] **Robustness (Ch. 4–6 tools):** alternative treatment definitions; the same test within a few large states.
- [ ] **Publish v1:** hex map tab + analytic notebook tab.
- [ ] Keep an "open questions" list in the notebook; it seeds Stages 2 and 3.

### Stage 2 — Ch. 7–10 (regression)

- Regress swing on the data center dummy, then add controls step by step and watch the coefficient move.
- Add state fixed effects; use robust standard errors clustered by state.
- New question: does the effect fade with distance? (Ch. 8, nonlinear patterns.)

### Stage 3 — Ch. 19–22 (causal)

- Matching: pair similar counties with and without data centers.
- Frame the swing outcome as difference-in-differences; check parallel trends with 2020 → 2022.
- State what can't be claimed: switching vs. not voting, and the ecological fallacy.

## DAG and causal thinking

A DAG (directed acyclic graph) is a causal diagram, as in Pearl's *The Book of Why*: arrows mean "causes" and there are no loops. It lists the assumptions about what drives both data center siting and the vote.

&#91;embedded content: causal DAG · treatment, outcome, confounders, mediator\]

Confounders affect both where data centers go and how counties vote, so they can fake or hide the effect. Electricity bills sit on the path from data center to vote, so controlling for them would hide part of the effect being measured.

- **Stage 1:** the DAG is the honest list of limitations ("this gap could also come from X and Y").
- **Stage 2:** it decides which controls go into the regression.
- **Stage 3:** it guides matching and the difference-in-differences assumptions.
- **Tool:** dagitty.net (free). Expect the DAG to change as you explore the data.

Limits to state in every stage: county data can't separate Republicans switching parties from Republicans staying home, and county patterns don't describe individual voters (ecological fallacy).

## Visualization plan (Tableau Public)

Two tabs: a county hex map for light readers and an analytic notebook. The hex map uses abstract coordinates, not real geography.

**Tab 1: hex map, layers from bottom to top**

1. County hexes: one hexagon per county, filled by winner (or swing), thin white or very light border.
2. State outlines: county hexes dissolved by state, no fill, 1px medium gray border (the subtle contour).
3. Data center flags: points at the hex centers via MAKEPOINT(hex\_lat, hex\_lon), shown only where has\_data\_center is TRUE.
4. Optional: state abbreviations at state label points, low opacity.

All layers must live in one data source, so the geometry tables relate to the election and data center tables through fips and state\_fips.

**Tab 2: analytic notebook** — question, data, method, results table, robustness checks, limitations. Scatterplots of swing against distance to the nearest data center carry the argument better than a map. Link the code and data model notes on GitHub.

**Hex grid pipeline**

1. Load TIGER county shapes.
2. Give each state its own region of the hex grid first, then place its counties inside it with R's geogrid package (run state by state). This keeps states contiguous so the outlines don't break into pieces.
3. Rescale the grid into a small lon/lat box around (0, 0), where Web Mercator barely distorts the hexagons.
4. Open the gaps between states: scale each state's group of hexes by about 0.97 around its own center. Hexes keep their shape and still touch inside the state. (The alternative, a negative buffer plus clipping, gives an even gap but cuts edge hexes.)
5. Dissolve by state\_fips for the state outlines, e.g. counties\_hex |> group\_by(state\_fips) |> summarise(), and compute label points.
6. Export to GeoJSON and/or a Hyper extract. The Hyper API supports a GEOGRAPHY column filled from WKT, so the geometry sits next to fips, swing and winner.
7. In Tableau, turn off the background map (Map → Background Maps → None).

## Next steps

- [ ] Write the R script for the hex grid (geogrid + state regions) and the Python script for the Hyper export.
- [ ] Download the PNNL atlas and county election results; start the data-quality notes.
- [ ] Draw the first DAG in dagitty.net.

## Sources

- [FEC – Election and voting information](https://www.fec.gov/introduction-campaign-finance/election-and-voting-information)
- [CRS – Federal Election Results: Frequently Asked Questions (Oct 2026)](https://www.everycrsreport.com/files/2026-10-19_R46565_d06613315ec283937d7cf410769714677470cb7f.html)
- [Fox News – Humans First analysis of red counties with data centers](https://www.foxnews.com/politics/red-counties-data-center-projects-swung-away-gop-midterms-analysis-finds.amp)
- [Al Jazeera – How the midterms reflected resistance to data centres](https://aljazeera.com/economy/2026/11/7/how-the-us-midterm-elections-reflected-resistance-to-data-centres)
- [PNNL IM3 Open Source Data Center Atlas (OSTI)](https://www.osti.gov/biblio/2550666)
