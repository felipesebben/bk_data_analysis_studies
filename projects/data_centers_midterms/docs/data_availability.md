# Data availability check (Task 2)

Goal: find which states publish county-level 2026 House results, and in what form. This check decides the state inclusion rule (README section 7). Only check whether data **exist**. Don't look at the results.

## 2026 House results by state

Start with the states likely to have the most data centers, then extend.

| State | Official results link | By county? | Format (CSV / Excel / Clarity / HTML only) | Direct download link | Provisional or certified | Date checked | Notes |
|-------|-----------------------|------------|--------------------------------------------|----------------------|--------------------------|--------------|-------|
| Virginia | https://enr.elections.virginia.gov/results/public/virginia/elections/2026-November-General | Yes | `csv` | https://enr.elections.virginia.gov/cdn/results/d2c804ee-4ec2-46bb-91d7-5b41526eab03/Election%20Results_ab226c36-0939-4ded-a2a0-84d95c8b7ae3.csv | Provisional/Unofficial | 2026-11-20 7:30AM | The CSV contains all races, not only the House of Representatives. Locality (county or independent city), district and precinct each have their own ID. The locality ID is the county part of the FIPS code without leading zeros (Accomack = 1, FIPS 51001). Last updated 2026-11-19. |
| Texas | https://goelect.txelections.civixapps.com/ivis-enr-ui/county | Yes | `JSON`, base64-encoded | https://goelect.txelections.civixapps.com/api-ivis-system/api/s3/enr/ (API), endpoint: `election/countyInfo/53815` | Provisional/Unofficial | 2026-11-21 4:52PM | Dataset available only through the API, found while inspecting the app. Election ID 53815 (from endpoint `electionConstants`). Results come as county × district pieces (Harris has 9 districts). County IDs are 1–254 in the SOS's own alphabetical order, not FIPS: join to FIPS by county name. 254/254 counties reporting. Official canvass reports are listed but not yet published. Last updated 2026-11-04 10:48PM. |
| Georgia | https://results.sos.ga.gov (TODO: exact election page URL) | Yes | `xlsx` | https://results.sos.ga.gov/cdn/results/09378a07-e6cf-4f66-be7c-ca4aa534f99a/Total%20Votes%20Results_b4156d6b-fdd0-46b8-885a-2cb1b8c0349b.xlsx | TODO | 2026-11-21 | Same results platform as Virginia (`/cdn/results/<id>/` link with random codes). Three sheets: `Total Votes` (statewide), `Total Votes by Group` (statewide by vote mode: Election Day, Advance Voting, Absentee by Mail, Provisional), `County Results` (county × contest × candidate, total only). All 159 counties. U.S. House offices are named `US House of Representatives - District N` (14 districts); split counties have one piece per district. Counties are names with " County" (`Appling County`), no FIPS. Each contest also has `Total Votes` and `Ballots Cast` rows with no party: drop them. TODO: last-updated time. |
| Ohio | | | | | | | |
| Arizona | | | | | | | |
| Oregon | | | | | | | |
| Iowa | | | | | | | |

Tip: Clarity (Scytl) results pages have `clarityelections.com` in the URL. States on Clarity share one format.

## 2024 House results by county

| State | Source (MEDSL precinct / OpenElections / state site) | Link | By county, or must be aggregated? | Notes |
|-------|------------------------------------------------------|------|-----------------------------------|-------|
| Virginia | MEDSL | https://doi.org/10.7910/DVN/NYTPDU | Precinct; must be added up by county using `county_fips` | doi:10.7910/DVN/NYTPDU, version 1.0, file 2024-va-precinct-general, license CC0 1.0, 2026-11-20. |
| Texas | MEDSL | https://doi.org/10.7910/DVN/NYTPDU | Precinct; must be added up by county using `county_fips` | doi:10.7910/DVN/NYTPDU, version 1.0, file 2024-tx-precinct-general, license CC0 1.0, 2026-11-21. `mode` is only `TOTAL`, no `*` in `US HOUSE` votes, 38 districts. 960 `US HOUSE` rows have `special = TRUE` (a special House election held alongside the regular one): drop them. |
| Georgia | MEDSL | https://doi.org/10.7910/DVN/NYTPDU | Precinct; must be added up by county using `county_fips` | doi:10.7910/DVN/NYTPDU, version 1.0, file 2024-ga-precinct-general (Dataverse file ID 13731164), license CC0 1.0, 2026-11-21. `mode` is only `TOTAL`, no `*` in `US HOUSE` votes, no `special = TRUE` House rows. 2 `US HOUSE` rows have the pseudo-county `STATE FLOATING` (no FIPS, districts 6 and 11, 0.2% of House votes): drop them. |
| Ohio | | | | |
| Arizona | | | | |
| Oregon | | | | |
| Iowa | | | | |

