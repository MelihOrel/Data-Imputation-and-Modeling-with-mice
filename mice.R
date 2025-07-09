library(mice)
set.seed(42)

# We'll generate data and then convert it to integers.
# This ensures we are working with whole numbers.
df <- data.frame(
  age = as.integer(rnorm(100, mean = 40, sd = 10)),
  height = as.integer(rnorm(100, mean = 175, sd = 12)),
  weight = as.integer(rnorm(100, mean = 80, sd = 8))
)

# Let's create a new dataframe to hold the missing data.
data_missing <- df

# We will randomly set some values in 'age' and 'weight' columns to NA.
# Set ~10% of 'age' to NA
missing_age_indices <- sample(1:nrow(data_missing), size = 10)
data_missing$age[missing_age_indices] <- NA

# Set ~15% of 'weight' to NA
missing_weight_indices <- sample(1:nrow(data_missing), size = 15)
data_missing$weight[missing_weight_indices] <- NA

# md.pattern() shows us how many values are missing in which variables.
md.pattern(data_missing)

# We will use 'pmm' (Predictive Mean Matching) as the method.
# This method is excellent for integer data because it imputes a missing value
# by borrowing an actual observed value from a similar record.
imputed_data <- mice(data_missing, m = 5, method = 'pmm', seed = 500)

# This shows the 5 imputed values for each row that was missing 'weight'.
print(imputed_data$imp$weight)


# Perform analysis and pool the results
# The standard practice is to run your analysis on all imputed datasets
# and then combine (pool) the results.

# Let's build a linear model to predict weight based on age and height.
# The with() function runs this model on each of the 5 imputed datasets.
model_fit <- with(data = imputed_data, exp = lm(weight ~ age + height))

# The pool() function combines the results from the 5 models
# into a single, robust result using Rubin's Rules.
pooled_results <- pool(model_fit)

# Print the final, pooled results
cat("\n--- Pooled Model Results ---\n")
summary(pooled_results)



