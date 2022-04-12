# class_material_code_throughout_this_semester

Weijia Wang

Parameters:

shape: changes the shape of points into squares, triangles according to the category of variable

color: changes colors, specify types.

size: changes the size of shapes?

scale_fill_manual(values = c("#ff99ff", "#cc9966")) # fill color into bar chart

span: geom_smooth(method = "loess", span = .1, se = FALSE)

----------------------------------------------------------

##  Continuous variables

   ### Histograms 
      1) base r: hist(x, col = "color")
      2) ggplot2: geom_histogram(color = "blue", fill = "lightblue", binwidth = 5, center = 52.5) + theme_grey(14))
   
   ### Bindwidth
      1) bin boundaries
         right closed (55, 60] or right open [55, 60)
         code: right = TRUE or FALSE
               hist(x, right = FALSE, ylim = c(0, 4), xlab = "right open ex. [55, 60)", font.lab = 2)
      2) set bin boundaries by hand: 
         code: breaks = seq(start, stop, gap)
               hist(x, breaks = seq(47.5, 72.5, 5), col = "lightblue", axes = FALSE)
      3) Frequency (count) histogram
         hist(prices, breaks = seq(300, 800, 100), col = "lightblue", las = 1)
      4) Density histogram: freq = FALSE
         hist(prices, breaks = c(300, 400, 500, 600, 700, 800),
              freq = FALSE, col = "lightblue", ylab = "",
              main = "Density Histogram", las = 1)
      5) Calculate: Density histogram with unequal bin widths
         g2 <- ggplot(df, aes(x = center, y = percent/(100*binwidth), 
               width = binwidth)) + 
         geom_col(color = "blue", fill = "lightblue") +
         ylab("density") + xlab("age") +
         scale_x_continuous(breaks = c(0, df$breaks)) +
         ggtitle("Census 2000: Zip Code 10027")
      6) Cumulative frequency histogram:
         geom_histogram(aes(y = cumsum(..count..)), color = "blue", fill = "lightblue")
      7) Change bindwidth interactively: ggvis
         df %>% ggvis(~GDP) %>% 
         layer_histograms(fill := "green", 
                          width = input_slider(500, 10000, 
                                               value = 5000, 
                                               step = 500,
                                               label = "width"))
   
## Boxplots
   ### How to draw: 
       ggplot(tidySavings, aes(person, amount)) + 
       geom_boxplot()
   ### Add number to quantiles:
       boxplot(D, horizontal = TRUE, ylim=c(-250, 200))
       text(fivenum(D)[c(1,3,5)], 1.25, round(fivenum(D)[c(1,3,5)],1), col = "red")
       text(fivenum(D)[c(2,4)], .75, round(fivenum(D),1)[c(2,4)], col = "red")
   ### Outliers:
       if the observation is 2.5 times further than the lower hinge, then it should be an outlier
   ### Variable width boxplots:
       geom_boxplot(varwidth = TRUE)
   ### Multiple density histograms, ordered by median
       gh <- ggplot(world, aes(x = TFR, y = ..density..)) +
           geom_histogram(color = "blue", fill = "lightblue") +
       facet_wrap(~reorder(CONTINENT, -TFR, median), nrow = 6, strip.position = "right") +
         theme(strip.placement = "outside",
               strip.background = element_blank(),
               strip.text = element_text(face = "bold"))
   ### Density curve
       geom_density(color = "red") 
   ### Violin plot
       geom_violin(adjust = 6) # change bandwidth
   ### Ridgeline plot
       gr <- ggplot(world, aes(x = GDP, y = reorder(CONTINENT, -GDP,
                                       median))) + 
             geom_density_ridges(fill = "blue", alpha = .5)




## Chapter 6 Rounding noraml distrubution

### Q-Q plot   
    3.1.1 What is a Q-Q plot?
    If the line is not 45 degrees, then it is not normally distrubtted
    
    3.1.2 How to draw
    qqnorm(x)
    
    3.1.3 DIY Q-Q plot
     qx <- quantile(x) 
     qn <- quantile(n)
     plot(qn, qx, pch = 16)
     mod <- lm(c(qx[2], qx[4])~c(qn[2], qn[4]))
     abline(mod, col = "red")
     
### Density Curve + Noraml Curve
    3.2.1 How to draw
          library(tidyverse)
          df <- data.frame(x = rnorm(1000, 50, 10))
          ggplot(df, aes(x)) + geom_histogram(aes(y = ..density..),
                                              fill = "lightblue",
                                              color = "black") +
            geom_density(lwd = 1.5) +
            stat_function(fun = dnorm, args = list(mean = 50, sd = 10), color = "red", lwd = 1.5)
    
