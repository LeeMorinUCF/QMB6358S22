########################################################
#
# QMB 6358: Software for Business Analytics
# Basic Statistics
#
# Lealand Morin, Ph.D.
# Assistant Professor
# Department of Economics
# College of Business
# University of Central Florida
#
# December 22, 2021
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

#--------------------------------------------------------------------#
# R in Action: Chapter 7                                             #
# requires that the npmc, ggm, gmodels, vcd, Hmisc,                  #
# pastecs, psych, doBy, and reshape packages have been installed     #
# install.packages(c('npmc', 'ggm', 'gmodels', 'vcd', 'Hmisc',       #
#     'pastecs', 'psych', 'doBy', 'reshape'))                        #
#---------------------------------------------------------------------


# Select some variables in the mtcars dataset.
vars <- c("mpg", "hp", "wt")
# Here, we select them using a vector of strings
# in the column index:
head(mtcars[vars])



# Listing 7.1 - descriptive stats via summary

# The quickest way to inspect an object is with the summary() command.
summary(mtcars[vars])
# It displays the range, the interquartile range, the median and the mean.
# If there were missing values, the summary would show
# an additional column labeled "NA".

# Listing 7.2 - descriptive stats via sapply()

# We might be interested in some other statistics,
# such as the skewness and kurtosis.
# This function performs a task similar to summary().

mystats <- function(x, na.omit = FALSE) {
    if (na.omit)
        x <- x[!is.na(x)]
    m <- mean(x)
    n <- length(x)
    s <- sd(x)
    skew <- sum((x - m)^3/s^3)/n
    kurt <- sum((x - m)^4/s^4)/n - 3
    return(c(n = n, mean = m, stdev = s, skew = skew, kurtosis = kurt))
}

# Now we can use the apply() function to apply this function
# for each column.

sapply(mtcars[vars], mystats)
# Our customized version of the summary shows the
# first four moments.


# Listing 7.3 - Descriptive statistics (Hmisc package)

# Some packages include functions for summarizing data,
# such as the Hmisc package.

library(Hmisc)
describe(mtcars[vars])

# The description contains other information,
# such as the number of missing values or distinct values.


# Listing 7.4 - Descriptive statistics (pastecs package)

# The stat.desc function in the pastecs package
# provides another list of statistics, which include
#confidence intervals for the mean of each variable.
library(pastecs)
stat.desc(mtcars[vars])


# Listing 7.5 - Descriptive statistics (psych package)

# The psych package offers yet another option.
library(psych)
describe(mtcars[vars])
# As you gain experience, you will find that you settle on
# one of the above methods of describing data
# but you have several options for obtaining
# a wide range of summary statistics.


# Listing 7.6 - Descriptive statistics by group with aggregate()

# Some datasets include categorical variables, so you
# might be interested in statistics for subgroups of the data
# with separate values of the categorical data.

# The aggregate() function is a very versatile option,
# which takes the provided function and applies it,
# not to the columns, but to the sets of rows
# corresponding to the levels of the categorical variables.

aggregate(mtcars[vars], by = list(am = mtcars$am), mean)
aggregate(mtcars[vars], by = list(am = mtcars$am), sd)

# For those familiar with SQL queries for interacting with databases,
# this command corresponds to the SELECT command followed by
# a GROUP BY clause.

# This procedure takes your analysis through a different path,
# toward a multivariate model of the data.


# Listing 7.7 - Descriptive statistics by group via by()

# Similarly, the by() function performs a similar aggregation
# with more compact notation.


#--------------------------------------------------
# Problem: function not working
# Function has probably been updated
#--------------------------------------------------

# Testing:
by(mtcars[vars], mtcars$am, mean)
by(mtcars[, vars], mtcars$am, sd)

by(mtcars[vars], list(mtcars$am), mean)
by(data = mtcars['mpg'], INDICES = mtcars$am, FUN = mean)



#--------------------------------------------------

# Online examples:

#importing data and assigning to variable df
df<-iris

#computes the mean for species categories in terms of petal.width
by(df$Petal.Width,list(df$Species),mean)


#importing dataset
df<-ToothGrowth

#passing multiple columns
by(df$len,list(df$supp,df$dose),mean)


#--------------------------------------------------

# Note that the above types are numeric.
class(df$len)
# [1] "numeric"

# This works with numeric types:
by(mtcars$mpg, mtcars$am, mean)
# mtcars$am: 0
# [1] 17
# ---------------------------------------
#     mtcars$am: 1
# [1] 24
# by(mtcars$mpg, mtcars$am, sd)
# mtcars$am: 0
# [1] 3.8
# ---------------------------------------
#     mtcars$am: 1
# [1] 6.2

