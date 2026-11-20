# Data availability check (Task 2)

Goal: find which states publish county-level 2026 House results, and in what form. This check decides the state inclusion rule (README section 7). Only check whether data **exist**. Don't look at the results.

## 2026 House results by state

Start with the states likely to have the most data centers, then extend.

| State | Official results link | By county? | Format (CSV / Excel / Clarity / HTML only) | Direct download link | Provisional or certified | Date checked | Notes |
|-------|-----------------------|------------|--------------------------------------------|----------------------|--------------------------|--------------|-------|
| Virginia | https://enr.elections.virginia.gov/results/public/virginia/elections/2026-November-General | Yes | `csv` | https://enr.elections.virginia.gov/cdn/results/d2c804ee-4ec2-46bb-91d7-5b41526eab03/Election%20Results_ab226c36-0939-4ded-a2a0-84d95c8b7ae3.csv | Provisional/Unofficial | 2026-11-20 7:30AM | The CSV contains all races, not only the House of Representatives. Locality (presumably county), district and precinct each have their own ID. Last updated 2026-11-19. |
| Texas | | | | | | | |
| Georgia | | | | | | | |
| Ohio | | | | | | | |
| Arizona | | | | | | | |
| Oregon | | | | | | | |
| Iowa | | | | | | | |

Tip: Clarity (Scytl) results pages have `clarityelections.com` in the URL. States on Clarity share one format.

## 2024 House results by county

| State | Source (MEDSL precinct / OpenElections / state site) | Link | By county, or must be aggregated? | Notes |
|-------|------------------------------------------------------|------|-----------------------------------|-------|
| Virginia |  MEDSL | https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910%2FDVN%2FNYTPDU&version=&q=&fileTypeGroupFacet=&fileAccess=&fileSortField=name&fileSortOrder=desc&tagPresort=true&folderPresort=true#| County | |
| Texas | | | | |
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
