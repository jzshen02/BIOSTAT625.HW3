# linear_model.R

#' Fit Linear Regression Model
#'
#' This function implements a simple linear regression model using ordinary least squares (OLS).
#' It calculates the regression coefficients by solving the normal equation \( \beta = (X'X)^{-1}X'Y \),
#' and provides additional metrics such as residuals, mean squared error (MSE), variance-covariance matrix,
#' and standard errors for the coefficients. This is a fundamental statistical method for modeling the
#' relationship between a response variable and one or more predictor variables.
#'
#' @param data A data frame containing predictors and response variable.
#' @param response_var A string specifying the name of the response variable.
#' @param predictor_vars A vector of strings specifying the names of predictor variables.
#' @param include_intercept Logical, whether to include an intercept in the model.
#' @return A list containing coefficients, fitted values, residuals, variance-covariance matrix, and standard errors.
#' @export
fit_linear_model <- function(data, response_var, predictor_vars, include_intercept = TRUE) {
  # Check if specified response and predictor variables exist
  if (!(response_var %in% colnames(data))) {
    stop(paste("Response variable", response_var, "not found in the data."))
  }
  if (!all(predictor_vars %in% colnames(data))) {
    stop("Some predictor variables are not found in the data.")
  }

  # Extract response and predictors
  Y <- data[[response_var]]
  X <- as.matrix(data[, predictor_vars, drop = FALSE])

  # Add intercept if required
  if (include_intercept) {
    X <- cbind("(Intercept)" = 1, X)
  }

  # Solve for coefficients: beta = (X'X)^(-1) X'Y
  XtX <- t(X) %*% X
  XtY <- t(X) %*% Y
  beta <- solve(XtX, XtY)

  # Compute fitted values and residuals
  fitted <- X %*% beta
  residuals <- Y - fitted

  # Calculate Mean Squared Error (MSE) and Degrees of Freedom
  n <- length(Y)
  p <- ncol(X)
  mse <- sum(residuals^2) / (n - p)

  # Variance-Covariance Matrix and Standard Errors
  var_cov_matrix <- mse * solve(XtX)
  standard_errors <- sqrt(diag(var_cov_matrix))

  return(list(
    coefficients = beta,
    fitted = fitted,
    residuals = residuals,
    mse = mse,
    degrees_freedom = n - p,
    var_cov_matrix = var_cov_matrix,
    standard_errors = standard_errors
  ))
}


# model_summary.R

#' Evaluate Model Performance
#'
#' This function evaluates the performance of a linear regression model by computing essential
#' metrics such as R-squared, adjusted R-squared, F-statistic, and its associated p-value. These
#' metrics allow us to assess how well the model fits the data and whether the predictors significantly
#' explain the variability in the response variable.
#'
#' The R-squared and adjusted R-squared quantify the proportion of variance explained by the model,
#' while the F-statistic and its p-value test the overall significance of the regression model.
#'
#' @param fit_result A list containing the results from a linear regression model.
#' @param dataset The dataset used to fit the model.
#' @param response_var The name of the response variable.
#' @param predictor_vars A vector of predictor variables.
#'
#' @return A list containing:
#' - R_squared: The R-squared value
#' - Adj_R_squared: The Adjusted R-squared value
#' - F_statistic: The F-statistic value
#' - p_value_F: The p-value for the F-statistic
#' @export
evaluate_model_performance <- function(fit_result, dataset, response_var, predictor_vars) {

  # Prepare data
  y <- as.matrix(dataset[[response_var]])
  residuals <- fit_result$residuals
  n <- length(y)
  p <- length(predictor_vars) + 1  # including intercept

  # Calculate total sum of squares (SS_total)
  y_mean <- sum(y) / n  # mean of y
  ss_total <- sum((y - y_mean)^2)

  # Calculate residual sum of squares (SS_residual)
  ss_residual <- sum(residuals^2)

  # Calculate R-squared and Adjusted R-squared
  R_squared <- 1 - (ss_residual / ss_total)
  Adj_R_squared <- 1 - (1 - R_squared) * (n - 1) / (n - p)

  # Calculate F-statistic
  F_statistic <- ((ss_total - ss_residual) / (p - 1)) / (ss_residual / (n - p))

  # Calculate p-value for F-statistic using custom function
  p_value_F <- 1 - pf_custom(F_statistic, p - 1, n - p)

  # Return the evaluation metrics
  return(list(
    R_squared = R_squared,
    Adj_R_squared = Adj_R_squared,
    F_statistic = F_statistic,
    p_value_F = p_value_F
  ))
}

# Custom implementation of the pf function
#' Calculate F Distribution Cumulative Probability
#'
#' This helper function computes the cumulative distribution function (CDF) for the F-distribution.
#' It is used to calculate the p-value for the F-statistic in model performance evaluation.
#'
#' @param F The F-statistic value.
#' @param df1 Degrees of freedom for the numerator.
#' @param df2 Degrees of freedom for the denominator.
#' @return The cumulative probability associated with the F-statistic.
#' @export
pf_custom <- function(F, df1, df2) {
  pbeta((df1 * F) / (df1 * F + df2), df1 / 2, df2 / 2)
}

#' Plot Residual Diagnostics
#'
#' This function generates diagnostic plots for the residuals of a linear regression model. The
#' plots include a residuals vs fitted values plot to assess heteroscedasticity and a Q-Q plot to
#' check for normality of residuals. These plots are critical for validating the assumptions of
#' linear regression.
#'
#' @param model A list returned by `fit_linear_model`.
#' @export
plot_residuals <- function(model) {
  residuals <- model$residuals
  fitted <- model$fitted

  # Residuals vs Fitted
  plot(fitted, residuals, main = "Residuals vs Fitted", xlab = "Fitted Values", ylab = "Residuals")
  abline(h = 0, col = "red")

  # Normal Q-Q Plot
  qqnorm(residuals, main = "Normal Q-Q Plot")
  qqline(residuals, col = "red")
}

usethis::use_testthat()
usethis::use_test("linear_model")

