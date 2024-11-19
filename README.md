# Biostat625.HW3: Linear Regression with Rcpp

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
   - [From GitHub](#from-github)
3. [Functions and Usage](#functions-and-usage)
   - [fit_linear_model_rcpp()](#fit_linear_model_rcpp)
   - [calculate_evaluation_metrics()](#calculate_evaluation_metrics)
   - [plot_diagnostics()](#plot_diagnostics)
4. [Example](#example)
5. [Output Details](#output-details)
6. [Testing](#testing)


---

## Overview

`BIOSTAT625.HW3` is an R package that provides efficient linear regression computations using Rcpp and RcppArmadillo. This package is designed to handle large-scale datasets while maintaining high computational efficiency.

The package includes the following key functions:

1. **Fitting the Model**: Calculates regression coefficients and fitted values.
2. **Model Evaluation**: Outputs metrics including \( R^2 \), adjusted \( R^2 \), F-statistic, p-value for F-statistic, and residual variance.
3. **Diagnostics**: Outputs residuals, degrees of freedom, variance-covariance matrix, and standard errors.
4. **Visualization**: Generates diagnostic plots for better understanding of the model's fit.


---

## Installation

### From GitHub

You can install the package directly from GitHub using the `devtools` package:

```r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("jzshen02/BIOSTAT625.HW3")

```
---

## Functions and Usage
### fit_linear_model_rcpp()

Description: Fits a linear regression model to a dataset using RcppArmadillo.

Usage:
```r
fit_linear_model_rcpp(X, Y)
```
Arguments:

 -X: A numeric matrix of predictor variables.

 -Y: A numeric vector of response variables.



Returns: A list containing:

 -coefficients: The regression coefficients.

 -fitted: The predicted values.

 -residuals: The residuals of the model.

 -mse: The mean squared error.

 -degrees_freedom: Degrees of freedom for the residuals.

 -var_cov_matrix: Variance-covariance matrix of the coefficients.

 -standard_errors: Standard errors of the coefficients.

### calculate_evaluation_metrics()

Description: Computes the R^2 value for a fitted linear regression model.

Usage:
```r
calculate_r_squared(Y, fitted)
```

Arguments:

 -Y: A numeric vector of observed response values.

 -fitted: A numeric vector of fitted response values.

 -X: A numeric matrix of predictor variables.


Returns: A list containing:

 -R_squared: The coefficient of determination (R^2).

 -Adj_R_squared: The adjusted R^2.

 -F_statistic: The F-statistic for the model.

 -p_value_F: The p-value for the F-statistic.

### plot_diagnostics()
Description: Generates diagnostic plots for assessing model fit.

Usage:
```r
plot_diagnostics(residuals, fitted)
```
Arguments:

 -residuals: A numeric vector of residuals from the model.

 -fitted: A numeric vector of fitted values from the model.


Details: Produces the following diagnostic plots:

1. Residuals vs Fitted: To assess linearity and equal variance.

2. Q-Q Plot: To check for normality of residuals.

3. Scale-Location Plot: To evaluate homoscedasticity.

4. Residuals vs Leverage: To detect influential observations.


Returns: Displays plots in the active graphics device.

## Example
Here is an example using the provided dataset (test.sas7bdat):
```r
# Load the package
library(BIOSTAT625.HW3)

# Load your dataset
library(haven)
data_path <- system.file("extdata", "test.sas7bdat", package = "BIOSTAT625.HW3")
data <- haven::read_sas(data_path)


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
```
## Output Details
1. Fit Results:

 -coefficients

 -fitted

 -residuals

 -mse

 -degrees_freedom

 -var_cov_matrix

 -standard_errors

2. Evaluation Metrics:

 -R_squared

 -Adj_R_squared

 -F_statistic

 -p_value_F

3. Plots:

 -Residuals vs Fitted

 -Q-Q Plot

 -Scale-Location Plot

 -Residuals vs Leverage


## Testing
The project includes a suite of tests using testthat. To run tests:
```r
devtools::test()
```
Additionally, you can compare the performance of the Rcpp-based implementation with base R:
```r
library(bench)

# Generate a larger dataset from your existing data
data_large <- data[sample(1:nrow(data), 1e4, replace = TRUE), ]
X_large <- as.matrix(data_large[, -ncol(data_large)])
Y_large <- as.numeric(data_large[, ncol(data_large)])

bench::mark(
  Rcpp = fit_linear_model_rcpp(X_large, Y_large),
  BaseR = lm(Y_large ~ X_large - 1)
)
```

