
# Functions ---------------------------------------------------------------

estimate_state_value <- function(x, u, phi, gamma) {
  
  phi%*%x + gamma%*%u
  
}

estimate_state_cov <- function(P, phi, Q) {
  
  phi %*% P %*% t(phi) + Q
  
}

calculate_kalman_gain <- function(tilde_P, R, A) {
  
  tilde_P %*% t(A) %*% solve(A %*% tilde_P %*% t(A) + R)
  
}

update_state_value <- function(tilde_x, y, u, K, A, gamma) {
  
  tilde_x + K %*% (y - A %*% tilde_x - gamma %*% u)
  
}

update_state_cov <- function(tilde_P, K, A) {
  
  (diag(nrow(tilde_P)) - K %*% A) %*% tilde_P
  
}

calculate_innovations <- function(tilde_x, y, u, A, gamma) {
  
  y - A %*% tilde_x - gamma %*% u
  
}

calculate_error_cov <- function(tilde_P, A, R) {
  
  A %*% tilde_P %*% t(A) + R
  
}

kalman_filter <- function(x0, P0, y, u, A, Q, R, phi, gamma) {
  
  x <- c(x0, rep(NA, length(y)))
  
  P <- c(P0, rep(NA, length(y)))
  
  tilde_x <- c(NA)
  tilde_P <- c(NA)
  
  for(i in 2:(length(x))) {
    
    tilde_x[i] <- estimate_state_value(x = x[i-1], u = u, phi = phi, gamma = gamma)
    
    tilde_P[i] <- estimate_state_cov(P = P[i-1], phi = phi, Q = Q)
    
    K <- calculate_kalman_gain(tilde_P = tilde_P, R = R, A = A)
    
    x[i] <- update_state_value(x = tilde_x[i], y = y, u = u, K = K, A = A, gamma = gamma)
    
    P[i] <- update_state_cov(tilde_P = tilde_P, K = K, A = A)
  }
  
  list(x = x, P = P, tilde_x = tilde_x, tilde_P = tilde_P)
}

log_likelihood_funciton <- function(epsilon, sigma) {
  
  (1/2) * sum(log(abs(sigma))) + (1/2) * sum(t(epsilon) %*% solve(sigma) %*% epsilon)
}

# MLE

while(alpha < alpha_control) {
  
  fit_kf <- kalman_filter(x0, P0, y, u, A, Q, R, phi, gamma)
  
  epsilon <- calculate_innovations(tilde_x = fit_kf$tilde_x[-1], y = y, u = u, A = A, gamma = gamma)
  
  sigma <- calculate_error_cov(tilde_P = fit_kf$tilde_P[-1], A = A, R = R)
  
  
  
}






