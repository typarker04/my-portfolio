# ==============================================================
# setup_and_update_strava.R
# ==============================================================
# Purpose:
#   1. Authenticate with the Strava API and save a valid token (.rds)
#   2. Fetch your most recent activities
#   3. Save them as a CSV for your Quarto site
# ==============================================================

# ---- Libraries ----
library(rStrava)
library(dplyr)
library(lubridate)
library(readr)
library(glue)

# ---- Configuration ----
app_name <- "Workout Predictor"         # Your Strava app name
app_client_id <- "184491"               # Your Strava Client ID
app_secret <- "705514dde6b9b41269122a7c0399cd86968528c2" # Your Strava Client Secret
app_scope = "activity:read_all"
token_path <- "data/strava_token.rds"
output_path <- "data/strava_activities.csv"

# ---- Step 1: Create or load token ----
if (!file.exists(token_path)) {
  message("🔑 No Strava token found — starting OAuth authentication...")
  
  # This opens a browser window for you to approve access once
  stoken <- strava_oauth(
    app_name = app_name,
    app_client_id = app_client_id,
    app_secret = app_secret,
    cache = FALSE,
    app_scope = app_scope
  )
  
  saveRDS(stoken, token_path)
  message(glue("✅ Token saved to '{token_path}'"))
} else {
  stoken <- readRDS(token_path)
  message(glue("🔁 Loaded existing token from '{token_path}'"))
}

# ---- Step 2: Fetch activities ----
message("📡 Fetching recent Strava activities...")

acts <- get_activity_list(stoken)
df <- compile_activities(acts)

# ---- Step 3: Clean and transform ----
clean_df <- df %>%
  mutate(
    date = as.Date(start_date_local),
    distance_miles = round(distance*1000 / 1609, 2),
    moving_time_min = round(moving_time / 60, 1),
    pace_min_mile = round(moving_time_min / distance_miles, 2),
    activity_name = name
  ) %>%
  select(date, activity_name, type, distance_miles, moving_time_min, pace_min_mile)

# ---- Step 4: Save CSV ----
write_csv(clean_df, output_path)
message(glue("✅ Saved {nrow(clean_df)} activities to '{output_path}'"))

# ---- Step 5: Print summary of the most recent workout ----
recent <- clean_df %>%
  arrange(desc(date)) %>%
  slice(1)

message(glue(
  "🏃 Most recent activity: {recent$type} — {recent$distance_miles} miles in {recent$moving_time_min} min on {recent$date}."
))
