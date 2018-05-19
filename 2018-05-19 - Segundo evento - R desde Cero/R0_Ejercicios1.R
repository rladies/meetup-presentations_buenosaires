---
  title: "R0_Ejercicios1"
author: "Mónica Alonso"
date: "16 de mayo de 2018"
---


## Operaciones Basicas 1
  
# Cuál es el resultado?

#EJERCICIO1
7 %% 4

# EJERCICIO 2
x <- "trompo"
y <- 2
class(x)
class(y)


## Operaciones Basicas 2
# Cuál es el resultado?

# EJERCICIO 3
a <- 500 
b <- 200
# a <- 200
a - b

#EJERCICIO 4
(2 ^ 2) ^3

## VECTORES 1

# EJERCICIO 5
# Cuál opción da como resultado
# [1] 6 7 4

6 + 7 + 4       # a) 
c(6, 7, 4)      # b)    
c(6 7 4)        # C)


## VECTORES 2

# Cuál es el resultado?

# EJERCICIO 6
a <-  c("a", "b", "c")
b <-  a == "a"
b

a <-  c("a", "b", "c")
b <-  a == "a"
b


# EJERCICIO 7
a <-  c(18, 21)
names(a) <-  c("SFE", "MZA")
a

a <-  c(18, 21)
names(a) <-  c("SFE", "MZA")
a


## VECTORES 3

Cuál es el resultado?
 
# EJERCICIO 8:  
a <-  c(4, 4, 2, 1)
a[c(1, 3)]

# EJERCICIO 9:

a <-  c(1, 8, 2, 7)
names(a) <- c("a", "b","c")
x <- a[c(1, 3)] == 2
x


## MATRICES 1
# Cuál es el resultado?

#EJERCICIO 10:
m <- matrix(1:4, nrow = 1)
mean (m [, 2:3])


# EJERCICIO 11
m <-  matrix( 1:4, nrow = 2)
m * 2


## MATRICES 2{.build}
# Cuál es el resultado?

# EJERCICIO 12:
m <- matrix(1:3, nrow = 1)
n <- matrix(4:6, nrow = 1)
rbind(m, n)
cbind(m, n)


## DATA FRAMES 1

# EJERCICIO 14:
df <- data.frame(a = 1:3, b = 4:6)
df

# EJERCICIO 13:
df <- data.frame(a = 20:30, b = 30:40)
x  <- head(df)
str(x)

## DATA FRAMES 2

# EJERCICIO 15:
v <- c(5, 2, 4, 3, 7)
df <- data.frame(a = 3:7, v)
df <- subset(df, v > 3)
df[order(df$v), ]

