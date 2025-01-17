#' @title Draw circles
#'
#' @description Given x and y coordinates as well as the circle radius, this function draw.
#'
#' @param x a coordinate vector of circles to plot.
#'
#' @param y a coordinate vector of circles to plot.
#'
#' @param radius a single numeric value or a vector specifying the radius of the circles to plot.
#'
#' @param Res a numeric value corresponding to the resolution of the circles (i.e., the number of points used to draw the circles contour, default = 500).
#'
#' @param center either TRUE or a single integers or a vector of integers specifying the symbol(s) or a single character to be used to represent the circle center
#' (see points for possible values and their interpretation).
#'
#' @param col the color or a vector of colors for filling the circles, the default leave polygons unfilled.
#'
#' @param border the color or a vector of colors to draw the border of the circles (default = "black").
#'
#' @param lwd the value of line width or a vector of line width of the circles border (default = 1).
#'
#' @param lty an integer or a vector of integer corresponding to line type to be used for drawing circles border, as in par (default = 1).
#'
#' @return draw the circles from center coordinates and value of the radius on an existing plot window or, if there is no active plot window, on a new plot window.
#'
#' @authors Quentin PETITJEAN
#'
#' @seealso \code{\link{plot}}, \code{\link{points}}, \code{\link{points}}
#'
#' @examples
#'
#'# draw 10 red-border and red-filled circles of different size on a new plot
#'circles(
#'  x = sample(1:100, 10),
#'  y = sample(1:100, 10),
#'  radius = sample(1:10, 10),
#'  center = TRUE,
#'  border = "red",
#'  col = adjustcolor("firebrick", alpha = 0.2),
#'  Res = 500,
#'  lwd = 1.5,
#'  lty = 1
#')
#'
#'# draw 5 red-border and red-filled circles and 5 blue-border and blue-filled circles of different size on a new plot
#'circles(
#'  x = sample(1:100, 10),
#'  y = sample(1:100, 10),
#'  radius = sample(1:10, 10),
#'  center = TRUE,
#'  border = c(rep("red", 5), rep("blue", 5)),
#'  col = c(rep(adjustcolor("firebrick", alpha = 0.2), 5), rep(adjustcolor("lightblue", alpha = 0.2), 5)),
#'  Res = 500,
#'  lwd = 1.5,
#'  lty = c(rep(1,5), rep(2,5))
#')
#'
#' @export

circles <-
  function(x = NULL,
           y = NULL,
           radius = NULL,
           Res = 500,
           center = NULL,
           col = NULL,
           border = "black",
           lwd = 1,
           lty = 1) {
    if (is.null(x)) {
      stop("x argument is missing, 2 coordinate vectors are needed to draw the circles")
    }
    if (length(x) != length(y)) {
      stop("x and y arguments has different length: ",
           length(x),
           ", ",
           length(y))
    }
    if (is.null(radius)) {
      stop("radius argument is missing, a value is needed to determine the size of the circles")
    }
    else if (length(radius) == 1) {
      radius <- rep(radius, length(x))
    }
    else if (length(radius) > 1 & length(radius) != length(x)) {
      stop(
        "radius, x and y arguments has different length: ",
        length(radius),
        ", ",
        length(x),
        ", ",
        length(y)
      )
    }
    if (length(col) == 1) {
      col <- rep(col, length(x))
    }
    else if (length(col) > 1 & length(col) != length(x)) {
      stop(
        "col, x and y arguments has different length: ",
        length(col),
        ", ",
        length(x),
        ", ",
        length(y)
      )
    }
    if (length(border) == 1) {
      border <- rep(border, length(x))
    }
    else if (length(border) > 1 & length(border) != length(x)) {
      stop(
        "border, x and y arguments has different length: ",
        length(border),
        ", ",
        length(x),
        ", ",
        length(y)
      )
    }
    if (length(lwd) == 1) {
      lwd <- rep(lwd, length(x))
    }
    else if (length(lwd) > 1 & length(lwd) != length(x)) {
      stop(
        "lwd, x and y arguments has different length: ",
        length(lwd),
        ", ",
        length(x),
        ", ",
        length(y)
      )
    }
    if (length(lty) == 1) {
      lty <- rep(lty, length(x))
    }
    else if (length(lty) > 1 & length(lty) != length(x)) {
      stop(
        "lty, x and y arguments has different length: ",
        length(lty),
        ", ",
        length(x),
        ", ",
        length(y)
      )
    }
    if (is.null(dev.list())) {
      graphics::plot.new()
      plot(
        NULL,
        xlim = c(
          min(x, na.rm = T) - max(radius,  na.rm = T),
          max(x, na.rm = T) + max(radius,  na.rm = T)
        ),
        ylim = c(
          min(y, na.rm = T) - max(radius,  na.rm = T),
          max(y, na.rm = T) + max(radius,  na.rm = T)
        ),
        xlab = "x",
        ylab = "y",
      )
    }
    theta <- seq(0, 2 * pi, length = Res)
    for (i in seq(length(x))) {
      graphics::polygon(
        x = radius[i] * cos(theta) + x[i],
        y = radius[i] * sin(theta) + y[i],
        col = col[i],
        border = border[i],
        lwd = lwd[i],
        lty = lty[i]
      )
      if (!is.null(center)) {
        if (length(center) == 1) {
          center <- rep(center, length(x))
        }
        else if (length(center) > 1 & length(center) != length(x)) {
          stop(
            "center, x and y arguments has different length: ",
            length(center),
            ", ",
            length(x),
            ", ",
            length(y)
          )
        }
        graphics::points(
          x[i],
          y[i],
          pch = ifelse(isTRUE(center[i]), "+", center[i]),
          col = border[i],
          cex = radius[i] / 6
        )
      }
    }
  }
