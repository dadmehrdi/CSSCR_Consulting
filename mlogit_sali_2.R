responses <- read.csv("/Users/dadmehr/R/CSSCR/Sali/DCE_responces.csv")
exp_d<-read.csv("/Users/dadmehr/R/CSSCR/Sali/exp_design_R.csv")

#merged_data <- inner_join(exp_d, responses_long, by = c("BLoCK", "QS"))

# Load necessary libraries
library(tidyr)
library(mlogit)
library(dplyr)

# Create a new dataframe with the reshaped data
new_data <- responses %>%
  pivot_longer(
    cols = q1:q18,
    names_to = "question",
    values_to = "response"
  ) %>%
  mutate(
    question = gsub("q", "", question),
    question = as.numeric(question)
  )

# View the new dataframe
head(new_data)

# Rename the columns and modify the QES column
exp_d <- exp_d %>%
  rename(
    question = QES,
    response = ALT
  ) %>%
  mutate(
    question = gsub("q", "", question),
    question = as.numeric(question)
  )

# View the modified dataframe
head(exp_d)

# Merge the two dataframes
merged_data <- merge(new_data, exp_d, by = c("question", "response"), all.x = TRUE)

# View the merged dataframe
head(merged_data)

# Convert the dataframe to an mlogit.data object
mlogit_data <- mlogit.data(merged_data, choice = "response", shape = "wide")

# Fit the mlogit model
model <- mlogit(response ~ 1 | Mortality_reduction + Disease_severity + Age_group + Financial_protection, data = mlogit_data)

# Print the summary of the model
summary(model)

