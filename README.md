# COMP3020 Group Project: "Climate Change" vs "Climate Crisis" on Bluesky

How does framing ("climate change" vs "climate crisis") shape the conversation on Bluesky?

## Data
- Collected from Bluesky with the `atrrr` R package on 1 Oct 2026 (7:49pm AEST)
- `posts_raw.rds`: 4,148 posts as collected
- `posts_clean.rds`: 2,400 posts after cleaning (1,513 "change", 887 "crisis")
- `pilot.rds`: comparison of 6 candidate topics
- `cleaning_steps.rds`: number of posts left after each cleaning step

## Scripts (run in order)
1. `01_collection_cleaning.R`: pilot, data collection and cleaning
2. Text analysis, hypothesis test, clustering and network scripts (to be added)

## How to reproduce
- Install packages: `atrrr`, `dplyr`, `stringr`
- The data is already saved, so you don't need to collect it again.
  Re-running the collection gives different posts because Bluesky changes over time.
- To reproduce the cleaning, run Part 3 of `01_collection_cleaning.R`.
- No passwords or API keys are stored in this repository.
