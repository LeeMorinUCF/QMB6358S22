# -*- coding: utf-8 -*-
"""
Created on Fri Aug  6 09:39:14 2021

Modified March 2022

@author: David
"""

# In this program we see methods used for building text classifiers.
# As with models for predicting continuous or discrete quantitative
# variables (e.g., home prices or the number of customers in a day)
# or qualitative variables (e.g., approval of a credit card application),
# we will undertake model training and testing to identify features associated
# with a superior text classifier.

# Also, as before, our methods will be 'supervised'.  In this setting the training
# data contains the correct class label and features to predict the class label.

# Note: The NPR Science Friday segment on August 6, 2021 provides nice coverage
# of the use of text classification methods, their limitations and benefits.
# Be certain to listen to it: https://www.sciencefriday.com/segments/imperfect-data/

import nltk
import nltk.corpus
from nltk.book import *
from nltk.tokenize import word_tokenize
from nltk.text import Text
from nltk.corpus import PlaintextCorpusReader
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('names')

# A first case we will consider is the classification of reported gender by name.
# The NLTK 'Names' corpus contains the first names of 7,944 self-reported female 
# and male individuals.

names = nltk.corpus.names
names.words()
names.fileids()

# We see the female and male names are stored separately.

# Let's direct the names to separate objects

names_male = names.words('male.txt')
names_male

names_female = names.words('female.txt')
names_female


# Can we identify names that appear in both files, and names that are in
# one file but not the other? That is, female names that are not in the
# male file and male names that are not in the female file? Sure!

# Let's do so a couple of ways: using loops with conditions and using
# a basic comparison function introduced in our first Python program.

# The names that appear in both files:

x = [i for i in names_male if i in names_female]

# The names that only appear in the male file

y = [i for i in names_male if i not in names_female]

# The names that only appear in the female file

z = [i for i in names_female if i not in names_male]



# Alternatively, we can use the intersection function introduced in the
# very first Python program.  Remember?!
 
m = set(names_male)
f = set(names_female)

# The names that appear in both files:

x1 = set(m.intersection(f))

# The names that only appear in the male file

y1 = sorted(m - set(m.intersection(f)))

# The names that only appear in the female file

z1 = sorted(f - set(m.intersection(f)))


# A claim: Names that end in 'a' are almost always associated with individuals
# who self-report as females. Do our samples provide evidence supporting the claim?

# How should we proceed? A simple starting point is to evaluate the frequency and
# cumulative frequency distributions of the final letters in female and male names.


# To use FreqDist() as we did before, we need to convert each name list into
# a single string and then tokenize it. It can then be included in FreqDist

# A string is first created 

male_string = " "

# the .join method is then used and the original string name is used

male_string = male_string.join(names_male)

# The following may also works, in this case with converting the list
# of female name strings into a single string:
    
female_string = " ".join(map(str, names_female))


# The strings are converted to tokens and nltk.text objects are created

tokenized_male = word_tokenize(male_string)
male = Text(tokenized_male)

tokenized_female = word_tokenize(female_string)
female = Text(tokenized_female)

# The desired letters can then be extracted. In the cases below
# the last letter in each first name is obtained.

female_last_letter = [i[-1] for i in female]
male_last_letter = [i[-1] for i in male]

female_first_letter = [i[0] for i in female]
male_first_letter = [i[0] for i in male]

female_first_last = [i[0] + i[-1] for i in female]
male_first_last = [i[0] + i[-1] for i in male]


# We're now set to see whether or not the claim is consistent
# with our sample of names.

freq_dist = FreqDist(female_last_letter)
freq_dist.most_common()
freq_dist.plot()
freq_dist.plot(cumulative=True)


# What conclusions might be made with respect to male names?

freq_dist = FreqDist(male_last_letter)
freq_dist.most_common()
freq_dist.plot()
freq_dist.plot(cumulative=True)

# Below is an alternative view of the frequency distribution
# with both female and male in a single plot

freq_dist = nltk.ConditionalFreqDist((fileid, name[-1])
                                     for fileid in names.fileids()
                                     for name in names.words(fileid))
freq_dist.plot()

# Modify the above code in order to plot the distributions of all
# first letters and all first letter/last letter pairs.



# Ok, let's proceed by working to build a classifier to identify
# an individual's self-reported gender.  We'll begin by classifying
# based upon the final letter in an individual's first name.

# Below we define a function to extract the desired feature (last letter)
# and store it in a dictionary. Note that we have defined the dictionary's
# key and value ("last letter" and last letter).

def features(name):
    return {"last letter": name[-1]}

# Note the output of the function when called:

features("David")

# Also, as we did above, we can extract the first, last, etc. letters

# Next, we specify the cases of interest (our 7944 names) and create
# class labels (female and male)

names_labeled = ([(name, "female") for name in names.words("female.txt")] +
                 [(name, "male") for name in names.words("male.txt")])

# Take a look at the list that was just created. Note the use of parentheses
# above results in the tuples that we see in the list. Will a list also work?

# Since the building of the classifier entails the training/testing process
# that we are familiar with, we next randomize the data. To ensure replicability,
# we also set the sampling seed

import random
random.seed(123)
random.shuffle(names_labeled)

# The features() function defined above is next used to extract 

feature_sets = [[features(i), gender] for (i, gender) in names_labeled]

# Take a look...

# Next, the training and test sets are created. Below, the 7944 observations
# are split into training and test sets of 6000 and 1944 observations, respectively.

