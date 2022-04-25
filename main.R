generate_feature <- function(length, width){
  y <- dgamma(seq(0, 5, by=5/(length-1)), 1.5, 0.5)
  xy <- matrix(NA, length, width)
  
  for(pos in seq(length)){
    x <- dnorm(seq(-1.5, 1.5, by=3/(width-1)), 0, y[pos])
    x <- x / max(x) * y [pos]
    x[is.nan(x)] <- 0
    xy[pos,] <- x
  }
  xy <- scale_feature(xy, 230, 65536)
  
  return(xy)
}


scale_feature <- function(feature, vmin, vmax){
  m <- max(feature)
  coef <- vmax - vmin
  feature <- (feature / m) * coef + vmin
  
  return(feature)
}

feature <- generate_feature(100, 100)
image(feature, col=grey(seq(0, 1, length = 256)))