### Shapiro Wilk test
    3.3.1 What is this
    Null hypothesis: data is normally distributed
    Alternative hypothesis: data is not normally distributed
    
    3.3.2 How 
    > shapiro.test(x)
    if P-value is very small, then the null hypothesis could be rejected.
    
    
    
## Chapter 7 Grammar of Graphics
### Layers
        g <- ggplot() + geom_point(data = df1, aes(x,y)) +
                 geom_col(data = df2, aes(num, height),
                 fill = "green") + 
                 geom_boxplot(data = df3, aes(1, score)) +
                 geom_line(data = df4, aes(time, dist),
                 color = "red")
    
### Coord
    g+coord_polar()
    
### Facet
    g + facet_grid(num~height)
    
### Theme
    g+theme_wsj()
    
### Mapping
    aes(x = x, y = y, color = "color", fill = "fill")
    
### Scale
        scale_x_reverse()
        scale_x_date()
        scale_y_continuous()
        scale_color_manual()
        scale_fill_viridis_c() 
        
### Code style
        ggplot (data =  <DATA> ) +  
            <GEOM_FUNCTION> (mapping = aes( <MAPPINGS> ),  
            stat = <STAT> , position = <POSITION> ) +      
            <COORDINATE_FUNCTION> + 
            <FACET_FUNCTION>  + 
            <SCALE_FUNCTION>  + 
            <THEME_FUNCTION>
    
    
## Chapter 8 Categorical Variables
### Types of data
        nominal – no fixed category order
        ordinal – fixed category order
        (“real”) discrete, small # of possibilities
        Not always clearcut: nominal vs. ordinal, ordinal vs. discrete, and...
        Sometimes numbers = nominal, not discrete
        
        5.1.1 Ordinal data
              Sort in logical order of the categories (left to right, starting at bottom or top, etc.)
        5.1.2 Nominal data
              Sort from highest to lowest count (left to right, or top to bottom, etc.)
        
        5.1.3 Discrete data
              * Cleveland dot plot:
                ggplot(africa, aes(x = GDP, y = fct_reorder(COUNTRY, GDP))) +
                  geom_point(color = "blue")
                hint: Set x and y axis different: scales = "free_y", space = "free_y"
    
### Plotting Categorical data
        5.2.1 Recoding factor levels: 
              
              1) setting levels by hand:
              levels(x) <- c("Physics", "Math", "Chemistry")
              
              2) fct_recode: change names of levels
              x <- factor(c("G234", "G452", "G136"))  
              y <- fct_recode(x, Physics = "G234", Math = "G452", Chemistry = "G136")  
              
              3) fct_inorder: set level order of x to row order
              ggplot(df, aes(x = fct_inorder(temperature), y = count))
              
              4) fct_relevel: manually set the order of levels of x
              x <- c("A", "B", "C", "move1", "D", "E", "move2", "F")  
              fct_relevel(x, "move1", "move2")
              
              5) fct_reorder: reorder x by y
              ggplot(pack1, aes(fct_reorder(color, count), count)) +   
              geom_col() 
              
              6) fct_infreq: order the levels of x by decreasing frequency
              ggplot(df, aes(fct_infreq(mmcolor))) +   
              geom_bar() 
              
              7) fct_rev: reverse the order of factor levels of x
              ggplot(df, aes(fct_rev(fct_infreq(mmcolor)))) +   
              geom_bar()
              
              8) fct_explicit_na: turn NAs into a real factor level
              
        5.2.2 Binning and rebinning data
              df %>%   
                group_by(Class) %>%   
                summarize(Freq = sum(Freq)) %>%   
                ggplot(aes(Class, Freq)) +   
                geom_col(color = "grey50", fill = "lightblue") +  
                theme_grey(16)
              
        5.2.3 Percentages
              df %>%   
                gro up_by(Class) %>%   
                summarize(Freq = sum(Freq)) %>%   
                mutate(prop = Freq/sum(Freq))
        
    
## Chapter 10 Tidying data
   Tidy: 1 variable per column, 1 observation per row
       
    
## Chapter 11 Dependency relationships
    
### Interactive plot
        1) ggplot
        library(plotly)
        ggplotly(g)
        
        2) base r
        plot_ly(world, x = ~GDP, y = ~TFR, color = ~CONTINENT, text = ~COUNTRY, hoverinfo = 'text') 
    
