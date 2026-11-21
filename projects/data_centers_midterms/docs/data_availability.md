# Data availability check (Task 2)

Goal: find which states publish county-level 2026 House results, and in what form. This check decides the state inclusion rule (README section 7). Only check whether data **exist**. Don't look at the results.

## 2026 House results by state

Start with the states likely to have the most data centers, then extend.

| State | Official results link | By county? | Format (CSV / Excel / Clarity / HTML only) | Direct download link | Provisional or certified | Date checked | Notes |
|-------|-----------------------|------------|--------------------------------------------|----------------------|--------------------------|--------------|-------|
| Virginia | https://enr.elections.virginia.gov/results/public/virginia/elections/2026-November-General | Yes | `csv` | https://enr.elections.virginia.gov/cdn/results/d2c804ee-4ec2-46bb-91d7-5b41526eab03/Election%20Results_ab226c36-0939-4ded-a2a0-84d95c8b7ae3.csv | Provisional/Unofficial | 2026-11-20 7:30AM | The CSV contains all races, not only the House of Representatives. Locality (county or independent city), district and precinct each have their own ID. The locality ID is the county part of the FIPS code without leading zeros (Accomack = 1, FIPS 51001). Last updated 2026-11-19. |
| Texas | https://goelect.txelections.civixapps.com/ivis-enr-ui/county | Yes | `JSON`, base64-encoded | https://goelect.txelections.civixapps.com/api-ivis-system/api/s3/enr/ (API), endpoint: `election/countyInfo/53815` | Provisional/Unofficial | 2026-11-21 4:52PM | Dataset available only through the API, found while inspecting the app. Election ID 53815 (from endpoint `electionConstants`). Results come as county × district pieces (Harris has 9 districts). County IDs are 1–254 in the SOS's own alphabetical order, not FIPS: join to FIPS by county name. 254/254 counties reporting. Official canvass reports are listed but not yet published. Last updated 2026-11-04 10:48PM. |
| Georgia | | | | | | | |
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
| Georgia | | | | |
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
- **Redistricting:** Texas redrew its congressional map in 2025. Wikipedia says the 2025 map was the one used in November 2026. TODO: confirm with the SOS district chart (https://www.sos.state.tx.us/elections/forms/2026-district-chart-nov-3-general-election.pdf). Open question for the design: when district lines move, a county's voters may face different candidates in 2024 and 2026, and a piece can be contested in one year and not the other. Is the county two-party swing still comparable?
