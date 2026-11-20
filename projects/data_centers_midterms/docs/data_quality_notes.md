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

- What it is: official election-night results published by each state's election office. They stay unofficial (provisional) until the state certifies them.
  - Virginia: Virginia Department of Elections results site, one CSV with all races.
- Coverage: statewide results for each state. Check each state's status (official or not).
- Unit and level: may vary across states.
  - Virginia: precinct level, with locality (county or independent city) and district IDs.
- How it was collected: CSV file downloaded manually.
- Possible biases: provisional numbers can change until certification, so the download date matters.
- Download:
  - Virginia: https://enr.elections.virginia.gov/cdn/results/d2c804ee-4ec2-46bb-91d7-5b41526eab03/Election%20Results_ab226c36-0939-4ded-a2a0-84d95c8b7ae3.csv (checked 2026-11-20; the site says last updated 2026-11-19). The file name contains random codes, so the link may change when results are updated.
- Known problems found:
  - Virginia: some rows have `United States Of America` as `DistrictName`. TODO: check which offices these rows belong to (probably races elected statewide or nationwide, which the `US HOUSE` filter removes).
  - Virginia: the `Locality` code is the county part of the FIPS code with the leading zeros dropped. Evidence: Accomack County = `1` (FIPS 51001), Fairfax County = `59` (FIPS 51059), Alexandria city = `510` (FIPS 51510).
    - Fix in the prepare step: pad the code to 3 digits and add the state code in front (`51` + `001` = `51001`).
    - Take the state codes from an official source, not typed by hand: the MEDSL 2024 files have `state_po` and `state_fips`, which give a lookup table from state abbreviation to state FIPS code (VA → `51`).
    - Keep all FIPS codes as text, not numbers. Stored as a number, Arizona's `04` becomes `4` and breaks the 5-digit code.
    - Check: every 5-digit code built for 2026 must also appear in the 2024 file and in the TIGER county shapes. A code that doesn't match points to a padding error or a special case.

## 2024 House results

- What it is: precinct-level 2024 general election returns compiled by MEDSL (MIT Election Data and Science Lab), hosted on Harvard Dataverse.
- Coverage: results for all states in 2024. Each file has every race (president, Senate, state races).
- Unit and level: precinct level, but each row also has the FIPS code, county and state.
- How it was collected: MEDSL collected the official results from each state and county, converted them to one format and checked them against official totals (according to the GitHub notes). It is a secondary source: the numbers are a copy of the official numbers. Downloaded as one CSV file per state.
- Possible biases: `votes` may contain the string `*` where small jurisdictions redact vote counts to prevent identifying voters. This could lead to totals being undercounted for counties, which can bias their share if the redacted votes lean one way. 
  - In pandas, the whole column is read as `text`, so a sum either raises an error or joins the strings together. We'll probably need to use `to_numeric()` to convert strings to numbers and `*` to `NaN`.
  - Quick check: Virginia sample does not contain any `*` in `US HOUSE` rows.
- Download: https://doi.org/10.7910/DVN/NYTPDU (version 1.0, file `2024-va-precinct-general`, license CC0 1.0, downloaded 2026-11-20)
- Known problems found:
  - District codes have 3 digits here, while Virginia's 2026 results store them as a single digit. Standardize before joining.

### Comments

- `office`: `US HOUSE` is the US House race.
- `county_fips`: stored as a string. It's the Census 5-digit code: the first 2 digits are the state code and the last 3 are the county code. For Alaska and Louisiana it identifies boroughs and parishes; for Connecticut it identifies planning regions.
- `mode`: the voting mode. It is set to `TOTAL` when the results are not broken down by mode.
  - The Virginia 2024 file doesn't break results down by mode: `mode` is only `TOTAL`.
- Party fields:
  - `party_detailed`: the candidate's detailed party. In states with fusion voting, such as New York, a candidate can run on several party lines, and these are reported as such. 
  - `party_simplified`: standardized party label.
  - Which field we'll use: `party_simplified`, because it standardizes party names across states. 
- `candidate`: candidate name, standardized within each state. Overvotes and undervotes must be removed, because they are invalid votes and are not part of the final count. Should write-ins be excluded? States seem to have different rules on how they count them.
  - Our outcome is R / (R + D), so we can safely ignore write-ins.
- `special`: boolean flag for special elections. In Virginia, `TRUE` returns local elections such as school board members. We should keep `FALSE` and/or filter `office` to `US HOUSE`.
- `stage`: string with the stage of the election. When `office` = `US HOUSE`, it is only `GEN`.
- `district`: district identifier. Values differ by election. For `US HOUSE`, it is zero-padded to 3 digits.
- `magnitude`: numeric; the number of candidates a voter may select for an office. Can be more than 1. In Virginia, `US HOUSE` rows have only 1.

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
