########################################################
#
# QMB 6358: Software for Business Analytics
# Linear Regression in R
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

# Pause on each graph.
par(ask = TRUE)

# Save current graphical parameters.
opar <- par(no.readonly = TRUE)

# Set working directory to location of data.
# wd_path <- '/path/to/your/folder'
# Set path to the code base for the course.
git_path <- '~/Teaching/QMB6358_Spring_2022/GitRepo/QMB6358S22/'
# Choose the subfolder for this lecture of the course.
wd_path <- paste(git_path, 'demo_20_Linear_Regression', sep = '')

setwd(wd_path)

#------------------------------------------------------------------------#
# R in Action: Chapter 8                                                 #
# requires that the car, gvlma, MASS, leaps packages have been installed #
# install.packages(c('car', 'gvlma', 'MASS', 'leaps'))                   #
#------------------------------------------------------------------------#


# Listing 8.1 - Simple linear regression

# The lm() function is the workhorse of statistical modelling
# in R.
# The syntax requires at least a statement of the dataset
# and a specification of the regression equation.
# Before we move on to loading data we will analyze
# a built-in dataset.
# The dataset called "women" is a record of height and weight
# observations for a sample of women.
summary(women)

# For this dataset, model the womens' weight as a function of height.
fit <- lm(weight ~ height, data = women)
# This creates an object of type "lm" that contains
# a list of statistics related to the regression model.
# Print out the results with the summary() function:
summary(fit)

# In addition to the summary,
# the lm object class is endowed with a set of functions
# relating to the estimated model.
# We can compare the observed weight with the
# fitted values and the residuals--the error of the regression model.

women$weight
fitted(fit)
residuals(fit)
# The fitted values are very close to the observed height
# and the residuals are all within a few pounds of zero.

# Visualize the results with a scatter plot of height by weight.

plot(women$height, women$weight, main = "Women Age 30-39",
    xlab = "Height (in inches)", ylab = "Weight (in pounds)")
# Add the line of best fit.
abline(fit)



# Listing 8.2 - Polynomial regression

# The linear model can be augmented with higher order terms.
# The notation I(variable_name^2) adds a term for the
# squared height in the model.

# Assign the estimates of this model to a new lm object.
fit2 <- lm(weight ~ height + I(height^2), data = women)
summary(fit2)

# This specification adds some curvature to the fitted regression line.
plot(women$height, women$weight, main = "Women Age 30-39",
    xlab = "Height (in inches)", ylab = "Weight (in lbs)")
lines(women$height, fitted(fit2))


# We can plot a scatterplot for this dataset
# using the standard graphics but the car package
# contains other plotting options.
# This figure includes information about the individual variables.

library(car)
scatterplot(weight ~ height, data = women, spread = FALSE,
    lty.smooth = 2, pch = 19, main = "Women Age 30-39", xlab = "Height (inches)",
    ylab = "Weight (lbs.)")



# Listing 8.3 - Examining a bivariate relationship

# Before we consider models with multiple explanatory variables,
# let's consider the pairwise relationships between these variables
# and the dependent variable.

states <- as.data.frame(state.x77[, c("Murder", "Population",
    "Illiteracy", "Income", "Frost")])

# A correlation matrix contains te pairwise correlation
# coefficient between each pair of variables.
cor(states)

# Each number in the correlation matrix corresponds
# to a scattergraph of of each pair of variables.
scatterplotMatrix(states, spread = FALSE, lty.smooth = 2,
    main = "Scatterplot Matrix")


# Listing 8.4 - Multiple linear regression

# After this initial investigation, build a multiple
# linear regression model.
# For this specification, the formula should be specified
# in the following form:
# Y ~ X1 + X2 + ... + Xk

fit <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)

summary(fit)


# Listing 8.5 Multiple linear regression with a significant
# interaction term

# Another specification option when you have multiple variables
# is an interaction term.
# This could be achieved by generating a new variable
# from the product of two variables,
# but since this is a common modelling option
# R has this functionality built in.
# The interaction term is specified as
# variable_1:variable_2 and is equivalent to
# variable_1*variable_2, without generating the product
# manually.

# This sample code builds a model of the gas mileage of cars
# as a function of horsepower, weight and the
# product of horsepower and weight.

fit <- lm(mpg ~ hp + wt + hp:wt, data = mtcars)
summary(fit)

# library(effects)
# plot(effect("hp:wt", fit, list(wt = c(2.2, 3.2, 4.2))),
#     multiline = TRUE)



