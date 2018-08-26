calc_score <- function(dat, profile) {
  # create spatial points data frame
  matrix <- as.matrix(dat)
  matrix[is.na(matrix)] <- -100
  score <- matrix %*% profile
  return(score)
}