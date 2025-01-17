% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resampleFrags.R
\name{resampleFrags}
\alias{resampleFrags}
\title{Resampling fragments}
\usage{
resampleFrags(trackDat, Tstep = NULL, TimeCol = NULL)
}
\arguments{
\item{Tstep}{A numeric value corresponding to the length of the resampling step (time unit, e.g., frame).}

\item{TimeCol}{A character string corresponding to the name of the column containing time information (e.g., "frame").}

\item{trackDatA}{A list of data frame containing tracking informations for each fragment.}
}
\value{
A list of data frame containing the resampled fragments.
}
\description{
Given a list of data frame containing tracking informations for each fragment,
this function returns a list of resampled fragments according to the length of the resampling
step specified by the user.
}
\examples{

# generate some dummy fragments
## start to specify some parameters to generate fragments
Fragn <- 50 # the number of fragment to simulate
FragL <- 100:1000 # the length of the fragments or a sequence to randomly sample fragment length

fragsList <- stats::setNames(lapply(lapply(seq(Fragn), function(i)
 trajr::TrajGenerate(sample(FragL, 1), random = TRUE, fps = 1)), function(j)
   data.frame(
     x.pos = j$x - min(j$x),
     y.pos = j$y - min(j$y),
     frame = j$time
   )), seq(Fragn))

# check the fragments
drawFrags(fragsList,
         imgRes = c(max(convert2list(fragsList)[["x.pos"]]),
                    max(convert2list(fragsList)[["y.pos"]])),
         timeCol = "frame")

# Run convert the time unit (frame) to seconds using analyseFrags (according to a frame rate of 25 fps)
fragsListV1 <-
 analyseFrags(
   fragsList,
   customFunc = list(
     # convert the time expressed in frame in second using a conversion factor of 25 frame per second
     TimeSec = function(x)
       x[["frame"]] / 25
   )
 )
# exemple 1: resample the fragment every 0.2 seconds
## check the size of the fragments 
fragSize <- unlist(lapply(fragsListV1, function(x) nrow(x)))

## resample the fragment every 1 seconds
fragListSampled1S <- resampleFrags(fragsListV1, 
                                  TimeCol = "TimeSec", 
                                  Tstep = 1)

## check the size of the fragments after resampling 
fragSize1s <- unlist(lapply(fragListSampled1S, function(x) nrow(x)))

## Compare the fragments size
cbind(fragSize, fragSize1s)

# exemple 2: resample the fragment every 1 minutes

## resample the fragment every 0.10 seconds
fragListSampled0.10S <- resampleFrags(fragsListV1, 
                                     TimeCol = "TimeSec", 
                                     Tstep = 0.10)
## here some time step are not found in the fragment list (e.g., 0.10, 0.30), 
## they are hence replaced by NA in the output list

## check the size of the fragments after resampling 
fragSize0.10S <- unlist(lapply(fragListSampled0.10S, function(x) nrow(x)))

## Compare the fragments size
cbind(fragSize, fragSize1s, fragSize0.10S)

}
