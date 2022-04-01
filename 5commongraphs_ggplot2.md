# Drawing Five Common Plots by ggplot2

Xirui Guo


```r
library(ggplot2)
library(tidyverse)
library(ggpubr)
library(gridExtra)
library(reshape2)
library(Lock5withR)
library(fivethirtyeight)
library(RColorBrewer)
library(plotly)
```

## Motivation
The ggplot2 is a powerful and effective package for drawing plots. It has a lot of syntaxes to support people get the graphs they want. A good plot needs to clearly represent the information. Scatter plots, line plots, histograms, boxplots, and heatmaps are frequently used in daily life. This Markdown hopes to be a guide about how to quickly and suitably draw the above five plots by ggplot2.

## Graph1 scatter plot: geom_point\
Using data `mtcars`\
The main code for drawing scatter plot is geom_point; however, we usually don't use it single because we need the plot shows more information and here are some syntaxes people use together with `geom_point`:\
`aes(size , color)`: sometimes it is effective, but people need to avoid showing too much information and making the graph hard to read..\
`alpha`: change the transparency of point.\
`geom_text`: add labels of each point.\
`geom_smooth`: show the regression line and correspond standard error boundary.\


```r
mtcars$vs <- as.factor(mtcars$vs)

ggplot(mtcars, aes(x=wt, y=mpg, size=cyl, color=vs)) +
  geom_point(alpha = .4) + 
  geom_text(label=rownames(mtcars), 
            nudge_x = 0.25, nudge_y = 0.25, 
            check_overlap = T)+
  geom_smooth(method=lm , color="red", fill="lightblue", se=TRUE)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-2-1.png" width="672" style="display: block; margin: auto;" />

## Graph2 line chart: geom_line\
People need to clarify the x-axis and y-axis and can use `group` to draw the line with different colors.

```r
# library(reshape2)
x <- -10:10
var1 <- dnorm(x,-2,1)
var2 <- dnorm(x,2,1)
var3 <- dt(x,2,2)
data <- data.frame(x,var1,var2,var3)
data_n <- melt(data, id="x")

ggplot(data_n,aes(x=x, y=value, group=variable, color=variable))+
  geom_line()
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-3-1.png" width="672" style="display: block; margin: auto;" />

Using geom_line twice: a way for representing line from different groups without legend.

```r
data_n <- data_n %>%
  mutate(variable2=variable) 

ggplot(data_n, aes(x=x, y=value))+
  geom_line(data=data_n %>% select(-variable), aes(group=variable2), color="grey", size=0.5, alpha=0.8) +
  geom_line(aes(color=variable), color="blue", size=1)+
  facet_wrap(~variable)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

## Graph3 box plot: geom_boxplot\
Using the Data: *StudentSurvey* in **Lock5withR** package(PSet1). Drawing a "simple" box-plot first:\
`labs()`: simultaneously add the main title and axis labels

```r
# library(Lock5withR)
p3<-ggplot(StudentSurvey, aes(x = SAT, y = Year)) + 
  geom_boxplot()+
  labs(title="Plot of SAT score and Year", x="SAT score", y="Year")
p3
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

How to make boxplot shows more information:\
1. Using `theme()` + `element_text()` to modify the color, font, size of text.

```r
p3+theme(
  plot.title = element_text(color = "red", size = 14, face = "bold.italic"),
  axis.title.x = element_text(color="blue", size = 14, face = "bold"),
  axis.title.y = element_text(color="green", size = 14, face = "bold")
)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

2. Adding legend and modifying the legend tittle 

```r
p3<-ggplot(StudentSurvey, aes(x = SAT, y = Year, fill=Year)) + 
  geom_boxplot()+
  labs(fill="School Year")
p3
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

3.Changing the position of legend: five choices "left","top", "right", "bottom", "none"

```r
p3<- p3+
  theme(legend.position = "top")
p3
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

4. Modifying the title, label and background of legend

```r
p3+
  theme(
    legend.title = element_text(color="blue"),
    legend.text = element_text(color="red"),
    legend.background = element_rect(fill="lightblue")
    )
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

5. Changing the name and order of factor's level 

```r
Y <- fct_recode(StudentSurvey$Year, "NA" = "", "1st" = "FirstYear", 
                "2nd" = "Sophomore", "3rd" = "Junior", "4th" = "Senior")
Y <- fct_relevel(Y,"1st","2nd","3rd","4th")

p3<-ggplot(StudentSurvey, aes(x = SAT, y = Y, fill=Y)) + 
  geom_boxplot()+
  labs(fill="School Year")
p3
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

6. 6 ways to change the background of whole plots

```r
p3_1<-p3+theme_gray()
p3_2<-p3+theme_bw()
p3_3<-p3+theme_linedraw()
p3_4<-p3+theme_light()
p3_5<-p3+theme_minimal()
p3_6<-p3+theme_classic()

ggarrange(p3_1,p3_2,p3_3,p3_4,p3_5,p3_6,nrow=3,ncol=2)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />


## Graph4 histogram: geom_histogram\
Using Data: *bad_drivers* in **fivethirtyeight ** package. Common syntaxes with geom_histogram:\
`binwidth`: control the width of each bin.\
`fill`: the color of bin.\
`color`: the frame color of bin.\
`alpha`: control the transparency of the bin color.

```r
# library(fivethirtyeight)
p4 <- ggplot(bad_drivers,aes(x=perc_alcohol,y=..count..)) +
  geom_histogram(binwidth=3, fill="lightblue", color="black", alpha=0.7)
p4
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

`coord_flip()`：make the histogram bar become horizontal

```r
p4<- p4 +
  coord_flip()
p4
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

`scale_x_reverse()` and `scale_y_reverse()`：reverse the x-axis and y-axis

```r
p4+
  scale_y_reverse()
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

## Graph5 heatmap: geom_tile
The data is from the class notes\

```r
grade <- rep(c("first", "second", "third", "fourth"), 3)
subject <- rep(c("math", "reading", "gym"), each = 4)
statescore <- sample(50, 12) + 50
df <- data.frame(grade, subject, statescore)

p5 <- ggplot(df, aes(grade, subject, fill = statescore)) + 
  geom_tile() 
p5
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

1. Changing the color
`scale_fill_gradient()`, `scale_fill_distiller()` and `scale_fill_viridis()`\
`scale_fill_gradient()` can customize the color\
`scale_fill_distiller()` usually need palette = RColorBrewer\
`scale_fill_viridis()` need to let discrete=False when the variable is continuous

```r
# library(RColorBrewer)
display.brewer.all()
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-16-1.png" width="576" style="display: block; margin: auto;" />


```r
p5_1<-p5 + scale_fill_gradient(low="white", high="purple") + theme(legend.position="top")
p5_2<-p5 + scale_fill_distiller(palette = "RdBu")+ theme(legend.position="top")
p5_3<-p5 + scale_fill_viridis_c()+ theme(legend.position="top")
ggarrange(p5_1,p5_2,p5_3,nrow=1,ncol=3)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-17-1.png" width="576" style="display: block; margin: auto;" />

2. adding text in each square and interact

```r
# library(plotly)

df <- df %>%
  mutate(text = paste("grade ", grade , "\n", "subject: ", subject, "\n", "statescore: ",statescore))
pp5<-ggplot(df, aes(grade, subject, fill = statescore, text = text)) + 
  geom_tile() 
ggplotly(pp5, tooltip="text")
```

```{=html}
<div id="htmlwidget-8241c3a1a5acc03cc4c3" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-8241c3a1a5acc03cc4c3">{"x":{"data":[{"x":[1,2,3,4],"y":[1,2,3],"z":[[0.818181818181818,0.0909090909090909,0,0.409090909090909],[0.613636363636364,0.590909090909091,0.0454545454545455,0.454545454545455],[0.977272727272727,1,0.863636363636364,0.25]],"text":[["grade  first <br /> subject:  gym <br /> statescore:  92","grade  fourth <br /> subject:  gym <br /> statescore:  60","grade  second <br /> subject:  gym <br /> statescore:  56","grade  third <br /> subject:  gym <br /> statescore:  74"],["grade  first <br /> subject:  math <br /> statescore:  83","grade  fourth <br /> subject:  math <br /> statescore:  82","grade  second <br /> subject:  math <br /> statescore:  58","grade  third <br /> subject:  math <br /> statescore:  76"],["grade  first <br /> subject:  reading <br /> statescore:  99","grade  fourth <br /> subject:  reading <br /> statescore:  100","grade  second <br /> subject:  reading <br /> statescore:  94","grade  third <br /> subject:  reading <br /> statescore:  67"]],"colorscale":[[0,"#132B43"],[0.0454545454545455,"#16304A"],[0.0909090909090909,"#183652"],[0.25,"#22496C"],[0.409090909090909,"#2D5E88"],[0.454545454545455,"#306490"],[0.590909090909091,"#3977A9"],[0.613636363636364,"#3B7AAD"],[0.818181818181818,"#4996D3"],[0.863636363636364,"#4C9DDC"],[0.977272727272727,"#54AEF3"],[1,"#56B1F7"]],"type":"heatmap","showscale":false,"autocolorscale":false,"showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1],"y":[1],"name":"99_1518c9c71f083dfe8ec9ed79e2cd7777","type":"scatter","mode":"markers","opacity":0,"hoverinfo":"skip","showlegend":false,"marker":{"color":[0,1],"colorscale":[[0,"#132B43"],[0.00334448160535123,"#132B44"],[0.0066889632107023,"#132C44"],[0.0100334448160535,"#142C45"],[0.0133779264214048,"#142D45"],[0.0167224080267558,"#142D46"],[0.0200668896321071,"#142D46"],[0.0234113712374583,"#142E47"],[0.0267558528428093,"#152E47"],[0.0301003344481606,"#152F48"],[0.0334448160535116,"#152F48"],[0.0367892976588629,"#152F49"],[0.0401337792642141,"#153049"],[0.0434782608695652,"#16304A"],[0.0468227424749164,"#16304A"],[0.0501672240802676,"#16314B"],[0.0535117056856187,"#16314B"],[0.0568561872909699,"#16324C"],[0.0602006688963211,"#17324D"],[0.0635451505016722,"#17324D"],[0.0668896321070235,"#17334E"],[0.0702341137123745,"#17334E"],[0.0735785953177257,"#17344F"],[0.076923076923077,"#18344F"],[0.080267558528428,"#183450"],[0.0836120401337793,"#183550"],[0.0869565217391305,"#183551"],[0.0903010033444816,"#183651"],[0.0936454849498328,"#193652"],[0.096989966555184,"#193652"],[0.100334448160535,"#193753"],[0.103678929765886,"#193754"],[0.107023411371237,"#193854"],[0.110367892976589,"#1A3855"],[0.11371237458194,"#1A3955"],[0.117056856187291,"#1A3956"],[0.120401337792642,"#1A3956"],[0.123745819397993,"#1A3A57"],[0.127090301003344,"#1B3A57"],[0.130434782608696,"#1B3B58"],[0.133779264214047,"#1B3B59"],[0.137123745819398,"#1B3B59"],[0.140468227424749,"#1C3C5A"],[0.1438127090301,"#1C3C5A"],[0.147157190635451,"#1C3D5B"],[0.150501672240803,"#1C3D5B"],[0.153846153846154,"#1C3D5C"],[0.157190635451505,"#1D3E5C"],[0.160535117056856,"#1D3E5D"],[0.163879598662207,"#1D3F5D"],[0.167224080267559,"#1D3F5E"],[0.17056856187291,"#1D3F5F"],[0.173913043478261,"#1E405F"],[0.177257525083612,"#1E4060"],[0.180602006688963,"#1E4160"],[0.183946488294314,"#1E4161"],[0.187290969899666,"#1E4261"],[0.190635451505017,"#1F4262"],[0.193979933110368,"#1F4263"],[0.197324414715719,"#1F4363"],[0.20066889632107,"#1F4364"],[0.204013377926421,"#1F4464"],[0.207357859531773,"#204465"],[0.210702341137124,"#204465"],[0.214046822742475,"#204566"],[0.217391304347826,"#204566"],[0.220735785953177,"#214667"],[0.224080267558528,"#214668"],[0.22742474916388,"#214768"],[0.230769230769231,"#214769"],[0.234113712374582,"#214769"],[0.237458193979933,"#22486A"],[0.240802675585284,"#22486A"],[0.244147157190636,"#22496B"],[0.247491638795987,"#22496C"],[0.250836120401338,"#224A6C"],[0.254180602006689,"#234A6D"],[0.25752508361204,"#234A6D"],[0.260869565217391,"#234B6E"],[0.264214046822743,"#234B6E"],[0.267558528428094,"#244C6F"],[0.270903010033445,"#244C70"],[0.274247491638796,"#244C70"],[0.277591973244147,"#244D71"],[0.280936454849498,"#244D71"],[0.28428093645485,"#254E72"],[0.287625418060201,"#254E72"],[0.290969899665552,"#254F73"],[0.294314381270903,"#254F74"],[0.297658862876254,"#254F74"],[0.301003344481605,"#265075"],[0.304347826086957,"#265075"],[0.307692307692308,"#265176"],[0.311036789297659,"#265176"],[0.31438127090301,"#275277"],[0.317725752508361,"#275278"],[0.321070234113712,"#275278"],[0.324414715719064,"#275379"],[0.327759197324415,"#275379"],[0.331103678929766,"#28547A"],[0.334448160535117,"#28547B"],[0.337792642140468,"#28557B"],[0.34113712374582,"#28557C"],[0.344481605351171,"#28567C"],[0.347826086956522,"#29567D"],[0.351170568561873,"#29567D"],[0.354515050167224,"#29577E"],[0.357859531772575,"#29577F"],[0.361204013377927,"#2A587F"],[0.364548494983278,"#2A5880"],[0.367892976588629,"#2A5980"],[0.37123745819398,"#2A5981"],[0.374581939799331,"#2A5982"],[0.377926421404682,"#2B5A82"],[0.381270903010034,"#2B5A83"],[0.384615384615385,"#2B5B83"],[0.387959866220736,"#2B5B84"],[0.391304347826087,"#2C5C85"],[0.394648829431438,"#2C5C85"],[0.397993311036789,"#2C5D86"],[0.40133779264214,"#2C5D86"],[0.404682274247492,"#2C5D87"],[0.408026755852843,"#2D5E87"],[0.411371237458194,"#2D5E88"],[0.414715719063545,"#2D5F89"],[0.418060200668896,"#2D5F89"],[0.421404682274247,"#2E608A"],[0.424749163879599,"#2E608A"],[0.42809364548495,"#2E618B"],[0.431438127090301,"#2E618C"],[0.434782608695652,"#2E618C"],[0.438127090301003,"#2F628D"],[0.441471571906354,"#2F628D"],[0.444816053511706,"#2F638E"],[0.448160535117057,"#2F638F"],[0.451505016722408,"#30648F"],[0.454849498327759,"#306490"],[0.458193979933111,"#306590"],[0.461538461538462,"#306591"],[0.464882943143813,"#306592"],[0.468227424749164,"#316692"],[0.471571906354515,"#316693"],[0.474916387959866,"#316793"],[0.478260869565217,"#316794"],[0.481605351170569,"#326895"],[0.48494983277592,"#326895"],[0.488294314381271,"#326996"],[0.491638795986622,"#326996"],[0.494983277591973,"#326997"],[0.498327759197324,"#336A98"],[0.501672240802676,"#336A98"],[0.505016722408027,"#336B99"],[0.508361204013378,"#336B99"],[0.511705685618729,"#346C9A"],[0.51505016722408,"#346C9B"],[0.518394648829431,"#346D9B"],[0.521739130434783,"#346D9C"],[0.525083612040134,"#346E9D"],[0.528428093645485,"#356E9D"],[0.531772575250836,"#356E9E"],[0.535117056856187,"#356F9E"],[0.538461538461538,"#356F9F"],[0.54180602006689,"#3670A0"],[0.545150501672241,"#3670A0"],[0.548494983277592,"#3671A1"],[0.551839464882943,"#3671A1"],[0.555183946488294,"#3772A2"],[0.558528428093646,"#3772A3"],[0.561872909698997,"#3773A3"],[0.565217391304348,"#3773A4"],[0.568561872909699,"#3773A4"],[0.57190635451505,"#3874A5"],[0.575250836120401,"#3874A6"],[0.578595317725753,"#3875A6"],[0.581939799331104,"#3875A7"],[0.585284280936455,"#3976A8"],[0.588628762541806,"#3976A8"],[0.591973244147157,"#3977A9"],[0.595317725752508,"#3977A9"],[0.59866220735786,"#3978AA"],[0.602006688963211,"#3A78AB"],[0.605351170568562,"#3A79AB"],[0.608695652173913,"#3A79AC"],[0.612040133779264,"#3A79AC"],[0.615384615384615,"#3B7AAD"],[0.618729096989967,"#3B7AAE"],[0.622073578595318,"#3B7BAE"],[0.625418060200669,"#3B7BAF"],[0.62876254180602,"#3C7CB0"],[0.632107023411371,"#3C7CB0"],[0.635451505016723,"#3C7DB1"],[0.638795986622074,"#3C7DB1"],[0.642140468227425,"#3C7EB2"],[0.645484949832776,"#3D7EB3"],[0.648829431438127,"#3D7FB3"],[0.652173913043478,"#3D7FB4"],[0.65551839464883,"#3D7FB5"],[0.65886287625418,"#3E80B5"],[0.662207357859532,"#3E80B6"],[0.665551839464883,"#3E81B6"],[0.668896321070234,"#3E81B7"],[0.672240802675585,"#3F82B8"],[0.675585284280937,"#3F82B8"],[0.678929765886288,"#3F83B9"],[0.682274247491639,"#3F83BA"],[0.68561872909699,"#4084BA"],[0.688963210702341,"#4084BB"],[0.692307692307692,"#4085BB"],[0.695652173913043,"#4085BC"],[0.698996655518395,"#4086BD"],[0.702341137123746,"#4186BD"],[0.705685618729097,"#4186BE"],[0.709030100334448,"#4187BF"],[0.7123745819398,"#4187BF"],[0.715719063545151,"#4288C0"],[0.719063545150502,"#4288C1"],[0.722408026755853,"#4289C1"],[0.725752508361204,"#4289C2"],[0.729096989966555,"#438AC2"],[0.732441471571906,"#438AC3"],[0.735785953177257,"#438BC4"],[0.739130434782609,"#438BC4"],[0.74247491638796,"#438CC5"],[0.745819397993311,"#448CC6"],[0.749163879598662,"#448DC6"],[0.752508361204014,"#448DC7"],[0.755852842809365,"#448EC8"],[0.759197324414716,"#458EC8"],[0.762541806020067,"#458FC9"],[0.765886287625418,"#458FC9"],[0.769230769230769,"#458FCA"],[0.77257525083612,"#4690CB"],[0.775919732441471,"#4690CB"],[0.779264214046823,"#4691CC"],[0.782608695652174,"#4691CD"],[0.785953177257525,"#4792CD"],[0.789297658862877,"#4792CE"],[0.792642140468228,"#4793CF"],[0.795986622073579,"#4793CF"],[0.79933110367893,"#4894D0"],[0.802675585284281,"#4894D0"],[0.806020066889632,"#4895D1"],[0.809364548494983,"#4895D2"],[0.812709030100334,"#4896D2"],[0.816053511705686,"#4996D3"],[0.819397993311037,"#4997D4"],[0.822742474916388,"#4997D4"],[0.826086956521739,"#4998D5"],[0.829431438127091,"#4A98D6"],[0.832775919732442,"#4A99D6"],[0.836120401337793,"#4A99D7"],[0.839464882943144,"#4A9AD8"],[0.842809364548495,"#4B9AD8"],[0.846153846153846,"#4B9BD9"],[0.849498327759197,"#4B9BDA"],[0.852842809364548,"#4B9BDA"],[0.8561872909699,"#4C9CDB"],[0.859531772575251,"#4C9CDB"],[0.862876254180602,"#4C9DDC"],[0.866220735785953,"#4C9DDD"],[0.869565217391305,"#4D9EDD"],[0.872909698996656,"#4D9EDE"],[0.876254180602007,"#4D9FDF"],[0.879598662207358,"#4D9FDF"],[0.882943143812709,"#4DA0E0"],[0.88628762541806,"#4EA0E1"],[0.889632107023411,"#4EA1E1"],[0.892976588628763,"#4EA1E2"],[0.896321070234114,"#4EA2E3"],[0.899665551839465,"#4FA2E3"],[0.903010033444816,"#4FA3E4"],[0.906354515050168,"#4FA3E5"],[0.909698996655518,"#4FA4E5"],[0.91304347826087,"#50A4E6"],[0.916387959866221,"#50A5E7"],[0.919732441471572,"#50A5E7"],[0.923076923076923,"#50A6E8"],[0.926421404682274,"#51A6E8"],[0.929765886287625,"#51A7E9"],[0.933110367892977,"#51A7EA"],[0.936454849498328,"#51A8EA"],[0.939799331103679,"#52A8EB"],[0.94314381270903,"#52A9EC"],[0.946488294314381,"#52A9EC"],[0.949832775919733,"#52AAED"],[0.953177257525084,"#53AAEE"],[0.956521739130435,"#53ABEE"],[0.959866220735786,"#53ABEF"],[0.963210702341137,"#53ACF0"],[0.966555183946488,"#54ACF0"],[0.96989966555184,"#54ADF1"],[0.973244147157191,"#54ADF2"],[0.976588628762542,"#54AEF2"],[0.979933110367893,"#55AEF3"],[0.983277591973244,"#55AFF4"],[0.986622073578595,"#55AFF4"],[0.989966555183947,"#55B0F5"],[0.993311036789298,"#56B0F6"],[0.996655518394649,"#56B1F6"],[1,"#56B1F7"]],"colorbar":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"thickness":23.04,"title":"statescore","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"tickmode":"array","ticktext":["60","70","80","90","100"],"tickvals":[0.0909090909090909,0.318181818181818,0.545454545454545,0.772727272727273,1],"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"ticklen":2,"len":0.5}},"xaxis":"x","yaxis":"y","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":66.4840182648402},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,4.6],"tickmode":"array","ticktext":["first","fourth","second","third"],"tickvals":[1,2,3,4],"categoryorder":"array","categoryarray":["first","fourth","second","third"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"grade","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,3.6],"tickmode":"array","ticktext":["gym","math","reading"],"tickvals":[1,2,3],"categoryorder":"array","categoryarray":["gym","math","reading"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"subject","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"52ec42897e11":{"x":{},"y":{},"fill":{},"text":{},"type":"heatmap"}},"cur_data":"52ec42897e11","visdat":{"52ec42897e11":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

## Effective ways for showing more information
### Way1: Faceting
1. faceting by single discrete variable：

```r
# vertical faceting
p3 + 
  facet_grid(Award~.)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />


```r
# horizontal faceting
p3 + 
  facet_grid(.~Award)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-20-1.png" width="672" style="display: block; margin: auto;" />

2. faceting by two discrete variables：

```r
# column facet by Year and row facet by Award
p3+
  facet_grid(Year~Award, scales='free')
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-21-1.png" width="672" style="display: block; margin: auto;" />

### Way2: Representing multiple charts on a single page
Using Data: *bad_drivers* with syntaxes grid.arrange()

```r
# Make 3 simple graphics:
g6_1 <- ggplot(mtcars, aes(x=qsec)) + 
  geom_density(fill="slateblue")

g6_2 <- ggplot(mtcars, aes(x=drat, y=qsec, color=cyl)) + 
  geom_point(size=5) + theme(legend.position="none")

g6_3 <- ggplot(mtcars, aes(x=factor(cyl), y=qsec, fill=cyl)) + 
  geom_boxplot() +
  theme(legend.position="none")

# Plots
grid.arrange(g6_1, arrangeGrob(g6_2, g6_3, ncol=2), nrow = 2)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />

```r
grid.arrange(g6_1, g6_2, g6_3, nrow = 3)
```

<img src="5commongraphs_ggplot2_files/figure-html/unnamed-chunk-22-2.png" width="672" style="display: block; margin: auto;" />
