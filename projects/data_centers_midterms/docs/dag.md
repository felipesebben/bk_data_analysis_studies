# DAG (causal diagram)

A DAG is a drawing of what causes what. Arrows mean "causes," and no arrow loops back. It writes your assumptions down so others can check them. Expect it to change as you explore the data.

## Words used here

- **Treatment:** the thing whose effect we ask about (hosting a data center).
- **Outcome:** what we measure the effect on (the swing).
- **Confounder:** something that affects both the treatment and the outcome. It can create a gap the treatment didn't cause. Example: suburbs attract data centers and were already moving away from Republicans.
- **Mediator:** a step in the middle of the effect. The treatment causes it, and it causes the outcome. Example: data center → higher electricity bills → vote change. Don't control for mediators, or you hide part of the effect.

## Starting list of nodes

Add, remove or rename as you think it through.

| Node | Role (treatment / outcome / confounder / mediator / unsure) | Why |
|------|------------------------------------------------------------|-----|
| Data center in county | treatment | |
| Swing 2024 → 2026 | outcome | |
| Suburban / urban | | |
| Power, water and fiber infrastructure | | |
| State (laws, tax deals, statewide races) | | |
| Electricity bills | | |
| Local jobs and construction | | |
| Local news coverage and protests | | |
| Candidates (open seat, incumbent) | | |
| 2024 partisanship (deep red or not) | | |

## Drawing

Draw it at [dagitty.net](https://dagitty.net). Paste the model code below so the DAG lives in the repo, and save a picture to `../output/dag.png`.

```
TODO: dagitty model code
```

## What this DAG means for each stage

- **Stage 1 (tests):** the confounders are the list of limitations ("the gap could also come from X and Y").
- **Stage 2 (regression):** confounders go into the regression as controls; mediators don't.
- **Stage 3 (causal):** guides matching and the difference-in-differences assumptions.

## Versions

| Date | Change |
|------|--------|
| | First draft |
