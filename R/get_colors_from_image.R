#' The get_colors_from_image function
#'
#' This function allows you to identify the dominant colors in an image.
#' @param image The path to the image. Supports most image types.
#' See image_read from magick package.
#' @param n The number of colors in the palette. Defaults to 5.
#' @param order_by How to order the colors. One of 'luminance', 'chroma' or 'hue'. Defaults to 'luminance'
#' @return The hex codes of the n colors in the palette
#' @export
#' @import magick raster colorspace
#' @examples get_colors_from_image("https://raw.githubusercontent.com/HughSt/mappalettes/master/images/nathan-lindahl-1j18807_ul0-unsplash.jpg",5)


get_colors_from_image <- function(image, n=5, order_by = "luminance"){

      if(!(order_by %in% c("luminance", "hue", "chroma"))){
        stop("'order_by' needs to be one of 'luminance', 'hue' or 'chroma'")
      }

      pic <- image_read(image)

      # Resample to lower res
      pic <- image_scale(pic, "300x")

      # Convert to raster
      tiff_file <- paste0(tempfile(),"pic.jpeg")
      image_write(pic, path = tiff_file, format = 'tiff')
      pic_raster <- raster::brick(tiff_file)

      # Get main clusters
      set.seed(1981)
      clusters <- kmeans(values(pic_raster), n)
      dom_clusters <- rev(sort(table(clusters$cluster)))[1:n]
      means <- round(aggregate(raster::values(pic_raster), list(clusters$cluster), mean), 0)
      means <- subset(means, means$Group.1 %in% names(dom_clusters))
      colors <- NULL
      for(i in 1:nrow(means)){
        colors <- c(colors,
                    rgb(means[i, 2]/255,
                         means[i, 3]/255,
                         means[i, 4]/255))
      }

      # To sort colors, choose closest
      LCH <- as(hex2RGB(colors), "polarLUV")

      if(order_by == "luminance"){
      plot_order <- order(LCH@coords[,1])
      }
      if(order_by == "chroma"){
        plot_order <- order(LCH@coords[,2])
      }
      if(order_by == "hue"){
        plot_order <- order(LCH@coords[,3])
      }

      # Plot pic and colors
      par(mfrow=c(1,2), mar=rep(2,4))
      plot(pic)

      barplot(rep(1, length(colors)),
              axes=F,
              space=0,
              border=NA,
              col = colors[plot_order])
      #mtext(colors, at=seq(0.5, n-0.5, length.out = n),
      #      las = 0, cex=0.6)

      return(colors[plot_order])
}

