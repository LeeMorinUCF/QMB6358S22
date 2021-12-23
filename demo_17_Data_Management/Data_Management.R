
########################################################
#
# QMB 6358: Software for Business Analytics
# Data Management in R
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


# It is a good habit to clear the workspace.
rm(list=ls(all=TRUE))
# This avoids the possibility of confusion
# with variables from previous analysis.


#---------------------------------------------------------#
# R in Action: Chapter 4                                  #
# requires that the reshape and sqldf packages have       #
# been installed                                          #
# install.packages(c('reshape', 'sqldf'))                 #
#---------------------------------------------------------#

# Listing 4.1 - Creating the leadership data frame


# Before the statistical analysis begins,
# much of the work involves manipulating the data
# to transform it to an appropriate form.

# We will begin by creating simple examples of datasets.
# One approach is to load columns of data from different courses,
# one column at a time.
# We replicate this by creating variables in memory and
# assembling them into a data frame with the
# data.frame() function.

manager <- c(1, 2, 3, 4, 5)
date <- c("10/24/08", "10/28/08", "10/1/08", "10/12/08",
    "5/1/09")
gender <- c("M", "F", "F", "M", "F")
age <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)
leadership <- data.frame(manager, date, gender, age,
    q1, q2, q3, q4, q5, stringsAsFactors = FALSE)

# The individual vectors are no longer needed,
# so we can remove them with the rm() function.

rm(manager, date, gender, age, q1, q2, q3, q4, q5)



# Listing 4.2 - Creating new variables

# Often, the data preparation process requires variables
# that are functions of the existing variables.

# Start with a simple data frame.
mydata <- data.frame(x1 = c(2, 2, 6, 4), x2 = c(3,
    4, 2, 8))

# To create new variables, assign values to them with
# the assignment operator <- and by referring to the
# values in the same way one would reference existing variables.

# one approach is to use the following syntax:
mydata$sumx <- mydata$x1 + mydata$x2
# in which the notation data_frame$name_of_column
# represents a vector of values in that column.
# Another form of notation references the new variable
# using the index names or numbers as follows.
mydata[, 'meanx'] <- (mydata$x1 + mydata$x2)/2


# Using an approach that is, in some sense,
# the opposite of what we did to create the leadership
# data frame above, we can attach() the data frame,
# which assigns the individual columns as objects in memory.

attach(mydata)
# We can recreate the above variables.
mydata$sumx <- x1 + x2
mydata$meanx <- (x1 + x2)/2


# When we detach the data frame, the data frame is
# still in memory but the individual variables are not.
detach(mydata)
x1
# Error: object 'x1' not found

# Yet another approach to transform the dataset is
# to use the...transform() function.
mydata <- transform(mydata, sumx = x1 + x2, meanx = (x1 +
    x2)/2)

# In R, as in most other languages, there are many ways
# to achieve the same result.


# --Section 4.3--

# Just as you can refer to subsets of rows of a data frame
# with the element numbers, you can also use logical variables.
# This allows the selection of rows of data based on values of
# the variables.

# WE can use this functionality to alter variables
# in a data frame.
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age > 45 &
    leadership$age <= 75] <- "Middle Aged"

# As with the entire columns created in the example above,
# you can also use the names of variables in square brackets.
leadership[leadership$age <= 45, 'agecat'] <- "Young"

# or more compactly, using the within() function.

leadership <- within(leadership, {
    agecat <- NA
    agecat[age > 75] <- "Elder"
    agecat[age >= 55 & age <= 75] <- "Middle Aged"
    agecat[age < 55] <- "Young"
})

# This syntax is not natural to many programmers
# but it does help you avoid retyping the name
# of the data frame so many times.

# These examples are worth knowing, not necessarily
# so that you would use them all,
# but because you might see different approaches taken by
# coworkers or on display in online help.
# As you become more comfortable with R,
# you will settle into the syntax that you find more comfortable.