### Dealing with overplotting
        7.2.1 Open circles:
        geom_point(pch = 21)
        
        7.2.2 Alpha blending: 
        geom_point(alpha = .05, stroke = 0) 
        
        7.2.3 Smaller dots:
        size = .05
        shape = "."
        
        7.2.4 Subset:
        ggplot(binnedmovies, aes(votes, rating)) + 
        geom_point(alpha = .1) +
          facet_wrap(~mybin, scales = "free_x")
          
        7.2.5 10% highest number:
        bin10 <- binnedmovies %>% filter(mybin == 10)
        ggplot(bin10, aes(votes, rating)) + geom_point()
        
### Heatmap
        7.3.1 Parameters:
        bindwidth = c(10, 10) changes large or small of the shape
        alpha - 0.4 changes color dark or light
        size = 2 changes large or small of the dots
        scale_fill_gradient(low = "grey", high = "purple") changes color
       
        7.3.2 Square heatmap:
        g1 + geom_bin2d(binwidth = c(5, 5)) # no dots, dark color
        g1 + geom_bin2d(binwidth = c(5, 5), alpha = .4) + geom_point(size = 2)
        
        7.3.3 Hex heatmap:
        g1 + geom_hex(binwidth = c(5, 5)) 
     
### Density estimate contour
         g +  geom_density_2d(bins = 5)
         
         contour lines: 
         contour(f1, add = T)
         g + geom_contour(aes(z = z))
         
## Chapter 12 Continuous + Categorical 
### Graphiical data analysis with R
       Examining Continuous Variables
       Displaying Categorical Data
       Looking for Structure: Dependency Relationships and Associations
       Combining Continuous and Categorical Data
       Investingating Multivariate Continuous Data
       Studying Multivariate Categorical Data
       
### Factes
   facet_wrap(~categorical variable, scales = "free_x") "free_x" means x axises are not the same
   
   
### Mapping options
   Continuous: x-axis, y-axis, color (not so great), size (not so great)
   Categorical: color, facets (rows, columns), shape (maybe)
   
   
   
## Parallel Coordinates (Multivariate continuous data)
   9.1 3D scatterplot
   3D scatterplot:
   library(scatterplot3d)  
   scatterplot3d(df$x, df$y, df$z, pch = 16, color = "blue")
   
   interactive 3D:
   library(plotly)  
   plot_ly(df, x = ~x, y = ~y, z = ~z, mode = "markers",   
           marker = list(size = 4)) %>% add_markers()
    
### Slope graph: ggplot2::geom_line()
   ggplot(tidydf, aes(x = var, y = value, group = ID)) +  
   geom_line()
   
       9.2.1 Standardize data
             mutate(value = standardize(value)) %>% ungroup()
       9.2.2 Rescale data to [0,1]
             mutate(value = scales::rescale(value)) 
       9.2.3 Parameters: GGally::ggparcoord() (static, ggplot2)
             1. Scale: ggparcoord(mystates, columns = 2:9, scale = " ")
                1) scale = "globalminmax"
                2) scale = “std” (default)
                3) scale = "uniminmax"
             
             2. Reorder:
                ggparcoord(mystates, columns = c(2, 4, 6, 8, 3, 5, 7, 9))
             
             3. alpha: changes color light or dark
             
             4. vline: add vertical lines
                geom_vline(xintercept = 1:4, color = "lightblue")
                
             5. splines: make lines softer
                gparcoord(df, columns = 1:4, scale = "globalminmax",  
                splineFactor = 10) 
             
             6. group: add color to different groups
                ggparcoord(mystates, columns = 2:9, groupColumn = 10)
             
             7. parcoords:
             MASS:: parcoord() (static, base)
             parcoords::parcoords() (interactive)  
             
                # See: http://www.buildingwidgets.com/blog/2015/1/30/week-04-interactive-parallel-coordinates-1 
                # devtools::install_github("timelyportfolio/parcoords")  
                library(parcoords)  
                mystates  %>% arrange(Region) %>%  
                  parcoords(  
                    rownames = F   
                    , brushMode = "1D-axes"  
                    , reorderable = T  
                    , queue = T  
                    , alpha = .5
                    )  
                    
             8. color:
                 parcoords(mystates  
                    , rownames = F   
                    , brushMode = "1D-axes"  
                    , reorderable = T  
                    , queue = T  
                    , color = list(  
                      colorBy = "Region"  
                      ,colorScale = "scaleOrdinal"  
                      ,colorScheme = "schemeCategory10"  
                      )  
                    , withD3 = TRUE  
                    )    
                
             9. highlighting a tred: Murder>11 is highlighted here:
             mystates <- mystates %>%  
                 mutate(color = factor(ifelse(Murder > 11, 1, 0))) %>%   
                 arrange(color)  
             ggparcoord(mystates, columns = 2:9, groupColumn = "color") + 
                 scale_color_manual(values = c("grey70", "red")) +
                 coord_flip() + guides(color = FALSE) +  
                 ggtitle("States with Murder Rate > 11 (per 100000) in red")
    
