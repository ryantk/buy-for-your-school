# Require environment variables on initialisation
# https://github.com/bkeepers/dotenv#required-keys
if defined?(Dotenv)
  Dotenv.require_keys(
    "CONTENTFUL_SPACE",
    "CONTENTFUL_ENVIRONMENT",
    "CONTENTFUL_ACCESS_TOKEN",
    "CONTENTFUL_PLANNING_START_ENTRY_ID"
  )
end
