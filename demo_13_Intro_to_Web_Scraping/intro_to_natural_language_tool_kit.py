# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 12:20:27 2021

Revised March 2022

@author: David
"""

# Here we introduce the Natural Language Toolkit for natural language
# processing with Python. The coverage follows from the companion book
# Natural Language Processing With Python (NLPP) by Steven Bird, Ewan Klein,
# and Edward Loper. The toolkit webpage is located at www.nltk.org 

# Version 3.7 can be installed from: https://pypi.org/project/nltk/

# Once installed the toolkit is installed, import it. 

import nltk

# Next, download the text datasets used in the NLPP text
# If the following is executed, all contents can be downloaded
# and installed through the NLTK Downloader.

nltk.download()

# The 9 text datasets are named text1, text2, etc.  
# Once downloaded, the datasets can be accessed using:
from nltk.book import *

# Note what appears in the variable explorer

# To see what is text associated with each dataset, simply type its name(s): 

text1, text2, text3, text4, text5, text6, text7, text8, text9

# Let's start by searching through some text for a particular word
# Text can be searched through a variety of ways. For example, it could
# be read, and the number of occurrences of the word then documented.

# A 'concordance view' of the text identifies every time the word appears
# plus some additional (before and after word) content.

# Let's find the term 'monstrous' in Herman Melvilles' book Moby Dick.

text1.concordance("monstrous")

# Note the function is not case sensitive, as both capital and lower
# case occurrences of monstrous are identified.

# A natural question is whether we can extend this to search for a phrase. The
# answer at this stage is no. For example, consider one of the resulting occurrences
# from the above search, say the first or last one.  Execute the following:

text1.concordance("monstrous size")    

# Ok, so what about just part of a word.. Execute the following:

text1.concordance("monst") 

# Another question is whether we can direct the search results to an object
# Execute the following:
    
x = text1.concordance("monstrous")
x
print(x)

# Ok, the original search and a search in text2 

text1.concordance("monstrous")

text2.concordance("monstrous")

# To find lists of words that appear in a similar context as 'monstrous'
# we can use the method similar(). A couple of examples:

text1.similar("monstrous")

text2.similar("monstrous")

# This is not especially useful. Alternatively, the method 
# common_contexts([list]) produces lists of words that share
# the same surrounding words. A couple of examples:

text1.concordance("monstrous")

text1.concordance("true", lines=50)
    
text1.common_contexts(["monstrous", "true"])


text2.concordance("monstrous")

text2.concordance("very")
    
text2.common_contexts(["monstrous", "very"])

# Note that 'monstrous pictures' is in the first concordance
# and 'True Pictures' is in the second concordance

# Note also that the above examples used only 2 words, but any
# number of words (greater than 1), can be used

# Dispersion plots are used to identify the location of a word in
# a corpus. The method is dispersion_plot([list]) 

# Note that NumPy and Matplotlib packages should be imported

text1.dispersion_plot(["monstrous", "true"])

# Question: We know that 'monstrous' appears 11 times, but why do we
# not see 11 bars? Perhaps it appeared in sentences that were very close
# together, so given the 250,000 word count in the corpus what appears to
# be a single bar is actually 2 that are really close together.

text2.dispersion_plot(["monstrous", "very"])


# We've seen how to display word occurrences. Let's next see various ways
# to count word occurrences. Some of the functions we are already familiar with

# To determine the length of a corpus with respect to the number of words and
# punctation symbols (i.e., tokens), we can use the function len()

len(text1)

# To determine the number of unique vocabulary items of a corpus, we use
# the function set()

set(text1)

# Whoa!  What is produced does not appear to be in any particular order
# (e.g., alphabetical, then numberical, etc.). If ordering is of interest,
# then we can wrap the sort() function around set().

sorted(set(text1)) 

# Note that we can wrap len() around set() to count the number of unique
# occurences of words (and punctation)

len(set(text1))

# So, although the corpus has 260,819 tokens, it has 19,317 unique 'word types';
# however, as this includes punctation, it will simply be referred to as 'types'

# Question: What is the percentage of distinct types relative to the number of
# total types? Alternatively, how many times on average is a type used?

percent = len(set(text1))/len(text1) 


# Let's next consider specific words. To count the occurrences of a given word
# in a corpus, use the method count()

text1.count("monstrous")

# Recall:

text1.concordance("monstrous")
    
# Note the discrepancy! What is the explanation?

# Suppose we want to repeat this word counting over a number corpora.
# It would be inefficient to copy, paste, and then modify our code for
# each corpus.  It would be more efficient to define a function whose
# argument is a given corpus and which returns the desired output
# (e.g., a count or percent)

# A couple of examples:

def unique_types(text):
    return len(set(text))

unique_types(text1)

def word_count(text, word):
    return text.count(word)

word_count(text1, "monstrous")
    

# Ok, recall Python's indexing structure and slicing from some of our
# earlier coverage. We can use this in order to extract text from specific
# positions within a corpus.

# Some examples:

text1[0]

text1[1]    

text1[124]

# So, the 125th token is 'the'. But, what is the first occurrence of 'the'?

text1.index("the")

# Here, we slice the first 125 tokens
text1[0:125]

# Or simply..

text1[:125]

# Ok, let's proceed to basics of statistics with natural language!



