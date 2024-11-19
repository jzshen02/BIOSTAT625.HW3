# test_framework.R

#' Test Linear Model Implementation
#'
#' Validates the correctness of linear regression functions with real dataset.
#'
#' @export
test_linear_model <- function() {
  library(testthat)
  library(haven)

  # Set working directory and load dataset
  data_path <- system.file("extdata", "test.sas7bdat", package = "BIOSTAT625.HW3")
  dataset <- haven::read_sas(data_path)

  # Standardize column names to lowercase
  colnames(dataset) <- tolower(colnames(dataset))

  # Define variables (also in lowercase)
  response_var <- "depression"
  predictor_vars <- c("fatalism")

  # Debug: Print standardized column names
  print("Standardized Dataset Columns:")
  print(colnames(dataset))

  # Ensure variables exist in the dataset
  stopifnot(all(tolower(c(response_var, predictor_vars)) %in% colnames(dataset)))

  message("Starting tests...")

  # Test linear model fitting
  test_that("fit_linear_model calculates correct coefficients on real dataset", {
    model <- fit_linear_model(dataset, response_var = response_var, predictor_vars = predictor_vars)

    # Validate coefficients
    expect_true(!is.null(model$coefficients))
    expect_equal(length(model$coefficients), length(predictor_vars) + 1, info = "Number of coefficients should match predictors plus intercept")
  })

  # Test model performance evaluation
  test_that("evaluate_model_performance calculates correct metrics on real dataset", {
    model <- fit_linear_model(dataset, response_var = response_var, predictor_vars = predictor_vars)
    evaluation <- evaluate_model_performance(model, dataset, response_var, predictor_vars)

    # Validate metrics
    expect_true(!is.null(evaluation$R_squared))
    expect_true(evaluation$R_squared <= 1 && evaluation$R_squared >= 0, info = "R-squared should be between 0 and 1")
    expect_true(!is.null(evaluation$Adj_R_squared))
    expect_true(evaluation$Adj_R_squared <= 1 && evaluation$Adj_R_squared >= 0, info = "Adjusted R-squared should be between 0 and 1")
    expect_true(!is.null(evaluation$F_statistic))
    expect_true(evaluation$F_statistic > 0, info = "F-statistic should be positive")
    expect_true(!is.null(evaluation$p_value_F))
    expect_true(evaluation$p_value_F >= 0 && evaluation$p_value_F <= 1, info = "p-value for F-statistic should be between 0 and 1")
  })

  # Test residual diagnostic plots
  test_that("Residual diagnostics produce valid plots", {
    model <- fit_linear_model(dataset, response_var = response_var, predictor_vars = predictor_vars)
    expect_silent(plot_residuals(model))
  })

  message("All tests completed successfully.")
}

# Explicitly call the test function to ensure tests are run
test_linear_model()
