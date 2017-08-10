#RLadies Meetup 4  Geo 1 Vector
#Priscilla Minotti
# Meetup 4 5-8-2017

#Ejercicios con datos vectoriales

# Requiere tener instalado los paquetes "rgdal", "sp", "raster", "tidyverse" y "tmap"
# 
# Requiere tener descargado y dezipeado DatosGeo.zip
# 
# Asume que el WD esta en el directorio que contiene la carpeta DatosGeo
# 
#Vamos a usar Datos de localizacion de docentes de programacion para chicas en formato shapefile
#CodeProfes.shp, son en realidad varios archivos vinculados
#y Datos de encuesta en formato csv para saber quiene son RLadies y a cuantos Meetups vinieron

#cargar librerias

library(rgdal)
library(sp)

#Ej1 Leer datosespaciales, y viz muy simple.

#Leer los datos geo de la localizacion de las docentes con rgdal 

#la instruccion general es:
#nombre_capa <- readOGR(dsn="direccion_carpeta_con_datos",layer="nombreshp_sin_el_.shp")

#pero si los datos vectoriales estan en formato shapefile todos en adentro de una misma carpeta
#se puede escribir primero carpeta y lugo nombre del shp

Profes<-readOGR("DatosGeo", "CodeProfes")

#Exploramos que tipo de datos y estructura tienen 
class(Profes)
head(Profes)
summary(Profes)

#cuando tenemos clases espaciales,escribiendo el nombre del objeto 
#nos resume todas sus caracteristicas
Profes

#Visualizacion basica

plot(Profes) # realmente no dice mucho

plot(Profes, axes=T) #pone ejes de coordenadas

plot(Profes, axes=T, pch=1)# cambia el simbolo a circulos vacios

#Quiero destacar la ubicacion de Ana, para eso filtro/selecciono solo los datos de Ana
Ana <- Profes[Profes[["Nombre"]] == "Ana", ]

#lo agrego al grafico anterior, pero con circulo pleno de color rojo y el dble de grande

plot(Ana, col = "red", pch=19, cex=2, add = TRUE)

#pone etiquetas con atributo Nombre
text(coordinates(Profes), 
     labels = Profes[["Nombre"]],
     cex = 0.7)

#Ej2 Leer y unr los datos no espaciales,  viz scon tmap

#Ingreso los datos de la encuesta que estan en una tabla csv
#Por defecto, R considera que las variables de textos son factores
# y si solo vamos a usar los datos en visualizacion o analisis geografico
# no siempre queremos eso, por eso es bueno indicarlo al entrar los datos

RLadies<-read.csv("DatosGeo/SonRLadies.csv",stringsAsFactors = FALSE)
class(RLadies)
head(RLadies)

#Vamos a unir los datos de las Profes con localizacion (dataset de la izquierda)
#con los datos de la encuesta (dataset de la derecha)
#para obtener un dataset con mas columnas y geolocalizado

#para unir debemos saber de antemano cuales son las columnas/atributos comunes, 
#y luego debemos explorar a ver si hay coincidencias en los valores, ya que en el left_join
#quedan unidastodas las instancias de los datos geo (Profes)
#con aquellos del cvs que esten en comun

#Para ver si los nombre de Profes coinciden con los que hay en RLadies hay varias formas de explorar 
#usanmos el operador %in% que permite ver como matchean los datos 
#de las dos columnas de los dataframes
#
Profes$Nombre %in% RLadies$Nombre #todas salen True si estan OK

#Si quiera saber cuales no estan en el csv
!Profes$Nombre%in% RLadies$Nombre

#Resumen de coincidencias
summary(Profes$Nombre %in% RLadies$Nombre)

#De acuerdo a esto,a todas las docentes les podemos asignar los datos de RLadies

#Cargamos la libreria dyplr que permite trabajas con tablas y viene con el
#que viene con el tidyverse o que podemosinstalar aparte
#
library(dplyr) 

#vamos a usar left_join para que el dataframe de Profes que son los geodatos quede tal cual y sole se agreguen las variables de RLadies
#esta funcion asume por defecto que las tablas se unen mediante campos comunes que llevan el mismo nombre
# pero tambien podrian ser distintos

Profes@data <- left_join(Profes@data, RLadies, by = c('Nombre' = 'Nombre'))
#los datos nuevos se unieron al spatialPointsdataframe que esta guardado en @data

#verificamos que se agregaron los nuevos atributos
Profes


#vamos a usar el paquete tmap que facilita la elaboracion de composiciones cartograficcas

library(tmap) #cargamos la libreria correspondiente
tmap_mode("plot")#ponemos para que dibuje en la pestaña Plots, no muestra nada

# ploteo basico donde representamos a ubicacion de las profes y la abundacia relativa
# de alumnos como tamaño variable de los puntos

qtm(Profes) #qtm es para ploteo rapido, asi pone solo puntitos 
qtm(Profes, symbols.size = "NMeetups") #puntos con tama;o proporcional a abundancia de Meetups


#Si queremos hacer un mapa mas complejo tmap tiene una sintaxis similar a ggplot2, pero 
#usando funciones que permiten encadenar el dibujo de elementos de mapa con distinta estetica
#hay que marcar las dos lineas

tm_shape(Profes) +
  tm_bubbles(size = "NMeetups", shape=1, border.lwd=1)

#Pero si necesitamos interpretar nuestros datos en funcion de la geografia
#es necesario ponerles  informacion geografica adicional como fondo para que 
#brinde contexto.
#Para eso el paquete tmap trae la opcion de usar capas como OpenStreetMaps o 
#CartoDB de internet como fondo, y para eso hay que usar el modo View.

tmap_mode("view")#muestra los datos en la pestaña Viewer
qtm(Profes) # ploteo basico 

tm_shape(Profes) +
  tm_bubbles("NMeetups", "red", border.col = "black", border.lwd=1)


  
#Practica adicional
#Leer los el shapefile de radios censales de la Ciudad de Buenos Aires

CABAPop<-readOGR("DatosGeo","cabaxrdato_gg")

#Ver el resumen de los datos que trae
CABAPop

#Experimentar presentar la distribucion del numero de hogares por radio censal
#usando tmap 

tmap_mode("view")#pone en modo para mostrar en viewer
qtm(CABAPop) #dibuj simple solo limites de radios censales, ojo que tarda mas 

qtm(CABAPop,fill = "HOGARES") #dibuja simple con los radios coloreados por Hogares y con bordes

tm_shape(CABAPop) +
  tm_polygons( col = "HOGARES")#igual al anterior pero por elementos

#tm_fill permite dibujar los poligonos sin bordes por defecto
#alpha define el nivel de transparencia entre 0 y 1, vale 1 por defecto
#tarda un poquito, no deseperen
tm_shape(CABAPop) +
  tm_fill( col = "HOGARES", alpha = 0.5)

#junto con los datos de los ejercicios anteriores para ver como se pueden armar 

tm_shape(CABAPop) +
  tm_fill( col = "HOGARES")+
tm_shape(Profes) +
  tm_bubbles("NMeetups", "red", border.col = "black", border.lwd=1)

#Como ya esta ocupado el lugar de la leyenda con la referencia del primer grupo de elementos, 
#no puede dibujar la leyenda para Profes en el mismo lugar y da un warning

#documentacion de tmap en
# https://www.rdocumentation.org/packages/tmap/versions/1.10

#dev.off() #borra ultimo plot
#rm(list = ls()) #borra todos objetos de R
#el icono de la escobita en viwere borra el mapa


