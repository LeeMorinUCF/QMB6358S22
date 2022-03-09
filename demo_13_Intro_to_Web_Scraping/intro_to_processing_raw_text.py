# -*- coding: utf-8 -*-
"""
Created on Wed Aug  4 11:58:00 2021

Modified March 2022

@author: David
"""

# In this program we see how to write code to read text from local files
# and from the internet. We'll then see how to split files/documents into
# distincts word types (words and punctation) and how to produce output for
# further analysis and save it in a file.

import nltk
import nltk.corpus
from nltk.book import text6, bigrams
from nltk.tokenize import word_tokenize
from nltk.text import Text
from nltk.corpus import PlaintextCorpusReader
nltk.download('punkt')
nltk.download('stopwords')


# Before we get going, let's take a look at one of the documents
# we worked with previously. Open the object 'text6' in the explorer

# So, what we're going to do is take a .txt file and get it into a
# similar format.  There are a few steps involved.

# First, read the .txt file from a local drive.

file_1 = open('D:/ucf_classes/eco_5445_spring_2022/abstract_text.txt')

raw_1 = file_1.read()

# We see that 'raw_1' is a string
# Next, it is split into invididual tokens stored in a list

tokenized_1 = word_tokenize(raw_1)

# Lastly, the list it is converted into a nltk.text object.
# Note that a name similar to that of the files in nltk.book is used.

text_1 = Text(tokenized_1)

# Cool! One could then proceed with some desired analysis.

list(bigrams(text_1))

text_1.collocation_list()



# Let's also see how to read files in .pdf format
# To do so, we'll use the module PyPDF2 installed 
# from the Anaconda prompt using: pip install PyPDF4

import PyPDF4

# First, a pdf file object is created

file_2 = open('D:/ucf_classes/eco_5445_spring_2022/abstract_pdf.pdf', 'rb')

# Next, a pdf reader object is created

pdf_reader = PyPDF4.PdfFileReader(file_2)

# The number of pages in the pdf file

print(pdf_reader.numPages)

# A page object is created that includes the first page

page_obj = pdf_reader.getPage(0)

# The page is printed, perhaps..

print(page_obj.extractText())

# Note: Unlike with the .txt files, we see no output.  Although PDF files
# are easy for us to read and print, they may be difficult for software to
# parse into text as we see here. 


# Let's try another pdf file. It is an article published in the
# Journal of Statistical Software

file_3 = open('D:/ucf_classes/eco_5445_spring_2022/Text Mining Infrastructure in R.pdf', 'rb')

pdf_reader = PyPDF4.PdfFileReader(file_3)

print(pdf_reader.numPages)

page_obj = pdf_reader.getPage(0)

print(page_obj.extractText())

# In this case, we see the contents of the first page, but unlike that from 
# the .txt files, it is messy.  With this in mind, converting a document 
# (e.g., a Word file) into .txt format versus .pdf format may be preferred.


# Next, let's see how to do deal with documents obtained from the internet.

# Note that these could be text (ascii) files contained at a web repository
# or they could be text embedded within a webpage in HTML format.

# We begin with the first of the 2 forms.  We'll work with documents that are
# available through Project Gutenberg, which is a catalog of 25,000+ free online
# texts available through: http://www.gutenberg.org/catalog/  

from urllib import request

# First, a string comprised of the desired URL is generated

url = "http://www.gutenberg.org/files/2554/2554-0.txt"

# It is then included as the input in .urplopen()

url_response = request.urlopen(url)

# The HTTPResponse object is converted into a string object
# that contains a readable version of the document

document = url_response.read().decode('utf8')

type(document)

# If we open 'document' we see that it is an a format similar
# to that of the .txt file we worked with above. So, we can
# tokenize it and convert it to a nltk.text object.

tokenized = word_tokenize(document)

tokenized

text_2 = Text(tokenized)

# Cool!  It is now in the desired, workable format.

text_2[5:24]

list(bigrams(text_2))

text_2.collocations(num=20, window_size=10)

# We can then proceed to address questions of interest
# regarding the contents of the document as we did previously.


# Ok, lastly we consider how to extract text from HTML
# from webpages.

url = "http://news.bbc.co.uk/2/hi/health/2284783.stm"
html = request.urlopen(url).read().decode('utf8')

# We can print all of the HTML content that was download

print(html)

# In order to extract text from HTML the Python library
# BeautifulSoup is used. See www.crummy.com/software/BeautifulSoup/
# From the Anaconda prompt: pip install beautifulsoup4

from bs4 import BeautifulSoup as bs

raw_code = bs(html, 'html.parser').get_text()
raw_code

tokenized = word_tokenize(raw_code)
tokenized

text_3 = Text(tokenized)

# Cool!  It is now in the desired, workable format.

text_3[5:12]

list(bigrams(text_3))

text_3.collocations(num=20)

text_3.concordance('gene')


# In the next program we continue webscraping. However, instead
# of scraping text we will see how to scrape tables. We'll then
# clean-up the data in the tables for an analysis of interest.