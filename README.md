# Biostat625.HW3: Linear Regression with Rcpp

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
   - [From GitHub](#from-github)
3. [Functions and Usage](#functions-and-usage)
   - [fit_linear_model_rcpp()](#fit_linear_model_rcpp)
   - [calculate_r_squared()](#calculate_r_squared)
4. [Example](#example)
5. [Testing](#testing)
6. [Contributing](#contributing)
7. [Acknowledgments](#acknowledgments)

---

## Overview

`BIOSTAT625.HW3` is an R package that provides efficient linear regression computations using Rcpp and RcppArmadillo. This package is designed to handle large-scale datasets while maintaining high computational efficiency.

The package includes the following key functions:

1. **`fit_linear_model_rcpp()`**: Fits a linear regression model using matrix operations in C++.  
2. **`calculate_r_squared()`**: Computes the coefficient of determination (\(R^2\)) to evaluate model performance.

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

X: A numeric matrix of predictor variables.

Y: A numeric vector of response variables.

Returns: A vector of regression coefficients.

### calculate_r_squared()

Description: Computes the R^2 value for a fitted linear regression model.

Usage:
```r
calculate_r_squared(Y, fitted)
```

Arguments:

Y: A numeric vector of observed response values.

fitted: A numeric vector of fitted response values.

Returns: A numeric value representing the coefficient of determination (R^2).