train_set = feature_sets[:6000]
test_set = feature_sets[6000:]

# For this example we will use the Naive Bayes Classifier method. The source code for
# this is located here: https://www.nltk.org/_modules/nltk/classify/naivebayes.html

nb_classifier = nltk.NaiveBayesClassifier.train(train_set)

# The classifier was created and confronted with the training set. Names can then be provided
# to the classifier. A nonsense example (since this name is known not to be in the training set):

nb_classifier.classify(features(["Abcdefg"]))

# Here, we extract the dictionary component of test_set. Before doing so, note that the elements
# in features_set, train_set, and test_set are comprised of a dictionary and a string.  If we 
# open the test_set in the variable explorer and then click on a row, we see that the dictionary
# component is located in position 0.  So, we extract the dictionary component as follows:

test_set2 = [i[0] for i in test_set]

# The list of dictionaries can then be included as input to .classify().
# Note what works and what does not work:
 
nb_classifier.classify(test_set2)

nb_classifier.classify(test_set2[1])


# A loop is written to classify each name in the test set according to
# the final letter in the name 

pred_gender = {}
for i in range(len(test_set2)):
    pred_gender[i] = nb_classifier.classify(test_set2[i])


# Let's extract predicted gender from the dictionary and compare
# the results to self-reported gender appearing in the test set
# The accuracy of the classifier will also be calculated.

# The predicted genders

preds = list(pred_gender.values())

# The self-reported genders

actuals = [i[1] for i in test_set]

# A loop is written that assigns a 1 for a correct classification
# and a 0 for an incorrect classification

comparison = list(range(len(preds)))
for i in range(len(preds)):
    if preds[i] == actuals[i]:
        comparison[i] = 1
    else:
        comparison[i] = 0

# View 'comparison' to see the correct and incorrect classifications

comparison

# The accuracy of the classifier:
    
accuracy = sum(comparison)/len(preds)
round(accuracy, 10)

# Cool! So, the simple NB classifier with a single feature (last letter)
# correctly classifies about 76% of the names that were not used in building
# the classifier (i.e., which were used for estimation). 

# Now that we have evaulated the model by hard-coding the routine needed
# to determine the out-of-sample (test) accuracy, let's use the 'canned'
# accuracy routine in ntlk.classify()

round(nltk.classify.accuracy(nb_classifier, test_set), 10)

# Cool**2!

# We can proceed by printing the confusion matrix and calculating
# other classifier performance metrics.

# Can we build a classifier that outperforms the simple one?
# What features might you define in working to do so?
# Can overfitting occur? Explain how and how you would identify overfitting.

# For you: build a NB classifier that uses the:
# 1) first and last letters
# 2) last letter and name length
# 3) first letter and name length
# 4) first and last letters and name length
# The above code is simple to modify for 1-4.

# Something we should do is take a look at the mis-classified names.
# We may see some aspects of individual names that we have not accounted
# for and which may lead to increased classifier accuracy if treated as features.

# Below we identify and print the mis-classified names.

# Remember that names_labeled was randomized.

names_train = names_labeled[:6000]
names_test = names_labeled[6000:]

mis_classed = []
for (name, tag) in names_test:
    error = nb_classifier.classify(features(name))
    if error != tag:
        mis_classed.append((tag, error, name))

for (tag, error, name) in sorted(mis_classed):
    print("true class={:<10} pred class={:<10s} names={:<33}".format(tag, error, name))

# From a cursory review of the female names, note that many that are mis-classified 
# have a final letter of 'n', yet we saw earlier that male names were more likely to
# end in an 'n' than female names. Note also the many of the final letter pairs include
# 'yn', 'in', 'is', 'ss', etc..

# Considering this, including the final letter pairs as a feature may lead to an
# improvement in classifier performance.  For you: Investigate this issue.


# Below the first of the 4 (first and last letters) is coded

def features_extended(name):
    return {"first letter": name[0], "last letter": name[-1]}

features_extended("David")

names_labeled = ([(name, "female") for name in names.words("female.txt")] +
                 [(name, "male") for name in names.words("male.txt")])

random.seed(123)
random.shuffle(names_labeled)

feature_sets_2 = [[features_extended(i), gender] for (i, gender) in names_labeled]

# Take a look...

train_set_2 = feature_sets_2[:6000]
test_set_2 = feature_sets_2[6000:]

nb_classifier_2 = nltk.NaiveBayesClassifier.train(train_set_2)

round(nltk.classify.accuracy(nb_classifier_2, test_set_2), 10)



# Below the last of the 4 (first and last letters and names length) is coded

def features_extended(name):
    return {"first letter": name[0], "last letter": name[-1], "length" : len(name)}

features_extended("David")

names_labeled = ([(name, "female") for name in names.words("female.txt")] +
                 [(name, "male") for name in names.words("male.txt")])

random.seed(123)
random.shuffle(names_labeled)

feature_sets_3 = [[features_extended(i), gender] for (i, gender) in names_labeled]

# Take a look...

train_set_3 = feature_sets_3[:6000]
test_set_3 = feature_sets_3[6000:]

nb_classifier_3 = nltk.NaiveBayesClassifier.train(train_set_3)

round(nltk.classify.accuracy(nb_classifier_3, test_set_3), 10)



# Shall we consider a second classification problem or have you had enough?
# Next, we work through the case of building and evaluating models to be used to
# classify documents (versus names). Specifically, we consider the case of movie
# reviews, which entail collections of words, which may be positive or negative
# in nature with respect to the movie reviewed.