# --Section 8.3--

fit <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data=states)

# You can inspect the regression results as above.
summary(fit)
# This displays the statistics for the most common
# statistical tests: whether the coefficients are truly zero.

# Sometimes the research question involves a number
# different than zero, such as a break-even point
# or some threshold of interest for a business decision.
# The confint() function can calculate the
# confidence interval and you can use this to quickly
# determine whether the estimates are statistically
# different from the number of interest.
confint(fit)


# Simple regression diagnostics

# Once you estimate a model, it is good practice to
# determine whether the model has characteristics
# that satisfy the assumptions of the classical
# linear regression model.

fit <- lm(weight ~ height, data = women)
# par(mfrow = c(2, 2))
plot(fit)
par(opar)

# Notice a clear increasing pattern in the residuals,
# which suggests a richer model may be necessary.

# Compare this to the regression diagnostics for
# the model with a quadratic term for height.

newfit <- lm(weight ~ height + I(height^2), data = women)
# par(mfrow = c(2, 2))
plot(newfit)
par(opar)

# These residuals are closer to zero but
# a wavy pattern is visible.


# Now compare this to the regression diagnostics for
# the model with a quadratic term for height,
# after removing two potential outliers.

newfit <- lm(weight ~ height + I(height^2), data = women[-c(13, 15),])
# par(mfrow = c(2, 2))
plot(newfit)
par(opar)


# Revisit the model of murder rates as a function of
# the characteristics of each state.
# Calculate the regression diagnostics for this model.

fit <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)
# par(mfrow = c(2, 2))
plot(fit)
par(opar)

# Inspect the series of plots to diagnose the model
# for deviations from the classical assumptions.


# Assessing normality


library(car)
fit <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)
qqPlot(fit, labels = FALSE, simulate = TRUE, main = "Q-Q Plot")

# A plot of the quantiles on the 45 degree line
# indicates that the quantiles are on the same scale as
# a normal distribution, which in turn would suggest that
# the residuals are normally distributed.
# In this case, the confidence bounds include the
# 45 degree line, giving no evidence of a non-normal
# distribution of residuals.


# Listing 8.6 Function for plotting studentized residuals

# For more customized analysis, you can create
# your own function.

residplot <- function(fit, nbreaks=10) {
    z <- rstudent(fit)
    hist(z, breaks=nbreaks, freq=FALSE,
    xlab="Studentized Residual",
    main="Distribution of Errors")
    rug(jitter(z), col="brown")
    curve(dnorm(x, mean=mean(z), sd=sd(z)),
        add=TRUE, col="blue", lwd=2)
    lines(density(z)$x, density(z)$y,
        col="red", lwd=2, lty=2)
    legend("topright",
        legend = c( "Normal Curve", "Kernel Density Curve"),
        lty=1:2, col=c("blue","red"), cex=.7)
}

residplot(fit)

#  Durbin Watson test for Autocorrelated Errors

# The Durbin-Watson statistic is used to test whether
# the errors in the model are serially correlated.

durbinWatsonTest(fit)
# This suggests no serial correlation over the sample:
# This provides little evidence of trends in crime rates
# other than those that are explained by the variables in the model.


# Component + Residual Plots

#

# crPlots(fit, one.page = TRUE, ask = FALSE)
crPlots(fit, ask = FALSE)
# In case of an error message:
# Error in plot.new() : figure margins too large
# You may have to increase the size of the plot window.


# Listing 8.7 - Assessing homoscedasticity

# library(car)

# Another form of diagnostics is to determine whether
# the variance of the residuals is constant.
ncvTest(fit)
# This provides no evidence of heteroscedasticity.

spreadLevelPlot(fit)
# This plot does show a slight deviation of variance
# from a constant line in the fitted values.



# Listing 8.8 - Global test of linear model assumptions

# This tests for all sorts of deviations from
# the classical assumptions in one model.

library(gvlma)
fit <- lm(Murder ~ Population + Illiteracy + Income +
              Frost, data = states)

gvmodel <- gvlma(fit)
summary(gvmodel)
# All tests pass: no evidence against the classical assumptions.


# Library 8.9 - Evaluating multi-collinearity

# If some variables are too closely related
# to each other, it will be difficult to discern the
# explanatory power of those related variables.

