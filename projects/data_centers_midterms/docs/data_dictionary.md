# Data dictionary

The tidy data model from BRIEF.md. Every table joins on county FIPS (`fips`, 5-digit string with leading zeros) or state FIPS (`state_fips`, 2-digit string). Fill in types and descriptions as you build each table, and fix the plan where the data force you to.

## fact_results

One row per county-district piece and year (aggregated to county for the analysis).

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| fips | | | |
| year | | | |
| district | | | |
| r_votes | | | |
| d_votes | | | |
| contested | | | |

## county_swing (analysis table)

One row per county.

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| fips | | | |
| r_share_2024 | | | |
| r_share_2026 | | | |
| swing | | | |
| has_data_center | | | |
| | | | |

## dim_county

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| fips | | | |
| state_fips | | | |
| county_name | | | |
| | | | |

## data_centers

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| id | | | |
| lat | | | |
| lon | | | |
| fips | | | |
| status | | | |
| size | | | |
| distance_to_nearest | | | |

## hex_county

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| fips | | | |
| geometry | | | |
| hex_lat | | | |
| hex_lon | | | |

## hex_state

| Column | Type | Description | Source |
|--------|------|-------------|--------|
| state_fips | | | |
| geometry | | | |
| label_lat | | | |
| label_lon | | | |
