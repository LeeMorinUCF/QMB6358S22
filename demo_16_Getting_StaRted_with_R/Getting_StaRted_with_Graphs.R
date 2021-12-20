
########################################################
#
# QMB 6358: Software for Business Analytics
# Getting StaRted with Graphs in R
#
# Lealand Morin, Ph.D.
# Assistant Professor
# Department of Economics
# College of Business
# University of Central Florida
#
# December 20, 2021
#
########################################################
#
# Sample code from scripts to accompany
# R in Action, by Robert I. Kabacoff.
# https://www.manning.com/books/r-in-action
#
########################################################


#-----------------------------------------------------#
# R in Action: Chapter 3                              #
# requires that the Hmisc package has been installed  #
# install.packages('Hmisc')                           #
#-----------------------------------------------------#

# The variable par stores parameter for displaying graphics.

# One parameter specifies a pause after each graph
par(ask = TRUE)


# --Section 3.1--

# Attach a dataset from a library with
# examples of data about cars.
attach(mtcars)

# Now plot the weight and miles per gallon.
plot(wt, mpg)

# Using the lm() function, you can estimate a linear model,
# i.e. a linear regression model.
# Placing the call to lm() in abline appends the
# estimated regression line through the observations.


abline(lm(mpg ~ wt))
# Notice that abline() appended a line to the existing plot,
# after the plot object was created by plot().

# You can add other deatures to an open plot,
# including titles and legends.
title("Regression of MPG on Weight")

# When you no longer need the data, you can detach the dataset.
detach(mtcars)


# --Section 3.2--

# Create some data and plot them.

dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)
plot(dose, drugA, type = "b")

# You can specify the type of plot as points ('p', the default),
# line ('l') or both ('b').


# --Section 3.3--


# You can also specify parameters for the type of line (lty)
# and the symbol used for the points.

plot(dose, drugA, type = "b", lty = 2, pch = 17)

# The lwd argument changes the line width
# and the cex argument changes the size of the points.
plot(dose, drugA, type = "b", lty = 3, lwd = 3, pch = 15,
     cex = 2)



# To plot several series, you can use a sequence of colors
# specified by the rainbow() function.
n <- 10
mycolors <- rainbow(n)
pie(rep(1, n), labels = mycolors, col = mycolors)

# For documents in black and white, use the grey scale.
mygrays <- gray(0:n/n)
pie(rep(1, n), labels = mygrays, col = mygrays)


# Listing 3.1 - Using graphical parameters to control
# graph appearance

# You can also set global graphical parameters with the par() function.

# Create some data.
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)

# First, store the existing parameter settings.
opar <- par(no.readonly = TRUE)
# We will reinstate them later.

# Customize the settings.
par(pin = c(2, 3))
par(lwd = 2, cex = 1.5)
par(cex.axis = 0.75, font.axis = 3)
# Now these settings are the defaults for the next plots.

plot(dose, drugA, type = "b", pch = 19, lty = 2, col = "red")
# If you get an error or warning message,
# try resizing the "Plot" window in the bottom right
# by dragging the edges of the window.


plot(dose, drugB, type = "b", pch = 23, lty = 6, col = "blue",
    bg = "green")

# Revert back to the default parameter settings we had earlier.
par(opar)


# --Section 3.4--


# You can add labels on the axes, a title
# and set the ranges in the x and y directions.
plot(dose, drugA, type = "b", col = "red", lty = 2,
    pch = 2, lwd = 2, main = "Clinical Trials for Drug A",
    sub = "This is hypothetical data",
    xlab = "Dosage", ylab = "Drug Response", xlim = c(0, 60),
    ylim = c(0, 70))


# Listing 3.2 - An Example of Custom Axes

# Create an example with multiple relationships
# to plot together.
x <- c(1:10)
y <- x
z <- 10/x

# As above, store and change the parameter settings.
opar <- par(no.readonly = TRUE)
par(mar = c(5, 4, 4, 8) + 0.1)

# Now create an example with multiple plots
# and customized axis labels.
plot(x, y, type = "b", pch = 21, col = "red", yaxt = "n",
    lty = 3, ann = FALSE)
lines(x, z, type = "b", pch = 22, col = "blue", lty = 2)
axis(2, at = x, labels = x, col.axis = "red", las = 2)
axis(4, at = z, labels = round(z, digits = 2), col.axis = "blue",
    las = 2, cex.axis = 0.7, tck = -0.01)
mtext("y=1/x", side = 4, line = 3, cex.lab = 1, las = 2,
    col = "blue")
