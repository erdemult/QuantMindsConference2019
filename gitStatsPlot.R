
require(ggplot2)
require(data.table)
require(gridExtra)

df <- read.csv(file = 'C:/Users/erdem/Documents/code/quantMinds2019/gitHubStats.csv')
setDT(df)
 
# remove background
# remove yaxis 5901, done
# remove ylabel done...
# remove xlabel done
# rotate xlabel by 90 degrees (if rotated axis shift to x not aligned)
# columns with respect to type of the library, commits/forks/stars/watchers 
# color with respect to category
# take care of python ones first, with an order, than commits

# python ones
# 1,2,3,4
# 5,6,7,8
# R ones
# 9, 10, 11, 12
# cbind two matrices
# 1, 2, 3, 4, 9, 10, 11, 12
# 5, 6, 7, 8, NA, NA, NA, NA



createPlot <- function(row, ycolumn, color, xlab, ylim, leftmargin) {
  p1 <- ggplot(row, aes_string(x = "repo", y = ycolumn, label = ycolumn)) +
  geom_bar(stat = "identity") +
  # geom_text(size = 3, hjust = -10, nudge_x =  0 ) +
    geom_text(
      aes_string(x = "repo", y = ycolumn, label = ycolumn), 
      hjust = -0.5, size = 2,
      inherit.aes = TRUE
    )  +
  coord_flip(ylim = c(0, ylim)) +
  labs(y='', x=xlab) + 
  theme(axis.text.y = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.title.y=element_text(size=5),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.margin=unit(c(0,0,-0.5,leftmargin), "cm"))   
  # +
  # annotate(geom = "text", x = 1, y = -1,
  #          label = "helpful annotation", color = "red",
  #            angle = 0)
  return(p1)
}
createPlot(row, ycolumn = "commits", color = '',
           xlab = row$repo, ylim= 20000, leftmargin = 1)

addToList <- function(gs, p){
  k <- length(gs)
  gs[[k+1]] <- p
  return(gs)
}




createGlob <- function(df, gs) {
  for(id in 1:dim(df)[1]) {
    row <- df[id,]
    p1 <- createPlot(row, ycolumn = "commits", color = '',
                     xlab = row$repo, ylim= 25000, leftmargin = 1)
    p2 <- createPlot(row, ycolumn = "forks", color = '',
                     xlab = '', ylim= 100000, leftmargin = -1)
    p3 <- createPlot(row, ycolumn = "stars", color = '',
                     xlab = '', ylim= 200000, leftmargin = -1)
    p4 <- createPlot(row, ycolumn = "watchers", color = '',
                     xlab = '', ylim= 10000, leftmargin = -1)
    gs <- addToList(gs, p1)
    gs <- addToList(gs, p2)
    gs <- addToList(gs, p3)
    gs <- addToList(gs, p4)
  }
  return(gs)
}

gsP <- list()
gsP <- createGlob(df[type=="python"][order(category,-commits)])  
layP <- matrix(1:length(gsP), ncol =4, byrow=TRUE)


grid.arrange(grobs=gs, layout_matrix = lay)


library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)
gs <- lapply(1:9, function(ii) 
  grobTree(rectGrob(gp=gpar(fill=ii, alpha=0.5)), textGrob(ii)))

lay <- rbind(c(1,1,1,2,3),
             c(1,1,1,4,5),
             c(6,7,8,9,9))
grid.arrange(grobs = gs, layout_matrix = lay)
