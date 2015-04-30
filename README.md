# interactmet
BME capstone project; designed to decelop
README for interactive interface with MetDraw
Amir Tabaian

The included software allows any manipulation of the MetDraw map. In terms of file structure the
following should be observed 


Parent:
ui.R #user side of applet 
server.R #server side of applet 
list.R # code to extract data from SVG file
www #folder for to house JavaScript files and svg 

WWW: 
file.svg #file from MetDraw that one wishes to modify 
SVGPan.js #SVGPan library that gives zoom and pan functionality 
#Removed some of the unnecessary functions to better work with this project



To add new visualization methods the following code blocks provide a template below to implement desired changes. 
########################################################################################
On the server side server.R (example for check box):  

 input <- input$checkbox1 
 
 #typically each will have to methods for one action which allows on/off ability 
 #in this example this is observed by 'myCallbackHandler5 & 6" 
                        
    
    
    if(input) { #if checked
      
      for (i in 1:length(input)){ #loop to go through all nodes selected 
        session$sendCustomMessage(type='myCallbackHandler5', input[i]) 
      }
      
    }
    
 
    
    if(!input) { #if unchecked 
      
      for (i in 1:length(input)){
        session$sendCustomMessage(type='myCallbackHandler6', input[i]) 
      }
    }
    
    
    
  })
  
  
 On the user side #ui.R include: 
 
 tags$div(
  HTML("
    <embed id='sv' src='file.svg' width='1875' height='750'> #svg should be held in www folder
      </embed>
")
  ),
 
 tags$script('


Shiny.addCustomMessageHandler("myCallbackHandler4",     
          function(met) { #pass the nodes from the R side of things
          
          var S=document.getElementById("sv") #Id of SVG file 
          var SD=S.getSVGDocument()
          Node=SD.getElementById(met)
          TPP.style.opacity="1"; #hide things on/off with opacity rather than visibility as that cannot be undone  
		
          }
    );

Shiny.addCustomMessageHandler("myCallbackHandler5",     
          function(met) {
      
          var S=document.getElementById("sv")
          var SD=S.getSVGDocument()
          TPP=SD.getElementById(met)
          var eli = TPP.getElementsByTagName("ellipse"); #since the nodes are within a <g> group elements by Tag name is needed
          var eli1 = eli[0] 
          eli1.style.fill="red" #style properties include: fill, stroke, rx, ry (size based on radii) 
            


          }
    );

To modify reaction paths: 

var edges = TPP.getElementsByTagName("path")
     var edges1 = edges[0]
	 edges1.style..... #properties include fill, stroke, and stroke-width
	 
	
	
To modify arrows: 

var arrow = TPP.getElementsByTagName("polygon")
     var arrow1 = arrow[0]
	 edges1.style..... #properties include fill, stroke,
	 
	 
######################################################################################

In terms of generating the data to manipulate in R list.R is provided below

library(shiny)
library(XML)
library(dplyr)
library(reshape2)
library(tidyr)


#getrid of null entries

is.NullOb <- function(x) is.null(x) | all(sapply(x, is.null)) #
rmNullObs <- function(x) {
  x <- Filter(Negate(is.NullOb), x)
  lapply(x, function(x) if (is.list(x)) rmNullObs(x) else x)
}

svg_list_nc <- rmNullObs(svg_list)

raw_tbl = svg_list_nc %>% setNames(svg_list_nc %>% sapply("[[",".attrs")) %>% melt %>% as.tbl %>% mutate(is_rxn = grepl("\\$R_",L1))
met_tbl = raw_tbl %>% mutate(raw_id = gsub("::.*","",L1)) %>% filter(!is_rxn)

met_tbl_title = met_tbl %>% filter(L2 == "title") %>% lapply(as.character) %>% as_data_frame %>% mutate(nn = nchar(value)) 



saveRDS(met_tbl_final,"")
met_tbl_final = readRDS("")
met_tbl <- met_tbl[(met_tbl$L2=="title"),]
met_tbl1 <- transform(met_tbl, n=nchar(as.character(value)))
met_tbl1 <- arrange(met_tbl1,n)
met_tbl1 = met_tbl1 %>% mutate(is_4 = grepl("32",n))
met5 = met_tbl1  %>% filter(!is_4)
met_tbl4 = met_tbl4 %>% mutate(Rxn_Id = "none")

met_tbl5 <- separate(data = met_tbl5, col = value, into = c("Met_id","Rxn_Id", "Subsystem","Compartment 1","Compartment 2"), sep = "\\::")
met_tbl4 <- separate(data = met_tbl4, col = value, into = c("Met_id", "Subsystem","Compartment 1","Compartment 2"), sep = "\\::")

met_tbl5[,c("L2","L1","n","numb","is_4","is_rxn")] <-list(NULL)
met_tbl4[,c("L2","L1","n","numb","is_4","is_rxn")] <-list(NULL)
met_tbl1 <- rbind(met_tbl5,met_tbl4)
rm(met5)
rm(met4)

rxn_tbl1 = raw_tbl  %>% filter(is_rxn)
rxn_tbl1 <- rxn_tbl1[(rxn_tbl1$L2==".attrs"),]
rxn_tbl1[,c("L2","is_rxn","L1")] <-list(NULL)
rxn_tbl1 <- separate(data = rxn_tbl1, col = value, into = c("Rxn_Id", "Rxn_part"), sep = "\\::")
rxn_tbl1 <- rxn_tbl1[with(rxn_tbl1, order(Rxn_Id,Rxn_part)), ]
rxn_tbl1[,c("Rxn_part")] <-list(NULL)
rxn_tbl1 <- aggregate(list(Rxn_segs=rep(1, nrow(rxn_tbl1))), rxn_tbl1, length)

##########################################################################################

#depending on what one wants to search for or modify the this can be done through a few commands

selection <- met_tbl1 %>% filter(CONDITON) #Condition format can be any columns such as "Subsystem == SUBSYSTEM__3"
selection_nodes <- selection$raw_id 

#selection nodes is the variable that would then be passed into the session$sendCustomMessage
#to the myCallbackHandler4 functions 

for best usability take the condition from a search bar or table upon user input