# --Section 4.4--

# Another very versatile approach is to
# rename variables with the reshape package.
# As with all packages, the fist time you use it,
# You will have to install the package.

install.packages("reshape")
library(reshape)
rename(leadership, c(manager = "managerID", date = "testDate"))

# This package allows for other operations to alter
# the shape of a data frame, as the name implies.

# Note that this operation returns a new data frame
# but did not alter the original.

# > rename(leadership, c(manager = "managerID", date = "testDate"))
# managerID testDate gender age q1 q2 q3 q4 q5 agecat
# 1         1 10/24/08      M  32  5  4  5  5  5  Young
# 2         2 10/28/08      F  45  3  5  2  5  5  Young
# 3         3  10/1/08      F  25  3  5  5  5  2  Young
# 4         4 10/12/08      M  39  3  3  4 NA NA  Young
# 5         5   5/1/09      F  99  2  2  1  2  1  Elder
# > leadership
# manager     date gender age q1 q2 q3 q4 q5 agecat
# 1       1 10/24/08      M  32  5  4  5  5  5  Young
# 2       2 10/28/08      F  45  3  5  2  5  5  Young
# 3       3  10/1/08      F  25  3  5  5  5  2  Young
# 4       4 10/12/08      M  39  3  3  4 NA NA  Young
# 5       5   5/1/09      F  99  2  2  1  2  1  Elder
# >


# --Section 4.5--

# Sometimes the data are not available.
# R uses the term NA to denote missing data.
# To detect missing data, use the is.na() function.

is.na(leadership[, 6:10])
# It returns a data frame of logical variables.

# In practice, data are missing often,
# you will often need to restate the missing data
# in a form that accurately reflects the data.
# Some databases use other conventions,
# such as a default value for missing observations,
# often because the value must be of a particular type.

# In this example, we recode observations recorded as 99
# to missing for the variable age.
leadership[leadership$age == 99, "age"] <- NA
leadership


# Some forms of analysis are not robust to missing data
# and these observations must e dropped.
# Use na.omit() to delete incomplete observations
newdata <- na.omit(leadership)
newdata


# --Section 4.6--

# R has a format for handling dates.
# A simple way to create a date variable is to
# pass strings of the form 'YYYY-MM-DD' to the
# as.Date() function (note the upper case "D").

mydates <- as.Date(c("2007-06-22", "2004-02-13"))

# The conversion can also be done in an arbitrary format,
# such as 'DD/MM/YYYY'.
# When converting these character values to dates,
# you must add an argument to denote the format.

strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")

# Of course, any variable represented by strings
# can be stored in a variable itself
# and passed directly to the function.
myformat <- "%m/%d/%y"
leadership$date <- as.Date(leadership$date, myformat)



# Useful date functions

# R has functions that store the current date
# down to the second.

Sys.Date()
date()


# With date variables in memory
today <- Sys.Date()
format(today, format = "%B %d %Y")
format(today, format = "%A")


# With date variables in memory, operators such as
# the minus sign permit calculations with dates.

startdate <- as.Date("2004-02-13")
enddate <- as.Date("2009-06-22")
days <- enddate - startdate

# There exists several date functions
# to alter the format to be printed.

today <- Sys.Date()
format(today, format = "%B %d %Y")
dob <- as.Date("1956-10-10")
format(dob, format = "%A")




# --Section 4.7--


# Listing 4.5 - Converting from one data type to another

# Just as we have seen the is.na() function, there exist
# several functions to determine the type of vareiables.
# Each one is written in the "is.name_of_type()" format.

# For example,
a <- c(1, 2, 3)
a
is.numeric(a)
is.vector(a)

# Similarly, functions of the form "as.name_of_type()"
# can be used to change the type of variables.
a <- as.character(a)
a
is.numeric(a)
is.vector(a)
is.character(a)

# Of course, you have to be careful that the argument
# corresponds to a valid value of the target type.




# --Section 4.8--

