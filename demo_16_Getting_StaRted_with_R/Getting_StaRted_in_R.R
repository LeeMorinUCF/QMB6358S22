
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
# R in Action, by Robert I. Kabacoff.
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


#--------------------------------------------------------#
# R in Action: Chapter 2                                 #
#--------------------------------------------------------#

# Using the c() function, you can create vectors
# with many types of variables.

a <- c(1, 2, 5, 3, 6, -2, 4)
b <- c("one", "two", "three")
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)

# Once a vector exists in memory,
# you can recall any of the elements
# by using vector subscripts

# By the index number:
a[3]
# With a vector of index numbers:
a[c(1, 3, 5)]
# By a sequence of consecutive index numbers
a[2:6]

# It can often be difficult to remember the element number
# you are looking for.
# For some data types, such as matrices and arrays,
# R allows you to name each row and column
# to reference the elements.


# Listing 2.1 - Creating Matrices

# Create a matrix with the matrix() function.
y <- matrix(1:20, nrow = 5, ncol = 4)
y

# You can populate the values and name them in one step.
cells <- c(1, 26, 24, 68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
mymatrix <- matrix(cells, nrow = 2, ncol = 2, byrow = TRUE,
                   dimnames = list(rnames, cnames))
mymatrix

# Now you can call the values by name.
mymatrix['R2', 'C2']

# It may be more convenient to enter the values
# by cycling through columns one row at a time.
mymatrix <- matrix(cells, nrow = 2, ncol = 2, byrow = FALSE,
                   dimnames = list(rnames, cnames))
mymatrix



# Listing 2.2 - Using matrix subscripts

# Define another matrix so that we can easily see the pattern.
x <- matrix(1:10, nrow = 2)
x

# Matrices are two-dimensional objects, so you reference an element
# with two indices or names in square brackets.
x[2, ]
x[, 2]
x[1, 4]
x[1, c(4, 5)]
# Leaving an index blank selects all values in that dimension.


# Listing 2.3 - Creating an array

# You need not stop in two dimensions.
# As in Python, you can store data in higher-dimensional arrays.
dim1 <- c("A1", "A2")
dim2 <- c("B1", "B2", "B3")
dim3 <- c("C1", "C2", "C3", "C4")
z <- array(1:24, c(2, 3, 4), dimnames = list(dim1,
                                             dim2, dim3))
z

# The notation is similar to that for matrices.


# Listing 2.4 - Creating a dataframe

# For tstatistical analysis, the most useful data type
# is a data frame, which can hold several types of data together.

patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
patientdata <- data.frame(patientID, age, diabetes,
                          status)
patientdata

# A data frame contains data organized into columns
# with each column holding a variable of the same type.


# Listing 2.5 - Specifying elements of a dataframe

# As with matrices, you can reference elements
# by name or by number.

patientdata[1:2]
patientdata[c("diabetes", "status")]
patientdata$age



# Listing 2.6 - Using factors

# The data type "factor" is used to store categorical data,
# which often arises in statistical analysis.

patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
diabetes <- factor(diabetes)
status <- factor(status, order = TRUE)
patientdata <- data.frame(patientID, age, diabetes,
                          status)

# Inspect the contents of this data frame.
str(patientdata)
summary(patientdata)



#  Listing 2.7 - Creating a list

# A list is a special type of object that can store
# multiple kinds of data in an unstructured way.

g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow = 5)
k <- c("one", "two", "three")
mylist <- list(title = g, ages = h, j, k)
mylist

# You can inspect the contents with commands similar
# to those for matrices and data frames.

mylist$title
mylist$ages
mylist[4]

# Notice that the last two elements are unnamed
# but are still referenced by number.



########################################################
# End
########################################################
