#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Load data
movies <- read.csv("../data/movies.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exploring Movies"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      # Select variable for y-axis
      selectInput("y",
                  "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes",
                              "critics_score", "audience_score",
                              "runtime"),
                  selected = "audience_score"
      ),
      
      # Select variable for x-axis
      selectInput("x",
                  "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes",
                              "critics_score", "audience_score",
                              "runtime"),
                  selected = "critics_score"
      ),
      
      # Select variable for color
      selectInput("z",
                  "Color by:",
                  choices = c("title_type", "genre", "mpaa_rating",
                              "critics_rating", "audience_rating")
      ),
      
      # Alpha
      sliderInput("alpha", 
                  "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Horizontal line separating population and sample input
      hr(),
      
      # Sample size
      numericInput("n",
                   "Sample size:",
                   min = 1,
                   max = nrow(movies),
                   value = nrow(movies))
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("exp_plot")
    )
  )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
  # create data frame for sample means to be stored
  movies_sample <- reactive({
    movies %>%
      sample_n(input$n)
  })
  
  output$exp_plot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y, 
                                              color = input$z)) +
      geom_point(alpha = input$alpha)
  })
})

# Run the application 
shinyApp(ui = ui, server = server)

