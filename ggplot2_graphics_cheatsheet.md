# Graphics cheatsheet in ggplot2 

Yuwei Hu

Motivation: My main purpose to create this cheat sheet is organizing statistical graphics (contains graphics mentioned in this class and in other websites(1)) by ggplot2. At the same time, I want to show the usage of ggplot2 functions in this cheat sheet. It means some graphics mentioned in this document can be created more easily by base R or other packages. This cheat sheet is divided into 'Distribution', 'Correlation', 'Ranking', 'Evolution' and 'Flow', five types of graphic. To find the code, you can firstly consider the type of graphic you want to draw and then choose the code for certain chart. I think that it is organized to create most graphics by ggplot2 because we can control elements in different graphs by similar methods. However, due to the existing of other graphic packages, we can draw some graphs by simpler code than several lines of ggplot2 code. Next time, I may create a cheat sheet of simpler code for the graphics mentioned in the document.

(1)https://r-graph-gallery.com/index.html


```r
library(ggplot2)
library(gridExtra)
library(d3r)
library(dplyr)
library(forcats)
library(Lock5withR)
library(ggridges)
library(broom)
library(plotly)
library(MASS)
library(gcookbook) 
library(GGally)
library(parcoords)
library(ggmosaic)
library(ggalluvial)
```
## Distribution
### histogram

```r
data=data.frame(x=sample(0:20,100,replace = T))
```


```r
# basic histogram
gh<-ggplot(data, aes(x)) + 
  geom_histogram()+
  ggtitle("basic histogram")+
  theme_grey(8)

# add color, bin width and bin center
g1<-ggplot(data, aes(x)) + 
  geom_histogram(color = "blue", fill = "lightblue", binwidth = 5, center = 0)+
  ggtitle("binwidth=5 and centered at 0")+
  theme_grey(8)

# unequal bin widths
g2<-ggplot(data, aes(x)) +
  geom_histogram(color = "blue", fill = "lightblue", breaks=c(0,2,5,10, 20))+
  ggtitle("unequal bin widths")+
  theme_grey(8)


# density histogram
gd<-ggplot(data, aes(x)) + 
  geom_histogram(aes(y = ..density..),color = "blue", fill = "lightblue")+
  geom_density(color = "red") +
  ggtitle("density histogram")+
  theme_grey(8)

# Cumulative frequency histogram
gc<-ggplot(data, aes(x)) +
  geom_histogram(aes(y = cumsum(..count..)), color = "blue", fill = "lightblue") +
  ggtitle("Cumulative Frequency")+
  theme_grey(8)


# Bin boundaries: right closed/left closed
gr<-ggplot(data, aes(x)) + 
  geom_histogram(color = "blue", fill = "lightblue", binwidth = 1, center = 0.5, closed = "right") +
  ggtitle("right closed")+
  theme_grey(8)

gl<-ggplot(data, aes(x)) + 
  geom_histogram(color = "blue", fill = "lightblue", binwidth = 1, center = 0.5, closed = "left") +
  ggtitle("left closed")+
  theme_grey(8)

# histogram with several groups
# source: https://r-graph-gallery.com/histogram_several_group.html
gmulti<-ggplot(iris, aes(x=Sepal.Length, fill=Species)) +
    geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity')+
  ggtitle("histogram with several groups")+
  theme_grey(8)

grid.arrange(gh,g1, g2,gd, gc,gr, gl,gmulti,ncol=3, nrow =3)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-3-1.png" width="672" style="display: block; margin: auto;" />

### boxplot

```r
# resource: https://r-graph-gallery.com/89-box-and-scatter-plot-with-ggplot2.html
data2 <- data.frame(
  group=c( rep("A",500), rep("B",500), rep("B",500), rep("C",20), rep('D', 100)  ),
  value=c( rnorm(500, 10, 5), rnorm(500, 13, 1), rnorm(500, 18, 1), rnorm(20, 25, 4), rnorm(100, 12, 1) )
)
```


```r
# basic
gs<-ggplot(data, aes(x)) + 
  geom_boxplot()+
  ggtitle("basic boxplot")+
  theme_grey(10)

gm<-ggplot(data2, aes(group, value)) + 
  geom_boxplot()+
  ggtitle("basic boxplot by group")+
  theme_grey(10)


# reorder by median
gorder<-ggplot(data2) + 
  geom_boxplot(aes(x = reorder(group, -value, median),y = value)) +
  ggtitle("order by median with variable width boxplots")+
  theme_grey(10)

# variable width boxplots
gwidth<-ggplot(data2) + 
  geom_boxplot(aes(group,value),varwidth = TRUE) +
  ggtitle("variable width boxplots")+
  theme_grey(10)

# horizontal boxplots
ghorizontal<-ggplot(data2) + 
  geom_boxplot(aes(group,value)) +
  coord_flip()+
  ggtitle("horizontal boxplots")+
  theme_grey(10)

grid.arrange(gs, gm,gorder, gwidth,ghorizontal,ncol=3, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

### Violin plots, ridgeline plot vs boxplot

```r
# basic violin plots with color
gv<-ggplot(data2) + 
  geom_violin(aes(group,value, fill=group),adjust = 6)+ 
  ggtitle("violin plots")

# basic ridgeline plot
gr<-ggplot(data2) +
  geom_density_ridges(aes(value,group, fill=group), alpha = .5, scale = 1)+
  ggtitle("ridgeline plot")

grid.arrange(gv, gr,gm,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />
## Correlation
### Scatterplot

```r
gsca<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width,color = Species)) + 
  geom_point()+
  ggtitle("colored Scatterplot")+
  theme_grey(8)

gscaadj<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  geom_point(alpha = 0.4, size = 0.8,pch = 21,stroke = 0)+
  ggtitle("Scatterplot with adjusted alpha, size, pch, stroke")+
  theme_grey(8)

glm<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  geom_point()+
  geom_smooth(method = 'lm', se = FALSE) +
  ggtitle("basic Scatterplot with linear model")+
  theme_grey(8)


mod <- lm(Sepal.Width~Sepal.Length,iris)
r2 <- summary(mod)$r.squared

df <- mod %>% augment()
grp<-ggplot(df, aes(.fitted, .std.resid)) + 
  geom_point()+
  geom_hline(yintercept = 0, col = "blue")+
  ggtitle("Residual plot")+
  theme_grey(8)

# basic Scatterplot with facets
gsf<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  geom_point()+
  facet_wrap(~Species, ncol=3,scales = "free_x")+
  ggtitle("basic Scatterplot with facets")+
  theme_grey(8)

