% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slidWin.R
\name{slidWin}
\alias{slidWin}
\title{Sliding window}
\usage{
slidWin(x, Tstep, customFunc)
}
\arguments{
\item{x}{A vector containing data to smooth.}

\item{Tstep}{A numeric value corresponding to the length of the sliding window (i.e., the number of values).}

\item{customFunc}{A function used to perform the computation along the sliding window.}
}
\value{
A vector containing smoothed data.
}
\description{
Given a vector containing numeric data, this function returns a vector of smoothed data
by performing the specified computation along a centered sliding window.
}
\examples{

set.seed(123) 
# compute smoothed mean 
smoothMean <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) mean(x, na.rm = T))
# compute smoothed variance 
smoothVar <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) var(x, na.rm = T))
# compute smoothed sd
smoothSd <- slidWin( x = rnorm(150), Tstep = 15, customFunc = function (x) sd(x, na.rm = T))

}
