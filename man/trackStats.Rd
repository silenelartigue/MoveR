% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trackStats.R
\name{trackStats}
\alias{trackStats}
\title{tracking statistics}
\usage{
trackStats(trackDat, frameR = NULL, scale = NULL, units = NULL)
}
\arguments{
\item{trackDat}{A list of data frame containing tracking information for each fragment (i.e., x.pos, y.pos, frame).}

\item{frameR}{A numeric value expressed in frames per second, the frequency at which frames are recorded/displayed in the video
(optional).}

\item{scale}{A ratio corresponding to the scaling factor to be applied to the trajectory coordinates
(e.g., size in cm / size in pixels, (default = 1).}

\item{units}{A character string specifying the spatial unit of the coordinates after scaling (default = "pixels").}
}
\value{
A summary of video and fragments data.
}
\description{

}
\examples{

# generate some dummy fragments
## start to specify some parameters to generate fragments
Fragn <- 500 # the number of fragment to simulate
FragL <- 1:1000 # the length of the fragments or a sequence to randomly sample fragment length

fragsList <- stats::setNames(lapply(lapply(seq(Fragn), function(i)
 trajr::TrajGenerate(sample(FragL, 1), random = TRUE, fps = 1)), function(j)
   data.frame(
     x.pos = j$x - min(j$x),
     y.pos = j$y - min(j$y),
     frame = j$time
   )), seq(Fragn))

# compute and display tracking summary
TrackSumary <- trackStats(fragsList,
                         frameR = 25,
                        scale = 1,
                        units = "pixels")

# retrieve the fragLength and duration in frame from the summary "manually"
FragL <- TrackSumary[["fragments_summary"]][["fragLength_pixels"]]
FragD <- TrackSumary[["fragments_summary"]][["fragsDuration_f"]]

# or using listGet utility
FragL2 <- listGet(TrackSumary, "fragLength_pixels")
FragD2 <- listGet(TrackSumary, "fragsDuration_f")

# plot the distribution of fragments length and duration
par(mfrow = c(2, 2))
hist(FragL)
hist(FragD)
hist(FragL2)
hist(FragD2)

}
\seealso{
\code{\link{trajr::TrajScale}}, \code{\link{trajr::TrajFromCoords}}
}
