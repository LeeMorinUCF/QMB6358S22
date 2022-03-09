# -*- coding: utf-8 -*-
"""
Created on Thu Mar  3 12:20:02 2022

@author: david
"""

# Here we learn how to scrape tables in html format from a webpage
# using Pandas read_html(). 

# We'll direct the tables to dataframes, and after doing so we'll
# see that some work is often times needed to get the contents of 
# a table into a format such that we can perform arithmetic operations.

# For example, we may need to strip some of the contents of strings
# (e.g., '$' and '-') and strings will need to be converted to integers
# or floats.

# Below, we obtain the current contents of one of the Florida Lottery
# scratch-off games. It will be directed to a dataframe and then cleaned-up.
# We'll then calculate the unconditional mean/expected value of a ticket
# and the current conditional mean/expected value of a ticket. We'll also
# calculate the unconditional and conditional variance (and standard deviation).

import numpy as np
import pandas as pd

# First, we find the location of the information we want to scrape and then
# create a string identifying the location (URL). In the case below we are
# obtaining information on the scratch-off game '$500 Madness'.

url_1 = "https://www.flalottery.com/scratch-offsGameDetails?gameNumber=1454"


# Next, scrape the contents using Panda's read_html()

page_contents_1 = pd.read_html(url_1)

# Open what was just created so you see what we'll be working with.

# The page only contains a single table, so we can direct it to a
# dataframe if we specify the table number, remembering Python's 
# indexing structure.

df = page_contents_1[0]

# Let's save this so that we don't need to re-scrape after we work
# with it. We'll then re-open it.

df.to_csv('D:/ucf_classes/eco_5445_spring_2022/data/game_1.csv')
game_1 = pd.read_csv('D:/ucf_classes/eco_5445_spring_2022/data/game_1.csv', delimiter=',', usecols=[1,2,3,4,5] )


# Ok, that was simple! But, we need to do a bit of work to get
# the dataframe in shape. Note:
# 1. Each of the variable names includes 2 words and a space is between
#    the words. Let's replace the spaces with underscores.
# 2. The contents of some of the variables are strings and include
#    non-numeric characters (e.g., '$' and '1-in-'). We need to strip
#    these characters and then convert the variables into numeric types.

# First, we replace the spaces with underscores in some variable names
 
game_1.columns = [c.replace(' ', '_') for c in game_1.columns]

# Second, we strip the '$' from one of the variables and replace the contents
# of another variable. See what happens if you use 'lstrip' instead of .replace().

for i in range(len(game_1.Prize_Amount)):
    game_1.Prize_Amount[i] = game_1.Prize_Amount[i].lstrip("$")
    game_1.Prize_Amount[i] = game_1.Prize_Amount[i].replace(',','' )
    game_1.Odds_of_Winning[i] = game_1.Odds_of_Winning[i].replace('1-in-','')
    game_1.Odds_of_Winning[i] = game_1.Odds_of_Winning[i].replace(',','' )

# Third, we convert the variables with string contents to numeric values.

game_1.Prize_Amount = pd.to_numeric(game_1.Prize_Amount, errors='raise', downcast=None)
game_1.Odds_of_Winning = pd.to_numeric(game_1.Odds_of_Winning, errors='raise', downcast=None)

# If you open the dataframe, you see that everything is in good shape.

# Ok, let's calculate the unconditional mean/expected value. By unconditional mean,
# we mean the mean before any tickets have been purchased and thus before anyone has
# lost or won.  Once tickets are purchased, there are losers and winners and the total
# number of tickets available declines. Thus, the mean value of a ticket changes.
# The conditional mean references the mean given the number of remaining tickets, some
# of which are 'losers' and some of which are 'winners'

# We could calculate the mean in one line, but let's spread the calculation out over
# a few for clarity.

# First, let's calculate the unconditional probability associated with each prize amount
# and the probability of losing an amount equal to the price.

game_1['Uncond_Prob'] = 1/game_1.Odds_of_Winning

lose_prob = 1 - sum(game_1.Uncond_Prob)

# Let's specify the the price

game_1['Price'] = game_1.Prize_Amount[len(game_1) - 1]

# Next, weight each outcome (prize amount) by the unconditional probability
# and sum over the outcomes.  Below the mean is calculated two ways.

game_1['Uncond_Mean'] = sum((game_1.Prize_Amount - game_1.Price)*game_1.Uncond_Prob) - lose_prob*game_1.Price
game_1['Uncond_Mean_2'] = sum(game_1.Prize_Amount*game_1.Uncond_Prob) - game_1.Price

np.mean(game_1.Uncond_Mean)
np.mean(game_1.Uncond_Mean_2)

