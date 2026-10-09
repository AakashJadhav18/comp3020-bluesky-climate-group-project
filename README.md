# COMP3020 Group Project: "Climate Change" vs "Climate Crisis" on Bluesky

How does framing ("climate change" vs "climate crisis") shape the conversation on Bluesky?

**Group 14:** Aakash Jadhav, Miciella Ngo, Pushti Patel

## Data
- Collected from Bluesky with the `atrrr` R package on 1 Oct 2026 (7:49pm AEST)
- `posts_raw.rds`: 4,148 posts as collected
- `posts_clean.rds`: 2,400 posts after cleaning (1,513 "change", 887 "crisis")
- `pilot.rds`: comparison of 6 candidate topics
- `cleaning_steps.rds`: number of posts left after each cleaning step

## Files
- `Final_Report_Group14_COMP3020_Social_Web_Analytics.Rmd` / `.pdf`: final submitted report
- `2.1_Data_Collection.Rmd`: data collection and cleaning
- `2.2_Hypothesis_Testing.Rmd`: chi-squared test of framing vs engagement
- `2.3_Text_Content_Analysis_Visualisation.Rmd`: word frequencies and word clouds
- `2.4_Clustering.Rmd`: TF-IDF, hierarchical clustering and k-means
- `2.5_Network_Analysis.Rmd`: reply network and centrality
- `01_collection_cleaning.R`: original collection and cleaning script

## How to reproduce
- Install packages: `dplyr`, `stringr`, `knitr`, `ggplot2`, `tm`, `SnowballC`, `wordcloud`, `RColorBrewer`, `igraph`, `kableExtra` (and `atrrr` only to re-collect data)
- Knit the final report, or run sections 2.1 to 2.5 in order
- The data is already saved, so you don't need to collect it again. Re-running the collection gives different posts because Bluesky changes over time.
- No passwords or API keys are stored in this repository.
