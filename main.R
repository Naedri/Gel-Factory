# function

generate_feature <- function(length, width, minValue, maxValue) {
  y <- dgamma(seq(0, 25, by = 25 / (length - 1)), 2, 0.2)
  y <- y
  xy <- matrix(NA, length, width)
  
  for (pos in seq(length)) {
    x <- dnorm(seq(-1.5, 1.5, by = 3 / (width - 1)), 0, y[pos] * 2)
    # Proportionate x axis to y axis intensity
    x <- x / max(x) * y [pos]
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

# var
lengthImg <- 100
min <- 230
max <- 65536
lengthRGB <- 256

# execution
feature <- generate_feature(lengthImg, lengthImg, min, max)
image(t(feature), col = grey(seq(0, 1, length = lengthRGB)))