## 2020 and 2022 House results by county (placebo test)

Not needed now. Fill in once the 2024–2026 sources are settled.

| State | Source | Link | Notes |
|-------|--------|------|-------|
| | | | |

## State inclusion rule

> TODO: write the rule once the tables above are filled, then copy it into README section 7 and log the change.

## Findings and surprises

> TODO: anything unexpected (states that report by town, missing counties, files that changed between visits, etc.).

### Texas (2026-11-21)

- **No download button.** The SOS results app is a JavaScript app. The data was found by opening the app's main JS file, searching it for `api`, and calling the endpoints. Each response is JSON with a base64-encoded payload that must be decoded.
- **The SOS county ID cannot be turned into FIPS by a formula.** `48 + (2 × id − 1)` works for 244 counties but fails for 9 (Madison through McMullen, SOS IDs 154–162). Census FIPS sorts "Mc" counties as if spelled "Mac", before Madison (McCulloch = 48307). The SOS list puts them after Maverick. Spot checks (Anderson, Harris, Zavala) all pass, which is why this is easy to miss. Fix: join on county name.
- **One county name differs:** SOS `LASALLE`, MEDSL `LA SALLE`. The other 253 match exactly.
- **Precinct count oddity:** the API reports 202 of 200 precincts reporting.
- **2024 special election:** MEDSL has `special = TRUE` rows for a special U.S. House election held on the same day. Keeping them would count the same voters twice.
- **Use `office == "US HOUSE"`**, not a loose "HOUSE" match: MEDSL also has `STATE HOUSE` (150 districts).
- **Redistricting confirmed (2026-11-21):** the 2026 SOS district chart (https://www.sos.state.tx.us/elections/forms/2026-district-chart-nov-3-general-election.pdf) assigns counties to different districts than the MEDSL 2024 file (2021 map). The first three counties in alphabetical order were checked:

  | County | 2024 (MEDSL, 2021 map) | 2026 (SOS chart) | Changed? |
  |--------|------------------------|------------------|----------|
  | Anderson | 6 | 5 | Yes |
  | Andrews | 19 | 19 | No |
  | Angelina | 17 | 15 and 27 (split) | Yes |

  Angelina is the strongest evidence: it went from one whole district to a split between two, so the lines moved, not just the numbers. 2 of 3 counties changed, and they were picked by alphabetical order, not because a change was expected.
- **Why it matters for the design:** in a county whose districts changed, voters faced different candidates in 2024 and 2026, so part of the "swing" may come from the new candidates, not from anything about data centers. A piece can also be contested in one year and not the other. Prepare phase: compute a per-county `districts_changed` flag (has the county's set of districts changed between 2024 and 2026?). Possible robustness check: does the result hold in counties whose districts did not change? Decide whether to pre-register it before looking at any results.

### Georgia (2026-11-21)

- **Easy case.** One Excel file with a county sheet, from the same results platform as Virginia, so the two states can share some cleaning code.
- **County names match MEDSL exactly** once the " County" suffix is removed and names are upper-cased: all 159 match. No ID or formula needed.
- **No redistricting between 2024 and 2026.** All 159 counties have the same set of U.S. House districts in both years (checked for every county, not a sample). Expected: Georgia's map was redrawn in late 2023, before the 2024 election. So `districts_changed` = 0 for every Georgia county.
- **`STATE FLOATING` in MEDSL 2024:** 2 `US HOUSE` rows not assigned to any county (no FIPS; districts 6 and 11; 0.2% of House votes). They can't go to a county, so they drop out of a county-level analysis.
- **Bilingual office names:** some State House contests have Spanish text added (`... District 102/ Para la Cámara de Representantes del Estado Distrito 102`). The U.S. House names don't, but filter on the start of the name (`US House of Representatives`), not on an exact full match.
- **Excel needs `openpyxl`:** pandas can't read `.xlsx` without it. Add it with `uv add openpyxl` in the Collect phase.
