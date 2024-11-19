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
devtools::install_github("yourusername/BIOSTAT625.HW3")