title("An Example of Creative Axes", xlab = "X values",
    ylab = "Y=X")

# It helps to run the above commands one at a time to
# see what each command adds to the plot.

# Reset the graphical parameters.
par(opar)


# Listing 3.3 - Comparing Drug A and Drug B response by dose

# Reconsider our clinical data.
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)

# Store and set the graphical parameters.
opar <- par(no.readonly = TRUE)
par(lwd = 2, cex = 1.5, font.lab = 2)

# Now plot the effectiveness of the two drugs
# and add a line to show a threshold with a dotted line.
plot(dose, drugA, type = "b", pch = 15, lty = 1, col = "red",
    ylim = c(0, 60), main = "Drug A vs. Drug B", xlab = "Drug Dosage",
    ylab = "Drug Response")
lines(dose, drugB, type = "b", pch = 17, lty = 2,
    col = "blue")
abline(h = c(30), lwd = 1.5, lty = 2, col = "grey")
# Again, you might need to resize the "Plot" window.
# Click the "Zoom" button to display
# the plot in a separate window.


# Now reset the default graphical parameters.
par(opar)


# --Section 3.4.5--

# You can also label points with text.

attach(mtcars)
plot(wt, mpg, main = "Milage vs. Car Weight", xlab = "Weight",
    ylab = "Mileage", pch = 18, col = "blue")
text(wt, mpg, row.names(mtcars), cex = 0.6, pos = 4,
    col = "red")
detach(mtcars)
# It is a good habit to remove datsets with detach()
# after you are finished with them.


# You can add the text in a variety of font families
opar <- par(no.readonly = TRUE)
par(cex = 1.5)
plot(1:7, 1:7, type = "n")
text(3, 3, "Example of default text")
text(4, 4, family = "mono", "Example of mono-spaced text")
text(5, 5, family = "serif", "Example of serif text")
par(opar)


# --Section 3.5--

# So far, we have considered one plot at a time,
# you can place multiple plots in rows or columns.

# Figure 3.14

# Since this figure is too large to display in the plot window,
# I will save it to a directory.
setwd('C:path/to/my/chosen/directory')
# Then the png() function will save the plot in
# a chosen file name.

attach(mtcars)
opar <- par(no.readonly = TRUE)

# Look for the image file in your chosen directory.
png('tiled_plot.png')
par(mfrow = c(2, 2))
plot(wt, mpg, main = "Scatterplot of wt vs. mpg")
plot(wt, disp, main = "Scatterplot of wt vs disp")
hist(wt, main = "Histogram of wt")
boxplot(wt, main = "Boxplot of wt")
# The dev.off() function redirects plots to the window
# and closes the png file.
dev.off()

# Reset the parameters.
par(opar)
detach(mtcars)


# Figure 3.15

# You can choose different dimensions
# for the pattern of the plots.
# This example plots three histograms
# arranged along rows in a single column.

attach(mtcars)
opar <- par(no.readonly = TRUE)

png('column_plot.png')
par(mfrow = c(3, 1))
hist(wt)
hist(mpg)
hist(disp)
dev.off()

par(opar)
detach(mtcars)

# Figure 3.16

# The plots do not always have to be the same size.
# The layout() command maps the first plot to the first two
# spaces in the first row of plots.

attach(mtcars)
png('layout_plot.png')

layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE))
hist(wt)
hist(mpg)
hist(disp)
dev.off()

detach(mtcars)




# Figure 3.17

# The relative sizes of plots can be specified separately.

attach(mtcars)

png('layout_plot_resized.png')
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE),
    widths = c(3, 1), heights = c(1, 2))
hist(wt)
hist(mpg)
hist(disp)
dev.off()

detach(mtcars)



# Listing 3.4 - Fine placement of figures in a graph

opar <- par(no.readonly = TRUE)

png('fine_placement_plot.png')
par(fig = c(0, 0.8, 0, 0.8))
plot(mtcars$wt, mtcars$mpg, xlab = "Miles Per Gallon",
    ylab = "Car Weight")
par(fig = c(0, 0.8, 0.55, 1), new = TRUE)
boxplot(mtcars$wt, horizontal = TRUE, axes = FALSE)
par(fig = c(0.65, 1, 0, 0.8), new = TRUE)
boxplot(mtcars$mpg, axes = FALSE)
mtext("Enhanced Scatterplot", side = 3, outer = TRUE,
    line = -3)
dev.off()

par(opar)

# That's a lot of graphs to get you StaRted with graphs in R.

