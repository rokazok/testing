library(shiny); library(rhandsontable); library(colourpicker)

#Colour cells ideally would be a colourInput() control similar to the Date input control
DF <- data.frame(Value = 1:4, Status = TRUE, Name = LETTERS[1:4],
                    Date = seq(from = Sys.Date(), by = "days", length.out = 4),
                    Colour = sapply(1:4, function(i) {
                      paste0(
                        '<div class="form-group shiny-input-container" data-shiny-input-type="colour">
                            <input id="myColour',i,'" type="text" class="form-control shiny-colour-input" 
                                data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
                        </div>'
                      )}),
                    stringsAsFactors = FALSE) 


  
  
  server <- shinyServer(function(input, output) {
    
    #create DF2 for attempt #2
    DF2 <- transform(DF, Colour =  c(sapply(1:4, function(x) {
                        jsonlite::toJSON(list(value = "black"))
                    })))
    
    output$hot <- renderRHandsontable({
      #Attempt #1 = use the HTML renderer
      #Results in no handsontable AND no HTML table <-- why no HTML table too?
      rhandsontable(DF) %>%  hot_col(col = "Colour", renderer = "html")
      
      #Attempt #2 = use colourWidget
      #Results are the same as above.
      #rhandsontable(DF2) %>% hot_col(col = "Colour", renderer = htmlwidgets::JS("colourWidget"))
      
      #Uncomment below to see the table without html formatting
      rhandsontable(DF) 
        #^This line was uncommented to obtain the screengrab in the Stack Overflow question.
      
    })
  
    #HTML table
    myHTMLtable <- data.frame(Variable = LETTERS[1:4],
                              Select = NA)

    output$tableWithColourInput <- renderUI({
      #create table cells
      rowz <- list() 
        #Fill out table cells [i,j] with static elements
        for( i in 1:nrow( myHTMLtable )) {
          rowz[[i]] <- tags$tr(lapply( myHTMLtable[i,1:ncol(myHTMLtable)], function( x ) {  
            tags$td( HTML(as.character(x)) )  
          }) )
        }
        #Add colourInput() to cells in the "Select" column in myHTMLtable
        for( i in 1:nrow( myHTMLtable ) ) {
          #Note: in the list rowz:
          #  i = row; [3] = row information; children[1] = table cells (list of 1); $Select = Column 'Select' 
          rowz[[i]][3]$children[[1]]$Select <- tags$td( 
            colourInput(inputId = as.character(paste0("inputColour", i)), label = NULL, value = "#000000")
          ) 
        } 
      mybody <- tags$tbody( rowz )

      tags$table( 
        tags$style(HTML(
          ".shiny-html-output th,td {border: 1px solid black;}"
          )),
        tags$thead( 
          tags$tr(lapply( c("Variable!", "Colour!"), function( x ) tags$th(align = "right", x ) ) )
        ),
        mybody
      ) #close tags$table
    }) #close renderUI
    
  }) #close shinyServer

