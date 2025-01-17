% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert2list.R
\name{convert2list}
\alias{convert2list}
\title{Convert a list of fragments to list of variables}
\usage{
convert2list(trackDat)
}
\arguments{
\item{trackDat}{A list of data frame containing tracking information for each fragment (e.g., x.pos, y.pos, frame).}
}
\value{
A list of vectors corresponding to the variable retrieved from the fragments.
}
\description{
Given a list containing 1 or more data frames corresponding to the data for each fragments
the function reduce the list by concatenating fragments' data based on the variables present within each fragment data frame
and add fragment identity as a new variable.
}
\examples{

#'# generate some dummy fragments
## start to specify some parameters to generate fragments
Fragn <- 10 # the number of fragment to simulate
FragL <- 1:1000 # the length of the fragments or a sequence to randomly sample fragment length

fragsList <- stats::setNames(lapply(lapply(seq(Fragn), function(i)
 trajr::TrajGenerate(sample(FragL, 1), random = TRUE, fps = 1)), function(j)
   data.frame(
     x.pos = j$x - min(j$x),
     y.pos = j$y - min(j$y),
     frame = j$time
   )), seq(Fragn))

# convert frag list to a simple list to extract image resolution for generated fragments
trackDatList <- convert2list(fragsList)

}
\seealso{
\code{\link{convert2frags}}
}
