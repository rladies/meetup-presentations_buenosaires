#RLadies Meetup 4  Geo 1 Raster
#Priscilla Minotti
# Meetup 4 5-8-2017

#Ejercicios con datos raster

#verificar que los paquetes"rgdal", "sp", "raster"y "tmap" esten cargados
#los datos a usar se encuentran en la carpeta DatosGeo 
#que debe estar descomprimida para poder acceder a las imagenes

#cargar librerias

library(raster)
library(tmap)#

#Ejercicio 3 Visualizar una capa sola = un Layer
#Entrar una capa, comprobar su clase, explorar con un resumen y ploteo basico



#Del ejercicio anterior, estamos en ./DatosGeo como working directory

tifdir<- c("./DatosGeo") #guardar nombre de directorio

#Adentro de DatosGeo tambien hay 12 rasters de temperatura superficial noche  obtenida por el sensor
#MODIS-Aqua con pixel de 5 km, cada raster o imagen presentando la temperatura media mensual en grados centigrados x 1000
#para tener las temperaturas con 3 decimales  como enteros
#Cada una de estas imagenes es de una sola capa 
#Estos datos ya vienen corregidos por pixeles sin datos dentro de Argentina
#Los unicos NA que hay son los que sirven para "enmascarar" las celdas que no son Argentina

list.files(tifdir, pattern ="*.tif")#listamos las imagenes en consola y verificamos que estan las 12
TifTemp<-list.files(tifdir, pattern ="*.tif")#guardamos la lista de imagenes tif para usar despues

#Cambiar el wd a adentro de la carpeta DatosGeo
setwd("DatosGeo")

#Vamos a entrar la imagen de temperatura media de enero que es
#MYD11C3.A2010001.tif"


T2010_1<-raster("MYD11C3.A2010001.tif")
#Forma generica de entrar una capa a R
#capa_raster = raster("capa.tif")


#exploramos el raster

class(T2010_1)#vemos su clase

# con el nombre del raster directamente, da el resumen de todas sus caracteristicas
# como su clase, dimensiones en filas, columnas y numero de celdas, resolucion espacial del pixel
# en las unidades de las coordenadas,el bbox, la proyeccion, la ubicacion de archivo, 
# su nombre y sus valores maximos y minimos

T2010_1 

#estas caracteristicas se guardan dentro de "slots" que se indican con un @, como @data o 
#en vez de @bbox usa @extent para dar las dimensiones del recuadro contenedor.
#La lista completa de los slots se obtiene con str() pero es un listado muy largo, asi 
#que si lo quieren ver, descomentenlo, pero es realmente muuy largo

#str(T2010_1)


plot(T2010_1)#da un ploteo simple del raster con una paleta por defecto y pone las coordenadas

#Ejercicio 4 Entrar capas de manera apilada, 
#sacar estadistica per pixel de imagen o raster multicapa y visualizacion basica con tmap

Temp2010<-stack(TifTemp)#entra todo las imagenes listadas antes y arma un rater multicapa

#Exploramos
Temp2010  #datos del raster multicapa tambien llamados metadatos

plot(Temp2010)#ploteo basico de todas las capas

#paleta de colores del azul al rojo para ver las zonas mas frias en azul y las mas calidas en rojo
plot(Temp2010, col=colorRampPalette(c("blue", "white", "red"))(255))
#mas ayuda con ?raster::plot

#Ejercicio 4 estadisticas simples de raster multicapa y viz en tmap con modo view

Tmed<-mean(Temp2010)
Tmax<-max(Temp2010)
Tmin<-min(Temp2010)

TempRes2010<-stack(Tmed,Tmax,Tmin)
plot(TempRes2010, col=colorRampPalette(c("blue", "white", "red"))(255))


tmap_mode("view")
qtm(Tmed)#ploteo basico

#si queremos mas control hay que ir ploteando conjuntos de elementos
tm_shape(Tmed)+
  tm_raster(Tmed, alpha=0.5) #plotea con transparencia

#Extra

writeRaster(TempRes2010, filename="TMedMaxMin2010.tif", format='GTiff') 
#exporta los datos del stack con la estadistica anual de temperatura a geotif
#con  orden de capas del stack y la misma geoferencia, unidades, 
#y tamaño de pixel que las imagenes de origen


#dev.off() #borro ultimo plot
#rm(list = ls()) #limpio de objetos R el WD