# You can write your own function to calculate
# the aggregated statistics of your choosing.
dstats <- function(x)(c(mean=mean(x), sd=sd(x)))

by(mtcars[vars], mtcars$am, dstats)
# FAIL with data.frame in data argument.
by(mtcars$mpg, mtcars$am, dstats)
# mtcars$am: 0
# mean   sd
# 17.1  3.8
# ---------------------------------------
#     mtcars$am: 1
# mean   sd
# 24.4  6.2



# Listing 7.8 Summary statistics by group (doBy package)

# Yet another approach is to call the summaryBy() function
# from the doBy package.
# This takes a formula object as the first argument,
# summarizing for each of the variables left of the tilde (~)
# for each level of the variables to the right of the tilde.

library(doBy)
summaryBy(mpg + hp + wt ~ am, data = mtcars, FUN = mystats)



# Listing 7.9 - Summary statistics by group (psych package)

# Another function has been developed by the psychological community.

library(psych)
# describe.by(mtcars[vars], mtcars$am)
describeBy(mtcars[vars], mtcars$am)
# This function, by default, calculates a set of common statistics.



# Listing 1.10 Summary statistics by group (reshape package)

# The cast package requires an intermediate step to put the data
# into a particular form.
# The reshape package contains the melt() function, which
# can provide what is needed.

library(reshape)
# Define a function of your choosing.
dstats <- function(x) (c(n = length(x),
                         mean = mean(x),
                         sd = sd(x)))
# Rearrang the data.
dfm <- melt(mtcars,
            measure.vars = c("mpg", "hp", "wt"),
            id.vars = c("am", "cyl"))
# Print this object to see that it is orgnized to be long instead of wide
# with the first two columns enumerating the combinations
# of the id.vars am and cyl.
# The remaining columns contain the values of the measure.vars
# in c("mpg", "hp", "wt") for each combination of the id.vars.

cast(dfm, am + cyl + variable ~ ., dstats)

# Although the previous options provide a direct route to the
# aggregate statistics, the melt() function produced an intermediate
# dataset that may be useful for other purposes, such a certain graphics packages.


# Section --7.2--

# Let's consider the Arthritis data,
# a clinical study of the effectiveness of Treatments for Arthritis.
library(vcd)
summary(Arthritis)


# One way table

# With the with() function, you can calculate a table

mytable <- with(Arthritis, table(Improved))
mytable

# If you are interested in proportions, rather than counts,
# the prop.table function will convert this table.
# In decimals:
prop.table(mytable)
# In percent:
prop.table(mytable)*100


# Two way table

# If you insert a formula object into the first argument,
# the xtabs function will produce a two-dimensional table
# of counts, for each combination of the variables
# to the right of the tilde.

mytable <- xtabs(~ Treatment+Improved, data=Arthritis)
mytable

# An xtabs object can be used to summarize the data in the table
# in a number of ways.

# Inspect across the first categorical variable:
# The margin.table() function computes the sum of table entries
# along the dimension indicated.
margin.table(mytable, 1)
# The prop.table calculates the table entries as fractions of the
# marginal table in the chosen dimensiuon.
prop.table(mytable, 1)

# Inspect across the second categorical variable:
margin.table(mytable, 2)
prop.table(mytable, 2)

# Consider both dimensions at once.
prop.table(mytable)

# The addmargin function appends the marginal totals
# for the chosen dimension, to display the proportions
# across each individual margin, i.e. in both rows and columns.
# The default simply adds a border with the marginal totals.
addmargins(mytable)
addmargins(prop.table(mytable))
# If you want only the borders on a particular dimension,
# specify the chosen dimension.
addmargins(prop.table(mytable, 1), 2)
addmargins(prop.table(mytable, 2), 1)




# Listing 7.11 - Two-way table using CrossTable

# A more exhaustive option is the table calculated by
# the CrossTable() function in the gmodels package.

library(gmodels)
CrossTable(Arthritis$Treatment, Arthritis$Improved)

# This table calculates an array of statistics
# for each cell in the table.
# The table at the top explains the calculation of the
# proportions in each cell.
# The new row called "Chi-square contribution"
# allows a test of the independence of the factors.
# This is a test for statistical differences between the
# proportions in the columns and rows.
# See the help(CrossTable) for the details.


# Listing 7.12 - Three-way contingency table

# If you use xtabs() to tabulate the observations in a dataframe
# along three categorical variables, it is listed as a set
# of two-dimensional tables in the first two dimensions
# but with a separate table for each value of the
# third categorical variable.

