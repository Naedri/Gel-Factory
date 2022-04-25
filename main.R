# function

generate_feature <- function(height, width, minValue, maxValue) {
  y <- dgamma(seq(0, 25, by = 25 / (height - 1)), 2, 0.2)
  y <- y
  xy <- matrix(NA, height, width)
  
  for (pos in seq(height)) {
    x <- dnorm(seq(-1.5, 1.5, by = 3 / (width - 1)), 0, y[pos] * 2)
    # Proportionate x axis to y axis intensity
    x <- x / max(x) * y[pos]
    x[is.nan(x)] <- 0
    xy[pos,] <- x
  }
  xy <- scale_feature(xy, minValue, maxValue)
  
  return(xy)
}


scale_feature <- function(feature, vmin, vmax) {
  m <- max(feature)
  coef <- vmax - vmin
  feature <- (feature / m) * coef + vmin
  
  return(feature)
}

draw_feature <- function(canvas,
                         feature,
                         ystart = 0,
                         xstart = 0) {
  dimCanvas <- dim(canvas)
  dimFeature <- dim(feature)
  
  if (ystart < 1 | ystart > dimCanvas[1]) {
    ystart <- sample(1:dimCanvas[1], 1)
  }
  if (xstart < 1 | xstart > dimCanvas[2]) {
    xstart <- sample(1:dimCanvas[2], 1)
  }
  
  for (y in 1:dimFeature[1]) {
    ypos <- ystart + y - 1
    if (ypos > dimCanvas[1]) {
      next
    }
    for (x in 1:dimFeature[2]) {
      xpos <- xstart + x - 1
      if (xpos > dimCanvas[2]) {
        next
      }
      canvas[ypos, xpos] <-
        max(c(canvas[ypos, xpos], feature[y, x]))
    }
  }
  
  return(canvas)
}

# var
lengthCanvas <- c(100, 100)
min <- 230
max <- 65536
lengthColor <- 256

# gradient
colfunc <- colorRampPalette(c("blue", "yellow", "red"))
gradient <- colfunc(lengthColor)

# execution
canvas <- matrix(min, lengthCanvas[1], lengthCanvas[2])
feature <-
  generate_feature(lengthCanvas[1], lengthCanvas[2], min, max)
canvas <- draw_feature(canvas, feature)

image(canvas, col = gradient)
