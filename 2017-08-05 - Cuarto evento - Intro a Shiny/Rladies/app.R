library("shiny")
library("tidyverse")
library("ggplot2")
library("shinythemes")

#Para mayor informacion del codigo ver la presentacion de power point

#### INTERFAZ DE USUARIO ####
ui<- fluidPage(theme = shinytheme("lumen"), h1(strong("Rladies Buenos Aires")), h4(em("Taller de Ciencia de Datos")),
              sidebarLayout(
                sidebarPanel(radioButtons("Vx", "Eje X", selected = "displ", inline = FALSE, width = NULL , choices= c("Millas de autopista por galon"="hwy", "Millas de ciudad por galon"="cty", "Cilindrada del motor (L)"="displ")),
                             radioButtons("Vy", "Eje Y", selected = "hwy", inline = FALSE, width = NULL , choices= c("Millas de autopista por galon"="hwy", "Millas de ciudad por galon"="cty", "Cilindrada del motor (L)"="displ")),
                radioButtons("class", "Clase",  inline = FALSE, width = NULL , choices= c("Tipo de auto"="class", "Numero de cilindros"="cyl", "Modelo"="model", "Marca"="manufacturer")),
                img(src='nametag_7x5.png', width= 200, align = "topright")),
                mainPanel(
                          plotOutput("coolplot"))))

##### SERVIDOR #####

server <- function(input, output) {
  
  output$coolplot <- renderPlot({ print(ggplot(data = mpg) + geom_point(mapping = aes_string(x = input$Vx, y = input$Vy, color= input$class)))})
  
  }
                                                  
###### FINAL ####
shinyApp(ui = ui, server = server) 


