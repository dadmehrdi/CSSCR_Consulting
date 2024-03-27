install.packages("readr") # Install readr package
install.packages("httr") # Install httr package
install.packages("jsonlite") # Install jsonlite package

library(httr)
library(jsonlite)
library(readr) # Load the readr package

# Use this to load your data
df <- read.csv("path/to/your/file.csv")

# Instead I use this sample dataframe
df <- data.frame(
  ID = c("R1", "R2", "R3", "R4", "R5"),
  IP = c("204.112.85.145", "83.77.117.59", "191.181.189.173", "203.95.118.150", "34.41.170.141")
)

# Function to fetch location data from ipinfo.io
fetch_location_data <- function(ip, api_key) {
  response <- GET(paste0("https://ipinfo.io/", ip, "/json?token=", api_key))
  data <- fromJSON(content(response, "text"), flatten = TRUE)
  
  list(
    city = data$city,
    state = data$region,
    zipcode = data$postal
  )
}

# Visit ipinfo.io
# Sign up for an account or log in if you already have one.
# Once logged in, navigate to the API section or your account settings to find your API key.
# Copy the API key (Access Token on Token tab) and replace "your_api_key_here" in the script with your copied key.

# Replace 'your_api_key_here' with your actual ipinfo.io API key
# I ran the code below with my api key from my account
api_key <- "your_api_key_here"

# Apply the function to each IP address in the dataframe and collect results
locations <- lapply(df$IP, fetch_location_data, api_key = api_key)

# Convert the list of locations into a dataframe correctly
locations_df <- do.call(rbind, lapply(locations, function(x) {
  if (is.null(x$city)) x$city <- NA
  if (is.null(x$state)) x$state <- NA
  if (is.null(x$zipcode)) x$zipcode <- NA
  return(data.frame(matrix(unlist(x), nrow=1, byrow=TRUE)))
}))

# Set the column names for the new data frame
colnames(locations_df) <- c("City", "State", "Zipcode")

# Combine the original dataframe with the location dataframe
df <- cbind(df, locations_df)

# Print the updated dataframe
print(df)
