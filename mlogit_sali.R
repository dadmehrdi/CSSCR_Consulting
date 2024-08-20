responses <- read.csv("/Users/dadmehr/R/CSSCR/Sali/DCE_responces.csv")
exp_d<-read.csv("/Users/dadmehr/R/CSSCR/Sali/exp_design_R.csv")

#merged_data <- inner_join(exp_d, responses_long, by = c("BLoCK", "QS"))



# Load necessary libraries
library(tidyr)
library(mlogit)
library(dplyr)


# Assuming your datasets are named 'responses' and 'exp_d'
# Reshape the 'responses' dataset to long format
responses_long <- responses %>%
  pivot_longer(cols = starts_with("q"), 
               names_to = "QES", 
               names_prefix = "q",
               values_to = "response")

# Convert 'QES' in responses_long to match the format in 'exp_d'
responses_long$QES <- paste0("q", responses_long$QES)

# Merge with 'exp_d' based on 'QES'
merged_data <- merge(responses_long, exp_d, by = "QES")

merged_data$ALT <- merged_data$ALT-1
merged_data$response <- merged_data$response-1


# Convert necessary columns to appropriate types
merged_data$Disease_severity <- as.factor(merged_data$Disease_severity)
merged_data$Age_group <- as.factor(merged_data$Age_group)
merged_data$QES <- as.factor(merged_data$QES)

# Convert response to logical
merged_data$response <- as.logical(as.numeric(as.character(merged_data$response)))

# Remove rows with NA in the response column
merged_data <- merged_data[!is.na(merged_data$response), ]

# Verify that NA values have been removed
sum(is.na(merged_data$response))  # Should return 0
merged_data %>% count(response)


# Convert the data to the required format for mlogit
mlogit_data <- mlogit.data(merged_data, choice = "response", shape = "long", 
                           id.var = "ID", alt.var = "ALT")


# Fit the standard logit model
model <- mlogit(response ~ Disease_severity + Age_group + Financial_protection + Mortality_reduction | 0, 
                data = mlogit_data)

# Summarize the results
summary(model)