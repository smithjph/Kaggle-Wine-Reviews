library(wordcloud)
library(tidyverse)
library(tm)
library(SnowballC)
library(RColorBrewer)

md = read_csv("winemag-data-130k-v2.csv")

md1 = md[100001:129971,]

docs = Corpus(VectorSource(md1$description))

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("wine", "flavors","aromas","palate",
                                    "drink","notes","now","nose","fruit",
                                    "finish","tannins","acidity")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 15)

# top15md1 = head(d,15)  # obs      1 - 30000
# top15md2 = head(d,15)  # obs  30001 - 60000
# top15md3 = head(d,15)  # obs  60001 - 100000
top15md4 = head(d,15)  # obs 100001 - 129971