# The Variance Inflation Factor
# is a measure of the magnitude of the variance of the
# coefficients compared to what they would be if the
# variables were uncorrelated.
# It is calculated with the formula 1/(1-R-squared),
# where the R-squared measures the fit of a linear regression model
# to predict each variable in turn
# using all other explanatory variables.
vif(fit)

# In this case, none are greater than 2,
# indicating little cause for concern about multicollinearity.
sqrt(vif(fit)) > 2



# --Section 8.4--

# Assessing outliers

# Another consideration is whether some obsevations
# appear very unusual relative to the others.

library(car)
outlierTest(fit)
# Apparently the state of Nevada shows an unusual value.
# You might consider estimating the model
# without Nevada.

# Index plot of hat values
# use the mouse to identify points interactively

hat.plot <- function(fit){
    p <- length(coefficients(fit))
    n <- length(fitted(fit))
    plot(hatvalues(fit), main = "Index Plot of Hat Values")
    abline(h = c(2, 3) * p/n, col = "red", lty = 2)
    identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}

hat.plot(fit)
# Click on the points of interest and when you press "Finish"
# the names of those states will be labeled.


# Cook's D Plot

# This calculates the Cook's distance
# of each observation to determine whether the
# standardized residuals are statistically far from zero.

# This test identifies observations with
# D values > 4/(n-k-1),
# where n is the number of observations,
# k is the number of explanatory variables.

# Calculate the cut-off first.
cutoff <- 4/(nrow(states) - length(fit$coefficients) - 2)
# Now plot the Cook's distance andcompare them to this threshold.
plot(fit, which = 4, cook.levels = cutoff)
abline(h = cutoff, lty = 2, col = "red")
# Alaska, Hawaii and Nevada seem to have unusually large
# residuals.
# Perhaps different dynamics are taking place in those locations.


# Added variable plots

# As with the hat.plot() function above.
# Use the mouse to select points interactively

avPlots(fit, ask = FALSE, onepage = TRUE, id.method = "identify")


# Influence Plot
# Again, use the mouse to identify points interactively

influencePlot(fit, id.method = "identify", main = "Influence Plot",
    sub = "Circle size is proportial to Cook's Distance")


# Listing 8.10 - Box-Cox Transformation to normality

# The Box-Cox transformation estimates a series of models,
# each with the explanatory variable raised to a power.
# It then estimates the power that produces the optimal fit.
# Notable values for the exponent include
# zero (for a logarithmic transformation)
# one half (for a square-root transformation)
# and one (for no transformation).

library(car)
summary(powerTransform(states$Murder))
# This suggests a wide range of acceptable values,
# with evidence against a log transformation
# and no evidence against making no transformation.
# Conclusion: leave the dependent variable as is.



# Box-Tidwell Transformations to Linearity

# In contrast to the Box-Cox transformation,
# the Box-Tidwell transformation applies to the
# explanatory variables.
# It allows for forms of nonlinearity
# that are combined in an additive model:
# a nonlinear function of the explanatory variable
# is included as if it were an explanatory variable
# in a regression model.

library(car)
boxTidwell(Murder ~ Population + Illiteracy, data = states)
# Noe of the variables stand out as candidates for a nonlinear
# transformation.
# Conclusion: keep linear functional form.


# Listing 8.11 - Comparing nested models using the anova function

# A model is nested in another model if it can be specified
# as a special case of the other model.
# For example, if one model can be stated with some
# parameters set to zero in the larger model,
# which could be achieved by removing some variables.

# Estimate two model objects
# and then feed them into the anova() function.
fit1 <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)
fit2 <- lm(Murder ~ Population + Illiteracy, data = states)
anova(fit2, fit1)
# This provides no evidence for the larger model,
# suggesting that the nested model,
# with the restriction, is adequate.



# Listing 8.12 - Comparing models with the Akaike Information Criterion

# Another model-selection technique is achieved by comparing
# information criteria.
# One such criterion is the Akaike Information Criterion
# which applies a linear penalty for the number
# of parameters in the model.

fit1 <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)
fit2 <- lm(Murder ~ Population + Illiteracy, data = states)
AIC(fit1, fit2)





# Listing 8.13 - Backward stepwise selection

# Although many researchers warn against using
# recursive model building procedures,
# many statisticians use them, so it is worth knowing
# how they work and what the risks are.

# Backward selection starts with the full model and sequentially removes
# one variable at a time until removing an additional
# variable would substantially degrade the performance
# of the model.

