#This is for practicing Chapter 1 Practice

#Loading Libraries
library(stringr)
library(rvest)

#Parsing html page
heritage_parsed <- read_html("http://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger", encoding = "UTF-8")

#Isolating and Cleaning Table of interest
tables <- html_table(heritage_parsed, fill = T)
danger_table <- danger_table <- tables[[2]]
names(danger_table)
danger_table <- danger_table[,c(1,3,4,6,7)]
colnames(danger_table) <- c("name","locn","crit","yins","yend")

str(danger_table)

#Recoding 'crit'
str(danger_table$crit) #The vector contains alot of noise within the responses
danger_table$crit <- ifelse (str_detect(danger_table$crit, "Natural") == T,"nat","cult") #Note: Why isnt simple if working?
danger_table$crit[1:10]

#Converting 'yins' to numeric
class(danger_table$yins)
danger_table$yins <- as.numeric(danger_table$yins) 
class(danger_table$yins)

#Removing noise from 'yend' and converting to prefered format
danger_table$yend[1:10]

yend_clean <- unlist(str_extract_all(danger_table$yend,"[[:digit:]]{4}.$")) #{} indicates repeatition of a particular expression
yend_clean[1:10]

yend_clean <- unlist(str_extract_all(yend_clean,"^[[:digit:]]{4}"))
yend_clean[1:10]

danger_table$yend <- yend_clean
danger_table$yend <- as.numeric(danger_table$yend)

#Cleaning locn 

danger_table$locn[1:3]
