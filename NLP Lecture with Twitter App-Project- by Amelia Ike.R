##Natural Language Processing-Twitter App
install.packages('tm')
install.packages('twitteR')
install.packages('wordcloud')
install.packages('RColorBrewer')
install.packages('e1017')
install.packages('class')

#Activate all Packages
library(e1o17)
library(class)
##use Keys with the twitteR library:
getTwitterOAuth(consumer_key, consumer_secret) #this code is deprecated
help(getTwitterOAuth)

##it has been changed to this code
##setup_twitter_oauth(consumer_key, consumer_secret, access_token=NULL, access_secret=NULL)
consumerKey <- "h5Beo0TMsDdHbTh5dQfqSdIps"
consumerSecret <- "KtiNTOiCcB8av5VHd9Ktz6dc5HPjB9hl1U2UJBceqkDqpGWzqL"
accessToken <- "789458512816381952-ReVb9EvDouHDDlj0QvWJ01eeCiOwVFM"
accessTokenSecret <- "3g6mS5CHR4lt3GNjKAduLAu3js8xeWtx4eykwqjVXBYx1"

#code to get it is below


##EX-1------Regular Expression Review
#Now let's review a few key Regular Expression functions we've touched upon earlier:
##--------grep()

args(grep) #arguments(grep)
#it prints out all arguments in the grep function

grep('A', c('A','B','C','D','A')) #example of what the grep function does

##-----------nchar()
#it checks the length of a string

args(nchar) #checks the arguments in the nchar function
nchar('helloworld') #example of what the nchar() function does

nchar('hello world')#it also counts space

#----------------gsub()
#it perform replacement of the matching patterns

args(gsub) #checks the argument in the gsub() function
gsub('pattern','replacement','hello have you seen the pattern here?')#example of what the gsub() function does

##Text Manipulation
##----------------paste()
#concatenate several strings together

print(paste('A','B','C',sep='...')) #what the paste() function does
help(paste)

#-----------------substr()
##it returns the substring in the given character range start:stop for the given

substr('abcdefg',start=2,stop = 5) #what the substr() function does

#------------------strsplit()
##it splits a string into a list of substrings based on another string split in x

strsplit('2016-01-23',split='-') #example of what the strsplit() function does

###-------------------------------------------NLP Important Terms and Concepts
#Step 1: Import Libraries
#Activate the needed libraries
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

#Step 2: Search for Topic on Twitter
#We'll use the twitteR library to data mine twitter. First you need to connect by 
#setting up your Authorization keys and tokens.
--------------------------------------------------------------------------------------------------------
##setup_twitter_oauth(consumer_key, consumer_secret, access_token=NULL, access_secret=NULL)
#Using this code give you : "Using browser based authentication" and a 403 error"
#WHILE using the code below gives you: ""Using direct authentication"
--------------------------------------------------------------------------------------------------------
key <- setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)#Setting up all keys

#We will search twitter for the term 'soccer'
soccer.tweets <- searchTwitter("soccer", n=2000, lang="en") #search and get 2000 tweets with the word soccer
View(soccer.tweets)
soccer.text <- sapply(soccer.tweets, function(x) x$getText()) #For those 2000 tweets get the texts that contain the word soccer
View(soccer.text)

#Step 3: Clean Text Data
#We'll remove emoticons and create a corpus
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII') # remove emoticons
soccer.corpus <- Corpus(VectorSource(soccer.text)) # create a corpus
head(soccer.corpus)
View(soccer.corpus)

#Step 4: Create a Document Term Matrix
##We'll apply some transformations using the TermDocumentMatrix Function

term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
                                     control = list(removePunctuation = TRUE,
                                                    stopwords = c("soccer","http", stopwords("english")),
                                                    removeNumbers = TRUE,tolower = TRUE)) #we are removing punctuations, stopwords and Numbers


#Step 5: Check out Matrix
head(term.doc.matrix)
term.doc.matrix <- as.matrix(term.doc.matrix) ##Converting it to a matrix
View(term.doc.matrix)

#Step 6: Get Word Counts
word.freqs <- sort(rowSums(term.doc.matrix), decreasing=TRUE) #listing out the number of times each word appear and 
View(word.freqs)
word.freqs #in a descending order

dm <- data.frame(word=names(word.freqs), freq=word.freqs)#Converting the word.freqs to a dataframe
head(dm) #Name of column word and freq

#Step 7: Create Word Cloud
wordcloud(head(dm$word, 50), head(dm$freq, 50), scale=c(2,1), random.order=FALSE, colors=brewer.pal(8, "Dark2")) #Creating a wordcloud wwith dm
