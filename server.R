library(shiny)


shinyServer( function(input, output, session) {
  
#   observer if value of the data sent from the client changes
#   if yes, send it back to the client callback handler
#   
#   observe({
#     val <- input$slider1
#     session$sendCustomMessage(type='myCallbackHandler', val)
#     
#     
#   })
#   

  observe({
    vis <- input$checkbox1
    print(vis)
    
    if(vis) {
    
      for (i in 1:length(subsys3)){
      session$sendCustomMessage(type='myCallbackHandler3', subsys3[i]) 
      print(subsys3[i])
      }
      
    }
    
      print(vis)
      
      if(!vis) {
        
        for (i in 1:length(subsys3)){
          session$sendCustomMessage(type='myCallbackHandler4', subsys3[i]) 
          print(subsys3[i])
        }
      }
    
    
    
  })
  
  output$table <- renderDataTable({
    data <- met_tbl1
    data
  })
})