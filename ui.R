library(shiny)

  ui <- shinyUI(fluidPage(
    
    sidebarLayout(
      sidebarPanel(
        #Standalone colour Input
        colourInput("myColour", label = "Just the color control:", value = "#000000"),
        br(),
        HTML("Build the colour Input from HTML tags:"), br(),
        HTML(paste0(
          "<div class='form-group shiny-input-container' data-shiny-input-type='colour'>
          <input id='myColour", 999,"' type='text' class='form-control shiny-colour-input' 
          data-init-value='#FFFFFF' data-show-colour='both' data-palette='square'/>
          </div>"
          
        ))
      ),
      
      mainPanel(
        HTML("Failed attempt"),
        rHandsontableOutput("hot"), 
        br(), br(),
        HTML("Success, but this is not a rhandsontable"),
        uiOutput("tableWithColourInput")

      )
    )
  ))
  
