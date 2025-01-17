#' @title Draw tracking fragments
#'
#' @description Given a list of tracking fragments containing cartesian coordinates,
#' this function returns a plot with fragments represented as a sequence of segments connecting
#' cartesian coordinates between successive frames. Fragments are colored according to the time.
#'
#'
#' @param trackDat A list of data frame containing tracking information for each fragment (i.e., x.pos, y.pos).
#'
#' @param selFrags A vector of either numeric values or character strings,
#' the number or the id of the selFrags to plot (optional).
#'
#' @param imgRes A vector of 2 numeric values, the resolution of the video used as x and y limit of the plot
#'  (i.e., the number of pixels in image width and height, default = 1920 x 1080).
#'
#' @param timeWin  A list of one or several vector containing 2 numeric values separated by a comma
#' corresponding to the time interval between which selFrags have to be drawn in frame (optional).
#'
#' @param timeCol A character string corresponding to the name of the column containing time information (default = "frame").
#'
#' @param colGrad A vector of a ready to use color ramp or several colors specified
#' either with their name or hexadecimal values (optional).
#'
#' @param colId A character string corresponding to a column name
#' present within each fragments' data frame from the trackDat list
#' and which is used as grouping factor to color the fragments (default = timeCol).
#' If colId is composed of continuous values, the legend will be plotted as a gradient.
#'
#' @param add2It A function specifying an element to add to the plot.
#'
#' @param srt A value or a vector of two values specifying the orientation of the axes values
#' for the x and y axis respectively (default = 0).
#'
#' @param lwd Line width of fragment path (default = 1).
#'
#' @param main Primary title of the plot (default = "Fragments").
#'
#' @param xlab X-axis label (default = "Video width (pixels)").
#'
#' @param ylab Y-axis label (default = "Video height (pixels)").
#'
#' @param legend Either TRUE or FALSE, display the legend on the plot or not (default = TRUE).
#'
#' @param cex.axis Character size and expansion for axis and legend values (default = 1).
#'
#' @param cex.main Character size and expansion for primary title (default = 1.25).
#'
#' @param cex.lab Character size and expansion for axes label (default = 1).
#'
#' @param cex.leg Character size and expansion for the legend label (default = 1).
#'
#' @param cex.start Dot size representing the start of a fragment (default = 0.5).
#'
#' @return A plot with all or only selected fragment paths colored according to time.
#'
#'
#' @authors Quentin PETITJEAN
#'
#'
#' @examples
#'
#'
#'# generate some dummy fragments
#' ## start to specify some parameters to generate fragments
#'Fragn <- 10 # the number of fragment to simulate
#'FragL <- 1:1000 # the length of the fragments or a sequence to randomly sample fragment length
#'
#'fragsList <- stats::setNames(lapply(lapply(seq(Fragn), function(i)
#'  trajr::TrajGenerate(sample(FragL, 1), random = TRUE, fps = 1)), function(j)
#'    data.frame(
#'      x.pos = j$x - min(j$x),
#'      y.pos = j$y - min(j$y),
#'      frame = j$time
#'    )), seq(Fragn))
#'
#'# convert frag list to a simple list to extract image resolution for generated fragments
#'# (x, y scales of the plot)
#' trackDatList <- convert2list(fragsList)
#'
#'# Exemple 1: draw all fragments, for the whole video duration
#'drawFrags(
#'  fragsList,
#'  imgRes = c(max(trackDatList$x.pos), max(trackDatList$y.pos)),
#'  timeCol = "frame"
#')
#'
#'# Exemple 2: draw only selected fragments (i.e., 1, 5 and 10), for the whole video duration
#'drawFrags(
#'  fragsList,
#'  imgRes = c(max(trackDatList$x.pos), max(trackDatList$y.pos)),
#'  selFrags = c(1, 5, 10),
#'  timeCol = "frame"
#')
#'
#'# Exemple 3: draw fragments according to time intervals
#'# (first interval 1 to 100, second interval 800 to 900 frames)
#'drawFrags(
#'  fragsList,
#'  imgRes = c(max(trackDatList$x.pos), max(trackDatList$y.pos)),
#'  timeWin = list(c(1, 100), c(800, 900)),
#'  timeCol = "frame"
#')
#'
#'# Exemple 4: draw fragments according to time intervals
#'# (first interval 1 to 100, second interval 800 to 900 frames)
#'# and color fragment according to their Id instead of time elapsed
#'drawFrags(
#'  fragsList,
#'  imgRes = c(max(trackDatList$x.pos), max(trackDatList$y.pos)),
#'  timeWin = list(c(1, 100), c(800, 900)),
#'  timeCol = "frame",
#'  colFrag = TRUE
#')
#'
#'# Exemple 5: draw fragments according to time interval (interval 1 to 100)
#'# and add dummy points on the plot
#'# (here we draw the starting and ending points of each fragments in blue and green respectively)
#'drawFrags(
#'  fragsList,
#'  imgRes = c(max(trackDatList$x.pos), max(trackDatList$y.pos)),
#'  timeWin = list(c(1, 100)),
#'  timeCol = "frame",
#'  add2It = list(for (j in seq(fragsList)) {
#'    points(
#'      fragsList[[j]]$x.pos[fragsList[[j]]$frame == 1],
#'      fragsList[[j]]$y.pos[fragsList[[j]]$frame == 1],
#'      col = "blue",
#'      pch = 19,
#'      cex = 0.8
#'    )
#'  }, for (l in seq(fragsList)) {
#'    points(
#'      fragsList[[l]]$x.pos[fragsList[[l]]$frame == 100],
#'      fragsList[[l]]$y.pos[fragsList[[l]]$frame == 100],
#'      col = "green",
#'      pch = 19,
#'      cex = 0.8
#'    )
#'  })
#')
#'
#'
#' @export

