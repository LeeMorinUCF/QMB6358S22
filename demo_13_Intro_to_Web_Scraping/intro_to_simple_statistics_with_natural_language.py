# -*- coding: utf-8 -*-
"""
Created on Mon Aug  2 11:14:21 2021

Revised March 2022

@author: David
"""

# We now learn som basics of statistics with natural language.

import nltk
from nltk.book import *
nltk.download('punkt')
nltk.download('stopwords')

# Recall the contents of each corpus:
    
text1, text2, text3, text4, text5, text6, text7, text8, text9

# We begin by generating and evaluating frequency distributions
# of 'types' (words and punctation) that comprise a corpus.

# Recall:

len(text1)
len(set(text1))

# Frequency distributions are generated using the function FreqDist(corpus)

freq_dist = FreqDist(text1)
print(freq_dist)

# From the output and from opening freq_dist in the variable explorer, we
# see it has the structure of a dictionary as it has a key and values.

# If we want the 'j' most common types, use the method most_common(j)

freq_dist.most_common(10)

# If we want the count of a given token, use freq_dist[token]

freq_dist["monstrous"]

# Recall the earlier discrepancy and why the output is 10 versus 11

freq_dist["moby"]

# Ok, consider the following:

freq_dist.most_common(50)

# If you review the resulting output, does anything strike you?

# Considering the answer, we can proceed to generate a frequency distribution 
# and cumulative distribution of the words to visually determine the proportion
# of the corpus that is comprised of common words

# To do so, use the plot() function

freq_dist.plot(50)

freq_dist.plot(50, cumulative=True)

# So, a bit less than 50% of the unique words in the text are associated
# with the 50 most frequently occurring types (120,000+/260,819)


# Note that relatively long words may be more informative than short words.
# Let's identify all words that are greater than (or equal to) a desired length

# Recall from our earlier coverage:

set(text1)
len(set(text1))

# Let's direct the above output to a set object

unique_words = set(text1)

# Below, 2 'for' looping approaches are used to generate
# lists that contain the desired output


# Approach 1
# First, a list is created from the set named 'unique_words'

long = list(unique_words)

# Second, a dictionary is created to store the results

long_words_1 = {}

# Lastly, the loop

for i in range(len(long)):
    if len(long[i]) > 15:
        long_words_1[i] = long[i]
sorted(list(long_words_1.values()))


# Note that we can do this a bit more efficiently if we recognize
# that FreqDist can be treated like a dictionary with key-value pairs;
# the keys are the 'words' and the values are the 'frequencies'

long_words_1 = {}
x = FreqDist(text1)

word = list(x.keys())
count = list(x.values())

for i in range(len(word)):
    if len(word[i]) > 15:
            long_words_1[i] = word[i]
sorted(list(long_words_1.values()))


# Approach 2

long_words_2 = [i for i in unique_words if len(i)>15]
sorted(long_words_2)

# Note that the aboving sorting can be wrapped around the 'for' loop:

sorted([i for i in unique_words if len(i)>15])

# Or

sorted(i for i in unique_words if len(i)>15)



# Are the resulting words informative for characterizing the corpus (book)?
# These long words are likely 'hapaxes'; that is, they only appear a single
# time (out of 250,000 or so words).

# It might be more informative to identify long words that occur frequently.
# Doing so would exclude frequently occurring short words and infrequently
# occuring long words.

# Let's identify all words that are longer than 'j' characterers and which
# occur more than 'k' times.

# As before, the 'for' loop will be executed 2 ways for validation

# Approach 1

long_words_1 = {}

x = FreqDist(text1)
word = list(x.keys())
count = list(x.values())

for i in range(len(word)):
    if len(word[i]) > 10 and count[i] > 10:
            long_words_1[i] = word[i]
sorted(list(long_words_1.values()))


# Approach 2

sorted(i for i in set(text1) if len(i)>10 and freq_dist[i]>10)


# Next, we consider 'bigrams' and 'collactions'
# A bigram is a collection of word pairs
# A collocation is a set of word pairs that occur with high frequency

# As a simple example example, consider the following sentence:
# Guy likes pie and Sandy likes candy.

# For Python the sentence is written: 
sentence = """Guy likes pie and Sandy likes candy."""

# Now, we can tokenize the sentence.  We can do so 2 ways:

# The first uses the function .split(): 
sentence = sentence.split()

# The second uses the NLTK function 'word_tokenize()':
from nltk.tokenize import word_tokenize

sentence = """Guy likes pie and Sandy likes candy."""

# Or

sentence = 'Guy likes pie and Sandy likes candy.'


sentence = word_tokenize(sentence)
    
list(bigrams(sentence))

list(bigrams(text1))


# Ok, now let's return to the corpus we've been working with
# to evaluate the collactions with it.

text1.collocations()

# From the resulting output we see the default is the top 20 collacations

# Let's pick another and evaluate another text for comparison, say
# Monte Python's Holy Grail. Expect "Run away!" to be a collocation ;)

text6.collocations(10)


# We saw above how to evaluate the frequency and cumulative frequency
# distribution of words in a corpus.  Let's next consider the distribution
# of word lengths, again using the 'FreqDist' function.

# Let's start by seeing what is used as the input/argument to FreqDist

y = [len(i) for i in text1]

# As expected, the list is of size 260,819

freq_dist_2 = FreqDist(y)

print(freq_dist_2)


# So, we see that there are 19 different word lengths amongst the
# 260,819 types (words and punctation)

# Remember that the output of FreqDist is stored in a dictionary format:

freq_dist_2

word_length = list(freq_dist_2.keys())
word_length

length_count = list(freq_dist_2.values())
length_count

# Let's use some of the functions incuded with FreqDist
# to evaluate the distribution of word lenghts

freq_dist_2.most_common()

# The resulting output is consistent with what we saw above
# in line 222 when we took a look at the freq_dist_2 'dictionary'

# Next, characteristics of the maximum are evaluated

freq_dist_2.max()

freq_dist_2[3]

# From the above, we see that the notation references a key in the
# dictionary and that the respective value is printed

freq_dist_2.freq(3)

# So, about 19% of the types in the corpus (50223/260819)
# are 3 characters in length

# Interestingly, perhaps, there is not a minimum nor average function.
# Can you code the average word length?

# The tabular (versus graphical) version of the frequency distribution

freq_dist_2.tabulate()

# The plots of the frequency and cumulative frequency distributions

freq_dist_2.plot()

freq_dist_2.plot(cumulative=True)


# Let's wind this down by considering some word comparison
# functions that will be useful. These will be used as conditions
# in iterating/looping over words to evaluate if the conditions on
# the words are met or not

# First, let's evaluate whether or not each word begins with a
# given letter and obtain a list that is sorted alphabetically

sorted(i for i in set(text6) if i.startswith("R"))

# Considering the above, note the case sensitivity of the function
# and that we are not limited to evaluating a single character

# How can we work around the case sensitivity issue? Modify the code:   

sorted(i for i in set(text6) if i.startswith("R") or i.startswith("r"))

# The i.endswith() method evaluates an ending condition

sorted(i for i in set(text6) if i.endswith("ay"))

# The two can be used together:
  
sorted(i for i in set(text6) if i.startswith("ru") and i.endswith("ng"))
 

# Other comparison methods for you to evaluate include:
# .islower(), .isupper(), .isalpha(), .isalnum(), isdigit(), and .istitle()


























