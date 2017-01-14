url <- "http://www.r-datacollection.com/materials/ch-3-xml/stocks/technology.xml"
url2 <- "http://www.r-datacollection.com/materials/ch-3-xml/stocks/technology-manip.xml"
parsed_xml <- xmlParse(file = url, validate = T, isURL = T)
parsed_xml <- xmlParse(file = url2, validate = T, isURL = T)

#Performing Parsing on Bond XML
url <- "http://www.r-datacollection.com/materials/ch-3-xml/bond.xml"
bond <- xmlParse(url, isURL = T)
class(bond)

#Performing functions on root node
root <- xmlRoot(bond) #Extracts the root node to an object
xmlName(root) #Displays the name of the root node
xmlSize(root) #Displays the number of children the root node has

#When Parsed docs act as lists
class(bond) #Objects of type XMLInternalDocument cannot be subsetted using normal List subsetting
class(root) #Objects of type XMLInternalElementNode are subsettable, thus we work with the root node

root[[1]] #Returns first child
root[[2]] #Second child
root[1] #Like lists double brackets are recommended to extract the element at that position
root[[1]][[1]] #First element of the first element of the root node

root[["movie"]] #Also subsettable by name
root["movie"] #Returns all children named 'movie'

root[[1]][[1]]
root[[1]][[1]][[1]] #Returns the element entirely atomic, without tags. 

#To parse an XML, subsetting can be used, however it is very cumbersome and mundane. 
#Generally we use XPath query language to parse an XML. 

#A few functions using XML
root[[1]]
xmlValue(root[[1]][[1]]) #Returns the value of a given closed tag/xml element.
xmlSApply(root[[1]],xmlValue) #Returns the value of all elements within the child 1 of root along with their names.

xmlAttrs(node =root[[1]]) #Returns a vector of all attributes in an element/leaf. Both names and value of the attribute (if provided).
xmlSApply(X = root, FUN = xmlAttrs) #Returns attribute names for all the elements/children in root.

xmlGetAttr(node = root[[1]], name = "id") #Returns the value of the attribute defined for the element provided.
xmlSApply(X = root, FUN = xmlGetAttr, name = "id")

movie_df <- xmlToDataFrame(root) #Can only be used for simpler XMLs whereby the end nodes of the XML are not too far from the root node. Ideally, children or grandchildren.
movie_df #actors is blank because actors tag did not have any value in the XML but only had attributes.

movie_list <- xmlToList(root)
movie_list #All values have been extracted into a list. with List names being the element/node names.

url <- ls()
rm(list = url)

#Performing Event based XML Parsing instead of using simple DOM Parsing. 

#Parsing URL
url <- "http://www.r-datacollection.com/materials/ch-3-xml/stocks/technology.xml"
technology <- xmlParse(url)
class(technology)
tech_root <- xmlRoot(technology)
class(tech_root)

#Exploring the structure of elements within the roots
tech_root[[1]]
tech_root[[2]]
xmlSize(tech_root) #Total 660 Children
tech_root[[640]]

#Defining a handler function that could efficiently read only closing value of Apple stocks on every date, as contained in the XML.

Apple_fun <- function(){
                  date_container <- numeric()
                  close_container <- numeric()
                  
                  "Apple" =   function(node,...){
                    date <- xmlValue(xmlChildren(node)[["date"]]) #We are using xmlChildren because we are subsetting within another function.
                    close <- xmlValue(xmlChildren(node)[["close"]])
                    date_container <<- c(date_container,date)
                    close_container <<- c(close_container,close)
                  }
                  container <- function (){
                    data.frame(date = date_container,close = close_container)
                  }
          
                  list(Apple = Apple, getStore = container)
}
h5 <- Apple_fun

Apple_close <- xmlEventParse(url, branches = h5, handlers = list())
