# Cheatsheet for multiple graphics

Guo Pei

## Description

The cheatsheet includes a single formula sheet and a more detailed tutorial of implementing different plot types on several data sets. To be specific, it contains Histogram, Boxplot, Violin plot, Ridgeline plot, Q-Q plot, Bar chart, Cleveland dot plot, Scatterplot, Parallel coordinates plot, Biplot, Mosaic plot, Alluvial diagram and Heatmap.

For the formula sheet part, it contains nearly all formulas professor introduced in class and we used and met in the previous problem sets.

Link: https://github.com/gloria6661/5293_CC/blob/main/cheatsheet.pdf

For the implementation part, each figure is attached with code on how to draw it. For some types of plots, it lists more than one methods to draw.




```r
library(ggplot2)
library(gridExtra)
library(ggridges)
library(carData)
library(forcats)
library(dplyr)
library(tidyr)
library(tibble)
library(openintro)
library(plotly)
library(GGally)
library(scales)
library(parcoords) # devtools::install_github("timelyportfolio/parcoords")
library(d3r)
library(redav)
library(grid)
library(vcd)
library(vcdExtra)
library(ggalluvial)
```

## Histogram

Data: `iris`

```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

### Frequency (count) histogram (ggplot2)

```r
ggplot(iris, aes(Sepal.Length)) +
  geom_histogram(color = "blue", fill = "lightblue", binwidth = .3) +
  theme_grey(14) +
  labs(title = "Histogram of Sepal Length", x = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

### Histograms with right closed / right open (base R)

```r
par(mfrow = c(1, 2))
# histogram with right closed
hist(iris$Sepal.Length, col = "lightblue", right = TRUE,
     breaks = 4, ylim = c(0, 60),
     main = "Histogram with right closed", xlab = "Sepal Length")
# histogram with right open
hist(iris$Sepal.Length, col = "lightblue", right = FALSE,
     breaks = 4, ylim = c(0, 60),
     main = "Histogram with right open", xlab = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

### Density histogram with density curve overlaid (ggplot2)

```r
ggplot(iris, aes(x = Sepal.Length, y = ..density..)) + 
  geom_histogram(binwidth = .5, color = "blue", fill = "lightblue", boundary = 0) +
  geom_density(color = "red") +
  labs(title = "Density Histogram", x = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

### Density histogram with density curve and theoretical normal curve overlaid (base R)

```r
# draw the density histogram
hist(iris$Sepal.Length, freq = FALSE, ylim = c(0, 0.5), 
     main = "Density Histogram", xlab = "Sepal Length")
# add density curve
lines(density(iris$Sepal.Length), col = 2)
# add normal curve
x <- seq(3, 9, length = 100) # x-axis grid
nc <- dnorm(x, mean = mean(iris$Sepal.Length), sd = sd(iris$Sepal.Length)) #normal curve
lines(x, nc, col = 3)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

### Cumulative frequency histogram

```r
g1 <- ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram(color = "blue", fill = "lightblue") +
  labs(title = "Frequency", x = "Sepal Length")
g2 <- ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram(aes(y = cumsum(..count..)),
                 color = "blue", fill = "lightblue") +
  labs(title = "Cumulative Frequency", x = "Sepal Length")
grid.arrange(g1, g2, nrow = 1)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

## Boxplot

### Boxplot (base R)

```r
boxplot(Sepal.Length ~ Species, data = iris, horizontal = TRUE,
        main = "Sepal Length vs Species", ylab = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

### Boxplot (ggplot2)

```r
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(varwidth = TRUE) +
  coord_flip() +
  labs(title = "Sepal Length vs Species", y = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

## Violin plot

```r
ggplot(iris, aes(x = Species,
                  y = Sepal.Length)) +
  geom_violin(adjust = 1.5) +
  coord_flip() +
  labs(title = "Violin Plot", y = "Sepal Length")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

## Ridgeline plot

```r
ggplot(iris, aes(x = Sepal.Length, y = reorder(Species, Sepal.Length, median))) +
  geom_density_ridges(fill = "blue", alpha = .5, scale = .95) +
  labs(title = "Ridgeline Plot", x = "Sepal Length", y = "Species")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

## Q-Q plot (quantile-quantile)


```r
qqnorm(iris$Sepal.Length)
qqline(iris$Sepal.Length, col = 2)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

## Bar chart

Data: `TitanicSurvival`

```r
head(TitanicSurvival)
```

```
##                                 survived    sex     age passengerClass
## Allen, Miss. Elisabeth Walton        yes female 29.0000            1st
## Allison, Master. Hudson Trevor       yes   male  0.9167            1st
## Allison, Miss. Helen Loraine          no female  2.0000            1st
## Allison, Mr. Hudson Joshua Crei       no   male 30.0000            1st
## Allison, Mrs. Hudson J C (Bessi       no female 25.0000            1st
## Anderson, Mr. Harry                  yes   male 48.0000            1st
```

### Ordinal data (sort in logical order of the categories)

```r
ggplot(TitanicSurvival, aes(passengerClass)) +
  geom_bar(fill = "cornflowerblue") +
  ggtitle("Passenger Class") +
  labs(title = "Passenger Class", x = "")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

### Nominal data (sort from highest to lowest count)

```r
ggplot(TitanicSurvival, aes(fct_infreq(passengerClass))) +
  geom_bar(fill = "cornflowerblue") +
  ggtitle("Passenger Class") +
  labs(title = "Passenger Class", x = "")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

### Bar chart with facets

```r
ggplot(data = TitanicSurvival, aes(x = passengerClass)) +
  geom_bar() +
  facet_wrap(~survived, ncol = 1, scales = "free_y") +
  labs(title = "Bar chart faceted by Survival Status",
       x = "Passenger Class", y = "")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

### Stacked bar chart

```r
ggplot(TitanicSurvival, aes(x = sex, fill = survived)) + 
    geom_bar()
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

### Grouped bar chart

```r
ggplot(TitanicSurvival, aes(x = sex, fill = survived)) +
  geom_bar(position = "dodge")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

### Grouped bar chart with facets

```r
counts <- TitanicSurvival %>%
  group_by(sex, survived, passengerClass) %>%
  summarize(Freq = n()) %>%
  ungroup() %>%
  complete(sex, survived, passengerClass, fill = list(Freq = 0))
# draw the grouped bar chart
ggplot(counts, aes(x = sex, y = Freq, fill = survived)) +
  geom_col(position = "dodge") +
  facet_wrap(~passengerClass)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-20-1.png" width="672" style="display: block; margin: auto;" />

## Cleveland dot plot

```r
TitanicSurvival1 <- TitanicSurvival %>%
  rownames_to_column(var = "name")
head(TitanicSurvival1)
```

```
##                              name survived    sex     age passengerClass
## 1   Allen, Miss. Elisabeth Walton      yes female 29.0000            1st
## 2  Allison, Master. Hudson Trevor      yes   male  0.9167            1st
## 3    Allison, Miss. Helen Loraine       no female  2.0000            1st
## 4 Allison, Mr. Hudson Joshua Crei       no   male 30.0000            1st
## 5 Allison, Mrs. Hudson J C (Bessi       no female 25.0000            1st
## 6             Anderson, Mr. Harry      yes   male 48.0000            1st
```

### Cleveland dot plot

```r
ts1 <- TitanicSurvival1 %>%
  filter(!is.na(age) & passengerClass == "1st" & survived == "yes" & sex == "female" &
           age >= 30 & age <= 40)

ggplot(ts1,aes(x = age, y = fct_reorder(name, age))) +
  geom_point(color = "blue") +
  ylab("")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />

### Cleveland dot plot with facets

```r
ts2 <- TitanicSurvival1 %>%
  filter(!is.na(age) & survived == "yes" & sex == "female" & age >= 30 & age <= 40)

ggplot(ts2, aes(x = age, y = reorder(name, age))) +
  geom_point(color = "blue") +
  facet_grid(.~reorder(passengerClass, -age, median)) +
  ylab("")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-23-1.png" width="672" style="display: block; margin: auto;" />

## Scatterplot

Data: `babies` in the openintro package

```r
head(babies)
```

```
## # A tibble: 6 × 8
##    case   bwt gestation parity   age height weight smoke
##   <int> <int>     <int>  <int> <int>  <int>  <int> <int>
## 1     1   120       284      0    27     62    100     0
## 2     2   113       282      0    33     64    135     0
## 3     3   128       279      0    28     64    115     1
## 4     4   123        NA      0    36     69    190     0
## 5     5   108       282      0    23     67    125     1
## 6     6   136       286      0    25     62     93     0
```

### Scatterplot

```r
# draw the scatterplot
g <- ggplot(babies, aes(x = gestation, y = bwt)) +
  # adjust point size and add alpha blending
  geom_point(size = 1, alpha = .5)
g +
  # add the density contour lines
  geom_density_2d() +
  # add the linear model
  geom_smooth(method = 'lm', se = FALSE, col = 2)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-25-1.png" width="672" style="display: block; margin: auto;" />

### Interactive scatterplot

```r
g1 <- ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) +
  geom_point()
ggplotly(g1)
```

```{=html}
<div id="htmlwidget-4f83c068b6ebbdd7e49c" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-4f83c068b6ebbdd7e49c">{"x":{"data":[{"x":[3.5,3,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3,3,4,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3,3.4,3.5,2.3,3.2,3.5,3.8,3,3.8,3.2,3.7,3.3],"y":[5.1,4.9,4.7,4.6,5,5.4,4.6,5,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5,5,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5,5.5,4.9,4.4,5.1,5,4.5,4.4,5,5.1,4.8,5.1,4.6,5.3,5],"text":["Sepal.Width: 3.5<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 4.9<br />Species: setosa","Sepal.Width: 3.2<br />Sepal.Length: 4.7<br />Species: setosa","Sepal.Width: 3.1<br />Sepal.Length: 4.6<br />Species: setosa","Sepal.Width: 3.6<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 3.9<br />Sepal.Length: 5.4<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 4.6<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 2.9<br />Sepal.Length: 4.4<br />Species: setosa","Sepal.Width: 3.1<br />Sepal.Length: 4.9<br />Species: setosa","Sepal.Width: 3.7<br />Sepal.Length: 5.4<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 4.8<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 4.8<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 4.3<br />Species: setosa","Sepal.Width: 4.0<br />Sepal.Length: 5.8<br />Species: setosa","Sepal.Width: 4.4<br />Sepal.Length: 5.7<br />Species: setosa","Sepal.Width: 3.9<br />Sepal.Length: 5.4<br />Species: setosa","Sepal.Width: 3.5<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.8<br />Sepal.Length: 5.7<br />Species: setosa","Sepal.Width: 3.8<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.4<br />Species: setosa","Sepal.Width: 3.7<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.6<br />Sepal.Length: 4.6<br />Species: setosa","Sepal.Width: 3.3<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 4.8<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 3.5<br />Sepal.Length: 5.2<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.2<br />Species: setosa","Sepal.Width: 3.2<br />Sepal.Length: 4.7<br />Species: setosa","Sepal.Width: 3.1<br />Sepal.Length: 4.8<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.4<br />Species: setosa","Sepal.Width: 4.1<br />Sepal.Length: 5.2<br />Species: setosa","Sepal.Width: 4.2<br />Sepal.Length: 5.5<br />Species: setosa","Sepal.Width: 3.1<br />Sepal.Length: 4.9<br />Species: setosa","Sepal.Width: 3.2<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 3.5<br />Sepal.Length: 5.5<br />Species: setosa","Sepal.Width: 3.6<br />Sepal.Length: 4.9<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 4.4<br />Species: setosa","Sepal.Width: 3.4<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.5<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 2.3<br />Sepal.Length: 4.5<br />Species: setosa","Sepal.Width: 3.2<br />Sepal.Length: 4.4<br />Species: setosa","Sepal.Width: 3.5<br />Sepal.Length: 5.0<br />Species: setosa","Sepal.Width: 3.8<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.0<br />Sepal.Length: 4.8<br />Species: setosa","Sepal.Width: 3.8<br />Sepal.Length: 5.1<br />Species: setosa","Sepal.Width: 3.2<br />Sepal.Length: 4.6<br />Species: setosa","Sepal.Width: 3.7<br />Sepal.Length: 5.3<br />Species: setosa","Sepal.Width: 3.3<br />Sepal.Length: 5.0<br />Species: setosa"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(248,118,109,1)"}},"hoveron":"points","name":"setosa","legendgroup":"setosa","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2,3,2.2,2.9,2.9,3.1,3,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3,2.8,3,2.9,2.6,2.4,2.4,2.7,2.7,3,3.4,3.1,2.3,3,2.5,2.6,3,2.6,2.3,2.7,3,2.9,2.9,2.5,2.8],"y":[7,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5,5.9,6,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6,5.7,5.5,5.5,5.8,6,5.4,6,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5,5.6,5.7,5.7,6.2,5.1,5.7],"text":["Sepal.Width: 3.2<br />Sepal.Length: 7.0<br />Species: versicolor","Sepal.Width: 3.2<br />Sepal.Length: 6.4<br />Species: versicolor","Sepal.Width: 3.1<br />Sepal.Length: 6.9<br />Species: versicolor","Sepal.Width: 2.3<br />Sepal.Length: 5.5<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 6.5<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 5.7<br />Species: versicolor","Sepal.Width: 3.3<br />Sepal.Length: 6.3<br />Species: versicolor","Sepal.Width: 2.4<br />Sepal.Length: 4.9<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 6.6<br />Species: versicolor","Sepal.Width: 2.7<br />Sepal.Length: 5.2<br />Species: versicolor","Sepal.Width: 2.0<br />Sepal.Length: 5.0<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 5.9<br />Species: versicolor","Sepal.Width: 2.2<br />Sepal.Length: 6.0<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 6.1<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 5.6<br />Species: versicolor","Sepal.Width: 3.1<br />Sepal.Length: 6.7<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 5.6<br />Species: versicolor","Sepal.Width: 2.7<br />Sepal.Length: 5.8<br />Species: versicolor","Sepal.Width: 2.2<br />Sepal.Length: 6.2<br />Species: versicolor","Sepal.Width: 2.5<br />Sepal.Length: 5.6<br />Species: versicolor","Sepal.Width: 3.2<br />Sepal.Length: 5.9<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 6.1<br />Species: versicolor","Sepal.Width: 2.5<br />Sepal.Length: 6.3<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 6.1<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 6.4<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 6.6<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 6.8<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 6.7<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 6.0<br />Species: versicolor","Sepal.Width: 2.6<br />Sepal.Length: 5.7<br />Species: versicolor","Sepal.Width: 2.4<br />Sepal.Length: 5.5<br />Species: versicolor","Sepal.Width: 2.4<br />Sepal.Length: 5.5<br />Species: versicolor","Sepal.Width: 2.7<br />Sepal.Length: 5.8<br />Species: versicolor","Sepal.Width: 2.7<br />Sepal.Length: 6.0<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 5.4<br />Species: versicolor","Sepal.Width: 3.4<br />Sepal.Length: 6.0<br />Species: versicolor","Sepal.Width: 3.1<br />Sepal.Length: 6.7<br />Species: versicolor","Sepal.Width: 2.3<br />Sepal.Length: 6.3<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 5.6<br />Species: versicolor","Sepal.Width: 2.5<br />Sepal.Length: 5.5<br />Species: versicolor","Sepal.Width: 2.6<br />Sepal.Length: 5.5<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 6.1<br />Species: versicolor","Sepal.Width: 2.6<br />Sepal.Length: 5.8<br />Species: versicolor","Sepal.Width: 2.3<br />Sepal.Length: 5.0<br />Species: versicolor","Sepal.Width: 2.7<br />Sepal.Length: 5.6<br />Species: versicolor","Sepal.Width: 3.0<br />Sepal.Length: 5.7<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 5.7<br />Species: versicolor","Sepal.Width: 2.9<br />Sepal.Length: 6.2<br />Species: versicolor","Sepal.Width: 2.5<br />Sepal.Length: 5.1<br />Species: versicolor","Sepal.Width: 2.8<br />Sepal.Length: 5.7<br />Species: versicolor"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,186,56,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,186,56,1)"}},"hoveron":"points","name":"versicolor","legendgroup":"versicolor","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[3.3,2.7,3,2.9,3,3,2.5,2.9,2.5,3.6,3.2,2.7,3,2.5,2.8,3.2,3,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3,2.8,3,2.8,3.8,2.8,2.8,2.6,3,3.4,3.1,3,3.1,3.1,3.1,2.7,3.2,3.3,3,2.5,3,3.4,3],"y":[6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"text":["Sepal.Width: 3.3<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 2.7<br />Sepal.Length: 5.8<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 7.1<br />Species: virginica","Sepal.Width: 2.9<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.5<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 7.6<br />Species: virginica","Sepal.Width: 2.5<br />Sepal.Length: 4.9<br />Species: virginica","Sepal.Width: 2.9<br />Sepal.Length: 7.3<br />Species: virginica","Sepal.Width: 2.5<br />Sepal.Length: 6.7<br />Species: virginica","Sepal.Width: 3.6<br />Sepal.Length: 7.2<br />Species: virginica","Sepal.Width: 3.2<br />Sepal.Length: 6.5<br />Species: virginica","Sepal.Width: 2.7<br />Sepal.Length: 6.4<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.8<br />Species: virginica","Sepal.Width: 2.5<br />Sepal.Length: 5.7<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 5.8<br />Species: virginica","Sepal.Width: 3.2<br />Sepal.Length: 6.4<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.5<br />Species: virginica","Sepal.Width: 3.8<br />Sepal.Length: 7.7<br />Species: virginica","Sepal.Width: 2.6<br />Sepal.Length: 7.7<br />Species: virginica","Sepal.Width: 2.2<br />Sepal.Length: 6.0<br />Species: virginica","Sepal.Width: 3.2<br />Sepal.Length: 6.9<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 5.6<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 7.7<br />Species: virginica","Sepal.Width: 2.7<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 3.3<br />Sepal.Length: 6.7<br />Species: virginica","Sepal.Width: 3.2<br />Sepal.Length: 7.2<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 6.2<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.1<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 6.4<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 7.2<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 7.4<br />Species: virginica","Sepal.Width: 3.8<br />Sepal.Length: 7.9<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 6.4<br />Species: virginica","Sepal.Width: 2.8<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 2.6<br />Sepal.Length: 6.1<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 7.7<br />Species: virginica","Sepal.Width: 3.4<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 3.1<br />Sepal.Length: 6.4<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.0<br />Species: virginica","Sepal.Width: 3.1<br />Sepal.Length: 6.9<br />Species: virginica","Sepal.Width: 3.1<br />Sepal.Length: 6.7<br />Species: virginica","Sepal.Width: 3.1<br />Sepal.Length: 6.9<br />Species: virginica","Sepal.Width: 2.7<br />Sepal.Length: 5.8<br />Species: virginica","Sepal.Width: 3.2<br />Sepal.Length: 6.8<br />Species: virginica","Sepal.Width: 3.3<br />Sepal.Length: 6.7<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.7<br />Species: virginica","Sepal.Width: 2.5<br />Sepal.Length: 6.3<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 6.5<br />Species: virginica","Sepal.Width: 3.4<br />Sepal.Length: 6.2<br />Species: virginica","Sepal.Width: 3.0<br />Sepal.Length: 5.9<br />Species: virginica"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(97,156,255,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(97,156,255,1)"}},"hoveron":"points","name":"virginica","legendgroup":"virginica","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":31.4155251141553},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[1.88,4.52],"tickmode":"array","ticktext":["2.0","2.5","3.0","3.5","4.0","4.5"],"tickvals":[2,2.5,3,3.5,4,4.5],"categoryorder":"array","categoryarray":["2.0","2.5","3.0","3.5","4.0","4.5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Sepal.Width","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[4.12,8.08],"tickmode":"array","ticktext":["5","6","7","8"],"tickvals":[5,6,7,8],"categoryorder":"array","categoryarray":["5","6","7","8"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Sepal.Length","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"title":{"text":"Species","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"3abd78d8301c":{"x":{},"y":{},"colour":{},"type":"scatter"}},"cur_data":"3abd78d8301c","visdat":{"3abd78d8301c":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

### Scatterplot matrix

```r
plot(iris[,1:4], col = "#00660030", pch = 19)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-27-1.png" width="672" style="display: block; margin: auto;" />

## Parallel coordinates plot

Data: `state.x77`

```r
mystates <- data.frame(state.x77) %>%
  rownames_to_column("State") %>%
  mutate(Region = factor(state.region))
head(mystates)
```

```
##        State Population Income Illiteracy Life.Exp Murder HS.Grad Frost   Area
## 1    Alabama       3615   3624        2.1    69.05   15.1    41.3    20  50708
## 2     Alaska        365   6315        1.5    69.31   11.3    66.7   152 566432
## 3    Arizona       2212   4530        1.8    70.55    7.8    58.1    15 113417
## 4   Arkansas       2110   3378        1.9    70.66   10.1    39.9    65  51945
## 5 California      21198   5114        1.1    71.71   10.3    62.6    20 156361
## 6   Colorado       2541   4884        0.7    72.06    6.8    63.9   166 103766
##   Region
## 1  South
## 2   West
## 3   West
## 4  South
## 5   West
## 6   West
```

### Static parallel coordinates plot

```r
ggparcoord(mystates, columns = 2:9, alphaLines = .5, 
           scale = "uniminmax", splineFactor = 10, groupColumn = 10) +
  geom_vline(xintercept = 2:8, color = "lightblue")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-29-1.png" width="672" style="display: block; margin: auto;" />

### Interactive parallel coordinates plot

```r
mystates %>%
  arrange(Region) %>%
  parcoords(
    rownames = FALSE,
    brushMode = "1D-axes",
    reorderable = TRUE,
    queue = TRUE,
    alpha = .5,
    color = list(
      colorBy = "Region",
      colorScale = "scaleOrdinal",
      colorScheme = "schemeCategory10"
      ),
    withD3 = TRUE,
    width = 800,
    height = 600
    )
```

```{=html}
<div class="parcoords html-widget" height="600" id="htmlwidget-c26408dff982c7263ea0" style="width:800px;height:600px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="800"></div>
<script type="application/json" data-for="htmlwidget-c26408dff982c7263ea0">{"x":{"data":{"names":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"],"State":["Connecticut","Maine","Massachusetts","New Hampshire","New Jersey","New York","Pennsylvania","Rhode Island","Vermont","Alabama","Arkansas","Delaware","Florida","Georgia","Kentucky","Louisiana","Maryland","Mississippi","North Carolina","Oklahoma","South Carolina","Tennessee","Texas","Virginia","West Virginia","Illinois","Indiana","Iowa","Kansas","Michigan","Minnesota","Missouri","Nebraska","North Dakota","Ohio","South Dakota","Wisconsin","Alaska","Arizona","California","Colorado","Hawaii","Idaho","Montana","Nevada","New Mexico","Oregon","Utah","Washington","Wyoming"],"Population":[3100,1058,5814,812,7333,18076,11860,931,472,3615,2110,579,8277,4931,3387,3806,4122,2341,5441,2715,2816,4173,12237,4981,1799,11197,5313,2861,2280,9111,3921,4767,1544,637,10735,681,4589,365,2212,21198,2541,868,813,746,590,1144,2284,1203,3559,376],"Income":[5348,3694,4755,4281,5237,4903,4449,4558,3907,3624,3378,4809,4815,4091,3712,3545,5299,3098,3875,3983,3635,3821,4188,4701,3617,5107,4458,4628,4669,4751,4675,4254,4508,5087,4561,4167,4468,6315,4530,5114,4884,4963,4119,4347,5149,3601,4660,4022,4864,4566],"Illiteracy":[1.1,0.7,1.1,0.7,1.1,1.4,1,1.3,0.6,2.1,1.9,0.9,1.3,2,1.6,2.8,0.9,2.4,1.8,1.1,2.3,1.7,2.2,1.4,1.4,0.9,0.7,0.5,0.6,0.9,0.6,0.8,0.6,0.8,0.8,0.5,0.7,1.5,1.8,1.1,0.7,1.9,0.6,0.6,0.5,2.2,0.6,0.6,0.6,0.6],"Life.Exp":[72.48,70.39,71.83,71.23,70.93,70.55,70.43,71.9,71.64,69.05,70.66,70.06,70.66,68.54,70.1,68.76,70.22,68.09,69.21,71.42,67.96,70.11,70.9,70.08,69.48,70.14,70.88,72.56,72.58,70.63,72.96,70.69,72.6,72.78,70.82,72.08,72.48,69.31,70.55,71.71,72.06,73.6,71.87,70.56,69.03,70.32,72.13,72.9,71.72,70.29],"Murder":[3.1,2.7,3.3,3.3,5.2,10.9,6.1,2.4,5.5,15.1,10.1,6.2,10.7,13.9,10.6,13.2,8.5,12.5,11.1,6.4,11.6,11,12.2,9.5,6.7,10.3,7.1,2.3,4.5,11.1,2.3,9.3,2.9,1.4,7.4,1.7,3,11.3,7.8,10.3,6.8,6.2,5.3,5,11.5,9.7,4.2,4.5,4.3,6.9],"HS.Grad":[56,54.7,58.5,57.6,52.5,52.7,50.2,46.4,57.1,41.3,39.9,54.6,52.6,40.6,38.5,42.2,52.3,41,38.5,51.6,37.8,41.8,47.4,47.8,41.6,52.6,52.9,59,59.9,52.8,57.6,48.8,59.3,50.3,53.2,53.3,54.5,66.7,58.1,62.6,63.9,61.9,59.5,59.2,65.2,55.2,60,67.3,63.5,62.9],"Frost":[139,161,103,174,115,82,126,127,168,20,65,103,11,60,95,12,101,50,80,82,65,70,35,85,100,127,122,140,114,125,160,108,139,186,124,172,149,152,15,20,166,0,126,155,188,120,44,137,32,173],"Area":[4862,30920,7826,9027,7521,47831,44966,1049,9267,50708,51945,1982,54090,58073,39650,44930,9891,47296,48798,68782,30225,41328,262134,39780,24070,55748,36097,55941,81787,56817,79289,68995,76483,69273,40975,75955,54464,566432,113417,156361,103766,6425,82677,145587,109889,121412,96184,82096,66570,97203],"Region":["Northeast","Northeast","Northeast","Northeast","Northeast","Northeast","Northeast","Northeast","Northeast","South","South","South","South","South","South","South","South","South","South","South","South","South","South","South","South","North Central","North Central","North Central","North Central","North Central","North Central","North Central","North Central","North Central","North Central","North Central","North Central","West","West","West","West","West","West","West","West","West","West","West","West","West"]},"options":{"rownames":false,"color":{"colorBy":"Region","colorScale":"scaleOrdinal","colorScheme":"schemeCategory10"},"brushMode":"1D-axes","brushPredicate":"AND","reorderable":true,"margin":{"top":50,"bottom":50,"left":100,"right":50},"alpha":0.5,"mode":"queue","bundlingStrength":0.5,"smoothness":0,"width":800,"height":600},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```

## Biplot

Data: `attributes.xls`  
(http://www.econ.upf.edu/~michael/attributes.xls)

```r
ratings <- data.frame(country = c("Italy","Spain","Croatia","Brazil","Russia",
                                  "Germany","Turkey","Morocco","Peru","Nigeria",
                                  "France","Mexico","SouthAfrica"),
                      living_standard = c(7,7,5,5,6,8,5,4,5,2,8,2,4),
                      climate = c(8,9,6,8,2,3,8,7,6,4,4,5,4),
                      food = c(9,9,6,7,2,2,9,8,6,4,7,5,5),
                      security = c(5,5,6,3,3,8,3,2,3,2,7,2,3),
                      hospitality = c(3,2,5,2,7,7,1,1,4,3,9,3,3),
                      infrastructure = c(7,8,6,3,6,9,3,2,4,2,8,3,3))
head(ratings)
```

```
##   country living_standard climate food security hospitality infrastructure
## 1   Italy               7       8    9        5           3              7
## 2   Spain               7       9    9        5           2              8
## 3 Croatia               5       6    6        6           5              6
## 4  Brazil               5       8    7        3           2              3
## 5  Russia               6       2    2        3           7              6
## 6 Germany               8       3    2        8           7              9
```

### Principal components analysis (PCA)

```r
pca <- prcomp(ratings[,2:7], scale. = TRUE)  
summary(pca)
```

```
## Importance of components:
##                          PC1    PC2     PC3     PC4     PC5     PC6
## Standard deviation     1.854 1.4497 0.43959 0.39052 0.27517 0.19778
## Proportion of Variance 0.573 0.3503 0.03221 0.02542 0.01262 0.00652
## Cumulative Proportion  0.573 0.9232 0.95544 0.98086 0.99348 1.00000
```

### Biplot

```r
draw_biplot(ratings, fix_sign = FALSE)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-33-1.png" width="672" style="display: block; margin: auto;" />

### Biplot with calibrated axis and projection lines

```r
draw_biplot(ratings, "climate",  project = TRUE)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-34-1.png" width="672" style="display: block; margin: auto;" />

## Mosaic plot

### Mosaic plot with one variable

```r
counts1 <- TitanicSurvival %>%
  group_by(sex, survived) %>%
  summarize(Freq = n())
mosaic(~sex, direction = "v", counts1)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-35-1.png" width="672" style="display: block; margin: auto;" />

### Mosaic plot with two variables

```r
mosaic(survived ~ sex, counts1, direction = c("v", "h"))
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-36-1.png" width="672" style="display: block; margin: auto;" />

### Mosaic plot with three variables

```r
mosaic(survived ~ passengerClass + sex, counts, direction = c("v", "v", "h"),
       rot_labels = c(0,0,0,90))
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-37-1.png" width="672" style="display: block; margin: auto;" />

### Mosaic pairs plot

```r
pairs(table(TitanicSurvival[,c(1,2,4)]), highlighting = 2)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-38-1.png" width="672" style="display: block; margin: auto;" />

## Alluvial diagram

Data: `Yamaguchi87` in the vcdExtra package

```r
head(Yamaguchi87)
```

```
##    Son Father Country Freq
## 1 UpNM   UpNM      US 1275
## 2 LoNM   UpNM      US  364
## 3  UpM   UpNM      US  274
## 4  LoM   UpNM      US  272
## 5 Farm   UpNM      US   17
## 6 UpNM   LoNM      US 1055
```


```r
ggplot(Yamaguchi87, aes(y = Freq, axis1 = Father, axis2 = Son)) +
  geom_flow(aes(fill = Father), width = 1/12) +
  geom_stratum(width = 1/12, fill = "grey80", color = "black") +
  geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limit = c("Father", "Son"), expand = c(.05, .05)) +
  scale_y_continuous(expand = c(.01, 0)) +
  guides(fill = FALSE)
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-40-1.png" width="672" style="display: block; margin: auto;" />

## Heatmap

### Hexagonal heatmap

```r
ggplot(babies, aes(x = gestation, y = bwt)) +
  geom_hex()
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-41-1.png" width="672" style="display: block; margin: auto;" />

### Square heatmap

```r
ggplot(babies, aes(x = gestation, y = bwt)) +
  geom_bin_2d()
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-42-1.png" width="672" style="display: block; margin: auto;" />

### Heatmap with facets

```r
mydata <- Yamaguchi87 %>%
  group_by(Country, Father) %>% 
  mutate(Total = sum(Freq)) %>%
  ungroup()
ggplot(mydata, aes(x = Father, y = Son)) +
  geom_tile(aes(fill = Freq/Total), color = "white") +
  coord_fixed() +
  facet_wrap(~Country) +
  scale_fill_distiller(palette = "RdBu")
```

<img src="cheatsheet_for_multiple_graphics_files/figure-html/unnamed-chunk-43-1.png" width="672" style="display: block; margin: auto;" />
