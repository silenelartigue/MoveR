% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert2frags.R
\name{convert2frags}
\alias{convert2frags}
\title{Convert a list of variables to list of fragments}
\usage{
convert2frags(trackDatList, by = NULL)
}
\arguments{
\item{trackDatList}{A list of vector corresponding to the variable of tracking data.}

\item{by}{A character vector identifying fragments to join by.}
}
\value{
A list of data frames corresponding the the tracking data for each fragments.
}
\description{
Given a list containing vectors corresponding to the various variable of tracking data
the function returns a list of data frames corresponding to the data for each fragment based on fragments identity.
}
\examples{

# generate some dummy fragments
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

# convert fragList to a simple list based on the variables present within each fragments' data frame
trackDatList <- convert2list(fragsList)

# convert the list of variable to a liost of fragment based on fragments identity
trackDat <- convert2frags(trackDatList, by = "fragsId")

}
\seealso{
\code{\link{convert2list}}
}
