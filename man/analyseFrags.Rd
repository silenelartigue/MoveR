% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analyseFrags.R
\name{analyseFrags}
\alias{analyseFrags}
\title{Fragments analyses}
\usage{
analyseFrags(trackDat, customFunc)
}
\arguments{
\item{trackDat}{A list of data frame containing tracking informations for each fragment.}

\item{customFunc}{A function or a list of functions used to perform the computation along all fragments
NB: in case customFunc is a list of unnamed function it will try to retrieve their names by returning the first character string
following the function() call as the name of the results column.}
}
\value{
this function returns the original list of data frames (i.e., fragments)
with the result of the specified computation appended.
}
\description{
Given a list of data frames containing tracking informations for each fragment and
a custom function, this function iterate trough the fragments lists to perform the specified computation
and returns the original list of data frames with the result of the analysis appended.
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

# Run some computation on the dataset using analyseFrags
fragsListV1 <-
 analyseFrags(
   fragsList,
   customFunc = list(
     # specify a first function to compute speed over each fragment (a modulus present within the MoveR package)
     speed = function(x)
       MoveR::speed(
         x,
         TimeCol = "frame",
        scale = 1,
         unit = "pixels"
       ),
     # compute turning angle in radians over each fragment (a modulus present within the MoveR package)
     TurnAngle = function(x)
       MoveR::turnAngle(x, unit = "radians"),
     # convert the time expressed in frame in second using a conversion factor of 25 frame per second
     TimeSec = function(x)
       x[["frame"]] / 25,
     # or in minutes
     TimeMin = function(x)
       x[["frame"]] / 25 / 60
   )
 )
# check the result for the first fragment
str(fragsListV1[["1"]])

# plot the histogram of the speed
hist(convert2list(fragsListV1)[["speed"]])

# plot the histogram of the turning angle
Ht = circular::circular(
 convert2list(fragsListV1)[["TurnAngle"]],
 type = "angle",
 units = "radians",
 zero = 0
)
circular::rose.diag(
 Ht,
 bins = 24,
 shrink = 0.89,
 xlim = c(-1, 1),
 ylim = c(-1, 1),
 prop = 2,
 col = "gray",
 border = "black",
 units = 'radians',
 ticks = TRUE
)

}
