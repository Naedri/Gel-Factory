# cleaning
rm(list = ls(all = TRUE))
data.frame(unlist("all"))

# function
generate_feature <- function(height, width, minValue, maxValue) {
  y <- dgamma(seq(0, 25, by = 25 / (height - 1)), 2, 0.2)
  xy <- matrix(NA, height, width)
  
  for (pos in seq(height)) {
    x <- dnorm(seq(-1.5, 1.5, by = 3 / (width - 1)), 0, y[pos] * 2)
    # Proportionate x axis to y axis intensity
    x <- x / max(x) * y[pos]
    x[is.nan(x)] <- 0
    xy[pos,] <- x
  }
  xy <- scale_feature(xy, minValue, maxValue)
  
  return(t(xy))
}


scale_feature <- function(feature, minValue, maxValue) {
  m <- max(feature)
  coef <- maxValue - minValue
  feature <- (feature / m) * coef + minValue
  
  return(feature)
}

draw_feature <- function(canvas, feature, yStart, xStart) {
  dimCanvas <- dim(canvas)
  dimFeature <- dim(feature)
  
  for (y in 1:dimFeature[1]) {
    yPos <- yStart + y
    if (yPos < 1 | yPos > dimCanvas[1]) {
      next
    }
    for (x in 1:dimFeature[2]) {
      xPos <- xStart + x
      if (xPos < 1 | xPos > dimCanvas[2]) {
        next
      }
      canvas[yPos, xPos] <-
        max(c(canvas[yPos, xPos], feature[y, x]))
    }
  }
  
  return(canvas)
}


add_feat <- function(canvas, pointFeat, lineFeat, min, max) {
  dimCanvas <- dim(canvas)
  
  
  if (pointFeat > 0) {
    for (i in 1:pointFeat) {
      height <- sample((dimCanvas[1] / 20):(dimCanvas[1] / 10), 1)
      width <- sample((dimCanvas[2] / 20):(dimCanvas[2] / 5), 1)
      feature <- generate_feature(height, width, min, max)
      
      yStart <- sample(0:dimCanvas[1], 1)
      xStart <- sample(0:dimCanvas[2], 1)
      canvas <- draw_feature(canvas, feature, yStart, xStart)
    }
  }
  
  if (lineFeat > 0) {
    for (i in 1:lineFeat) {
      height <- sample((dimCanvas[1] * 1.5):(dimCanvas[1] * 2), 1)
      width <- sample((dimCanvas[2] / 20):(dimCanvas[2] / 10), 1)
      feature <- generate_feature(height, width, min, max)
      
      yStart <- sample(0:(dimCanvas[1] / 8), 1)
      xStart <- sample(0:(dimCanvas[2] / 3), 1)
      canvas <- draw_feature(canvas, feature, yStart, xStart)
    }
  }
  
  return(canvas)
}


image_export <- function(plot, name, color) {
  name <- paste0(name, ".png")
  png(filename = name)
  image(plot, col = color)
  dev.off()
}

# var
lengthCanvas <- c(1000, 1000)
min <- 230
max <- 65536
lengthColor <- 256
featureLong <- 3
featurePoint <- 12

# gradient from brewer "Spectral" palette
colfunc <- colorRampPalette(c("#3288BD", "#FFFFBF", "#D53E4F"))
gradient <- colfunc(lengthColor)

# execution
canvas <- matrix(min, lengthCanvas[1], lengthCanvas[2])
feature <-
  generate_feature(dim(canvas)[1], dim(canvas)[2], min, max)
canvas <- add_feat(canvas, featurePoint, featureLong, min, max)

# export
image_export(canvas, "output/Rplot", gradient)