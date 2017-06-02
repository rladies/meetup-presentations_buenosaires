###########################################################
# Código para el Taller R para Ciencia de Datos - Parte I #
###########################################################

# Paquetes con los que trabajaremos a lo largo de todo el Taller (no sólo la
# Parte I) 

# Instalación (sólo se hace la primera vez que se necesitan los paquetes)

install.packages("tidyverse")
install.packages(c("nycflights13", "gapminder", "Lahman"))

# Para usar un paquete hay que cargarlo durante cada uso. Para eso usamos
# la función library

library(tidyverse)

# Siempre conviene tener los paquetes del tidyverse actualizados
# Código para actualizarlos: tidyverse_update()

###############################################################################
# Mi primer código R: R también es una calculadora

1 + 2

# Si quiero guardar la respuesta

resultado <- 1 + 2 # Qué apareció en el panel de arriba a la derecha?
                   # Para tipear " <- " podés usar alt y - a la vez. Probálo.

# Para ver el resultado

resultado

# Ejercicio: hacé la cuenta que quieras desde el script o directamente desde
# la consola, guardando y sin guardar el resultado

###############################################################################
# Explorando con gráficos

# Pregunta: ¿Los autos con motores grandes usan más nafta que los autos con 
# motores chicos? ¿Cómo es la relación entre el tamaño del motor y el consumo 
# de nafta? ¿Es positiva? ¿Negativa? ¿Lineal? ¿No lineal?

#### Dataframes

# Vamos a usar la base de datos mpg - miremos de qué se trata este dataframe

mpg # alternativamente ggplot2::mpg - me asegura que el mpg que uso es del
    # paquete ggplot2

?mpg # abre la documentación sobre mpg abajo a la derecha, donde se explica qué 
     # es cada variable

# Ejercicio: Cuántas filas tiene mpg? Cuántas columnas?

# Ejercicio: Qué describre la variable drv?

#### ggplot

# Para crear un gráfico de dispersión usando mpg que incluya el tamaño del motor
# (displ) en el eje de las x y cantidad de millas por galón (hwy) en el eje de 
# las y 

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy))

# Funciona si pruebo otras formas como:??

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

# o como:??

ggplot(data = mpg) 
    + geom_point(mapping = aes(x = displ, y = hwy))

# Ejercicio: Hacé un gráfico de dispersión de hwy versus cyl

#### Agregado de atributos estéticos a distintas variables

# Usando colores para identificar las distintas clases de vehículos (class)

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, color = class))

# También podés usar distintos niveles de transparencias

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# O distintas formas (Cuidado! SUV no aparece en el gráfico, se quedó sin forma)

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# En lugar de pintar por clase, pinto todos los puntos de un mismo color

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# Ejercicio: Por qué en el siguiente gráfico los puntos no son azules? 
# Cómo lo arreglarías?

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# Qué pasa si usás la variable cty (variable continua) para el atributo estético 
# color? El código para eso es:

ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, color = cty))

# Probá lo mismo con alpha y shape. Cómo se comparan estos gráficos a cuando
# usaste la variable categórica class?

# Ejercicio: Mapeá la variable cty a los atributos estéticos color y alpha.

# Ejercicio: Qué hace el atributo estético stroke? Con qué formas funciona?
# Mostrá un ejemplo. Pista: Usá el comando ?geom_point