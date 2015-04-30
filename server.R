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
    vis <- input$checkbox
    
    print(vis)
    
    if(vis) {
    
      for (i in 1:length(sub3)){
      session$sendCustomMessage(type='myCallbackHandler3', sub3[i])
      print(sub3[i])
      }
      
    }
    
      print(vis)
      
      if(!vis) {
        
        for (i in 1:length(sub3)){
          session$sendCustomMessage(type='myCallbackHandler4', sub3[i]) 
        }
      }
    
    
    
  })
  
  observe({
    hili <- input$checkbox1
    
    print(hili)
    
    if(hili) {
      
      for (i in 1:length(hilight)){
        session$sendCustomMessage(type='myCallbackHandler5', hilight[i])
        print(hilight[i])
      }
      
    }
    
    print(hili)
    
    if(!hili) {
      
      for (i in 1:length(hilight)){
        session$sendCustomMessage(type='myCallbackHandler6', hilight[i]) 
      }
    }
    
    
    
  })
  
  output$table <- renderDataTable({
    data <- met_tbl1
    data
  })
})