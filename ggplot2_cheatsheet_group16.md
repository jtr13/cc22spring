# ggplot2 cheatsheet

Haoyuan Sun, Zhongtian Qiao




```r
library(tidyverse)
library(ggplot2)
```


## Overview
ggplot2 is a system for declaratively creating graphics. You provide the data, tell ggplot2 how to map variables to aesthetics, what graphical primitives to use, and it takes care of the details. This cheatsheet shows code options for commonly used graphs by using ggplot2.

## scatter plot


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-3-1.png" width="672" style="display: block; margin: auto;" />

We can get a scatter plot by using `geom_point()`.

### Setting color


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy), color = "blue")
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

We can change the color of the poionts by using `color =`. 

### Color by groups


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, color = class))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

If X-variable is a categorical variable, such as variable "class", we can set points of different classes to have different colors.

### Identify overlapping points


```r
ggplot(data = mpg) +
  geom_count(aes(x = displ, y = hwy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

We can get a scatter plot by using `geom_count`. The size of the points shows if the point is overlap.

## Line plot


```r
ggplot(data = mpg) +
  geom_line(aes(x = displ, y = hwy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

We can get a line plot by using `geom_line()`.

~ Use `lty =` to change the type of line.
~ Use `size =` to change the size of line.
~ Use `col =` to change the color of line.

### Adding an arbitrary line


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  geom_abline(slope = 1, intercept = 20)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

We can add arbitrary lines by using `geom_abline()`.

## Box plot


```r
ggplot(data = mpg) +
  geom_boxplot(aes(x = class, y = hwy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

We can get a box plot by using `geom_boxplot()`.

### Horizontal box plot 

```r
ggplot(data = mpg) +
  geom_boxplot(aes(x = class, y = hwy)) +
  coord_flip()
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

By using `coord_flip()`, we will get a horizontal box plot.

## Histogram


```r
ggplot(data = mpg) +
  geom_histogram(aes(x = hwy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

We can get a histogram by using `geom_histogram()`.

### Bins


```r
ggplot(data = mpg) +
  geom_histogram(aes(x = hwy), bins = 10)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

The default value of bin is 30. By changing the value of `bins =`, we can get different width of bin.

## Bar plot


```r
ggplot(data = mpg, aes(x = hwy, y = displ)) +
  geom_bar(position = "dodge", stat = "identity")
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

We can get a barplot which shows the relationship between of hwy and displ by using `geom_bar` with arguments `position="dodge"` and `stat = "identity"`. 

## Heatmap


```r
x <- c(1, 1, 1, 2, 2, 2, 3, 3, 3)
y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
df <- data.frame(x, y)
set.seed(2017)
df$z <- sample(9)
ggplot(df, aes(x, y)) +
  geom_raster(aes(fill = z))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

### Another way to plot heatmap


```r
ggplot(df, aes(x, y, fill = z)) +
  geom_tile() 
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

## Countour plot


```r
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_density2d() +
  geom_point(size = 1, alpha = 0.3)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

We can get a contour plot by using `geom_density2d()`.

## Area plot 


```r
ggplot(data = economics) +
  geom_area(aes(x = date, y = unemploy))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

If we want to analyse 2 continuous variables, we can plot an area plot by using `geom_area`.

## Adding Text 

### title and xy-corrdinate

```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, color = class)) +
  labs(title = "displ v.s. hwy",
       subtitle = "group by different class",
       x = "Displ",
       y = "Hwy",
       color = "Class")
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

By using `labs()`, we can add more information for the plot, such as the title, subtitle, x-coordinate, y-coordinate, the class of color, the class of fill, etc.

### Label


```r
data <- data.frame(name = c("a", "b", "c"), count = c(20, 10, 30))

ggplot(data, aes(name, count)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = count))
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

We can get the label for the plot of data by `geom_text()`, 

~ The content of label is controlled by `aes(label = )`.
~ Use `hjust` and `vjust` to adjust the vertical and horizontal position of the label. 
~ Use `col = ` to adjust the color of the label. 
~ Use `size = ` to adjust the size of the label. 


```r
ggplot(data, aes(name, count)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = count), col = "blue", vjust = -0.3, size = 5)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-20-1.png" width="672" style="display: block; margin: auto;" />

## Facet

### facet_wrap


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~class,nrow=2)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-21-1.png" width="672" style="display: block; margin: auto;" />

We can get multiple plots group by class by using `facet_wrap`.

### facet_grid


```r
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv~cyl)
```

<img src="ggplot2_cheatsheet_group16_files/figure-html/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />

We can get multiple plots which are group by drv and cyl by using `facet_grid`.