grid.arrange(gsca,gscaadj,glm,grp,gsf,ncol=3, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

```r
# Interactive

ggplotly(gsca)
```

```{=html}
<div id="htmlwidget-5d967101cf135d925ead" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-5d967101cf135d925ead">{"x":{"data":[{"x":[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5],"y":[3.5,3,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3,3,4,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3,3.4,3.5,2.3,3.2,3.5,3.8,3,3.8,3.2,3.7,3.3],"text":["Sepal.Length: 5.1<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 4.9<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 4.7<br />Sepal.Width: 3.2<br />Species: setosa","Sepal.Length: 4.6<br />Sepal.Width: 3.1<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.6<br />Species: setosa","Sepal.Length: 5.4<br />Sepal.Width: 3.9<br />Species: setosa","Sepal.Length: 4.6<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 4.4<br />Sepal.Width: 2.9<br />Species: setosa","Sepal.Length: 4.9<br />Sepal.Width: 3.1<br />Species: setosa","Sepal.Length: 5.4<br />Sepal.Width: 3.7<br />Species: setosa","Sepal.Length: 4.8<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 4.8<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 4.3<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 5.8<br />Sepal.Width: 4.0<br />Species: setosa","Sepal.Length: 5.7<br />Sepal.Width: 4.4<br />Species: setosa","Sepal.Length: 5.4<br />Sepal.Width: 3.9<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 5.7<br />Sepal.Width: 3.8<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.8<br />Species: setosa","Sepal.Length: 5.4<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.7<br />Species: setosa","Sepal.Length: 4.6<br />Sepal.Width: 3.6<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.3<br />Species: setosa","Sepal.Length: 4.8<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.2<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 5.2<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 4.7<br />Sepal.Width: 3.2<br />Species: setosa","Sepal.Length: 4.8<br />Sepal.Width: 3.1<br />Species: setosa","Sepal.Length: 5.4<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.2<br />Sepal.Width: 4.1<br />Species: setosa","Sepal.Length: 5.5<br />Sepal.Width: 4.2<br />Species: setosa","Sepal.Length: 4.9<br />Sepal.Width: 3.1<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.2<br />Species: setosa","Sepal.Length: 5.5<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 4.9<br />Sepal.Width: 3.6<br />Species: setosa","Sepal.Length: 4.4<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.4<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 4.5<br />Sepal.Width: 2.3<br />Species: setosa","Sepal.Length: 4.4<br />Sepal.Width: 3.2<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.5<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.8<br />Species: setosa","Sepal.Length: 4.8<br />Sepal.Width: 3.0<br />Species: setosa","Sepal.Length: 5.1<br />Sepal.Width: 3.8<br />Species: setosa","Sepal.Length: 4.6<br />Sepal.Width: 3.2<br />Species: setosa","Sepal.Length: 5.3<br />Sepal.Width: 3.7<br />Species: setosa","Sepal.Length: 5.0<br />Sepal.Width: 3.3<br />Species: setosa"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(248,118,109,1)"}},"hoveron":"points","name":"setosa","legendgroup":"setosa","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7],"y":[3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2,3,2.2,2.9,2.9,3.1,3,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3,2.8,3,2.9,2.6,2.4,2.4,2.7,2.7,3,3.4,3.1,2.3,3,2.5,2.6,3,2.6,2.3,2.7,3,2.9,2.9,2.5,2.8],"text":["Sepal.Length: 7.0<br />Sepal.Width: 3.2<br />Species: versicolor","Sepal.Length: 6.4<br />Sepal.Width: 3.2<br />Species: versicolor","Sepal.Length: 6.9<br />Sepal.Width: 3.1<br />Species: versicolor","Sepal.Length: 5.5<br />Sepal.Width: 2.3<br />Species: versicolor","Sepal.Length: 6.5<br />Sepal.Width: 2.8<br />Species: versicolor","Sepal.Length: 5.7<br />Sepal.Width: 2.8<br />Species: versicolor","Sepal.Length: 6.3<br />Sepal.Width: 3.3<br />Species: versicolor","Sepal.Length: 4.9<br />Sepal.Width: 2.4<br />Species: versicolor","Sepal.Length: 6.6<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 5.2<br />Sepal.Width: 2.7<br />Species: versicolor","Sepal.Length: 5.0<br />Sepal.Width: 2.0<br />Species: versicolor","Sepal.Length: 5.9<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 6.0<br />Sepal.Width: 2.2<br />Species: versicolor","Sepal.Length: 6.1<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 5.6<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 6.7<br />Sepal.Width: 3.1<br />Species: versicolor","Sepal.Length: 5.6<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 5.8<br />Sepal.Width: 2.7<br />Species: versicolor","Sepal.Length: 6.2<br />Sepal.Width: 2.2<br />Species: versicolor","Sepal.Length: 5.6<br />Sepal.Width: 2.5<br />Species: versicolor","Sepal.Length: 5.9<br />Sepal.Width: 3.2<br />Species: versicolor","Sepal.Length: 6.1<br />Sepal.Width: 2.8<br />Species: versicolor","Sepal.Length: 6.3<br />Sepal.Width: 2.5<br />Species: versicolor","Sepal.Length: 6.1<br />Sepal.Width: 2.8<br />Species: versicolor","Sepal.Length: 6.4<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 6.6<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 6.8<br />Sepal.Width: 2.8<br />Species: versicolor","Sepal.Length: 6.7<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 6.0<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 5.7<br />Sepal.Width: 2.6<br />Species: versicolor","Sepal.Length: 5.5<br />Sepal.Width: 2.4<br />Species: versicolor","Sepal.Length: 5.5<br />Sepal.Width: 2.4<br />Species: versicolor","Sepal.Length: 5.8<br />Sepal.Width: 2.7<br />Species: versicolor","Sepal.Length: 6.0<br />Sepal.Width: 2.7<br />Species: versicolor","Sepal.Length: 5.4<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 6.0<br />Sepal.Width: 3.4<br />Species: versicolor","Sepal.Length: 6.7<br />Sepal.Width: 3.1<br />Species: versicolor","Sepal.Length: 6.3<br />Sepal.Width: 2.3<br />Species: versicolor","Sepal.Length: 5.6<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 5.5<br />Sepal.Width: 2.5<br />Species: versicolor","Sepal.Length: 5.5<br />Sepal.Width: 2.6<br />Species: versicolor","Sepal.Length: 6.1<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 5.8<br />Sepal.Width: 2.6<br />Species: versicolor","Sepal.Length: 5.0<br />Sepal.Width: 2.3<br />Species: versicolor","Sepal.Length: 5.6<br />Sepal.Width: 2.7<br />Species: versicolor","Sepal.Length: 5.7<br />Sepal.Width: 3.0<br />Species: versicolor","Sepal.Length: 5.7<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 6.2<br />Sepal.Width: 2.9<br />Species: versicolor","Sepal.Length: 5.1<br />Sepal.Width: 2.5<br />Species: versicolor","Sepal.Length: 5.7<br />Sepal.Width: 2.8<br />Species: versicolor"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,186,56,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,186,56,1)"}},"hoveron":"points","name":"versicolor","legendgroup":"versicolor","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"y":[3.3,2.7,3,2.9,3,3,2.5,2.9,2.5,3.6,3.2,2.7,3,2.5,2.8,3.2,3,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3,2.8,3,2.8,3.8,2.8,2.8,2.6,3,3.4,3.1,3,3.1,3.1,3.1,2.7,3.2,3.3,3,2.5,3,3.4,3],"text":["Sepal.Length: 6.3<br />Sepal.Width: 3.3<br />Species: virginica","Sepal.Length: 5.8<br />Sepal.Width: 2.7<br />Species: virginica","Sepal.Length: 7.1<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.3<br />Sepal.Width: 2.9<br />Species: virginica","Sepal.Length: 6.5<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 7.6<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 4.9<br />Sepal.Width: 2.5<br />Species: virginica","Sepal.Length: 7.3<br />Sepal.Width: 2.9<br />Species: virginica","Sepal.Length: 6.7<br />Sepal.Width: 2.5<br />Species: virginica","Sepal.Length: 7.2<br />Sepal.Width: 3.6<br />Species: virginica","Sepal.Length: 6.5<br />Sepal.Width: 3.2<br />Species: virginica","Sepal.Length: 6.4<br />Sepal.Width: 2.7<br />Species: virginica","Sepal.Length: 6.8<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 5.7<br />Sepal.Width: 2.5<br />Species: virginica","Sepal.Length: 5.8<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 6.4<br />Sepal.Width: 3.2<br />Species: virginica","Sepal.Length: 6.5<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 7.7<br />Sepal.Width: 3.8<br />Species: virginica","Sepal.Length: 7.7<br />Sepal.Width: 2.6<br />Species: virginica","Sepal.Length: 6.0<br />Sepal.Width: 2.2<br />Species: virginica","Sepal.Length: 6.9<br />Sepal.Width: 3.2<br />Species: virginica","Sepal.Length: 5.6<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 7.7<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 6.3<br />Sepal.Width: 2.7<br />Species: virginica","Sepal.Length: 6.7<br />Sepal.Width: 3.3<br />Species: virginica","Sepal.Length: 7.2<br />Sepal.Width: 3.2<br />Species: virginica","Sepal.Length: 6.2<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 6.1<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.4<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 7.2<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 7.4<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 7.9<br />Sepal.Width: 3.8<br />Species: virginica","Sepal.Length: 6.4<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 6.3<br />Sepal.Width: 2.8<br />Species: virginica","Sepal.Length: 6.1<br />Sepal.Width: 2.6<br />Species: virginica","Sepal.Length: 7.7<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.3<br />Sepal.Width: 3.4<br />Species: virginica","Sepal.Length: 6.4<br />Sepal.Width: 3.1<br />Species: virginica","Sepal.Length: 6.0<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.9<br />Sepal.Width: 3.1<br />Species: virginica","Sepal.Length: 6.7<br />Sepal.Width: 3.1<br />Species: virginica","Sepal.Length: 6.9<br />Sepal.Width: 3.1<br />Species: virginica","Sepal.Length: 5.8<br />Sepal.Width: 2.7<br />Species: virginica","Sepal.Length: 6.8<br />Sepal.Width: 3.2<br />Species: virginica","Sepal.Length: 6.7<br />Sepal.Width: 3.3<br />Species: virginica","Sepal.Length: 6.7<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.3<br />Sepal.Width: 2.5<br />Species: virginica","Sepal.Length: 6.5<br />Sepal.Width: 3.0<br />Species: virginica","Sepal.Length: 6.2<br />Sepal.Width: 3.4<br />Species: virginica","Sepal.Length: 5.9<br />Sepal.Width: 3.0<br />Species: virginica"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(97,156,255,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(97,156,255,1)"}},"hoveron":"points","name":"virginica","legendgroup":"virginica","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":36.1909506019095,"r":5.31340805313408,"b":29.2237442922374,"l":31.3491075134911},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682},"title":{"text":"colored Scatterplot","font":{"color":"rgba(0,0,0,1)","family":"","size":12.7521793275218},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[4.12,8.08],"tickmode":"array","ticktext":["5","6","7","8"],"tickvals":[5,6,7,8],"categoryorder":"array","categoryarray":["5","6","7","8"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":2.65670402656704,"tickwidth":0.483037095739462,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":8.50145288501453},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.483037095739462,"zeroline":false,"anchor":"y","title":{"text":"Sepal.Length","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[1.88,4.52],"tickmode":"array","ticktext":["2.0","2.5","3.0","3.5","4.0","4.5"],"tickvals":[2,2.5,3,3.5,4,4.5],"categoryorder":"array","categoryarray":["2.0","2.5","3.0","3.5","4.0","4.5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":2.65670402656704,"tickwidth":0.483037095739462,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":8.50145288501453},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.483037095739462,"zeroline":false,"anchor":"x","title":{"text":"Sepal.Width","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.37437365783822,"font":{"color":"rgba(0,0,0,1)","family":"","size":8.50145288501453},"title":{"text":"Species","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"2fbca1be88e":{"x":{},"y":{},"colour":{},"type":"scatter"}},"cur_data":"2fbca1be88e","visdat":{"2fbca1be88e":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

```r
# scatterplot with heatmap and contour lines
ghh<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  scale_fill_viridis_c()+
  geom_hex(binwidth = c(0.5, 0.5), alpha = .4)+
  geom_point(size = 1)+
  ggtitle("Scatterplot with Hex heatmap")+
  theme_grey(8)

gsh<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  scale_fill_viridis_c()+
  geom_bin2d(binwidth = c(0.5, 0.5), alpha = .4)+
  geom_point(size = 1)+
  ggtitle("Scatterplot with Square heatmap")+
  theme_grey(8)

gcl<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  scale_fill_viridis_c()+
  geom_density2d(colour="red",bins = 5)+
  geom_point(size = 1)+
  ggtitle("Scatterplot with contour lines")+
  theme_grey(8)

data3<-data.frame(time = c(1,2,3,4,5,6,7,8,9,10),
                  value = sample(1:50,10))
# basic connected scatterplot
ggcs<-ggplot(data3, aes(x=time, y=value)) +
    geom_line() +
    geom_point()+
  ggtitle("basic connected scatterplot")+
  theme_grey(8)

grid.arrange(ghh,gsh,gcl,ggcs,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-7-3.png" width="672" style="display: block; margin: auto;" />

```r
# 2D kernel

f1 <- kde2d(iris$Sepal.Length, iris$Sepal.Width)
image(f1)
contour(f1, add = T)
points(iris$Sepal.Length, iris$Sepal.Width, pch = 16)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-7-4.png" width="672" style="display: block; margin: auto;" />

### Heatmap

```r
# data from course notes
grade <- rep(c("first", "second", "third", "fourth"), 3)
subject <- rep(c("math", "reading", "gym"), each = 4)
statescore <- sample(50, 12) + 50
df <- data.frame(grade, subject, statescore)

# basic heatmap
ghp<-ggplot(df, aes(grade, subject, fill = statescore))+ 
  geom_tile()+
  ggtitle("basic heatmap")+
  theme_grey(8)

# control color
ghpc<-ggplot(df, aes(grade, subject, fill = statescore)) + 
  geom_tile() +
  scale_fill_gradient(low="white", high="blue")+
  ggtitle("control color")+
  theme_grey(8)

grid.arrange(ghp,ghpc,ncol=2, nrow =1)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

```r
# interactive
ggplotly(ghp)
```

```{=html}
<div id="htmlwidget-91382f4916a0192cc851" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-91382f4916a0192cc851">{"x":{"data":[{"x":[1,2,3,4],"y":[1,2,3],"z":[[0.675,0.775,0,0.9],[0.45,1,0.7,0.525],[0.1,0.975,0.325,0.425]],"text":[["grade: first<br />subject: gym<br />statescore: 82","grade: fourth<br />subject: gym<br />statescore: 86","grade: second<br />subject: gym<br />statescore: 55","grade: third<br />subject: gym<br />statescore: 91"],["grade: first<br />subject: math<br />statescore: 73","grade: fourth<br />subject: math<br />statescore: 95","grade: second<br />subject: math<br />statescore: 83","grade: third<br />subject: math<br />statescore: 76"],["grade: first<br />subject: reading<br />statescore: 59","grade: fourth<br />subject: reading<br />statescore: 94","grade: second<br />subject: reading<br />statescore: 68","grade: third<br />subject: reading<br />statescore: 72"]],"colorscale":[[0,"#132B43"],[0.1,"#193753"],[0.325,"#275379"],[0.425,"#2E608A"],[0.45,"#2F638F"],[0.525,"#346E9C"],[0.675,"#3F82B8"],[0.7,"#4186BD"],[0.775,"#4690CB"],[0.9,"#4FA2E3"],[0.975,"#54ADF2"],[1,"#56B1F7"]],"type":"heatmap","showscale":false,"autocolorscale":false,"showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1],"y":[1],"name":"99_012e31c27bc74d28e17c6b5cf716b1eb","type":"scatter","mode":"markers","opacity":0,"hoverinfo":"skip","showlegend":false,"marker":{"color":[0,1],"colorscale":[[0,"#132B43"],[0.00334448160535121,"#132B44"],[0.00668896321070243,"#132C44"],[0.0100334448160535,"#142C45"],[0.0133779264214047,"#142D45"],[0.0167224080267559,"#142D46"],[0.0200668896321071,"#142D46"],[0.0234113712374581,"#142E47"],[0.0267558528428093,"#152E47"],[0.0301003344481606,"#152F48"],[0.0334448160535118,"#152F48"],[0.0367892976588628,"#152F49"],[0.040133779264214,"#153049"],[0.0434782608695652,"#16304A"],[0.0468227424749164,"#16304A"],[0.0501672240802675,"#16314B"],[0.0535117056856187,"#16314B"],[0.0568561872909699,"#16324C"],[0.0602006688963211,"#17324D"],[0.0635451505016722,"#17324D"],[0.0668896321070234,"#17334E"],[0.0702341137123746,"#17334E"],[0.0735785953177258,"#17344F"],[0.076923076923077,"#18344F"],[0.080267558528428,"#183450"],[0.0836120401337793,"#183550"],[0.0869565217391305,"#183551"],[0.0903010033444817,"#183651"],[0.0936454849498327,"#193652"],[0.0969899665551839,"#193652"],[0.100334448160535,"#193753"],[0.103678929765886,"#193754"],[0.107023411371237,"#193854"],[0.110367892976589,"#1A3855"],[0.11371237458194,"#1A3955"],[0.117056856187291,"#1A3956"],[0.120401337792642,"#1A3956"],[0.123745819397993,"#1A3A57"],[0.127090301003344,"#1B3A57"],[0.130434782608696,"#1B3B58"],[0.133779264214047,"#1B3B59"],[0.137123745819398,"#1B3B59"],[0.140468227424749,"#1C3C5A"],[0.1438127090301,"#1C3C5A"],[0.147157190635452,"#1C3D5B"],[0.150501672240803,"#1C3D5B"],[0.153846153846154,"#1C3D5C"],[0.157190635451505,"#1D3E5C"],[0.160535117056856,"#1D3E5D"],[0.163879598662207,"#1D3F5D"],[0.167224080267559,"#1D3F5E"],[0.17056856187291,"#1D3F5F"],[0.173913043478261,"#1E405F"],[0.177257525083612,"#1E4060"],[0.180602006688963,"#1E4160"],[0.183946488294314,"#1E4161"],[0.187290969899666,"#1E4261"],[0.190635451505017,"#1F4262"],[0.193979933110368,"#1F4263"],[0.197324414715719,"#1F4363"],[0.20066889632107,"#1F4364"],[0.204013377926421,"#1F4464"],[0.207357859531773,"#204465"],[0.210702341137124,"#204465"],[0.214046822742475,"#204566"],[0.217391304347826,"#204566"],[0.220735785953177,"#214667"],[0.224080267558528,"#214668"],[0.22742474916388,"#214768"],[0.230769230769231,"#214769"],[0.234113712374582,"#214769"],[0.237458193979933,"#22486A"],[0.240802675585284,"#22486A"],[0.244147157190636,"#22496B"],[0.247491638795987,"#22496C"],[0.250836120401338,"#224A6C"],[0.254180602006689,"#234A6D"],[0.25752508361204,"#234A6D"],[0.260869565217391,"#234B6E"],[0.264214046822742,"#234B6E"],[0.267558528428093,"#244C6F"],[0.270903010033445,"#244C70"],[0.274247491638796,"#244C70"],[0.277591973244147,"#244D71"],[0.280936454849498,"#244D71"],[0.284280936454849,"#254E72"],[0.287625418060201,"#254E72"],[0.290969899665552,"#254F73"],[0.294314381270903,"#254F74"],[0.297658862876254,"#254F74"],[0.301003344481605,"#265075"],[0.304347826086957,"#265075"],[0.307692307692308,"#265176"],[0.311036789297659,"#265176"],[0.31438127090301,"#275277"],[0.317725752508361,"#275278"],[0.321070234113712,"#275278"],[0.324414715719064,"#275379"],[0.327759197324415,"#275379"],[0.331103678929766,"#28547A"],[0.334448160535117,"#28547B"],[0.337792642140468,"#28557B"],[0.341137123745819,"#28557C"],[0.34448160535117,"#28567C"],[0.347826086956522,"#29567D"],[0.351170568561873,"#29567D"],[0.354515050167224,"#29577E"],[0.357859531772575,"#29577F"],[0.361204013377926,"#2A587F"],[0.364548494983278,"#2A5880"],[0.367892976588629,"#2A5980"],[0.37123745819398,"#2A5981"],[0.374581939799331,"#2A5982"],[0.377926421404682,"#2B5A82"],[0.381270903010033,"#2B5A83"],[0.384615384615385,"#2B5B83"],[0.387959866220736,"#2B5B84"],[0.391304347826087,"#2C5C85"],[0.394648829431438,"#2C5C85"],[0.397993311036789,"#2C5D86"],[0.401337792642141,"#2C5D86"],[0.404682274247492,"#2C5D87"],[0.408026755852843,"#2D5E87"],[0.411371237458194,"#2D5E88"],[0.414715719063545,"#2D5F89"],[0.418060200668896,"#2D5F89"],[0.421404682274247,"#2E608A"],[0.424749163879598,"#2E608A"],[0.42809364548495,"#2E618B"],[0.431438127090301,"#2E618C"],[0.434782608695652,"#2E618C"],[0.438127090301003,"#2F628D"],[0.441471571906354,"#2F628D"],[0.444816053511706,"#2F638E"],[0.448160535117057,"#2F638F"],[0.451505016722408,"#30648F"],[0.454849498327759,"#306490"],[0.45819397993311,"#306590"],[0.461538461538461,"#306591"],[0.464882943143813,"#306592"],[0.468227424749164,"#316692"],[0.471571906354515,"#316693"],[0.474916387959866,"#316793"],[0.478260869565217,"#316794"],[0.481605351170569,"#326895"],[0.48494983277592,"#326895"],[0.488294314381271,"#326996"],[0.491638795986622,"#326996"],[0.494983277591973,"#326997"],[0.498327759197324,"#336A98"],[0.501672240802675,"#336A98"],[0.505016722408027,"#336B99"],[0.508361204013378,"#336B99"],[0.511705685618729,"#346C9A"],[0.51505016722408,"#346C9B"],[0.518394648829431,"#346D9B"],[0.521739130434783,"#346D9C"],[0.525083612040134,"#346E9D"],[0.528428093645485,"#356E9D"],[0.531772575250836,"#356E9E"],[0.535117056856187,"#356F9E"],[0.538461538461538,"#356F9F"],[0.54180602006689,"#3670A0"],[0.545150501672241,"#3670A0"],[0.548494983277592,"#3671A1"],[0.551839464882943,"#3671A1"],[0.555183946488294,"#3772A2"],[0.558528428093646,"#3772A3"],[0.561872909698997,"#3773A3"],[0.565217391304348,"#3773A4"],[0.568561872909699,"#3773A4"],[0.57190635451505,"#3874A5"],[0.575250836120402,"#3874A6"],[0.578595317725753,"#3875A6"],[0.581939799331104,"#3875A7"],[0.585284280936455,"#3976A8"],[0.588628762541806,"#3976A8"],[0.591973244147157,"#3977A9"],[0.595317725752508,"#3977A9"],[0.598662207357859,"#3978AA"],[0.602006688963211,"#3A78AB"],[0.605351170568562,"#3A79AB"],[0.608695652173913,"#3A79AC"],[0.612040133779264,"#3A79AC"],[0.615384615384615,"#3B7AAD"],[0.618729096989966,"#3B7AAE"],[0.622073578595318,"#3B7BAE"],[0.625418060200669,"#3B7BAF"],[0.62876254180602,"#3C7CB0"],[0.632107023411371,"#3C7CB0"],[0.635451505016722,"#3C7DB1"],[0.638795986622074,"#3C7DB1"],[0.642140468227425,"#3C7EB2"],[0.645484949832776,"#3D7EB3"],[0.648829431438127,"#3D7FB3"],[0.652173913043478,"#3D7FB4"],[0.65551839464883,"#3D7FB5"],[0.658862876254181,"#3E80B5"],[0.662207357859532,"#3E80B6"],[0.665551839464883,"#3E81B6"],[0.668896321070234,"#3E81B7"],[0.672240802675585,"#3F82B8"],[0.675585284280936,"#3F82B8"],[0.678929765886288,"#3F83B9"],[0.682274247491639,"#3F83BA"],[0.68561872909699,"#4084BA"],[0.688963210702341,"#4084BB"],[0.692307692307692,"#4085BB"],[0.695652173913043,"#4085BC"],[0.698996655518395,"#4086BD"],[0.702341137123746,"#4186BD"],[0.705685618729097,"#4186BE"],[0.709030100334448,"#4187BF"],[0.712374581939799,"#4187BF"],[0.715719063545151,"#4288C0"],[0.719063545150502,"#4288C1"],[0.722408026755853,"#4289C1"],[0.725752508361204,"#4289C2"],[0.729096989966555,"#438AC2"],[0.732441471571907,"#438AC3"],[0.735785953177258,"#438BC4"],[0.739130434782609,"#438BC4"],[0.74247491638796,"#438CC5"],[0.745819397993311,"#448CC6"],[0.749163879598662,"#448DC6"],[0.752508361204013,"#448DC7"],[0.755852842809364,"#448EC8"],[0.759197324414716,"#458EC8"],[0.762541806020067,"#458FC9"],[0.765886287625418,"#458FC9"],[0.769230769230769,"#458FCA"],[0.77257525083612,"#4690CB"],[0.775919732441471,"#4690CB"],[0.779264214046823,"#4691CC"],[0.782608695652174,"#4691CD"],[0.785953177257525,"#4792CD"],[0.789297658862876,"#4792CE"],[0.792642140468227,"#4793CF"],[0.795986622073579,"#4793CF"],[0.79933110367893,"#4894D0"],[0.802675585284281,"#4894D0"],[0.806020066889632,"#4895D1"],[0.809364548494983,"#4895D2"],[0.812709030100334,"#4896D2"],[0.816053511705686,"#4996D3"],[0.819397993311037,"#4997D4"],[0.822742474916388,"#4997D4"],[0.826086956521739,"#4998D5"],[0.82943143812709,"#4A98D6"],[0.832775919732441,"#4A99D6"],[0.836120401337793,"#4A99D7"],[0.839464882943144,"#4A9AD8"],[0.842809364548495,"#4B9AD8"],[0.846153846153846,"#4B9BD9"],[0.849498327759197,"#4B9BDA"],[0.852842809364548,"#4B9BDA"],[0.8561872909699,"#4C9CDB"],[0.859531772575251,"#4C9CDB"],[0.862876254180602,"#4C9DDC"],[0.866220735785953,"#4C9DDD"],[0.869565217391304,"#4D9EDD"],[0.872909698996656,"#4D9EDE"],[0.876254180602007,"#4D9FDF"],[0.879598662207358,"#4D9FDF"],[0.882943143812709,"#4DA0E0"],[0.88628762541806,"#4EA0E1"],[0.889632107023412,"#4EA1E1"],[0.892976588628763,"#4EA1E2"],[0.896321070234114,"#4EA2E3"],[0.899665551839465,"#4FA2E3"],[0.903010033444816,"#4FA3E4"],[0.906354515050167,"#4FA3E5"],[0.909698996655518,"#4FA4E5"],[0.91304347826087,"#50A4E6"],[0.916387959866221,"#50A5E7"],[0.919732441471572,"#50A5E7"],[0.923076923076923,"#50A6E8"],[0.926421404682274,"#51A6E8"],[0.929765886287625,"#51A7E9"],[0.933110367892976,"#51A7EA"],[0.936454849498327,"#51A8EA"],[0.939799331103679,"#52A8EB"],[0.94314381270903,"#52A9EC"],[0.946488294314381,"#52A9EC"],[0.949832775919732,"#52AAED"],[0.953177257525083,"#53AAEE"],[0.956521739130435,"#53ABEE"],[0.959866220735786,"#53ABEF"],[0.963210702341137,"#53ACF0"],[0.966555183946488,"#54ACF0"],[0.969899665551839,"#54ADF1"],[0.973244147157191,"#54ADF2"],[0.976588628762542,"#54AEF2"],[0.979933110367893,"#55AEF3"],[0.983277591973244,"#55AFF4"],[0.986622073578595,"#55AFF4"],[0.989966555183946,"#55B0F5"],[0.993311036789298,"#56B0F6"],[0.996655518394649,"#56B1F6"],[1,"#56B1F7"]],"colorbar":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.37437365783822,"thickness":23.04,"title":"statescore","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682},"tickmode":"array","ticktext":["55","65","75","85","95"],"tickvals":[0,0.25,0.5,0.75,1],"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":8.50145288501453},"ticklen":2,"len":0.5}},"xaxis":"x","yaxis":"y","frame":null}],"layout":{"margin":{"t":36.1909506019095,"r":5.31340805313408,"b":29.2237442922374,"l":48.3520132835201},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682},"title":{"text":"basic heatmap","font":{"color":"rgba(0,0,0,1)","family":"","size":12.7521793275218},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,4.6],"tickmode":"array","ticktext":["first","fourth","second","third"],"tickvals":[1,2,3,4],"categoryorder":"array","categoryarray":["first","fourth","second","third"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":2.65670402656704,"tickwidth":0.483037095739462,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":8.50145288501453},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.483037095739462,"zeroline":false,"anchor":"y","title":{"text":"grade","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,3.6],"tickmode":"array","ticktext":["gym","math","reading"],"tickvals":[1,2,3],"categoryorder":"array","categoryarray":["gym","math","reading"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":2.65670402656704,"tickwidth":0.483037095739462,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":8.50145288501453},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.483037095739462,"zeroline":false,"anchor":"x","title":{"text":"subject","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.37437365783822,"font":{"color":"rgba(0,0,0,1)","family":"","size":8.50145288501453},"title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":10.6268161062682}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"2fbc2d4bc3a7":{"x":{},"y":{},"fill":{},"type":"heatmap"}},"cur_data":"2fbc2d4bc3a7","visdat":{"2fbc2d4bc3a7":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

### Bubble plot

```r
# source: https://r-graph-gallery.com/320-the-basis-of-bubble-plot.html
head(StudentSurvey)
```

```
##        Year Gender Smoke   Award HigherSAT Exercise TV Height Weight Siblings
## 1    Senior      M    No Olympic      Math       10  1     71    180        4
## 2 Sophomore      F   Yes Academy      Math        4  7     66    120        2
## 3 FirstYear      M    No   Nobel      Math       14  5     72    208        2
## 4    Junior      M    No   Nobel      Math        3  1     63    110        1
## 5 Sophomore      F    No   Nobel    Verbal        3  3     65    150        1
## 6 Sophomore      F    No   Nobel    Verbal        5  4     65    114        2
##   BirthOrder VerbalSAT MathSAT  SAT  GPA Pulse Piercings    Sex
## 1          4       540     670 1210 3.13    54         0   Male
## 2          2       520     630 1150 2.50    66         3 Female
## 3          1       550     560 1110 2.55   130         0   Male
## 4          1       490     630 1120 3.10    78         0   Male
## 5          1       720     450 1170 2.70    40         6 Female
## 6          2       600     550 1150 3.20    80         4 Female
```

```r
# basic bubble plot
gbp<-ggplot(StudentSurvey, aes(x=VerbalSAT, y=MathSAT, size = Exercise)) +
  geom_point(alpha=0.5)+
  ggtitle("basic bubble plot")+
  theme_grey(8)

# Control circle size
gbps<-ggplot(StudentSurvey, aes(x=VerbalSAT, y=MathSAT, size = Exercise)) +
  geom_point(alpha=0.1)+
  scale_size(range = c(.1, 10))+
  ggtitle("control circle size")+
  theme_grey(8)

# add the fourth dimension
gbpd<-ggplot(StudentSurvey, aes(x=VerbalSAT, y=MathSAT, size = Exercise,color = Gender)) +
  geom_point(alpha=0.5)+
  ggtitle("add the fourth dimension")+
  theme_grey(8)

grid.arrange(gbp,gbps,gbpd,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

## Ranking
### bar chart

```r
# with/without stat="identity"
gb1<-ggplot(data2,aes(x=group, y=value)) + 
  geom_bar(stat = "identity")+
  ggtitle("with stat")

gb2<-ggplot(data2,aes(group)) + 
  geom_bar()+
  ggtitle("without stat")

# order bar chart
data2$group<-factor(data2$group)

gborder1<-ggplot(data2) +
  geom_bar(aes(fct_infreq(group))) +
  ggtitle("order the levels of x by decreasing frequency")+
  theme_grey(6)

gborder2<-data2 %>%
  group_by(group) %>%
  summarize(sum = sum(value)) %>%
  ggplot(aes(fct_reorder(group, sum, .desc = TRUE), sum))+
  geom_bar(stat = "identity")+
  ggtitle("reorder x by y")+
  theme_grey(6)

gborder<-ggplot(data2, aes(x = fct_inorder(group), y = value)) +
  geom_bar(stat = "identity")+
  ggtitle("set level order of x to row order")+
  theme_grey(6)

gborderm1<-ggplot(data2, aes(x = fct_relevel(group, "C"), y = value)) +
  geom_bar(stat = "identity")+
  ggtitle("manually set group C to the first") +
  theme_grey(6)

gborderm2<-ggplot(data2, aes(x = fct_relevel(group, "C",after = 2), y = value)) +
  geom_bar(stat = "identity")+
  ggtitle("manually set group C after the second group") +
  theme_grey(6)

gborderm3<-ggplot(data2, aes(x = fct_relevel(group, "C",after = Inf), y = value)) +
  geom_bar(stat = "identity")+
  ggtitle("manually set group C to the last") +
  theme_grey(6)

gbrev<-ggplot(data2, aes(fct_rev(group))) +
  geom_bar() +
  coord_flip() +
  ggtitle("reverse the order of factor levels of x") +
  theme_grey(6)

grid.arrange(gb1, gb2,gborder1, gborder2,gborder,gborderm1,gborderm2,gborderm3,gbrev,ncol=4, nrow =3)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

### Cleveland dot plot

```r
# resourse: https://r-graphics.org/recipe-bar-graph-dot-plot

tophit <- tophitters2001[1:25, ]

gc1<-ggplot(tophit, aes(x = avg, y = name)) +
  geom_point()+
  ggtitle("basic Cleveland dot plot") +
  theme_grey(8)

gc2<-ggplot(tophit, aes(x = avg, y = fct_reorder(name, avg))) +
  geom_point() +
  ggtitle("ordered Cleveland dot plot") +
  theme_grey(8)

gc3<-ggplot(tophit, aes(x = avg, y = fct_reorder(name, avg), color = lg)) +
  geom_point() +
  ggtitle("ordered Cleveland dot plot by color") +
  theme_grey(8)

gc4<-ggplot(tophit, aes(x = avg, y = fct_reorder(name, avg))) +
  geom_point() +
  facet_grid(lg~.,scales = "free_y", space = "free_y") +
  ggtitle("ordered Cleveland dot plot with facets") +
  theme_grey(8)

grid.arrange(gc1,gc2,gc3,gc4,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

### Parallel coordinates plot

```r
# rescale + group
gstd<-ggparcoord(iris, columns = 1:4,groupColumn = 5)+
  ggtitle("substract mean & divide by sd")+
  theme_grey(8)
gglo<-ggparcoord(iris, columns = 1:4,groupColumn = 5,scale = "globalminmax")+
  ggtitle("No scaling")+
  theme_grey(8)
guni<-ggparcoord(iris, columns = 1:4,groupColumn = 5,scale = "uniminmax")+
  ggtitle("Standardize to Min = 0 and Max = 1")+
  theme_grey(8)
gcenter<-ggparcoord(iris, columns = 1:4,groupColumn = 5,scale = "center")+
  ggtitle("Standardize and center variables")+
  theme_grey(8)

# change alpha
gpcalpha<-ggparcoord(iris, columns = 1:4,alphaLines = .3)+
  ggtitle("change alpha")+
  theme_grey(8)
# Splines
gpcspline<-ggparcoord(iris, columns = 1:4, splineFactor = 10) +
  ggtitle("splines")+
  theme_grey(8)

# Highlight a group
iriscolor <- iris %>%
mutate(color = factor(ifelse(Species == "setosa",1,0))) %>%
arrange(color)
gpchl<-ggparcoord(iriscolor, columns = 1:4, groupColumn = "color") +
  scale_color_manual(values = c("grey70", "red")) +
  guides(color = FALSE) +
  ggtitle("highlight setosa")+
  theme_grey(8)

grid.arrange(gstd,gglo,guni,gcenter,gpcalpha,gpcspline,gpchl,ncol=3, nrow =3)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

```r
# interactive Parallel coordinates with arrangement by groups

iris %>% arrange(Species) %>%
parcoords(
rownames = F 
, brushMode = "1D-axes"
, reorderable = T
, queue = T
, color = list(
colorBy = "Region"
,colorScale = "scaleOrdinal"
,colorScheme = "schemeCategory10"
)
, withD3 = TRUE
, width = 1000
, height = 400
)
```

```{=html}
<div class="parcoords html-widget" height="400" id="htmlwidget-71153055bef0df84046a" style="width:1000px;height:400px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="1000"></div>
<script type="application/json" data-for="htmlwidget-71153055bef0df84046a">{"x":{"data":{"names":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150"],"Sepal.Length":[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5,7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7,6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"Sepal.Width":[3.5,3,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3,3,4,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3,3.4,3.5,2.3,3.2,3.5,3.8,3,3.8,3.2,3.7,3.3,3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2,3,2.2,2.9,2.9,3.1,3,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3,2.8,3,2.9,2.6,2.4,2.4,2.7,2.7,3,3.4,3.1,2.3,3,2.5,2.6,3,2.6,2.3,2.7,3,2.9,2.9,2.5,2.8,3.3,2.7,3,2.9,3,3,2.5,2.9,2.5,3.6,3.2,2.7,3,2.5,2.8,3.2,3,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3,2.8,3,2.8,3.8,2.8,2.8,2.6,3,3.4,3.1,3,3.1,3.1,3.1,2.7,3.2,3.3,3,2.5,3,3.4,3],"Petal.Length":[1.4,1.4,1.3,1.5,1.4,1.7,1.4,1.5,1.4,1.5,1.5,1.6,1.4,1.1,1.2,1.5,1.3,1.4,1.7,1.5,1.7,1.5,1,1.7,1.9,1.6,1.6,1.5,1.4,1.6,1.6,1.5,1.5,1.4,1.5,1.2,1.3,1.4,1.3,1.5,1.3,1.3,1.3,1.6,1.9,1.4,1.6,1.4,1.5,1.4,4.7,4.5,4.9,4,4.6,4.5,4.7,3.3,4.6,3.9,3.5,4.2,4,4.7,3.6,4.4,4.5,4.1,4.5,3.9,4.8,4,4.9,4.7,4.3,4.4,4.8,5,4.5,3.5,3.8,3.7,3.9,5.1,4.5,4.5,4.7,4.4,4.1,4,4.4,4.6,4,3.3,4.2,4.2,4.2,4.3,3,4.1,6,5.1,5.9,5.6,5.8,6.6,4.5,6.3,5.8,6.1,5.1,5.3,5.5,5,5.1,5.3,5.5,6.7,6.9,5,5.7,4.9,6.7,4.9,5.7,6,4.8,4.9,5.6,5.8,6.1,6.4,5.6,5.1,5.6,6.1,5.6,5.5,4.8,5.4,5.6,5.1,5.1,5.9,5.7,5.2,5,5.2,5.4,5.1],"Petal.Width":[0.2,0.2,0.2,0.2,0.2,0.4,0.3,0.2,0.2,0.1,0.2,0.2,0.1,0.1,0.2,0.4,0.4,0.3,0.3,0.3,0.2,0.4,0.2,0.5,0.2,0.2,0.4,0.2,0.2,0.2,0.2,0.4,0.1,0.2,0.2,0.2,0.2,0.1,0.2,0.2,0.3,0.3,0.2,0.6,0.4,0.3,0.2,0.2,0.2,0.2,1.4,1.5,1.5,1.3,1.5,1.3,1.6,1,1.3,1.4,1,1.5,1,1.4,1.3,1.4,1.5,1,1.5,1.1,1.8,1.3,1.5,1.2,1.3,1.4,1.4,1.7,1.5,1,1.1,1,1.2,1.6,1.5,1.6,1.5,1.3,1.3,1.3,1.2,1.4,1.2,1,1.3,1.2,1.3,1.3,1.1,1.3,2.5,1.9,2.1,1.8,2.2,2.1,1.7,1.8,1.8,2.5,2,1.9,2.1,2,2.4,2.3,1.8,2.2,2.3,1.5,2.3,2,2,1.8,2.1,1.8,1.8,1.8,2.1,1.6,1.9,2,2.2,1.5,1.4,2.3,2.4,1.8,1.8,2.1,2.4,2.3,1.9,2.3,2.5,2.3,1.9,2,2.3,1.8],"Species":["setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica"]},"options":{"rownames":false,"color":{"colorBy":"Region","colorScale":"scaleOrdinal","colorScheme":"schemeCategory10"},"brushMode":"1D-axes","brushPredicate":"AND","reorderable":true,"margin":{"top":50,"bottom":50,"left":100,"right":50},"mode":"queue","bundlingStrength":0.5,"smoothness":0,"width":1000,"height":400},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```

### Mosaic plot

```r
# Stacked bar chart
gsbc<-ggplot(StudentSurvey, aes(x = Year, fill = Award)) +
  geom_bar()+
  ggtitle("Stacked bar chart")+
  theme_grey(8)

# Mosaic plot (2 var)

gmp2<-ggplot(StudentSurvey) +
  geom_mosaic(aes(x = product(Year), fill = Award))+
  ggtitle("Mosaic plot (2 var)")+
  theme_grey(8)

# Mosaic plot (3 var)
gmp3<-ggplot(StudentSurvey) +
  geom_mosaic(aes(x = product(Year,Gender), fill = Award))+
  ggtitle("Mosaic plot (3 var)")+
  theme_grey(8)

grid.arrange(gsbc,gmp2,gmp3,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

### lollipop plot

```r
# source: https://r-graph-gallery.com/301-custom-lollipop-chart.html
# basic lollipop plot
glp<-ggplot(data3, aes(x=time, y=value)) +
  geom_point() + 
  geom_segment( aes(x=time, xend=time, y=0, yend=value))+
  ggtitle("basic lollipop plot")+
  theme_grey(8)

# control marker
glpm<-ggplot(data3, aes(x=time, y=value)) +
  geom_point() + 
  geom_segment( aes(x=time, xend=time, y=0, yend=value))+
  geom_point( size=5, color="red", fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=2) +
  ggtitle("control marker")+
  theme_grey(8)

# control stem
glps<-ggplot(data3, aes(x=time, y=value)) +
  geom_point() + 
  geom_segment( aes(x=time, xend=time, y=0, yend=value),size=1, color="blue",linetype="dotdash" )+
  ggtitle("control stem")+
  theme_grey(8)

# control baseline
glpb<-ggplot(data3, aes(x=time, y=value)) +
  geom_point() + 
  geom_segment( aes(x=time, xend=time, y=20, yend=value))+
  ggtitle("control baseline")+
  theme_grey(8)

grid.arrange(glp,glpm,glps,glpb,ncol=2, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

### Donut chart, pie chart

```r
# source: https://r-graph-gallery.com/128-ring-or-donut-plot.html
data2$fraction = data2$value / sum(data2$value)
data2$ymax = cumsum(data2$fraction)
data2$ymin = c(0, head(data2$ymax, n=-1))

gdc<-ggplot(data2, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=2, fill=group)) +
  geom_rect() +
  coord_polar(theta="y")+
  xlim(c(-1, 4))+
  ggtitle("Donut chart")+
  theme_grey(8)

gpc<-ggplot(data2, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=2, fill=group)) +
  geom_rect() +
  coord_polar(theta="y")+
  ggtitle("Pie chart")+
  theme_grey(8)

grid.arrange(gdc,gpc,ncol=2, nrow =1)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

## Evolution
### line plot/area chart

```r
# source: https://r-graph-gallery.com/line-chart-ggplot2.html
# basic line plot
glp<-ggplot(data3, aes(x=time, y=value)) +
  geom_line()+
  ggtitle("basic line plot")+
  theme_grey(8)

# Customize
glpc<-ggplot(data3, aes(x=time, y=value)) +
  geom_line( color="#69b3a2", size=2, alpha=0.9, linetype=2)+
  ggtitle("customize line plot")+
  theme_grey(8)

# basic area chart
gac<-ggplot(data3, aes(x=time, y=value)) +
  geom_area()+
  ggtitle("basic area chart")+
  theme_grey(8)

data4<-data.frame(time = as.numeric(rep(seq(1,7),each=7)), 
value = runif(49, 10, 100) ,             
group = rep(LETTERS[1:7],times=7)
)

# basic stacked area chart
gsac<-ggplot(data4, aes(x=time, y=value, fill=group)) + 
  geom_area()+
  ggtitle("basic stacked area chart")+
  theme_grey(8)

# proportional stacked area chart
data4 <- data4  %>%
  group_by(time, group) %>%
  summarise(n = sum(value)) %>%
  mutate(percentage = n / sum(n))
gpsac<-ggplot(data4, aes(x=time, y=percentage, fill=group)) + 
  geom_area(alpha=0.6 , size=1, colour="black")

grid.arrange(glp,glpc,gac,gsac,gpsac,ncol=3, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

## flow
### alluvial diagram

```r
# source: https://cran.r-project.org/web/packages/ggalluvial/vignettes/ggalluvial.html#:~:text=The%20ggalluvial%20package%20is%20a,the%20feedback%20of%20many%20users.

# alluvial diagram example

gad<-ggplot(as.data.frame(Titanic),aes(y = Freq, axis1 = Survived, axis2 = Sex, axis3 = Class)) +
  geom_alluvium(aes(fill = Class),width = 0)+
  geom_stratum(width = 1/8) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)))+
  ggtitle("alluvial diagram")

# change alluvium color
gadc<-ggplot(as.data.frame(Titanic),aes(y = Freq, axis1 = Survived, axis2 = Sex, axis3 = Class)) +
  geom_alluvium(aes(fill = Survived),width = 0)+
  geom_stratum(width = 1/8) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)))+
  ggtitle("change alluvium color")

grid.arrange(gad,gadc,ncol=1, nrow =2)
```

<img src="ggplot2_graphics_cheatsheet_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />





