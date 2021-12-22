# Graphics in R

# Basic Graphs

Often, your data include categorical variables
and the ```vcd``` package is designed for
*Visualizing Categorical Data*.

```R
# Load vcd package
library(vcd)
```

Let's use this package to analyze the Arthritis dataset.
This dataset is used to determine whether a given ```Treatment```
```Improved``` the patient's condition.

```R
> summary(Arthritis)
       ID       Treatment      Sex          Age       Improved 
 Min.   : 1   Placebo:43   Female:59   Min.   :23   None  :42  
 1st Qu.:22   Treated:41   Male  :25   1st Qu.:46   Some  :14  
 Median :42                            Median :57   Marked:28  
 Mean   :42                            Mean   :53              
 3rd Qu.:63                            3rd Qu.:63              
 Max.   :84                            Max.   :74      
 ```

First, we'll get the cell counts for the ```"Improved"``` variable
using the ```table()``` function.

```R
> counts <- table(Arthritis$Improved)
> counts

  None   Some Marked 
    42     14     28 
```


This shows the number of observations with the "Improved"
variable in each of three categories.


## Listing 6.1 - Simple bar plot


The first step in any analysis is to create a simple bar plot
of the dependent variable.
```R
barplot(counts, main = "Simple Bar Plot", xlab = "Improvement",
    ylab = "Frequency")
```

<img src="Images/simple_bar.png" width="500"/>

For variables with few categories, often a
horizontal bar plot offers a better visualization.

```R
barplot(counts, main = "Horizontal Bar Plot", xlab = "Frequency",
    ylab = "Improvement", horiz = TRUE)
```
<img src="Images/horizontal_bar.png" width="500"/>


The only difference in syntax is the ```horiz = TRUE``` argument.


So far, we have analyzed one variable at a time.
Now consider how the ```Improved``` outcome varies with the ```Treatment```.
When two variables are passed to the ```table()``` function,
it tabulates a two-dimensional table of counts.

```R
> counts <- table(Arthritis$Improved,
+ Arthritis$Treatment)
> counts
        
         Placebo Treated
  None        29      13
  Some         7       7
  Marked       7      21
```

We can already see higher counts in the ```None``` column
for the ```Placebo``` group and many patients
with ```Marked``` Improvement in the ````Treated``` group.



## Listing 6.2 - Stacked and grouped bar plots

Bar plots offer several options for plotting
two-dimensional data.

A stacked barplot is one option.

```R
barplot(counts, main = "Stacked Bar Plot",
        xlab = "Treatment", ylab = "Frequency",
        col = c("red", "yellow", "green"),
        legend.text = rownames(counts))
```
<img src="Images/stacked_bar_ugly.png" width="500"/>

Note that the legend might be inconveniently placed
by default. You may have to pass some arguments to
alter the placement of the legend.

```R
barplot(counts, main = "Stacked Bar Plot",
        xlab = "Treatment", ylab = "Frequency",
        col = c("red", "yellow", "green"),
        legend.text = rownames(counts),
        args.legend = list(x = "topright" ,
                           inset = c(- 0.10, -0.6),
                           cex = 0.75,
                           ncol = 1))
```
<img src="Images/stacked_bar.png" width="500"/>

This looks good in the plot window,
however, sometimes other adjustments are
necessary when saving it to a file.



A grouped barplot is another option
to plot two-dimensional categorical data.
```R
barplot(counts, main = "Grouped Bar Plot",
        xlab = "Treatment", ylab = "Frequency",
        col = c("red", "yellow", "green"),
        beside = TRUE,
        legend.text = rownames(counts),
        args.legend = list(x = "topright" ,
                           inset = c(- 0.10, -0.6),
                           cex = 0.75,
                           ncol = 1))
```
<img src="Images/grouped_bar.png" width="500"/>



## Listing 6.3 - Mean bar plots

Now let's revisit a dataset with characteristics by US states.

We'll draw two variables from the data frame.
```R
states <- data.frame(state.region, state.x77)
```
Now we can calculate the mean Illiteracy rate by region.

```R
> means <- aggregate(states$Illiteracy,
+     by = list(state.region),
+     FUN = mean)
> means
        Group.1   x
1     Northeast 1.0
2         South 1.7
3 North Central 0.7
4          West 1.0
```
It helps to sort the means in order.
```R
> means <- means[order(means$x), ]
> means
        Group.1   x
3 North Central 0.7
1     Northeast 1.0
4          West 1.0
2         South 1.7
```

Now this table is in shape for a barplot.

```R
barplot(means$x, names.arg = means$Group.1)
title("Mean Illiteracy Rate")
```
<img src="Images/sorted_mean_bar.png" width="500"/>



## Listing 6.4 - Fitting labels in bar plots

Moving back to the Arthritis treatment data,
we can go back to a one-dimensional table,
but this time add notes to the table.

First, adjust the margins of the graph.
```R
par(mar = c(5, 8, 4, 2))
par(las = 2)
counts <- table(Arthritis$Improved)

barplot(counts, main = "Treatment Outcome",
        horiz = TRUE,
        cex.names = 0.8,
        names.arg = c("No Improvement",
                      "Some Improvement",
                      "Marked Improvement"))
```
<img src="Images/labels_barplot.png" width="500"/>

This allows you to skip the chore of
fooling around with the legend.


## Section --6.1.5 Spinograms--

A spinogram is a stacked bar plot in which
the height of each bar is one
and the segment heights represent proportions.

```R
library(vcd)
```
As above, we can attach the Arthritis data
to allow us to refer to the variables by name.
```R
attach(Arthritis)
counts <- table(Treatment, Improved)
spine(counts, main = "Spinogram Example")
detach(Arthritis)
```
<img src="Images/spinogram.png" width="500"/>


## Listing 6.5 - Pie charts

The statistical community largely does not favor pie charts,
which is partly the reason for limited functionality for pie charts.
The psychological justification for this is that
people are able to judge lengths better than volume.
Nevertheless, pie charts are common in business, so
we will work through some examples.

Let's start with a simple example.
```R
slices <- c(10, 12, 4, 16, 8)
lbls <- c("US", "UK", "Australia", "Germany", "France")

pie(slices, labels = lbls, main = "Simple Pie Chart")
```
<img src="Images/simple_pie.png" width="500"/>

We can add percentages as labels by calculating
the percentages and pasting them into a vector.
```R
pct <- round(slices/sum(slices) * 100)
lbls2 <- paste(lbls, " ", pct, "%", sep = "")

pie(slices, labels = lbls2, col = rainbow(length(lbls)),
    main = "Pie Chart with Percentages")
```
<img src="Images/pie_percent.png" width="500"/>

For added effect, one can plot the pie chart in
three dimensions.

```R
library(plotrix)
pie3D(slices, labels = lbls, explode = 0.1, main = "3D Pie Chart ")
```
<img src="Images/3D_pie.png" width="500"/>

As with a barplot, you can plot a pie chart
from a table.

```R
mytable <- table(state.region)
lbls <- paste(names(mytable), "\n", mytable, sep = "")
pie(mytable, labels = lbls,
    main = "Pie Chart from a Table\n (with sample sizes)")
```
<img src="Images/table_pie.png" width="500"/>


We added the table into the labels.




## Fan plots

Some people find a fan plot to be more visually
appealing than a pie chart, even though it carries
the same information.

```R
library(plotrix)
slices <- c(10, 12, 4, 16, 8)
lbls <- c("US", "UK", "Australia", "Germany", "France")
fan.plot(slices, labels = lbls, main = "Fan Plot")
```
<img src="Images/fan_plot.png" width="500"/>



## Listing 6.6 - Histograms

We have seen histograms before.

The standard histogram is simple to create
and is good for quick analysis.

```R
hist(mtcars$mpg)
```
<img src="Images/simple_hist.png" width="500"/>

For a histogram that you would add to a report,
you can overwrite the default features.
```R
hist(mtcars$mpg, breaks = 12, col = "red",
    xlab = "Miles Per Gallon",
    main = "Colored histogram with 12 bins")
```
<img src="Images/custom_bar.png" width="500"/>

The ```lines()``` command will append a line to an
existing plot.
Use it to plot a density curve.
```R
hist(mtcars$mpg, freq = FALSE, breaks = 12, col = "red",
    xlab = "Miles Per Gallon",
    main = "Histogram, rug plot, density curve")
rug(jitter(mtcars$mpg))
lines(density(mtcars$mpg), col = "blue", lwd = 2)
```
<img src="Images/hist_density.png" width="500"/>

The rug command adds a plot of the location of
observations to augment the density plot.

With some additional calculation,
you can superimpose a normal curve
over the histogram.

```R
x <- mtcars$mpg
h <- hist(x, breaks = 12, col = "red",
    xlab = "Miles Per Gallon",
    main = "Histogram with normal curve and box")
xfit <- seq(min(x), max(x), length = 40)
yfit <- dnorm(xfit, mean = mean(x), sd = sd(x))
yfit <- yfit * diff(h$mids[1:2]) * length(x)
lines(xfit, yfit, col = "blue", lwd = 2)
box()
```
<img src="Images/normal_hist.png" width="500"/>

Some like to enclose the histogram in a ```box()```.



## Listing 6.7 - Kernel density plot

A histogram is a simple form of a class of models
called nonparametric models (there are no parameters,
such as slope coefficients to estimate).
One step further is to plot a smoothed curve
approximating the density of the distribution.

The density function is designed for this purpose.

```R
d <- density(mtcars$mpg)
plot(d)
```
<img src="Images/density_default.png" width="500"/>

As with all graphs, one can specify additional features.
In this case, the density plot is created first,
assigned to the variable ```d```,
and passed as an argument to the plot function.

```R
d <- density(mtcars$mpg)
plot(d, main = "Kernel Density of Miles Per Gallon")
polygon(d, col = "red", border = "blue")
rug(mtcars$mpg, col = "brown")
```
<img src="Images/colored_density.png" width="500"/>

For additional decoration, you can paint the
shape of the plot and add a rug for the observations.


## Listing 6.8 - Comparing kernel density plots

Perhaps you want to compare two distributions
on one plot. The ```sm``` packages offers more options
for calculating smoothed curves.

```R
library(sm)
```

Set thicker line width for all plots.
```R
par(lwd = 2)
```
Take a sample from the mtcars dataset.
```R
attach(mtcars)
```
Now plot the densities of miles per gallon,
on for each category of number of cylinders.
```R
sm.density.compare(mpg, cyl, xlab = "Miles Per Gallon")
title(main = "MPG Distribution by Car Cylinders")
```
<img src="Images/comparing_densities.png" width="500"/>

Convert the number of cylinders to a factor
to annotate the graphs.
```R
cyl.f <- factor(cyl, levels = c(4, 6, 8),
                labels = c("4 cylinder", "6 cylinder", "8 cylinder"))
colfill <- c(2:(2 + length(levels(cyl.f))))
```

Now we're getting fancy:
you can use the ```locator()``` function to ask you
to point to a location in your plot window.
```R
cat("Use mouse to place legend...", "\n\n")
legend(locator(1), levels(cyl.f), fill = colfill)
```
<img src="Images/multi_density.png" width="500"/>


Detach the data and reset the line widths.
```R
detach(mtcars)
par(lwd = 1)
```


## --Section 6.5--

A boxplot is also useful to compare distributions
of a continuous variable across different categories.

```R
boxplot(mpg ~ cyl, data = mtcars,
    main = "Car Milage Data",
    xlab = "Number of Cylinders",
    ylab = "Miles Per Gallon")
```
<img src="Images/box_plot.png" width="500"/>

## Listing 6.9 - Box plots for two crossed factors

The same logic applies to the case with
two explanatory factors.

Define two categorical variables as factors:
number of cylinders and transmission type.
```R
mtcars$cyl.f <- factor(mtcars$cyl, levels = c(4, 6,
    8), labels = c("4", "6", "8"))
mtcars$am.f <- factor(mtcars$am, levels = c(0, 1),
    labels = c("auto", "standard"))
```

Now draw the boxplot by specifying
the formula as you would for a regression
of mpg on the interaction of ```am.f``` and ```cyl.f```.
```R
boxplot(mpg ~ am.f * cyl.f, data = mtcars,
    varwidth = TRUE, col = c("gold", "darkgreen"),
    main = "MPG Distribution by Auto Type",
    xlab = "Auto Type")
```
<img src="Images/cross_boxplot.png" width="500"/>

## Listing 6.10 - Violin plots

For the connoisseur, the violin plot
offers a sophisticated approach to plotting
densities across categories.

```R
library(vioplot)
x1 <- mtcars$mpg[mtcars$cyl == 4]
x2 <- mtcars$mpg[mtcars$cyl == 6]
x3 <- mtcars$mpg[mtcars$cyl == 8]
vioplot(x1, x2, x3,
    names = c("4 cyl", "6 cyl", "8 cyl"),
    col = "gold")
title("Violin Plots of Miles Per Gallon")
```
<img src="Images/violin_plot.png" width="500"/>

A violin plot is a combination of a boxplot and a
density plot for each category.
The white dot is the median,
the black column represents the interquartile range,
and the vertical line shows the whiskers as in a boxplot.
The boxplot is cased in a kernel density estimate of
the distribution.


## --Section 6.6--

A dot chart is the categorical analogue to
a scatterplot.

```R
dotchart(mtcars$mpg, labels = row.names(mtcars),
    cex = 0.7,
    main = "Gas Milage for Car Models",
    xlab = "Miles Per Gallon")
```
<img src="Images/dot_chart.png" width="700"/>

## Listing 6.11 - sorted colored grouped dot chart

A dot chart can be augmented by
using colors to represent categories
and sorting the data by gas mileage
to create a better visualization.

```R
# Sort the data first.
x <- mtcars[order(mtcars$mpg), ]
# Create a factor and assign color names
# by the levels of the factor.
x$cyl <- factor(x$cyl)
x$color[x$cyl == 4] <- "red"
x$color[x$cyl == 6] <- "blue"
x$color[x$cyl == 8] <- "darkgreen"
# Now plot the dotchart.
dotchart(x$mpg, labels = row.names(x), cex = 0.7,
    pch = 19, groups = x$cyl,
    gcolor = "black", color = x$color,
    main = "Gas Milage for Car Models\ngrouped by cylinder",
    xlab = "Miles Per Gallon")
```
<img src="Images/fancy_dot_chart.png" width="700"/>

# Intermediate Graphs

If you have followed this far,
perhaps you'll take a step further.

## Listing 11.1 - A scatterplot with best fit lines

You can augment plots with estimates from
statistical models.
This example adds a linear regression line
and a smoothed estimate of the relationship
with the ```lowess()``` function to implement a
locally weighted regression.
```R
attach(mtcars)
plot(wt, mpg,
     main="Basic Scatterplot of MPG vs. Weight",
     xlab="Car Weight (lbs/1000)",
     ylab="Miles Per Gallon ", pch=19)
abline(lm(mpg ~ wt), col="red", lwd=2, lty=1)
lines(lowess(wt, mpg), col="blue", lwd=2, lty=2)
```
<img src="Images/scatter_w_lines.png" width="500"/>


## Scatterplot matrices

You might want to quickly inspect several scatterplots
for a small set of variables.
The ```pairs()``` function calculates a scatterplot
for each pair of variables.
```R
pairs(~ mpg + disp + drat + wt, data=mtcars,
      main="Basic Scatterplot Matrix")
```
<img src="Images/scatter_matrix.png" width="500"/>

But why stop there?
With the ```lty.smooth=2``` argument, you can add
smoothed model fits between each pair of variables,
with density plots of each variable on the diagonal.
```R
library(car)
scatterplotMatrix(~ mpg + disp + drat + wt, data=mtcars, spread=FALSE,
    lty.smooth=2, main="Scatterplot Matrix via car package")
```
<img src="Images/smooth_scatter_matrix.png" width="500"/>


And because, when graphing in R, enough is never enough,
you can color code the plots by a specified category,
in this cae separated by number of cylinders.
```R
scatterplotMatrix(~ mpg + disp + drat + wt | cyl, data=mtcars, spread=FALSE,
    main="Scatterplot Matrix via car package", diagonal="histogram")
```

<img src="Images/smooth_scatter_by_cyl.png" width="500"/>

For the numerically-oriented, a correlation matrix
captures the relationships.
```R
> cor(mtcars[c("mpg", "wt", "disp", "drat")])
       mpg    wt  disp  drat
mpg   1.00 -0.87 -0.85  0.68
wt   -0.87  1.00  0.89 -0.71
disp -0.85  0.89  1.00 -0.71
drat  0.68 -0.71 -0.71  1.00
```


## Listing 11-2 Scatter plot matrix produced with the ```gclus``` package

The ```gclus``` package can produce a scatterplot matrix with
what you might agree is a more pleasing color scheme.

```R
library(gclus)
mydata <- mtcars[c(1,3,5,6)]
mydata.corr <- abs(cor(mydata))
mycolors <- dmat.color(mydata.corr)
myorder <- order.single(mydata.corr)
cpairs(mydata,
    myorder,
    panel.colors=mycolors,
    gap=.5,
    main="Variables Ordered and Colored by Correlation"
)
```
<img src="Images/scatter_matrix_color.png" width="500"/>


## High-density scatterplots

For this example, we will generate some random data.
```R
set.seed(1234)
n <- 10000
c1 <- matrix(rnorm(n, mean=0, sd=.5), ncol=2)
c2 <- matrix(rnorm(n, mean=3, sd=2), ncol=2)
mydata <- rbind(c1, c2)
mydata <- as.data.frame(mydata)
names(mydata) <- c("x", "y")
```
Another method to produce a scatterplot is
with the ```with()``` function.
```R
with(mydata,
    plot(x, y, pch=19,
         main="Scatter Plot with 10000 Observations"))
```
<img src="Images/ugly_scatter.png" width="500"/>

This syntax allows you to reference the names of variables
in the object passed to the ```with()``` function,
much like what happens when we ```attach()``` and ```detach()``` an object.

With so many points, covering most of the area,
it is difficult to tell the density.

A ```smoothScatter``` plot represents the density with
the intensity of the hue and augments the periphery
with plots of some outlying observations.
```R
with(mydata,
    smoothScatter(x, y,
                  main="Scatterplot with Smoothed Density"))
```
<img src="Images/smooth_scatter.png" width="500"/>

The ```hexbin``` package produces a color-coded scattergraph
by separating the region into hexagonal shapes.
```R
library(hexbin)
with(mydata, {
    bin <- hexbin(x, y, xbins=50)
    plot(bin, main="Hexagonal Binning (10,000 Observations)")
    })
```
<img src="Images/hex_bin_scatter.png" width="500"/>

The opaquely-named ```IDPmisc``` package can be used to plot
an illuminating scattergraph with a color scale to indicate density.
```R
library(IDPmisc)
with(mydata,
    iplot(x, y, main="Image Scatter Plot with Color Indicating Density"))
par(opar)
```
<img src="Images/color_scale_scatter.png" width="500"/>


## 3-D Scatterplots

If you are interested in three-dimensional data,
you can still plot a scattergraph.
```R
library(scatterplot3d)
attach(mtcars)
scatterplot3d(wt, disp, mpg,
     main="Basic 3D Scatterplot")
```
<img src="Images/3D_scatter.png" width="500"/>

However, for many analysts, it is difficult to
visualize the locations...
...unless the locations are represented with vertical lines.
```R
scatterplot3d(wt, disp, mpg,
    pch=16,
    highlight.3d=TRUE,
    type="h",
    main="3D Scatterplot with Vertical Lines")
```
<img src="Images/3D_scatter_vertical.png" width="500"/>

If you've followed this far,
why not augment your 3-D scatter plot with
a plot of the regression plane?
```R
s3d <-scatterplot3d(wt, disp, mpg,
    pch=16,
    highlight.3d=TRUE,
    type="h",
    main="3D Scatter Plot with Verical Lines and Regression Plane")
# Fit a regression model.
fit <- lm(mpg ~ wt+disp)
# Add it to the plot object s3d created above.
s3d$plane3d(fit)

# Clean up after finishing.
detach(mtcars)
```
<img src="Images/3D_scatter_w_reg_plane.png" width="500"/>


## Spinning 3D plot

It is often difficult to visualize 3-D data
on a 2-D surface. The ```rgl``` package has the function
```plot3d``` that renders the scatterplot in a separate window.
```R
library(rgl)
attach(mtcars)
plot3d(wt, disp, mpg, col="red", size=5)
```

<img src="Images/3D_plane_interactive_1.png" width="700"/>

You can interact with this plot by dragging your mouse
to move the plot around and see the view from different angles.



A similar interactive plot is available from the 
```scatter3d``` function in the ```Rcmdr```. 
```R
rgl.open()
library(Rcmdr)
attach(mtcars)
scatter3d(wt, disp, mpg)
```
RStudio may prompt you to install a number of 
packages to render the graph
but once you see it, you can drag the figure 
with your mouse and rotate it to 
see the data from all angles.


<img src="Images/3D_plane_interactive_2.png" width="700"/>


## Bubble plots

A bubble plot allows you to visualize the value of a third variable
while plotting the data on another two dimensions.
This figure plots gas mileage against the weight of a car,
with the size of the bubbles indicating the displacement of the engine.

```R
attach(mtcars)
r <- sqrt(disp/pi)
symbols(wt, mpg, r, inches=0.30, fg="white", bg="lightblue",
main="Bubble Plot with point size proportional to displacement",
ylab="Miles Per Gallon",
xlab="Weight of Car (lbs/1000)")
text(wt, mpg, rownames(mtcars), cex=0.6)
detach(mtcars)
par(opar)
```
<img src="Images/bubble_plot.png" width="500"/>


## Listing 11.3 - Creating side by side scatter and line plots

The dataset ```Oranges``` contains observations of the
circumference and ages for a sample of five orange trees.
The ```mfrow``` argument in the ```par``` function
sets the graphical parameters to plot
two scattergraphs side-by-side,
one for each orange tree.

```R
par(mfrow=c(1,2))
t1 <- subset(Orange, Tree==1)
plot(t1$age, t1$circumference,
    xlab="Age (days)",
    ylab="Circumference (mm)",
    main="Orange Tree 1 Growth")
t2 <- subset(Orange, Tree==2)
plot(t2$age, t2$circumference,
    xlab="Age (days)",
    ylab="Circumference (mm)",
    main="Orange Tree 2 Growth",
    type="b")
par(opar)
```
<img src="Images/two_tree_scatter.png" width="500"/>


## Listing 11.4 -  Line chart displaying the growth of 5 Orange trees over time

For plots with multiple parameters, it often helps to
Create blank axes first and then add the plots.

Calculate the parameters for the plot axes.
```R
Orange$Tree <- as.numeric(Orange$Tree)
ntrees <- max(Orange$Tree)

xrange <- range(Orange$age)
yrange <- range(Orange$circumference)
```

The ```type = "n"``` argument tells R to plot nothing:
Leave the plot blank to be filled in later.
```R
plot(xrange, yrange,
    type="n",
    xlab="Age (days)",
    ylab="Circumference (mm)"
 )
```

Next, determine the color scheme, line type
and plot character numbers in vectors,
each with five elements,
one for each tree in the ```Oranges``` dataset.
```R
colors <- rainbow(ntrees)
linetype <- c(1:ntrees)
plotchar <- seq(18, 18+ntrees, 1)
```
Now loop through the tree numbers.
```R
for (i in 1:ntrees) {
    tree <- subset(Orange, Tree==i)
    lines(tree$age, tree$circumference,
        type="b",
        lwd=2,
        lty=linetype[i],
        col=colors[i],
        pch=plotchar[i]
    )
}
```
Add a title and legend to complete the picture.

```R
title("Tree Growth", "example of line plot")

legend(# 'topright',
  xrange[1], yrange[2],
    legend = 1:ntrees,
    cex=0.75,
    col=colors,
    pch=plotchar,
    lty=linetype,
    title="Tree"
    )
```
<img src="Images/rainbow_plot.png" width="500"/>


## Correlograms

R has many options for the enthusiastic
data visualizer.
You might think that the following examples take
data visualization too far.

```R
options(digits=2)
cor(mtcars)

library(corrgram)
corrgram(mtcars, order=TRUE, lower.panel=panel.shade,
    upper.panel=panel.pie, text.panel=panel.txt,
    main="Correlogram of mtcar intercorrelations")

corrgram(mtcars, order=TRUE, lower.panel=panel.ellipse,
    upper.panel=panel.pts, text.panel=panel.txt,
    diag.panel=panel.minmax,
    main="Correlogram of mtcar data using scatterplots and ellipses")

corrgram(mtcars, lower.panel=panel.shade,
    upper.panel=NULL, text.panel=panel.txt,
    main="Car Mileage Data (unsorted)")

col.corrgram <- function(ncol){
    colorRampPalette(c("darkgoldenrod4", "burlywood1",
                                     "darkkhaki", "darkgreen"))(ncol)}


corrgram(mtcars, order=TRUE, lower.panel=panel.shade,
    upper.panel=panel.pie, text.panel=panel.txt,
    main="A Corrgram (or Horse) of a Different Color")
```
Plot them and decide for yourself.


## Figure 11.18

This set of figures demonstrates a way to
plot several figures by splitting the "Plot"
pane into eight sections on a 2x4 grid.

This set of figures also plots examples of several
options for the argument ```"type"```
in the ```plot()``` and ```lines()``` functions

```R
# Create the two series.
x <- c(1:5)
y <- c(1:5)
# Split the "Plot" pane into a 2x4 grid.
par(mfrow=c(2,4))
# Generate a list of type options for the plots.
types <- c("p", "l", "o", "b", "c", "s", "S", "h")
for (i in types){
    plottitle <- paste("type=", i)
    plot(x,y,type=i, col="red", lwd=2, cex=1, main=plottitle)
}
```
<img src="Images/line_type_options.png" width="500"/>


## Mosaic Plots

This final figure plots the fates of passengers on the
cruise ship Titanic.
It plots the proportion of passengers who survived
among the sex, age and the different classes of passengers.

```R
ftable(Titanic)
library(vcd)
mosaic(Titanic, shade=TRUE, legend=TRUE)
```
<img src="Images/mosaic_plot.png" width="700"/>

A tragic ending for some but an impressive
set of plotting options for us.