# Sorting a dataset

# Often the data are not in the order you need.
# The sort command takes care of this.

attach(leadership)
newdata <- leadership[order(age), ]
newdata
detach(leadership)

# You can also sort by multiple variables,
# and a minus sign indicates dereasing order.
attach(leadership)
newdata <- leadership[order(gender, -age), ]
newdata
detach(leadership)


# -- Section 4.10--

# In our introduction, we saw many approaches for
# selecting variables
# You can select by numeric index to select specific row or
# column numbers.
newdata <- leadership[, c(6:10)]

# Using the reference to variable names as strings,
# you can pass these strings through a variable
# that is a vector of strings.
myvars <- c("q1", "q2", "q3", "q4", "q5")
newdata <- leadership[myvars]

# Often, the reason you would do such a thing is
# that the variables have systematic names.
# The paste() function is useful for this.
myvars <- paste("q", 1:5, sep = "")
newdata <- leadership[myvars]


# Dropping variables can be achieved by creating
# logical indicators for the column indices.
# Those with TRUE will be kept and
# those with FALSE will be dropped.

myvars <- names(leadership) %in% c("q3", "q4")
newdata <- leadership[!myvars]

# You can also select
newdata <- leadership[c(-7, -8)]



# You could use the following to delete q1 and q5
# from the newdata copy of the leadership dataset
newdata$q1 <- newdata$q5 <- NULL
# The double assignment operator moves right to left
# and assigns the value NULL to both,
# thus dropping the variables. .
newdata


# Selecting observations

# Listing 4.6 - Selecting Observations

# As above, you can select rows using numeric or logical values.
newdata <- leadership[1:3, ]
newdata <- leadership[c(rep(TRUE, 3), rep(FALSE, 2)), ]

# The which() function finds the numeric index numbers
# from a logical vector.
newdata <- leadership[which(leadership$gender == "M" &
    leadership$age > 30), ]


# By attaching the dataset, you can temporarily
# create those variables in memory and shorten the notation.
attach(leadership)
newdata <- leadership[which(gender == "M" & age > 30), ]
detach(leadership)



# Selecting observations based on dates

# Dates are variables like any other and can be used
# to calculat logical indices to select data.
leadership$date <- as.Date(leadership$date, "%m/%d/%y")
startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-10-31")
newdata <- leadership[leadership$date >= startdate &
    leadership$date <= enddate, ]
# Note that the greater than and less than operators
# operate on dates as they would for numbers:
# earlier dates are lower values.


# For those who like a functional approach,
# the subset() function takes subsets of the data.

newdata <- subset(leadership, age >= 35 | age < 24,
    select = c(q1, q2, q3, q4))
newdata <- subset(leadership, gender == "M" & age >
    25, select = gender:q4)


# --Section 4.11--

# Listing 4.7 - Using SQL statements to manipulate data frames

# Finally, those who know how to use SQL to interact with databases,
# can use this language to select data from data frames
# as if they were tables in a database.
# The sqldf lets you use SQL on data frames.

install.packages("sqldf")
library(sqldf)
newdf <- sqldf("select * from mtcars where carb=1 order by mpg",
    row.names = TRUE)