## Biplots
### Principal components analysis
         pca <- prcomp(ratings[,2:7], scale. = TRUE)
### Biplot
         1) ggplot
         ggplot(df_pca, aes(PC1, PC2, label = country)) +
         geom_point() +
         geom_text(nudge_y = .2) +
         coord_fixed()
         
         2) base r
         draw_biplot(ratings, "living_standard")
### Scatterplot of scaled data
       
    
## Multivariate Categorical data

### Stacked bar chart
    ggplot(cases, aes(x = Age, fill = Favorite)) + 
      geom_bar() + 
      scale_fill_manual(values = c("#ff99ff", "#cc9966"))
    
### Group bar chart
    ggplot(cases, aes(x = Age, fill = Favorite)) +
      geom_bar(position = "dodge") +

      
### Cleveland dot plot
    1) Setting theme
       theme_dotplot <-
         theme_bw(16) +
         theme(axis.ticks.y = element_blank(), panel.grid.major.x = element_blank(),
               panel.grid.major.y = element_line(size = 0.5), panel.grid.minor.x = element_blank())
    2) geom_point
    
### Mosaic plot
    1) two variables
       library(vcd)
       tidyexp$Group <- fct_rev(tidyexp$Group)
       mosaic(Group ~ Age, direction = c("v", "h"), tidyexp,
              highlighting_fill = c("grey80", "cornflowerblue"))
    2) three variables
       vcd::mosaic(Favorite ~ Music + Age, counts3,
       direction = c("v", "v", "h"), # <- order: Music ("v"), Age ("v"), Favorite ("h")
       highlighting_fill = icecreamcolors)
       
    3) Mosaic pairs plot
       pairs(table(cases[,2:4]), highlighting = 2)
       
    4) Mosaic mobility plot
       UKmob$mob <- factor(UKmob$mob, levels = 4:-4)
       UKmob$Father <- factor(UKmob$Father, levels = levels(Yamaguchi87$Father))
       vcd::mosaic(mob ~ Father, UKmob, 
                   direction = c("v", "h"),
                   tl_labels = c(FALSE, TRUE),  # move labels to bottom  
                   rot_labels = c(0,0,0,0),   # all horizontal
                   highlighting_fill = fills9,
                   main = "Downward mobility")
     5) Change of names:
        library(vcd)
        library(vcdExtra)
        library(tidyverse)
        
        foodorder <- Alligator %>% group_by(food) %>% summarize(Freq = sum(count)) %>% 
          arrange(Freq) %>% pull(food)
        
        ally <- Alligator %>% 
          rename(Freq = count) %>% 
          mutate(size = fct_relevel(size, "small"),
                 food = factor(food, levels = foodorder),
                 food = fct_relevel(food, "other"))
        
        vcd::mosaic(food ~ sex + size, ally,
               direction = c("v", "v", "h"),
               highlighting_fill= RColorBrewer::brewer.pal(5, "Accent"))
      
      6) Treemap
         library(treemap)
         # example from ?treemap
         data(GNI2014)
         treemap::treemap(GNI2014,
                index=c("continent", "iso3"),
                vSize="population",
                vColor="GNI",
                type="value",
                format.legend = list(scientific = FALSE, big.mark = " "))
       
       7) Spine plot:  mosaic plot with straight, parallel cuts in one dimension (“spines”) and only one variable cutting in the other direction
          vcd::mosaic(food ~ sex + size, ally,
          direction = c("v", "v", "h"),
          highlighting_fill= RColorBrewer::brewer.pal(5, "Accent"))
       
       8) ggplot
          fillcolors <- brewer.pal(3, "Blues")
          h <- housing %>% group_by(Type, Infl, Cont) %>% 
            mutate(RelFreq = Freq/sum(Freq)) %>% ungroup()
          ggplot(h, aes(x = Infl, y = RelFreq, fill = Sat)) +
            geom_col() +
            facet_grid(Cont ~ Type) +
            scale_fill_manual(values = fillcolors) +
         theme_classic()

    
