app <- strava_oauth(
  app_name = "Workout Predictor",
  app_client_id = "184491",
  app_secret = "705514dde6b9b41269122a7c0399cd86968528c2",
  cache = TRUE,
  app_scope = "activity:read_all"
)

library(rStrava)
library(dplyr)
library(lubridate)
library(glue)

saveRDS(stoken, "data/strava_token.rds")


# Function to fetch and format the most recent workout
get_recent_workout <- function(token_path = "data/strava_token.rds") {
  
  # Load saved authentication token
  stoken <- readRDS(token_path)
  
  # Get activities
  acts <- get_activity_list(stoken)
  df <- compile_activities(acts)
  
  # Find the most recent
  recent <- df %>%
    arrange(desc(start_date_local)) %>%
    slice(1) %>%
    mutate(
      distance_miles = round(distance / 1609.34, 2),
      moving_time_min = round(moving_time / 60, 1),
      date = as.Date(start_date_local)
    )
  
  # Create a simple display string
  msg <- glue(
    "**{recent$type}** — {recent$distance_miles} miles in {recent$moving_time_min} min on {recent$date}."
  )
  
  return(msg)
}
get_recent_workout('dcf49e688aa33e25021eee55ac91fb11cab6ed83')