mytable <- xtabs(~ Treatment+Sex+Improved, data=Arthritis)
mytable

# However, the ftable() function cycles through the combinations
# of the first two variables in the rows, and shows the counts
# for along the third dimension in the rows.

ftable(mytable)
# This is called a 'flat' contingency table.

# As with the margin.tables for a two-dimensional table,
# you can still calculate across one dimension at a time,
# except now there is a third dimension.
margin.table(mytable, 1)
margin.table(mytable, 2)
margin.table(mytable, 3)
# You can reduce a three-dimensional table down to a
# two-dimensional table for two chosen variables.
margin.table(mytable, c(1,3))
# Likewise for proportion tables with prop.table(),
# can then be reshaped into a flat contingency table.
ftable(prop.table(mytable, c(1, 2)))


# You can also chain a call to addmargins() before flattening
# the contingency table with ftable().
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))
# Finally, you can convert it into percentages
# simply by multiplying the table by 100,
# since it behaves like a numeric type.
ftable(addmargins(prop.table(mytable, c(1, 2)), 3)) * 100



# Listing 7.13 - Chi-square test of independence

library(vcd)
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
chisq.test(mytable)

# With a p-value so low, it is unlikely that we would obtain
# such a large Chi-squared statistic
# if the variables were truly independent.
# This is evidence against independence of the factors.

mytable <- xtabs(~Improved+Sex, data=Arthritis)
chisq.test(mytable)
# This implements Pearson's chi-squared test
# of the null hypothesis that the joint distribution
# of the cell counts in the 2-dimensional contingency table
# is the product of the row and column marginals.
# In other words, that the factors are independent.


# Fisher's exact test

# R.A. Fisher proposed an *exact* test of the same hypothesis
# that the rows and columns in a contingency table are independent.
# It is exact in the sense that the t-statistic is an exact test statistic:
# the t-distribution holds for small samples, not only large samples.

mytable <- xtabs(~Treatment+Improved, data=Arthritis)
fisher.test(mytable)

# Again, this provides evidence that the variables are related.
# It suggests that we might consider building a statistical model
# to study the relationship further.

# Chochran-Mantel-Haenszel test

# The mantelhaen.test() in the base statistics package
# performs a Cochran-Mantel-Haenszel chi-squared test
# of the null that two nominal variables are conditionally
# independent in each stratum,
# assuming that there is no three-way interaction.

mytable <- xtabs(~Treatment+Improved+Sex, data=Arthritis)
mantelhaen.test(mytable)

# Again, such a high statistic, and corresponding low p-value
# provides evidence that the variables are related.

# Since R is a statistical programming language
# an enormous array of statistics are available to
# test for independence of categorical variables.
# Usually the tests will lead to similar conclusions
# but each test has type 1 and type 2 errors
# associated with it, so they may disagree.


# Listing 7.14 - Measures of association for a two-way table

# The assocstats() function in the vcdpackage
# computes the Pearson chi-Squared test,
# the Likelihood Ratio chi-Squared test,
# the phi coefficient, the contingency coefficient
# and Cramer's V for possibly stratified contingency tables.
# See help(assocstats) for references to the relevant statistical
# literature.

library(vcd)
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
assocstats(mytable)


# Listing 7.15 - converting a table into a flat file via table2flat

# We used ftable above to convert a higher-dimensional
# table to a flat table.
# The following function definition performs a similar task
# but table2flat() is a more informative name.

table2flat <- function(mytable) {
    df <- as.data.frame(mytable)
    rows <- dim(df)[1]
    cols <- dim(df)[2]
    x <- NULL
    for (i in 1:rows) {
        for (j in 1:df$Freq[i]) {
            row <- df[i, c(1:(cols - 1))]
            x <- rbind(x, row)
        }
    }
    row.names(x) <- c(1:dim(x)[1])
    return(x)
}

# Test it out on a two-dimensional example.
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
table2flat(mytable)

# Try it with a three-dimensional table.
mytable <- xtabs(~ Treatment+Sex+Improved, data=Arthritis)
table2flat(mytable)

# A look at the results reveals that the table2flat()
# function performs the inverse of the xtabs operation.
# This is a good way to recover a dataset from
# a contingency in a published article.


# Listing 7.16 - Using table2flat with published data

# Generate an example, so we know how it is created.
treatment <- rep(c("Placebo", "Treated"), 3)
improved <- rep(c("None", "Some", "Marked"), each = 2)
# Freq <- c(29, 13, 7, 7, 7, 21)
Freq <- c(5, 13, 7, 7, 21, 6)

