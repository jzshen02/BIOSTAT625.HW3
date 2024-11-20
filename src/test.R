# Load necessary libraries
library(Rcpp)
library(RcppArmadillo)
library(haven)

# Source the Rcpp implementation
Rcpp::sourceCpp("src/linear_model.cpp")

# Load the dataset
data_path <- system.file("extdata", "test.sas7bdat", package = "BIOSTAT625.HW3")
dataset <- haven::read_sas(data_path)

# Select response and predictor variables
response_var <- "EducationHS" # Example response variable
predictor_vars <- c("Age", "Comorbidity1") # Example predictor variables
X <- as.matrix(dataset[, predictor_vars])
Y <- as.numeric(dataset[[response_var]])

# Fit the model using Rcpp
rcpp_fit <- fit_linear_model_rcpp(X, Y)

# Fit the model using R's built-in lm
lm_fit <- lm(EducationHS ~ Age + Comorbidity1, data = dataset)

# Compare coefficients
cat("Coefficients comparison:\n")
print(all.equal(rcpp_fit, coef(lm_fit)[-1]))

# Compute fitted values
rcpp_fitted <- X %*% rcpp_fit
lm_fitted <- fitted(lm_fit)

# Compare fitted values
cat("\nFitted values comparison:\n")
print(all.equal(as.numeric(rcpp_fitted), as.numeric(lm_fitted)))

# Compute residuals
rcpp_residuals <- Y - rcpp_fitted
lm_residuals <- residuals(lm_fit)

# Compare residuals
cat("\nResiduals comparison:\n")
print(all.equal(as.numeric(rcpp_residuals), as.numeric(lm_residuals)))

# Calculate R-squared using Rcpp
rcpp_r_squared <- calculate_r_squared(Y, rcpp_fitted)
lm_r_squared <- summary(lm_fit)$r.squared

# Compare R-squared
cat("\nR-squared comparison:\n")
print(all.equal(rcpp_r_squared, lm_r_squared))

