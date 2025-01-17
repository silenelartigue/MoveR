#' @title Compute distance to the edge of an object (e.g., the arena) along a trajectory
#'
#'
#' @description Given a data frame containing tracking information for a given fragment and a data frame containing the 
#' coordinates of an object edges, this function compute the euclidean distance between the edge of the object (e.g., the arena)
#' and coordinates of the particle along its trajectory. The function then returns the distance between each points of the
#' trajectory and the closest point to the object edge.
#'
#'
#' @param df A data frame containing at x, y coordinates named "x.pos", "y.pos", for a fragment.
#'
#' @param edge A data frame containing x, y coordinates named "x.pos", "y.pos" and specifiyng the location of the
#' arena or any object edge.
#'
#' @param customFunc A function used to specify the formula allowing to compute the
#' distance between a given object or arena edge and the particle along its trajectory
#' It is possible to call already implemented methods for Circular arena by calling customFunc = "CircularArena".
#'
#' @return This function returns a vector containing the distance between each points of the
#' trajectory and the closest point of the object edge.
#'
#'
#' @authors Quentin PETITJEAN
#'
#' @examples # TODO with a circular arena and to complete with a polygaonal arena
#'
#'# Exemple 1: With a circular arena
#'
#'
#'# Exemple 2: With a a polygonal arena, using a distance matrix to avoid tough computation
#'
#'# load the sample data
#'Data <-
#'  readTrex("https://github.com/qpetitjean/MoveR/tree/MovRV1/sampleData/sample_1/TREXOutput",
#'    mirrorY = T,
#'    imgHeight = 2160,
#'   rawDat = F
#'  )
#'# convert it to a list of fragments
#'trackDat <- convert2frags(Data[1:7], by = "identity")
#'# load the reference dataset (A matrix or dataframe or path to a file (either .txt or .csv) containing a distance matrix to any object or 
#'# the location of one or several areas of interest (here we have created a distance map using ImageJ)
#'refDat <-
#'  as.matrix(read.delim("https://github.com/qpetitjean/MoveR/blob/MovRV1/sampleData/sample_1/ReferenceData/ImgTresholding_2602_ISA3080_Low_5.mov_1800.txt",
#'    dec = "."
#'  ))
#'#  retrieve the value of the edge limit (1) and of the center limit (254) to plot them
#'arenaEdge <- data.frame(which(refDat == 1, arr.ind=T))
#'arenaCenter <- data.frame(which(refDat == 254, arr.ind=T))
#'
#'# draw only the first fragment
#'drawFrags(
#'  trackDat,
#'  selFrags = 1,
#'  imgRes = c(3840, 2160),
#'  add2It = list(
#'   points(x = arenaEdge[, 2], y = arenaEdge[, 1], cex = 0.1)
#' )
#')
#'
#'dist2Edge(trackDat[[1]])
#'
#' @export

dist2Edge <- function(df, edge, customFunc) {
  if (customFunc == "CircularArena") {
    ### for a circular arena, compute the distance between the point of the trajectory and the center of the arena
    ### and substract it to the length of the radius :
    center <- c(mean(edge[, "x.pos"]), mean(edge[, "y.pos"]))
    radius <- mean(unlist(sqrt((center[1] - edge["x.pos"]) ^ 2 +
                                 (center[2] - edge["y.pos"]) ^ 2
    )), na.rm = T)
    customFunc <- function(i) {
      sqrt((center[1] - df[["x.pos"]][i]) ^ 2 +
             (center[2] - df[["y.pos"]][i]) ^ 2) - radius
    }
  }
  Res <-
    sapply(seq(nrow(df)), customFunc)
  return(Res)
}