### Chi-square test of independence
       x<- chisq.test(matrix, correct = F)
       x$observed
       x$expected
       x
    


## Alluvial form
    1) Structure: stratum, load, alluvium
    2) Basic code:
       library(ggalluvial)
       ggplot(df, aes(axis1 = Class1, axis2 = Class2, y = Freq)) +
         geom_alluvium(color = "black") +
         geom_stratum() +
         geom_text(stat = "stratum", aes(label = paste(after_stat(stratum), "\n", after_stat(count)))) +
         scale_x_discrete(limits = c("Class1", "Class2"))
    3) Separate code:
       3.1) Strata only:
            ggplot(df, aes(axis1 = Class1, axis2 = Class2, y = Freq)) +
            #  geom_alluvium(color = "black") +
              geom_stratum() +
              geom_text(stat = "stratum", aes(label = paste(after_stat(stratum), "\n", after_stat(count)))) +
              scale_x_discrete(limits = c("Class1", "Class2"))
       3.2) Alluvia only:
             ggplot(df, aes(axis1 = Class1, axis2 = Class2, y = Freq)) +
               geom_alluvium(color = "black") +
             #  geom_stratum() +
             #  geom_text(stat = "stratum", aes(label = paste(after_stat(stratum), "\n", after_stat(count)))) +
               scale_x_discrete(limits = c("Class1", "Class2"))
    4) geom_flow:
        df2 <- data.frame(Class1 = c("Stats", "Math", "Stats", "Math", "Stats", "Math", "Stats", "Math"),
                  Class2 = c("French", "French", "Art", "Art", "French", "French", "Art", "Art"),
                  Class3 = c("Gym", "Gym", "Gym", "Gym", "Lunch", "Lunch", "Lunch", "Lunch"),
                  Freq = c(20, 3, 40, 5, 10, 2, 5, 15))
        ggplot(df2, aes(axis1 = Class1, axis2 = Class2, axis3 = Class3, y = Freq)) +
          geom_flow(color = "black") +
          geom_stratum() +
          geom_text(stat = "stratum", aes(label = paste(after_stat(stratum), "\n", after_stat(count)))) +
          scale_x_discrete(limits = c("Class1", "Class2", "Class3"))
    5) color by first variable:
        library(vcdExtra)
        ggplot(Yamaguchi87, aes(y = Freq, axis1 = Father, axis2 = Son)) +
          geom_flow(aes(fill = Father), width = 1/12) +
          geom_stratum(width = 1/12, fill = "grey80", color = "black") +
          geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
          scale_x_discrete(limit = c("Father", "Son"), expand = c(.05, .05)) +
          scale_y_continuous(expand = c(.01, 0)) +
          guides(fill = FALSE) +
          theme_classic()
    
    
    
