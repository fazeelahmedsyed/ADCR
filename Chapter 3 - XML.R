#This Script is for hte practice of ADCR Chapter 3 XML and JSON. 

#Defining filepaths
url <- "http://www.r-datacollection.com/materials/ch-3-xml/stocks/technology.xml"
url2 <- "http://www.r-datacollection.com/materials/ch-3-xml/stocks/technology-manip.xml"
url3 <- "http://www.r-datacollection.com/materials/ch-3-xml/bond.xml"

#Loading Libraries
library(XML)

#Reading XML
parsed_stocks <- xmlParse(url, validate = T) #Parses the XML and validates it agains the DTD defined

#Reading XML
parsed_stocks2 <- xmlParse(url2, validate = T) #results in an error because DTD is broken

#Parsing the Bond file
bond <- xmlParse(url3)

#Isolating the root node (Top level node) of the XML
bond_root <- xmlRoot(bond) 
xmlName(bond_root)                      #Shows the name of the root node
xmlSize(bond_root)                      #Shows the number of elements in the root node
bond_root[[1]]                          #Objects of type XMLInternalElementNode are indexed exactly like lists (as opposed to objects of type XMLInternalDocument which cant be indexed)
bond_root[["movie"]][[1]][[1]]          #Using Double 
bond_root[[1]][[1]]
bond_root[]