# The unconditional mean is about -$2.51. So, instead of the game being called
# '$500 Madness' it might instead be called '$500 Sadness'

# Next the unconditional variance. It is equal to the sum of probability-weighted
# squared deviations. The standard deviation is the square root of this.

game_1['Uncond_Var'] = sum(((game_1.Prize_Amount - game_1.Uncond_Mean)**2)*game_1.Uncond_Prob)

game_1['Uncond_Std'] = np.sqrt(game_1.Uncond_Var)

game_1.Uncond_Std[0]



# Ok, next let's calculate the conditional mean/expected value and variance.
# Note that it will be an estimate because we must estimate the total number
# of remaining tickets in order to construct the conditional probabilities.

# How should we do so?  Well, a first simple approach will be to use what we know
# about the number of remaining $10 prizes as prizes of this amount are the most
# likely prize to be realized. There is good reason to believe therefore that the
# unconditional and conditional probability of winning $10 will be about the same.

# Let's use the number of remaining $10 prizes together with the unconditional
# probability of winning $10 to estimate the total number of remaining tickets

# There are 7141301 remaining $10 prizes. The probability of winning $10
# (or breaking even) is 1 in 10 or 0.10. Therefore an estimate of the number of
# remaining tickets is the reciprocal of the unconditional probability times the
# number of remaining $10 prizes or 10*7141301.

game_1['Tickets_Remaining'] = (1/game_1.Uncond_Prob[len(game_1) - 1])*game_1.Prizes_Remaining[len(game_1) - 1]  


# As we know the number of remaining prizes for all other prize levels greater than
# $10, we can estimate the conditional probabilities and thus the conditional mean.

game_1['Cond_Prob'] = game_1.Prizes_Remaining/game_1.Tickets_Remaining


cond_lose_prob = 1 - sum(game_1.Cond_Prob)

game_1['Cond_Mean'] = sum((game_1.Prize_Amount - game_1.Price)*game_1.Cond_Prob) - cond_lose_prob*game_1.Price
game_1['Cond_Mean_2'] = sum(game_1.Prize_Amount*game_1.Cond_Prob) - game_1.Price

np.mean(game_1.Cond_Mean)
np.mean(game_1.Cond_Mean_2)


# Next the conditional variance. It is equal to the sum of probability-weighted
# squared deviations. The standard deviation is the square root of this.

game_1['Cond_Var'] = sum(((game_1.Prize_Amount - game_1.Cond_Mean)**2)*game_1.Cond_Prob)

game_1['Cond_Std'] = np.sqrt(game_1.Cond_Var)

game_1.Cond_Std[0]


# Has the expected value increased or decreased as time has passed and
# the numbers of winning and losing tickets sold have accumulated?
# Let's take a look at the unconditional and conditional means.

np.mean(game_1.Uncond_Mean)
np.mean(game_1.Uncond_Mean_2)

np.mean(game_1.Cond_Mean)
np.mean(game_1.Cond_Mean_2)

coef_of_variation = game_1.Cond_Std[0]/abs(game_1.Cond_Mean[0])
coef_of_variation 

# What can the differences be attributed to? 

# We can compare the unconditional and conditional probabilities to
# determine which are larger (smaller). A simple way to do so is to
# open the dataframe and 'eyeball' the probabilities. We can also plot
# plot the conditionals against the unconditionals.

import matplotlib.pyplot as plt

plt.scatter(game_1.Cond_Prob, game_1.Uncond_Prob, color='blue', s = 5)

# Note that by design, the unconditional and conditional probabilities
# of breaking even (i.e., winning an amount equal to the ticket price)
# are the same, so let's exclude these probabilities from the plot

plt.scatter(game_1.Cond_Prob, game_1.Uncond_Prob, color='blue', s = 5)
plt.xlim(-0.001,0.01)
plt.ylim(-0.001,0.01)

plt.hist(game_1.Uncond_Prob, color='blue', bins=300, range = (0,0.01))
plt.hist(game_1.Cond_Prob, color='blue',  bins=300,range = (0,0.01))


# So, we see very little difference between the unconditional and conditional
# probabilities for this particular game. Thus, the unconditional and conditional
# means differ by very little.

# Suppose you are going to spend $10 on one of the $10 scratch-off games. Should you
# purchase this particular one? If you are an expected value maximizer then the answer
# is 'perhaps'.  You would want to repeat the process above across $10 games to determine
# which has the highest (least negative) expected value.  But, what if two or more $10 games
# happen to have the same conditional expected value.  What should you do?  That is, what
# additional information might you take into account before you make a choice?

