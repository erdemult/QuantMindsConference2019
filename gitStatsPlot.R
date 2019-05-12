
require(ggplot2)
require(data.table)
require(gridExtra)

# put the repo lables through geom_text to the left of the plots
# select proper colors, DONE
# remove the white space between the grid plots, DONE
# update the underlying datasets


lighten <- function(color, factor=1.5){
  col <- col2rgb(color)
  col <- col*factor
  col <- rgb(t(as.matrix(apply(col, 1, function(x) if (x > 255) 255 else x))), maxColorValue=255)
  col
}

df <- read.csv(file = 'C:/Users/erdem/Documents/code/quantMinds2019/gitHubStats.csv')
setDT(df)

colorMap <- data.frame(category=c("data manipulation","machinelearning", 
                          "mathematics", "visualization"),
               color = c("#eaa52e","#e05555", "#2c88ea", "#4da839"))
# orange, red, blue
df <- merge(df, colorMap)



# creates Single plot
createPlot <- function(row, ycolumn, color, xlab, ylim, leftmargin) {
  fontsize <- 3
  p1 <- ggplot(row, aes_string(x = "repo", y = ycolumn, label = ycolumn)) +
      geom_bar(stat = "identity", fill=row$color) 

  if (row[[ycolumn]] > ylim*0.5 ) {
    p1 <- p1 + geom_text(
      aes_string(x = "repo", y = ycolumn, label = ycolumn), color = "white", 
              size = fontsize, fontface = "bold",
              position = position_stack(vjust = 0.5)) 
  }  else{
    p1 <- p1 + geom_text(
      aes_string(x = "repo", y = ycolumn, label = ycolumn), 
      hjust = -0.1, size = fontsize, fontface = "bold",
      inherit.aes = TRUE, color=row$color
    )  
  }
    
  p1 <- p1 + coord_flip(ylim = c(0, ylim)) +
  labs(y='', x=xlab) + # needs replacement with geom_text
  theme(axis.text.y = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.title.y=element_text(size=5),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin=unit(c(0, 0, -1, leftmargin), "cm"), # top, r, b, l
        # can we create slightly better background
        panel.background = element_rect(fill = lighten(row$color),
                                        colour = "white",
                                        size = 0.5, linetype = "solid"))   
  return(p1)
}
# test of single plot
createPlot(row, ycolumn = "commits", color = '',
           xlab = row$repo, ylim= 25000, leftmargin = 1)
createPlot(df[repo=="tensorflow"], ycolumn = "commits", color = '',
           xlab = row$repo, ylim= 100000, leftmargin = 1)
createPlot(df[repo=="scipy"], ycolumn = "commits", color = '',
           xlab = df[repo=="scipy"]$repo, ylim= 100000, leftmargin = 1)
createPlot(df[repo=="matplotlib"], ycolumn = "commits", color = '',
           xlab = df[repo=="matplotlib"]$repo, ylim= 100000, leftmargin = -1)

addToList <- function(gs, p){
  k <- length(gs)
  gs[[k+1]] <- p
  return(gs)
}

# go through data and create a list of plots => glob
createGlob <- function(df) {
  shift <- 0
  gs <- list()
  for(id in 1:dim(df)[1]) {
    row <- df[id,]
    p1 <- createPlot(row, ycolumn = "commits", color = row$color,
                     xlab = row$repo, ylim= 25000+shift, leftmargin = 1)
    p2 <- createPlot(row, ycolumn = "forks", color = '',
                     xlab = '', ylim= 80000+shift, leftmargin = -0.4)
    p3 <- createPlot(row, ycolumn = "stars", color = '',
                     xlab = '', ylim= 130000+shift, leftmargin = -0.4)
    p4 <- createPlot(row, ycolumn = "watchers", color = '',
                     xlab = '', ylim= 9000+shift, leftmargin = -0.4)
    gs <- addToList(gs, p1)
    gs <- addToList(gs, p2)
    gs <- addToList(gs, p3)
    gs <- addToList(gs, p4)
  }
  return(gs)
}


gsP <- createGlob(df[type=="python"][order(category,-commits)])  
layP <- matrix(1:length(gsP), ncol = 4, byrow=TRUE)

gsR <- createGlob(df[type=="R"][order(category,-commits)])  
layR <- matrix(seq(length(gsP)+1, length.out=length(gsR)), ncol = 4, byrow=TRUE)

gs <- c(gsP, gsR)
lay <- rowr::cbind.fill(layP, layR, fill=NA)

#createas any empty top row
# lay <- rbind(rep(NA,dim(lay)[2]), lay)
# grid.arrange(grobs=gsR, layout_matrix = layR)
# grid.arrange(grobs=gsP, layout_matrix = layP)
grid.arrange(grobs=gs, layout_matrix = data.matrix(lay))

# 
# library(gridExtra)
# library(grid)
# library(ggplot2)
# library(lattice)
# gs <- lapply(1:9, function(ii)
#   grobTree(rectGrob(gp=gpar(fill=ii, alpha=0.5)), textGrob(ii)))
# 
# lay <- rbind(c(1,1,NA,2,3),
#              c(1,1,NA,4,NA),
#              c(6,7,8,9,NA))
# grid.arrange(grobs = gs, layout_matrix = lay)
# 
# 
# require(qpcR)
# a <- matrix(rnorm(20), ncol = 4) # unequal size matrices
# b <- matrix(rnorm(20), ncol = 5)
# cbind.na(a, b) # works, in contrast to original cbind


# 
# lighten("#FFCC99",1)
# plot(c(1,2,3), type="l", col=lighten("#FFCC99",1))
# plot(c(1,2,3), type="l", col=lighten("#FFCC99",1.5))