newdf <- sqldf("select avg(mpg) as avg_mpg, avg(disp) as avg_disp,
    gear from mtcars where cyl in (4, 6) group by gear")

# With all of thispossible, we turn to some intermediate
# data handling methods.

#----------------------------------------------------#
# R in Action: Chapter 5                             #
#----------------------------------------------------#

# Listing 5.1 -  Calculating the mean and
# standard deviation

# We have already seen how to calculate basic statistics
# using built-in functions.

x <- c(1, 2, 3, 4, 5, 6, 7, 8)
mean(x)
sd(x)

# If you know the formula, you can calculate it yourself.
n <- length(x)
meanx <- sum(x)/n
css <- sum((x - meanx)**2)
sdx <- sqrt(css / (n-1))
meanx
sdx


# Listing 5.2 - Generating pseudo-random numbers from
# a uniform distribution

# Sometimes you want to generate random data tfor simulation,
# possibly to test your statistical methods.
# The runif() function draws a variable from the
# uniform distribution.
runif(5)
# If you call it again, you get different numbers.
runif(5)

# However, if you set a seed, the algorithm genrating
# the random variables starts from the same starting point.
set.seed(1234)
runif(5)

# Then the specific sequence of (pseudo-)random numbers is fixed.
set.seed(1234)
runif(5)

# As you might imagine, these numbers cannot truly be random
# if they are reproducible.
# The algorithms generating these values are designed
# so that the values appear random but all numbers
# in the computer are deterministic.



# Listing 5.3 - Generating data from a multivariate
# normal distribution

# The normal distribution is a common distribution
# from which to draw random variables.

# Install and attach the MASS package,
# named after a well-known book on applied statistics in R,
# to draw vectors from the multivariate normal distribution.
library(MASS)
options(digits=3)
set.seed(1234)
# Set the mean vector and covariance matrix.
mean <- c(230.7, 146.7, 3.6)
sigma <- matrix( c(15360.8, 6721.2, -47.1,
                   6721.2, 4700.9, -16.5,
                   -47.1,  -16.5,   0.3), nrow=3, ncol=3)
# Draw the random variables.
mydata <- mvrnorm(500, mean, sigma)
mydata <- as.data.frame(mydata)
names(mydata) <- c("y", "x1", "x2")

# Inspect the matrix by checking the dimension
# (the number of rows and columns:)
dim(mydata)
# and print the first 10 rows with head().
head(mydata, n=10)
# The tail() function works as you might imagine.


# Listing 5.4 - Applying functions to data objects

# R has many built-in functions to perform calculations
# with variables in memory.

# The sqrt() function takes the sqare root.
a <- 5
sqrt(a)
b <- c(1.243, 5.654, 2.99)

# The round() funtion rounds.
round(b)

# These functions often operate element-by-element
# on vector and matrices.
c <- matrix(runif(12), nrow=3)
c
log(c)
mean(c)

# This is much more effricient than using for loops
# on the elements of a matrix.

# Listing 5.5 - Applying a function to the rows
# (columns) of a matrix

# Furthermore, R has a family of built-in functions
# of the form
# apply(name_of_object, dimension_to_operate, name_of_function).

mydata <- matrix(rnorm(30), nrow=6)
mydata
apply(mydata, 1, mean)
apply(mydata, 2, mean)
apply(mydata, 2, mean, trim=.4)

# To many, these functions appear strange but they
# often provide very efficient ways to perform repeated calculations.


# Listing 5.6 - A solution to the learning example

# In the textbook, an example is presented using a
# dataset of student grades called "roster".
# Reproduce the values below.

options(digits=2)

Student <- c("John Davis", "Angela Williams",
             "Bullwinkle Moose", "David Jones",
             "Janice Markhammer", "Cheryl Cushing",
             "Reuven Ytzrhak", "Greg Knox", "Joel England",
             "Mary Rayburn")
Math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522)
Science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86)
English <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18)
roster <- data.frame(Student, Math, Science, English,
                     stringsAsFactors=FALSE)


# We can rescale the values in terms of the number
# of standard deviations from the mean
z <- scale(roster[,2:4])

# Now when we apply the mean to the rows, we see that we have centered the data on zero.
summary(z)

# With this scaled variable, we can calculate an average
# deviation from average for each student, using the apply function.
# Then append it to the data frame as a new variable.
score <- apply(z, 1, mean)
roster <- cbind(roster, score)
# The cbind() function binds two objects with
# the same number of rows by adding additional columns.
# The rbind() function does a similar operation in the
# vertical dimension by creating an object with more rows.