# Generate the table.
mytable <- as.data.frame(cbind(treatment, improved, Freq))
mytable

# Now convert it into a dataset.
mydata <- table2flat(mytable)
# Notice the pattern at the top and bottom of the created
# dataset:
head(mydata, 10)
tail(mydata, 10)
# The first 5 rows show the combination Placebo and None,
# moving to the next, Treated and None, in the sixth row and beyond.
# Similarly, the last 6 rows represent the combination
# Treated and Marked.

# The dataset mydata has one row for each count of the
# combinations of treatment and improved in the Freq column.
nrow(mydata) == sum(Freq)



# Listing 7.17 - Covariances and correlations

# Another method of analyzing the association between variables
# is the covariance and correlation between variables.
# With more than two variables, the functions cov() and cor()
# create a matrix of the covariance or correlation
# coefficient for each pair of variables in te dataset.

# For an example, draw 6 variables from the states dataset.
states <- state.x77[, 1:6]

# The cov() function calculates the covariance matrix.
cov(states)
# The cor() function calculates the correlation matrix,
# which normalizes each element by the standard deviations
# of the corresponding pair of variables.
cor(states)

# There exist several method os calculation of the correlation
# coefficient, so it allows an argument to select the calculation method.
cor(states, method="spearman")

# Perhaps the entire matrix is not needed.
# In that case, you can pass different sets of variables
# and cor() will calculate only the correlations
# from pairs with the first variable drawn from the first data frame
# and the second drawn from the second data frame.

x <- states[, c("Population", "Income", "Illiteracy", "HS Grad")]
y <- states[, c("Life Exp", "Murder")]
cor(x, y)


# The pcor() function in the ggm package calculates the
# partial correlation of population and murder rate, controlling
# for income, illiteracy rate, and HS graduation rate

library(ggm)
pcor(c(1, 5, 2, 3, 6), cov(states))

# Read the help for this function, possibly several times:
# The first two elements c(1,5) indicate that
# the partial correlation is taken on the first and fifth
# columns in states, which some may find confusing.



# Listing 7.18 - Testing correlations for significance

# Whatever the measure of correlation between variables,
# it is important to determine the statistical significance
# of any relationship before further modeling.
# The cor.test() tests for correlation between two variables.

cor.test(states[, 3], states[, 5])
# The low p-value provides evidence that
# the true correlation is not equal to zero.


# Listing 7.19 - Correlation matrix and tests of significance via corr.test

# The corr.test() (note the two r's)
# tests for correlation between two variables.
# This outputs two matrices:
# the first is the correlation matrix;
# the second is the matrix in which each element
# is the p-value of a test that the corresponding
# correlation coefficient is zero.

library(psych)
corr.test(states, use = "complete")
# The p-values near zero provide evidence that the
# corresponding correlation coefficient is not zero.




# --Section 7.4--

# Independent t-test

# The t.test() function is a simple t-test
# of the difference in means between two variables.

library(MASS)
t.test(Prob ~ So, data=UScrime)
# This provides evidence that the mean of group 0
# is less than the mean in group 1.

# The above test ignores dependence between the two variables.

# Dependent t-test

library(MASS)
# Calculate the means ad standard deviations of each variable.
sapply(UScrime[c("U1", "U2")], function(x) (c(mean = mean(x),
    sd = sd(x))))

# Now calculate the test of differences.
# The paired argument considers that the
# observations of each variable follow the same index.
with(UScrime, t.test(U1, U2, paired = TRUE))




# --Section 7.5--

# The above tests are termed "parameteric tests"
# because they depend on calculating parameters,
# such as the mean and standard deviation
# of the distributions of each variable.
# The following sets of tests are nonparametric
# tests which, as the name implies, do not depend
# on parameters that are moments of the distributions.

# Wilcoxon two group comparison...



# Also called the Mann-Whitney test,
# the Wilcoxon rank sum

with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data=UScrime)


sapply(UScrime[c("U1", "U2")], median)
with(UScrime, wilcox.test(U1, U2, paired = TRUE))



# Kruskal Wallis test

states <- as.data.frame(cbind(state.region, state.x77))
kruskal.test(Illiteracy ~ state.region, data=states)



# Listing 7.20 - Nonparametric multiple comparisons

# Create a sample dataset and drop the unnecessary columns.
class <- state.region
var <- state.x77[, c("Illiteracy")]
mydata <- as.data.frame(cbind(class, var))
rm(class,var)



library(npmc)
summary(npmc(mydata), type = "BF")
aggregate(mydata, by = list(mydata$class), median)



########################################################
# End
########################################################
