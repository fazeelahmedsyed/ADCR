#This file is for practice of Chapter 2

#Reading file using ReadLines
filepath <- "http://www.r-datacollection.com/materials/html/fortunes.html"
fortunes <- readLines(filepath)
fortunes 

#ReadLines is inefficient as it is indifferent between different tags of html
#Parsing file using DOM-style Parser will result in the programming environment understanding tags
#libxml2 is a DOM-style parser contained in the package XML.

#Using XML to parse html
library(XML)
parsed_fortunes <- htmlParse(filepath)
print(parsed_fortunes) #xmllib2 completes any missing code from html tags

#A html can be read more efficiently by the use of handlers. 
#Handlers are code functions that read html using C language and convert it into R.
#We can define a handler to XML functions to read the html in a specific way. 

#Creating a list of handler functions. Using only one handler that would not read <body> tag and all its children
h1 <- list("body" = function(x){NULL})

#Reading html using handler
parsed_fortunes2 <- htmlTreeParse(filepath, handlers = h1, asTree = TRUE) #asTree=F returns result of the handler functions, asTree=T returns the rest of the html excluding the result of handler functions
parsed_fortunes2 #Results are in a list form
parsed_fortunes2$children #provides the code we need

#Functions that can be used while creating handlers
a <- c("startElement()","text()","comment()","cdata()","processingInstruction()","namespace()","entity()")
b <- c("XML element","Text node","Comment node","<CDATA> node","Processing instruction","XML namespace","Entity reference") 
d <- c("Used to define a function for all nodes","text()","comment()","cdata()","processingInstruction()","namespace()","entity()")
Handler_func <- data.frame(a,b,d)
colnames(Handler_func) <- c("Function","Name", "Usage")
rm(list = c("a","b", "d"))
Handler_func

#Defining a handler that reads everything but <div> & <title> elements and comments.
h2 <- list( 
        startElement = function(node, ...){
                name <- xmlName(node)
                if (name %in% c("div","title")){NULL}
                else {node}
        },
        comment = function(node){NULL}
        )# Here the list contains two handlers. One that applies on all html tags/nodes and one that applies only on comments.

#Using h2 to parse our html.
parsed_fortunes3 <- htmlTreeParse(filepath, handlers = h2, asTree = T)
parsed_fortunes3$children

#Creating a handler function that directly extracts all italicized text from the html and saves it in a R object
getItalics <- function(){
        i_container <- character()                              #Creates an empty container for our results
        list(i = function(node,...){                            #Defining the list of handler functions now. Our first function is for tags <i> as suggested by "i ="
                i_container <<- c(i_container, xmlValue(node))  #A super Assignment operator <<- is used because i_container does not exist in the list function. <<- allows the assigner to read from its parent environment(or the environment above it)
                }, returnI = function(){i_container})           #Simple function that returns our container
        }

h3 <- getItalics()

#Using h3 to read from our html
htmlTreeParse(filepath, handlers = h3)

#reading results
h3$returnI()                                                    #Alternatively we could have also saved our results in another object while reading and then call upon its subset. But since h3's return function does not call upon any value from the html, we can directly read its value from the list of functions, by running it individually. hence, h3$returnI()

#Further helpful web sources are the following.

#A complete list of tags with description and example: http://www.w3schools.com/tags
#A long list of special characters, symbols, and their entity representation: http://www.w3schools.com/charsets/ref_html_8859.asp
#A much much longer list of characters and their entity representation:http://unicode-table.com
#An HTML validator:http://validator.w3.org

