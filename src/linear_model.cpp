#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::vec fit_linear_model_rcpp(const arma::mat& X, const arma::vec& Y) {
  // Calculate XtX and XtY
  arma::mat XtX = X.t() * X;
  arma::vec XtY = X.t() * Y;

  // Solve for beta: beta = (XtX)^(-1) * XtY
  arma::vec beta = arma::solve(XtX, XtY);
  return beta;
}

// [[Rcpp::export]]
double calculate_r_squared(const arma::vec& Y, const arma::vec& fitted) {
  double ss_total = arma::accu(arma::square(Y - arma::mean(Y)));
  double ss_residual = arma::accu(arma::square(Y - fitted));
  return 1.0 - (ss_residual / ss_total);
}