## Color
   1) Continuous data:  
      +scale_color_viridis_c() or _fill_
      
      recolorbrewer:
      + scale_color_distiller(palette = “PuBu") 
      
      reverse palette order with direction = 1
   
   2) Continuous data:
      Create your own sequential: +scale_color_gradient(low = "white", high = "red") 
      Create your own diverging: +scale_color_gradient2(low = "blue", mid = "white", high = "red")
   
   3) Discrete data:
      +scale_color_viridis_d() 
      
      recolor brewer:
      +scale_color_brewer(palette = "PuBu") 
      
      Create your own:
      +scale_color_manual(values = c("red", "yellow", "blue")
    
    4) Discrete ordinal data:
       library(RColorBrewer)
       colors<- brewer.pal(4, "Reds)
       barplot(1:4, col = colors)
    

## Time Series
### Multiple time series: line
        df <- df %>% gather(key = TYPE, value = RATE, -DATE) %>%
          mutate(TYPE = forcats::fct_reorder2(TYPE, DATE, RATE))# puts legend incorrect order
  
### filling:
        ggplot(df, aes(DATE, RATE, fill = TYPE)) 
        
### plot:
        plot()
        monthplot()
        
### label by day of week
          ggplot(christmas, aes(Date, Gross)) +
           geom_label(aes(label = wday(Date, label = TRUE)))
        label by day of month 
          geom_label(data = christmas, 
           aes(x = Date, y = Gross/1000000 + .06, 
               label = day(Date)))
      
### Highlight the abnormality
          g + annotate("rect", xmin = start, xmax = end,
                   ymin = -Inf, ymax = Inf, fill = "green",
                   alpha = .2) +
          annotate("text", x = end + 2,
                   y = 1500000, label = "Dec 24 - Jan 2",
                   color = "green", hjust = 0)
      
### Scale the data
          mutate(index = round(100*value/value[1], 2)) 
     
### Gaps
          mydat$Date <- as.Date(paste0(mydat$Year, "-", as.character(mydat$Q*3), "-30"))
          scale_x_date(limits = c(as.Date("2012-02-01"), as.Date("2014-12-31")), date_breaks = "6 months", date_labels = "%b %Y")
      
### Leave gaps
           geom_path(aes(group = `Order method type`)) +
           scale_x_date(limits = c(as.Date("2012-02-01"), as.Date("2014-12-31")),
               date_breaks = "6 months", date_labels = "%b %Y") 
      
      
 
## Dates
### Convert to date class
         1) Convert
            date<- as.Date(character)
            # class(date) >> Date
         2) Specifying the format
            as.Date("Thursday, January 6, 2005", format = "%A, %B %d, %Y")
            ## "2005-01-06"
         3) Parse_date
            as.Date("1/12/2019", format="%m/%d/%y")
            ## "2020-01-12"
            readr::parse_date("1/12/2019", format="%m/%d/%y")
            ## NA
           
            as.Date("Thursday, January 6, 2005", format = "%A, %B %d, %Y")
            ## "2005-01-06"
            readr::parse_date("Thursday, January 6, 2005", format = "%A, %B %d, %Y")
            ## Error: Invalid %A auto parser
### Lubridate: ymd(), ydm(), mdy(), myd(), dmy(), dym()
         1) mdy
            lubridate::mdy("April 13, 1907")
            ## "1907-04-13"
         2) as.Date
            as.Date("2017-11-02") - as.Date("2017-01-01")
            ## Time difference of 305 days
         3) Sys.Date()
            ## "2021-10-25"
            class(Sys.Date())
            ## "Date"
         4) today <- Sys.Date()
            lubridate::year(today)
            ## 2021
            
            lubridate::yday(today)
            ## 298
            
            lubridate::month(today, label = TRUE)
            ## Oct
            ## 12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < ... < Dec  
            
### Base R functions
         1) today <- Sys.Date()
            weekdays(today, abbreviate = TRUE)
            ## "Mon
         2) months(today, abbreviate = TRUE)
            ## "Oct"
         3) quarters(today)
            ## "Q4"
         
    
## Missing data
   1) Missing values by column
      colSums(is.na(mycars)) %>%
      sort(decreasing = TRUE)
      
   2) Missing values by row
      rowSums(is.na(mycars)) %>%
      sort(decreasing = TRUE)
    
   3) Plotting missing data
      ggplot(tidycars, aes(x = key, y = fct_rev(id), fill = missing))
   
   4) Heatmap
      missing_data.frame(mycars)
    
   5) Missing values by variable
      ggplot(tidycars, aes(x = key, y = fct_rev(id), fill = value)) +
        geom_tile(color = "white") + 
        scale_fill_gradient(low = "grey80", high = "red", na.value = "black")
    
   6) Missing values by variable
      mi::missing_data.frame(mycars)
   
   7) Aggregate missing patterns
      plot_missing(mycars, percent = FALSE)
   
   8) Number missing by day of month
       · add day of week info
       missing <- missing %>% 
           mutate(dayofweek = weekdays(as.Date(key),
                                       abbreviate = FALSE))
       · correct day order
       daysinorder <- c("Monday", "Tuesday", "Wednesday",
                        "Thursday", "Friday", "Saturday",
                        "Sunday")
       
       · reorder dayofweek
       missing$dayofweek <- factor(missing$dayofweek,
                                   levels = daysinorder)
       · choose colors
       daycolors <- c(rep("#cbc9e2", 5), rep("#2b8cbe", 2))
       
       · plot missing values by day, weekday/weekend colors
       ggplot(missing, aes(x = key, y = sum.na, fill = dayofweek)) +
           geom_col() +
           ggtitle("Number of missing values by day") +
           scale_fill_manual(values = daycolors) +
           xlab("") +
         ylab("Number of missing station values (out of 349)") +
           theme_classic() +
           theme(axis.text.x = element_text(angle = 90))
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
