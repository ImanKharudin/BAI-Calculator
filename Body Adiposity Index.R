
library(shiny)
library(shinythemes)
library (markdown)

ui <- fluidPage(theme = shinytheme("united"),
                navbarPage("BAI Calculator:",
                           
                           tabPanel("Home",
                                    
                                    sidebarPanel(
                                      HTML("<h3>Slide to your height and hip circumference</h3>"),
                                      sliderInput("height", 
                                                  label = "Height", 
                                                  value = 160, 
                                                  min = 40, 
                                                  max = 250),
                                      sliderInput("hipcircumference", 
                                                  label = "Hip circumference", 
                                                  value = 37, 
                                                  min = 20, 
                                                  max = 100),
                                      
                                      actionButton("submitbutton", 
                                                   "Submit", 
                                                   class = "btn btn-primary")
                                    ),
                                    
                                    mainPanel(
                                      tags$label(h3('Status/Output')),
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata'),
                                      img(src = "male.jpg", height = 200, width = 500),
                                      img(src = "female.jpg", height = 200, width = 500)
                                    )
                                    
                           ), 
                           
                           tabPanel("About", 
                                    titlePanel("About"), 
                                    div(includeMarkdown("about.md"), 
                                        align="justify")
))) 
                    


server <- function(input, output, session) {
  
  datasetInput <- reactive({  
    
    bai = (input$hipcircumference / (input$height/100)^1.5) - 18
    bai = data.frame(bai)
    names(bai) = "Your BAI is (%)"
    print(bai)
    
  })
  
  
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  

  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

shinyApp(ui = ui, server = server)
