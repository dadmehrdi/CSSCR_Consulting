# Install and load the mlogit package
#install.packages("mlogit")
library(mlogit)

# Create a sample dataset
set.seed(123)
n <- 50
salary <- rnorm(n, mean = 50000, sd = 10000)
income <- rnorm(n, mean = 60000, sd = 15000)
married <- sample(c(0, 1), n, replace = TRUE, prob = c(0.4, 0.6))

# Create a dataframe
df <- data.frame(salary, income, married)

# Convert the dataframe to an mlogit.data object
mlogit_data <- mlogit.data(df, choice = "married", shape = "wide")

# Fit the mlogit model
model <- mlogit(married ~ 1 | salary + income, data = mlogit_data)

# Print the summary of the model
summary(model)
