
########################################################
#
# QMB 6358: Software for Business Analytics
# Getting StaRted with R
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
# R in Action: Introduction to R,
# by Robert I. Kabacoff.
# https://www.manning.com/books/r-in-action
#
########################################################


#------------------------------------------------------#
# R in Action: Chapter 1                               #
#------------------------------------------------------#


# Listing 1.1 - A Sample R session

# Before we read in some data from a file,
# define some vectors of variables using the c() function.
# This function concatenates variables into a vector.

age <- c(1, 3, 5, 2, 11, 9, 3, 9, 12, 3)
weight <- c(4.4, 5.3, 7.2, 5.2, 8.5, 7.3, 6, 10.4,
    10.2, 6.1)
# You can end a command on the next line
# as long as the line terminates with an operator
# that indicates an unfinished command.


# Now calculate some statistics with these variables.

# Calculate the mean:
mean(weight)

# Calculate the standard deviation:
sd(weight)

# Calculate the correlation between two variables:
cor(age, weight)

# R comes standard with several tools for
# statistical analysis as well as graphics.

plot(age, weight)
# The default version is a very simple
# black-and-white scattergraph but we will learn how to
# use R for richer data visualization.


# Listing 1.2 - An example of commands used to manage
# the R Workspace.

# Change the next line to assign wd_path a valid directory
# on your computer.

wd_path <- '~/Teaching/QMB6358_Fall_2020/GitRepos/QMB6358F20/demo_05_R_intro'
setwd(wd_path)

# We can use the runif() function to generate
# uniformly distributed random variables.
x <- runif(20)

# The summary() command is the basic function
# for investigating new data.
summary(x)

# The hist() function plots a histogram.
hist(x)

# You can save the history of your commands in a session with
# savehistory()
# and also save the state of your session,
# including all the values of variables in memory, with
# save.image()

# Although useful, this is not recommended
# because the state of your workspace can always
# be recreated with your data and your script.
# You should develop the habit of writing code in a script
# so that it preserves your analysis.



# Listing 1.3 - Working with a new package

# So far, we have seen several built-in functions.
# The full functionality of R is achieved by
# installing packages of functions developed
# by other users in the R community.

# The package vcd is used to Visualizing Categorical Data.
# Install packages with the install.packages() function:
install.packages("vcd")

# The package needs only be installed once,
# unless you want to update the version.
# Once installed, you need to attach the package
# with the library() function.
library(vcd)

# Now, all the functions in the vcd library are available
# to use in your workspace.


# You can obtain a description of the functions available
# in a package.
help(package = "vcd")

# Many packages contain sample datasets to use as examples
# of the functionality.

help(Arthritis)

# Display the dataset (since it is small)
Arthritis


# Find the examples corresponding to the datasets with example()
example(Arthritis)

# You can copy the text for a command that uses this dataset
art <- xtabs(~ Treatment + Improved, data = Arthritis, subset = Sex == "Female")
# Hit <Return> to cycle through the plots.



# Getting Help

# We saw the help function used above.
# It can be used in many ways.
# You can find many resources to get you started with help.
help.start()

# If you know the name of a function, such as ```lm```,
# you can type either
'?'(lm)
# or
help(lm)
# You can also type keywords in the help window in RStudio.





########################################################
# End
########################################################
