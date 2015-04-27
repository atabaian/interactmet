
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

met.node.df = data.frame(node_id = c("node1","node2","node3", "node4","node5","node6"),
                         node_name = c("TPP","LipoamideE","Hydroxyeythl","H20","Malate","Fumerate"),stringsAsFactors = F)

shinyUI( fluidPage(

#Load HTML which calls svg  
tags$div(
  HTML("
    <embed id='sv' src='brack.svg' width='1875' height='750'>
      </embed>
")
  ),

#javascript with Shiny Call back handler 
tags$script('

var E;

function prepare(r){
   var S=document.getElementById("sv")
   var SD=S.getSVGDocument();
   E=SD.getElementById(r);
}



Shiny.addCustomMessageHandler("myCallbackHandler3",     
          function(met) {
      
          var S=document.getElementById("sv")
          var SD=S.getSVGDocument()
          TPP=SD.getElementById(met)
          TPP.style.opacity="0";
            


          }
    );


Shiny.addCustomMessageHandler("myCallbackHandler4",     
          function(met) {
      
          var S=document.getElementById("sv")
          var SD=S.getSVGDocument()
          TPP=SD.getElementById(met)
          TPP.style.opacity="1";
            


          }
    );
            '),

#shiny slider
#sliderInput("slider1", label = h3(""), min = 2, 
           # max = 20, value = 8),

#selectizeInput("slider_met_control",label = "metabolites",choices = setNames(met.node.df$node_id,met.node.df$node_name),selected = NULL,
 #              width = "100%"),

checkboxInput("checkbox", label = "Hide Selected", value =FALSE),
# 
checkboxInput("checkbox1", label = "Highlight Selected", value =FALSE),

fluidRow(
  dataTableOutput(outputId="table") )  


  )
)