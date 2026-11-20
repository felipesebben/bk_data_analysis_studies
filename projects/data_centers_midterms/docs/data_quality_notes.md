# Data quality notes

One section per source. Fill them in as you collect (Ch. 1: how the data were born decides what they can tell you).

For each source answer:

- **What it is:** who produced it, and why.
- **Coverage:** which places and years, and what is missing.
- **Unit and level:** what one row is (precinct, county, county-district piece, facility).
- **How it was collected:** official count, volunteers, model, news monitoring.
- **Possible biases:** what kind of place or record is more or less likely to appear.
- **Download:** link, date, file name, license.
- **Known problems found:** typos, duplicates, odd values, changes between downloads.

---

## 2026 House results (state election offices)

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

## 2024 House results

- What it is: Harvard Dataverse dataset with the 2024 general election results, including House elections.
- Coverage: results for all states in 2024. Each file has every race (president, Senate, state races).
- Unit and level: precinct level, but each row also has the FIPS code, county and state.
- How it was collected: downloaded as one CSV file per state.
- Possible biases: none so far.
- Download:
- Known problems found:

### Comments

- `office`: `US HOUSE` is the US House race.
- `county_fips`: stored as a string. It's the Census 5-digit code: the first 2 digits are the state code and the last 3 are the county code. For Alaska and Louisiana it identifies boroughs and parishes; for Connecticut it identifies planning regions.
- `mode`: the voting mode. It is set to `TOTAL` when the results are not broken down by mode.
  - The Virginia 2024 file doesn't break results down by mode: `mode` is only `TOTAL`.
- Party fields:
  - `party_detailed`: the candidate's detailed party. In states with fusion voting, such as New York, a candidate can run on several party lines, and these are reported as such. Blank for ballot measures.
  - `party_simplified`: standardized party label.
  - Which field we'll use: `party_simplified`, because it standardizes party names across states. Also, it is our reference for ballot measures.
- `candidate`: candidate name, standardized within each state. Overvotes and undervotes must be removed, because they are invalid votes and are not part of the final count. Should write-ins be excluded? States seem to have different rules on how they count them.

## 2020 and 2022 House results (placebo)

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

## PNNL IM3 Open Source Data Center Atlas (main treatment)

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

## FracTracker data center database (robustness treatment)

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

## Census TIGER county shapes

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

## Census ACS (controls, used in Stage 2)

- What it is:
- Coverage:
- Unit and level:
- How it was collected:
- Possible biases:
- Download:
- Known problems found:

---

## Dropped observations log

Every row removed from the analysis, and why. Needed for the check on dropped races (README section 9, item 5).

| Step | What was dropped | How many | Reason |
|------|------------------|----------|--------|
| | | | |