# If you want to sort the students into grade categories,
# the quantile function is useful.
y <- quantile(score, c(.8,.6,.4,.2))
roster$grade[score >= y[1]] <- "A"
roster$grade[score < y[1] & score >= y[2]] <- "B"
roster$grade[score < y[2] & score >= y[3]] <- "C"
roster$grade[score < y[3] & score >= y[4]] <- "D"
roster$grade[score < y[4]] <- "F"

# To separate the names into two variables,
# the strsplit() function splits strings by a
# given character--in this case, the space " ".
name <- strsplit((roster$Student), " ")
lastname <- sapply(name, "[", 2)
firstname <- sapply(name, "[", 1)

# Now bind those new variables
# as new columns of the data frame.
roster <- cbind(firstname,lastname, roster[,-1])
roster <- roster[order(lastname,firstname),]

roster

# Conditional logic and repetition

# In our study of Python, we used for loops and while loops
# to perform repeated calculations.
# Instead of a colon, as in Python, in R
# the code blocks are contained in braces "{}",
# after a logical expression in brackets.

if (3 > 7) {
    print('This statement is FALSE.')
}
if (round(10/10) == 1) {
    print('This statement is TRUE.')
}
for (i in 1:10) {
    print(i^2)
}
for (day in c('Monday', 'Wednesday', 'Friday')) {
    print(day)
}
i <- 0
while(i < 5) {
    print(i)
    i <- i + 2
}

# Aside from the minor differences in syntax,
# your knowledge of Python carries over.

# Listing 5.7 - A switch example

# Another convenient option is the switch function.
# The switch function maps some values of one variable to another.

feelings <- c("sad", "afraid")
for (i in feelings)
    print(
        switch(i,
               happy  = "I am glad you are happy",
               afraid = "There is nothing to fear",
               sad    = "Cheer up",
               angry  = "Calm down now"
        )
    )

# Depending on your preferences, you might find this
# much simpler, if not only easier to type
# than a long chain of if cases.

# Listing 5.8 - mystats(): a user-written function
# for summary statistics

# As with Python, you can create your own functions.
# The def keyword is replace by a function called "function".

mystats <- function(x, parametric=TRUE, print=FALSE) {
    if (parametric) {
        center <- mean(x); spread <- sd(x)
    } else {
        center <- median(x); spread <- mad(x)
    }
    if (print & parametric) {
        cat("Mean=", center, "\n", "SD=", spread, "\n")
    } else if (print & !parametric) {
        cat("Median=", center, "\n", "MAD=", spread, "\n")
    }
    result <- list(center=center, spread=spread)
    return(result)
}


# Calling this function with different inputs
# shows how it works.
set.seed(1234)
x <- rnorm(500)
y <- mystats(x)
y <- mystats(x, parametric=FALSE, print=TRUE)



# A switch function can be placed inside a function.

mydate <- function(type="long") {
    switch(type,
           long =  format(Sys.time(), "%A %B %d %Y"),
           short = format(Sys.time(), "%m-%d-%y"),
           cat(type, "is not a recognized type\n"))
}


# This function prints the date in the desired format,
# as long as it is a valid format.
mydate("long")
mydate("short")
mydate()
mydate("medium")
# When you write functions, you should think about how a user
# might misuse your function and build in appropriate
# error messages to notify the user of any required adjustments.


# Listing 5.9 - Transposing a dataset

# In R, dataset is similar to a matrix,
# so it can be transposed,
# which means to switch the columns and rows.

cars <- mtcars[1:5, 1:4]
cars
t(cars)

# Listing 5.10 - Aggregating data

# You might find that you are not interested in the
# individual observations in a data frame.
# Instead, you might want to *aggregate* the data.
# In this operation, you tabulate the value of
# variables in the data, using a specified function,
# for each combination of values of the variables
# that the aggregation is grouped by.

options(digits=3)
attach(mtcars)
aggdata <-aggregate(mtcars, by=list(cyl,gear),
                    FUN=mean, na.rm=TRUE)
aggdata