drawFrags <- function(trackDat,
                      selFrags = NULL,
                      imgRes = c(1920, 1080),
                      timeWin = list(c(0, Inf)),
                      timeCol = "frame",
                      colGrad = c(
                        "#000000",
                        "#999999",
                        "#6600CC",
                        "#9999FF",
                        "#33CCFF",
                        "#0066CC",
                        "#66CC00",
                        "#FFFF00",
                        "#FF3300",
                        "#CC0000"
                      ),
                      colId = NULL,
                      add2It = NULL,
                      srt = 0,
                      lwd = 1,
                      main = "Fragments",
                      xlab = "Video width (pixels)",
                      ylab = "Video height (pixels)",
                      legend = TRUE,
                      cex.axis = 1,
                      cex.main = 1.25,
                      cex.lab = 1,
                      cex.leg = 1,
                      cex.start = 0.5) {
  if (is.null(names(trackDat))) {
    names(trackDat) <- seq(length(trackDat))
  }
  if (is.null(timeCol)) {
    stop(
      "timeCol argument is missing, the name of the column carying time information is needed to draw the fragments over time"
    )
  }
  # compute the duration of the video according to timeCol argument
  viDur <-
    max(unlist(lapply(trackDat, function(x)
      max(listGet(x, timeCol),
          na.rm = T))))
  
  # if colId argument is NULL, set it to timeCol as default
  if (is.null(colId)) {
    colId <- timeCol
  }
  # define color ramp according to colId argument
  Pal <- grDevices::colorRampPalette(c(colGrad))
  colVal <- unique(unlist(lapply(trackDat, function(x)
    listGet(x, colId))))
  colVal <- colVal[order(colVal)]
  coloration <- Pal(length(colVal[!is.na(colVal)]))
  
  # initialize the plot window
  ScaleY <- pretty(c(0, imgRes[[2]]), n = 5)
  ScaleX <- pretty(c(0, imgRes[[1]]), n = 5)
  
  plot(
    NA,
    xlim = ifelse(rep(isTRUE(legend), 2), c(0, max(ScaleX) + (ScaleX[2] - ScaleX[1])), c(0, max(ScaleX))),
    ylim = c(0, max(ScaleY)),
    ylab = "",
    xlab = "",
    axes = FALSE
  )
  ## add plot title
  graphics::mtext(
    main,
    cex = cex.main,
    side = 3,
    line = 1.5,
    adj = c(0.5, 0.5)
  )
  ## add axis labels
  ### ylabel
  graphics::mtext(
    ylab,
    cex = cex.lab,
    side = 2,
    line = 2,
    adj = c(0.5, 0.5)
  )
  ### xlabel
  graphics::mtext(
    xlab,
    cex = cex.lab,
    side = 1,
    line = 2,
    adj = c(0.5, 0.5)
  )
  ## draw y axis
  graphics::segments(
    x0 = 0,
    y0 = ScaleY[1],
    x1 = 0,
    y1 = max(ScaleY)
  )
  graphics::text(
    rep(0, length(ScaleY)),
    ScaleY,
    ScaleY,
    xpd = TRUE,
    srt = ifelse(length(srt) > 1, srt[2], srt),
    cex = cex.axis,
    pos = 2
  )
  graphics::text(
    rep(0, length(ScaleY)),
    ScaleY,
    "-",
    xpd = TRUE,
    srt = 0,
    adj = c(0.8, 0.2)
  )
  ## draw x axis
  graphics::segments(
    x0 = ScaleX[1],
    y0 = 0,
    x1 = max(ScaleX),
    y1 = 0
  )
  if (ScaleX[1] == ScaleY[1]) {
    ScaleX <- ScaleX[-which(ScaleX == 0)]
  }
  graphics::text(
    ScaleX,
    rep(0, length(ScaleX)),
    ScaleX,
    xpd = TRUE,
    srt = ifelse(length(srt) > 1, srt[1], srt),
    adj = c(0.5, 1.8),
    cex = cex.axis
  )
  graphics::text(
    ScaleX,
    rep(0, length(ScaleX)),
    "-",
    xpd = TRUE,
    srt = 90,
    adj = c(1, 0.3)
  )
  
  ## in case legend argument is TRUE, create a legend
  if (isTRUE(legend)) {
    ### legend title (retrieve from colId)
    graphics::text(
      max(ScaleX) + (10 * max(ScaleX) / 100),
      max(ScaleY) + (5 * max(ScaleY) / 100),
      ifelse(
        colId == timeCol,
        paste("Time ", "(", timeCol, ")", sep = ""),
        colId
      ),
      cex = cex.leg,
      font = 1,
      xpd = TRUE
    )
    
    ### draw the legend as a gradient if colId is a continuous vector (numerical) or as category in case
    ### colId is a factor or character vector
    if (is.numeric(colVal[!is.na(colVal)])) {
      ScaleVal <-
        pretty(c(min(colVal, na.rm = T), max(colVal, na.rm = T)), n = 5)
      ScaleLegtemp <- which(colVal %in% ScaleVal)
      if (length(ScaleLegtemp) < length(ScaleVal)) {
        ScaleLegtemp <-
          c(ScaleLegtemp, max(ScaleLegtemp + mean(diff(
            ScaleLegtemp
          ))))
      }
      if(max(nchar(ScaleVal)) >= 5){
        ScaleVal <- format(ScaleVal, scientific = TRUE)
      }else{
        ScaleVal <- format(ScaleVal, scientific = FALSE)
      }
      ScaleLeg <-
        as.integer(ScaleLegtemp * max(ScaleY) / max(ScaleLegtemp))
      ScaleLeg[1] <- ScaleLeg[1] + (5 * max(ScaleY) / 100)
      ScaleLeg[length(ScaleLeg)] <-
        ScaleLeg[length(ScaleLeg)] - (5 * max(ScaleY) / 100)
      
      legend_image <-
        grDevices::as.raster(matrix(coloration, ncol = 1))
      graphics::rasterImage(
        legend_image,
        max(ScaleX) + (5 * max(ScaleX) / 100),
        max(ScaleY) - (5 * max(ScaleY) / 100),
        max(ScaleX) + (10 * max(ScaleX) / 100),
        min(ScaleY) + (5 * max(ScaleY) / 100)
      )
      graphics::text(
        x = max(ScaleX) + (15 * max(ScaleX) / 100),
        y = ScaleLeg,
        labels =  ScaleVal,
        cex = cex.leg
      )
    } else{
      graphics::legend(
        x = max(ScaleX) + (5 * max(ScaleX) / 100),
        y = max(ScaleY) - (1 * max(ScaleY) / 100),
        legend = colVal[!is.na(colVal)],
        pch = 22,
        col = "black",
        pt.bg = coloration,
        bty = "n",
        pt.cex = 2,
        text.font = 1,
        cex = cex.leg,
        xpd = TRUE,
        ncol = ceiling(length(colVal[!is.na(colVal)]) / 10)
      )
    }
  }
  
  # if an additional function (add2it argument) is added to drawFrags draw it
  if (!is.null(add2It) == TRUE) {
    add2It
  }
  
  if (!is.list(timeWin)) {
    stop(
      "timeWin argument should be a list of vector(s) containing starting and ending value of each time window interval"
    )
  }
  if (max(unlist(lapply(timeWin, length))) > 2) {
    stop(
      "timeWin argument contains a vector of length > 2,
         timeWin should be a list of vector(s) containing 2 values (start and end of the time window interval)"
    )
  }
  
  # if timeWin is set to default (0 to Inf)
  if (length(timeWin) == 1 & timeWin[[1]][2] == Inf) {
    timeWin[[1]][2] <- viDur
    NewfragsList <- trackDat
  } else {
    # in case there is Inf in timeWin replace it by vidur
    InfLoc <-
      length(unlist(lapply(lapply(timeWin, function(x)
        which(x == Inf)), function (y)
          length(y) > 0)))
    if (length(InfLoc) > 0) {
      timeWin[[InfLoc]][which(timeWin[[InfLoc]] == Inf)] <- viDur
    } else {
      timeWin <- timeWin
    }
    ## cut the fragments to draw only the specified part
    NewfragsList <- lapply(seq(length(timeWin)),
                           function(p)
                             cutFrags(
                               trackDat,
                               customFunc = function(x)
                                 x[[timeCol]] >= timeWin[[p]][[1]] &
                                 x[[timeCol]] <= timeWin[[p]][[2]]
                             ))
    
    NewfragsList <- unlist(NewfragsList, recursive = FALSE)
  }
  
  coloration <-
    data.frame(colors = coloration, colVal = as.numeric(colVal))
  
  # plot all fragments according to timeWin
  if (is.null(selFrags)) {
    # initialize progress bar
    total = length(NewfragsList)
    pb <-
      progress::progress_bar$new(format = "fragments drawing [:bar] :current/:total (:percent)", total = total)
    pb$tick(0)
    Sys.sleep(0.001)
    
    for (f in seq(length(NewfragsList))) {
      NewfragsList[[f]]$colorpal <-
        coloration[match(as.character(listGet(NewfragsList[[f]], colId)), as.character(coloration[["colVal"]][!is.na(colVal)])), "colors"]
      graphics::points(
        NewfragsList[[f]]$x.pos[1],
        NewfragsList[[f]]$y.pos[1],
        col = NewfragsList[[f]]$colorpal[1],
        pch = 19,
      )
      cex = cex.start
      with(
        NewfragsList[[f]],
        graphics::segments(
          head(x.pos,-1),
          head(y.pos,-1),
          x.pos[-1],
          y.pos[-1],
          NewfragsList[[f]]$colorpal,
          lwd = lwd
        )
      )
      
      # progress bar
      pb$tick(1)
      Sys.sleep(0.001)
    }
  } else {
    # plot only the selected fragments according to timeWin color
    # initialize progress bar
    total = length(selFrags)
    pb <-
      progress::progress_bar$new(format = "fragments drawing [:bar] :current/:total (:percent)", total = total)
    pb$tick(0)
    Sys.sleep(0.001)
    
    for (f in selFrags) {
      NewfragsList[[f]]$colorpal <-
        coloration[match(as.character(listGet(NewfragsList[[f]], colId)), as.character(coloration[["colVal"]][!is.na(colVal)])), "colors"]
      graphics::points(
        NewfragsList[[f]]$x.pos[1],
        NewfragsList[[f]]$y.pos[1],
        col = NewfragsList[[f]]$colorpal,
        pch = 19,
        cex = cex.start
      )
      with(
        NewfragsList[[f]],
        graphics::segments(
          head(x.pos,-1),
          head(y.pos,-1),
          x.pos[-1],
          y.pos[-1],
          NewfragsList[[f]]$colorpal,
          lwd = lwd
        )
      )
      # progress bar
      pb$tick(1)
      Sys.sleep(0.001)
    }
  }
}
