#Siempre guardar el archivo con encoding UTF8
#install.packages("shiny")
library("shiny")

##### INTERFAZ DE USUARIO #####
ui<-fluidPage()


##### SERVIDOR #####

server <-function(input, output){}

##### FIN #####
shinyApp(ui = ui, server = server) 