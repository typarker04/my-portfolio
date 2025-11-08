library(rStrava)

# Replace with your app info
stoken <- strava_oauth(
  app_name = "Workout Predictor",
  app_client_id = "184491",
  app_secret = "705514dde6b9b41269122a7c0399cd86968528c2",
  cache = TRUE,
  app_scope = "activity:read_all"
)


# Save it as an .rds file
saveRDS(stoken, "data/strava_token.rds")
