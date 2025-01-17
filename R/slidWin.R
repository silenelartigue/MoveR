#' @title Sliding window
#' 
#' @description Given a vector containing numeric data, this function returns a vector of smoothed data 
#' by performing the specified computation along a centered sliding window.
#'
#'
#' @param x A vector containing data to smooth.
#'
#' @param Tstep A numeric value corresponding to the length of the sliding window (i.e., the number of values).
#' 
#' @param customFunc A function used to perform the computation along the sliding window.
#'
#' @return A vector containing smoothed data.
#'
#' @authors Quentin PETITJEAN
#'
#' @examples
#' 
#' set.seed(123) 
#' # compute smoothed mean 
#' smoothMean <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) mean(x, na.rm = T))
#' # compute smoothed variance 
#' smoothVar <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) var(x, na.rm = T))
#' # compute smoothed sd
#' smoothSd <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) sd(x, na.rm = T))
#'
#' @export

slidWin <- function (x, Tstep, customFunc) {
  smoothed <- vector()
  for (i in seq(length(x))) {
    if (!(i - ((Tstep - 1) / 2)) < 1 &
        !(i + ((Tstep - 1) / 2)) > length(x)) {
      selVal <- x[(i - ((Tstep - 1) / 2)):(i + ((Tstep - 1) / 2))]
      smoothed[i] <- customFunc(selVal)
    } else {
      smoothed[i] <- NA
    }
  }
  return(smoothed)
}
