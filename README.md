# Biostat625.HW3: Linear Regression with Rcpp

```r
# Table of Contents
# 1. Overview
# 2. Installation
#    - From GitHub
# 3. Functions and Usage
#    - fit_linear_model_rcpp()
#    - calculate_r_squared()
# 4. Example
# 5. Testing
# 6. Contributing
# 7. License
# 8. Acknowledgments

# Overview
# BIOSTAT625.HW3 is an R package that provides efficient linear regression computations 
# using Rcpp and RcppArmadillo. This package is designed to handle large-scale datasets 
# while maintaining high computational efficiency.
#
# The package includes the following key functions:
# 1. fit_linear_model_rcpp(): Fits a linear regression model using matrix operations in C++.
# 2. calculate_r_squared(): Computes the coefficient of determination (R^2) to evaluate 
#    model performance.

# Installation
# From GitHub
# You can install the package directly from GitHub using the devtools package:
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("yourusername/BIOSTAT625.HW3")

# Functions and Usage

# 1. fit_linear_model_rcpp()
# Description: Fits a linear regression model to a dataset using RcppArmadillo.
#
# Usage:
# fit_linear_model_rcpp(X, Y)
#
# Arguments:
# - X: A numeric matrix of predictor variables.
# - Y: A numeric vector of response variables.
#
# Returns:
# - A vector of regression coefficients.

# 2. calculate_r_squared()
# Description: Computes the R^2 value for a fitted linear regression model.
#
# Usage:
# calculate_r_squared(Y, fitted)
#
# Arguments:
# - Y: A numeric vector of observed response values.
# - fitted: A numeric vector of fitted response values.
#
# Returns:
# - A numeric value representing the coefficient of determination (R^2).

# Example
# Example usage of BIOSTAT625.HW3 package with provided dataset

# Load the package
library(BIOSTAT625.HW3)

# Load your dataset (assuming "test.sas7bdat" contains the required data)
library(haven)
data <- read_sas("test.sas7bdat")

# Prepare predictors and response
X <- as.matrix(data[, -ncol(data)])  # All columns except the last as predictors
Y <- as.numeric(data[, ncol(data)]) # Last column as the response variable

# Fit the linear regression model
coefficients <- fit_linear_model_rcpp(X, Y)

# Predict the fitted values
fitted_values <- X %*% coefficients

# Evaluate model performance
r_squared <- calculate_r_squared(Y, fitted_values)

# Print results
print(coefficients)  # Regression coefficients
print(r_squared)     # R-squared value

# Testing
# The project includes a suite of tests using testthat. To run tests:
devtools::test()

# Additionally, you can compare Rcpp-based performance with base R:
library(bench)

# Generate a larger dataset from your existing data
data_large <- data[sample(1:nrow(data), 1e4, replace = TRUE), ]
X_large <- as.matrix(data_large[, -ncol(data_large)])
Y_large <- as.numeric(data_large[, ncol(data_large)])

bench::mark(
  Rcpp = fit_linear_model_rcpp(X_large, Y_large),
  BaseR = lm(Y_large ~ X_large - 1)
)

# Contributing
# If you would like to contribute to this package, feel free to fork the repository 
# and create pull requests. Feedback, bug reports, and feature requests are welcome.

# License
# This package is licensed under the MIT License. See the LICENSE file for more details.

# Acknowledgments
# This package was developed as part of the Biostat 625 course. Special thanks to the 
# instructors for their guidance and support.