library(MASS)
fit1 <- lm(Murder ~ Population + Illiteracy + Income +
    Frost, data = states)
stepAIC(fit, direction = "backward")

# The final model includes Population and Illiteracy
# as explanatory variables
# but not Income, which was dropped from the model.



# Listing 8.14 - All subsets regression

# As above, use the mouse to place the legend interactively
# in the second plot, if prompted.

library(leaps)
leaps <- regsubsets(Murder ~ Population + Illiteracy +
    Income + Frost, data = states, nbest = 4)
plot(leaps, scale = "adjr2")
# This plots the adjusted R-squared statistic
# for an array of models with every
# combination of the explanatory variables.
# The results suggest the highest adjusted R-squared
# values for Population and Illiteracy,
# which is consistent with the backward selection above.



library(car)
subsets(leaps, statistic = "cp",
    main = "Cp Plot for All Subsets Regression")
abline(1, 1, lty = 2, col = "red")



# Listing 8.15 - Function for k-fold cross-validated R-square

# # Save this topic for a later demo.
#
# shrinkage <- function(fit, k = 10) {
#     require(bootstrap)
#     # define functions
#     theta.fit <- function(x, y) {
#         lsfit(x, y)
#     }
#     theta.predict <- function(fit, x) {
#         cbind(1, x) %*% fit$coef
#     }
#
#     # matrix of predictors
#     x <- fit$model[, 2:ncol(fit$model)]
#     # vector of predicted values
#     y <- fit$model[, 1]
#
#     results <- crossval(x, y, theta.fit, theta.predict, ngroup = k)
#     r2 <- cor(y, fit$fitted.values)^2
#     r2cv <- cor(y, results$cv.fit)^2
#     cat("Original R-square =", r2, "\n")
#     cat(k, "Fold Cross-Validated R-square =", r2cv, "\n")
#     cat("Change =", r2 - r2cv, "\n")
# }
#
# # using shrinkage()
#
# fit <- lm(Murder ~ Population + Income + Illiteracy +
#     Frost, data = states)
# shrinkage(fit)
#
# fit2 <- lm(Murder ~ Population + Illiteracy, data = states)
# shrinkage(fit2)


#  Calculating standardized regression coefficients

# This calculates the effect of a one-standard-deviation
# change in each variable.

zstates <- as.data.frame(scale(states))
zfit <- lm(Murder ~ Population + Income + Illiteracy +
    Frost, data = zstates)
coef(zfit)

# It suggests Population and Illiteracy
# have the largest effects on the Murder rate.



# Listing 8.16 - relweights() function for calculating relative
# importance of predictors

# # Postponed to tree methods.
#
#
# ########################################################################
# # The relweights function determines the relative importance of each   #
# # independent variable to the dependent variable in an OLS regression. #
# # The code is adapted from an SPSS program generously provided by      #
# # Dr. Johnson.                                                         #
# #                                                                      #
# # See Johnson (2000, Multivariate Behavioral Research, 35, 1-19) for   #
# # an explanation of how the relative weights are derived.              #
# ########################################################################
# relweights <- function(fit, ...) {
#     R <- cor(fit$model)
#     nvar <- ncol(R)
#     rxx <- R[2:nvar, 2:nvar]
#     rxy <- R[2:nvar, 1]
#     svd <- eigen(rxx)
#     evec <- svd$vectors
#     ev <- svd$values
#     delta <- diag(sqrt(ev))
#
#     # correlations between original predictors and new orthogonal variables
#     lambda <- evec %*% delta %*% t(evec)
#     lambdasq <- lambda^2
#
#     # regression coefficients of Y on orthogonal variables
#     beta <- solve(lambda) %*% rxy
#     rsquare <- colSums(beta^2)
#     rawwgt <- lambdasq %*% beta^2
#     import <- (rawwgt/rsquare) * 100
#     lbls <- names(fit$model[2:nvar])
#     rownames(import) <- lbls
#     colnames(import) <- "Weights"
#
#     # plot results
#     barplot(t(import), names.arg = lbls, ylab = "% of R-Square",
#         xlab = "Predictor Variables", main = "Relative Importance of Predictor Variables",
#         sub = paste("R-Square = ", round(rsquare, digits = 3)),
#         ...)
#     return(import)
# }
#
# # using relweights()
#
# fit <- lm(Murder ~ Population + Illiteracy + Income +
#     Frost, data = states)
# relweights(fit, col = "lightgrey")



