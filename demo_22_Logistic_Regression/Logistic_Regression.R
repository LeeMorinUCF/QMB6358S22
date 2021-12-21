########################################################
#
# QMB 6358: Software for Business Analytics
# Logistic Regression in R
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

# # Pause on each graph.
# par(ask = TRUE)
#
# # Save current graphical parameters.
# opar <- par(no.readonly = TRUE)

# Set working directory to location of data.
# wd_path <- '/path/to/your/folder'
# Set path to the code base for the course.
git_path <- '~/Teaching/QMB6358_Spring_2022/GitRepo/QMB6358S22/'
# Choose the subfolder for this lecture of the course.
wd_path <- paste(git_path, 'demo_22_Logistic_Regression', sep = '')

setwd(wd_path)



#--------------------------------------------------#
# R in Action: Chapter 13                          #
# requires that the AER, robust, and qcc packages  #
#    have been installed                           #
# install.packages(c('AER', 'robust', 'qcc'))      #
#--------------------------------------------------#

# --Logistic Regression--

# Load a dataset of information about peoples'
# engagement in extramarital affairs,
# anonymously collected, of course.
data(Affairs, package = "AER")


# Always start by investigating the properties of the dataset.
# Calculate the summary statistics.

summary(Affairs)
table(Affairs$affairs)

# Notice that the majority report never
# having such an affair.
# Although, several report numbers as high as 12.

# To indicate faithfulness, create a binary outcome
# variable thast indicates whether a subject has ever had an affair.
Affairs$ynaffair[Affairs$affairs > 0] <- 1
Affairs$ynaffair[Affairs$affairs == 0] <- 0
# Define this as a factor with two levels.
Affairs$ynaffair <- factor(Affairs$ynaffair,
                           levels = c(0, 1),
                           labels = c("No", "Yes"))
table(Affairs$ynaffair)




# Start by fitting the full model,
# with all available variables.
fit.full <- glm(ynaffair ~ gender + age + yearsmarried +
    children + religiousness + education + occupation + rating,
    data = Affairs, family = binomial())
summary(fit.full)

# Notice that severa variables are not statistically significant.
# Consider removing one or more and fitting a reduced model.
# Normally, you would consider a sequence of small changes
# but for this demonstration, we will make one big change
# by dropping several variables.

fit.reduced <- glm(ynaffair ~ age + yearsmarried +
    religiousness + rating, data = Affairs, family = binomial())
summary(fit.reduced)

# Now all remaining variables are statistically significant.

# Compare the two candidate models
# and test for a statistically significant
# improvement in fit for the larger model.
anova(fit.reduced, fit.full, test = "Chisq")

# This jointly tests the exclusion of all the
# variables dropped in the change above.
# The high p-value suggests very little is lost by
# restricting the additional coefficients to zero,
# which is the same as excluding the variables.

# Now that we have settled on a model,
# consider the interpretation of the coefficients.
coef(fit.reduced)
# For a logistic regression,
# the change in estimated probability is
# approximately proportional, so check the exponential
# transformation of the coefficients.
exp(coef(fit.reduced))


# Now analyze the model predictions directly,
# which is a more reliable way to investigate the
# predictions of the model.
# First, generate a dataset of hypothetical values
# for the predictions.
# It includes one row for each level of the
# marital rating variable and
# the average values of the other variables.
testdata <- data.frame(rating = c(1, 2, 3, 4, 5),
    age = mean(Affairs$age), yearsmarried = mean(Affairs$yearsmarried),
    religiousness = mean(Affairs$religiousness))

# Calculate the probability of extramarital affair
# by marital ratings.
testdata$prob <- predict(fit.reduced, newdata = testdata,
    type = "response")
# The "response" type returns the predictions
# in terms of the probability that an affair would occur.
testdata
# For the selected values of the other variables,
# we can see that the probability of an affair
# increases as the marital rating declines.

# Now repeat the calculation for the age variable.
# The prediction dataset has average values of the other variable
# but selected levels of the age variable.
testdata <- data.frame(rating = mean(Affairs$rating),
    age = seq(17, 57, 10), yearsmarried = mean(Affairs$yearsmarried),
    religiousness = mean(Affairs$religiousness))
# Calculate probabilities of extramarital affair by age
testdata$prob <- predict(fit.reduced, newdata = testdata,
    type = "response")
testdata
# The probability of an affair decreases as people age.


# One consideration for a logistic regression model
# is whether the data are more variable than
# the binomial model would suggest.
# This departure could be generated by factors
# such as a changing relationship over time.


# We can evaluate overdispersion
# by considering a richer model called the quasibinomial
# family, just as we did for the exclusion
# of several variables from the original model.
# Take the fit of the logistic (binomial) model.
fit <- glm(ynaffair ~ age + yearsmarried + religiousness +
    rating, family = binomial(), data = Affairs)
# Now obtain the fit of the (quasibinomial) model.
fit.od <- glm(ynaffair ~ age + yearsmarried + religiousness +
    rating, family = quasibinomial(), data = Affairs)

# This statistic should follow the Chi-squared distribution.
od.stat <- summary(fit.od)$dispersion * fit$df.residual
# The p-value of this test is as follows:
pchisq(od.stat, fit$df.residual, lower = F)
# It is not an unusual value with a fairly high p-value.




# --Poisson Regression--

# # Skipped for this course.
#
# # look at dataset
# data(breslow.dat, package = "robust")
# names(breslow.dat)
# summary(breslow.dat[c(6, 7, 8, 10)])
#
# # plot distribution of post-treatment seizure counts
# opar <- par(no.readonly = TRUE)
# par(mfrow = c(1, 2))
# attach(breslow.dat)
# hist(sumY, breaks = 20, xlab = "Seizure Count", main = "Distribution of Seizures")
# boxplot(sumY ~ Trt, xlab = "Treatment", main = "Group Comparisons")
# par(opar)
#
# # fit regression
# fit <- glm(sumY ~ Base + Age + Trt, data = breslow.dat,
#     family = poisson())
# summary(fit)
#
# # interpret model parameters
# coef(fit)
# exp(coef(fit))
#
# # evaluate overdispersion
# library(qcc)
# qcc.overdispersion.test(breslow.dat$sumY, type = "poisson")
#
# # fit model with quasipoisson
# fit.od <- glm(sumY ~ Base + Age + Trt, data = breslow.dat,
#     family = quasipoisson())
# summary(fit.od)
