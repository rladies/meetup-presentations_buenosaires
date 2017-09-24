## app.R ##
#install.packages("shinydashboard")
library(shiny)
library(shinydashboard)
library(ggplot2)



sidebar<-dashboardSidebar(radioButtons("Vx", "Eje X", selected = "displ", inline = FALSE, width = NULL , choices= c("Millas de autopista por galon"="hwy", "Millas de ciudad por galon"="cty", "Cilindrada del motor (L)"="displ")),
                        radioButtons("Vy", "Eje Y", selected = "hwy", inline = FALSE, width = NULL , choices= c("Millas de autopista por galon"="hwy", "Millas de ciudad por galon"="cty", "Cilindrada del motor (L)"="displ")),
                        radioButtons("class", "Clase",  inline = FALSE, width = NULL , choices= c("Tipo de auto"="class", "Numero de cilindros"="cyl", "Modelo"="model", "Marca"="manufacturer")),
                        img(src='nametag_7x5.png', width= 200))


body<-dashboardBody(plotOutput("coolplot"))


ui <- dashboardPage(skin="purple",
                    dashboardHeader(title="Rladies Buenos Aires"),
  sidebar,
  body
)



server <- function(input, output) {
  
  output$coolplot <- renderPlot({ print(ggplot(data = mpg) + geom_point(mapping = aes_string(x = input$Vx, y = input$Vy, color= input$class)))})
  
}

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
shinyApp(ui, server)