# COMP3020 Group Project - Bluesky: "climate change" vs "climate crisis"
# Data collection and cleaning
# Written by: Aakash Jadhav

# NOTE: The data was collected on 1 Oct 2026 at 7:49pm (AEST).
# If you run the collection part again, Bluesky will give different posts.
# The save lines are turned off (#) so our original data doesn't get replaced.
# To check our cleaning, just run Part 3 - it uses the saved posts_raw.rds.

library(atrrr)    # for getting data from Bluesky
library(dplyr)    # for working with tables
library(stringr)  # for working with text


# ---- Part 1: Log in to Bluesky (we used Aakash's account) ----
auth(user = "aakash18.bsky.social")


# ---- Part 2: Pick a topic ----

# Bluesky sometimes gives a "502" server error, so this function
# tries the search again (up to 3 times) instead of crashing.
get_posts <- function(t, limit = 500, tries = 3) {
  for (i in 1:tries) {
    p <- tryCatch(search_post(t, limit = limit), error = function(e) NULL)
    if (!is.null(p)) return(p)
    message("Retry ", i, " for: ", t)
    Sys.sleep(5)
  }
  NULL
}

# We tried 6 topics first to see which one had the best data
topics <- c("nursing shortage", "AI healthcare", "housing crisis australia",
            "climate change", "climate crisis", "net zero")

# For each topic, get about 500 posts and count:
# number of posts, different users, % of posts with likes,
# typical likes, % that mention someone (@), % that got replies
pilot <- lapply(topics, function(t) {
  p <- get_posts(t)
  Sys.sleep(2)
  if (is.null(p)) return(tibble(topic = t, posts = NA))
  tibble(
    topic          = t,
    posts          = nrow(p),
    unique_authors = n_distinct(p$author_handle),
    pct_liked      = round(mean(p$like_count > 0) * 100, 1),
    median_likes   = median(p$like_count),
    pct_mentions   = round(mean(str_detect(p$text, "@\\w")) * 100, 1),
    pct_replied    = round(mean(p$reply_count > 0) * 100, 1)
  )
}) |> bind_rows()

pilot

# The climate topics had the most users, likes and mentions, so we chose them.
# (nursing shortage didn't work as Bluesky kept giving errors)

# saveRDS(pilot, "pilot.rds")   # already saved on 1 Oct 2026 - don't overwrite


# Quick look at 100 posts to make sure they are actually about climate.
# We found some non-English posts and some that didn't use the phrase,
# so we changed our search and cleaning to fix that.
cc <- get_posts("climate crisis", limit = 100)
head(cc$text, 10)


# Main data collection:
# - quotes "" make Bluesky search for the exact phrase
# - lang:en keeps only English posts
# - up to 2000 posts for each phrase
q_crisis <- get_posts('"climate crisis" lang:en', limit = 2000)
Sys.sleep(5)
q_change <- get_posts('"climate change" lang:en', limit = 2000)

# Put both searches into one table and label where each post came from
posts_raw <- bind_rows(
  q_crisis |> mutate(search_term = "climate crisis"),
  q_change |> mutate(search_term = "climate change")
)

# saveRDS(posts_raw, "posts_raw.rds")   # already saved on 1 Oct 2026 - don't overwrite

nrow(posts_raw)                  # we got 4148 posts
count(posts_raw, search_term)    # 2085 crisis, 2063 change
Sys.time()


# ---- Part 3: Clean the data ----

# Starting from our saved raw data, so the result is always the same
posts_raw <- readRDS("posts_raw.rds")
n0 <- nrow(posts_raw)

# Step 1: remove empty posts, and posts that showed up in both searches.
# Also check which phrase each post actually uses.
posts_clean <- posts_raw |>
  filter(!is.na(text), text != "") |>
  distinct(uri, .keep_all = TRUE) |>
  mutate(
    text_lower = str_to_lower(text),
    has_crisis = str_detect(text_lower, "climate crisis"),
    has_change = str_detect(text_lower, "climate change"),
    framing = case_when(
      has_crisis & has_change ~ "both",
      has_crisis ~ "crisis",
      has_change ~ "change",
      TRUE ~ NA_character_
    ),
    n_words = str_count(text, "\\S+")
  )
n1 <- nrow(posts_clean)

# Step 2: keep posts that use only ONE of the two phrases.
# Posts using neither (matched through a link) or both can't be put
# into one group, so we take them out.
posts_clean <- posts_clean |> filter(!is.na(framing), framing != "both")
n2 <- nrow(posts_clean)

# Step 3: remove very short posts (less than 5 words) - not enough text to analyse
posts_clean <- posts_clean |> filter(n_words >= 5)
n3 <- nrow(posts_clean)

# Step 4: remove posts with the exact same text (bots and copy-paste spam)
posts_clean <- posts_clean |> distinct(text_lower, .keep_all = TRUE)
n4 <- nrow(posts_clean)

# Step 5: keep only the columns we need for the analysis
posts_clean <- posts_clean |>
  select(uri, author_handle, author_name, text, framing, n_words,
         like_count, repost_count, reply_count, any_of("quote_count"), indexed_at)

# Table showing how many posts were left after each step (for the report)
cleaning_steps <- tibble(
  step  = c("Raw posts", "Empty/duplicate posts removed",
            "Phrase in text (one framing only)", "5+ words", "Duplicate text removed"),
  posts = c(n0, n1, n2, n3, n4)
)

cleaning_steps                  # 4148 -> 2400 posts
count(posts_clean, framing)     # 1513 change, 887 crisis

# Save the clean data for the rest of the group
saveRDS(posts_clean, "posts_clean.rds")
saveRDS(cleaning_steps, "cleaning_steps.rds")


