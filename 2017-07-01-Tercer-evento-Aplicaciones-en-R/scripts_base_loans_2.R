#entonces conviene simular con todos los meses y que pueda pagar 0... que seria que no se presenta


setwd('C:/Users/Gaby/Documents/slack')

###simulo los pagos
#no puede tener mas de 2 meses en el medio

##genero una tabla con todos los meses en el medio
###elijo random la fecha de origen para los clientes
###calculo los pagos con un loop, que tenga en cuenta los meses que pasaron hasta ahora
###y los pagos hasta la fecha
##la cantidad de cuotas pagas en cada instancia se define como
#sample(max(0,mora ant-1)), meses-cuotasPagasAcAnt)



fechas=seq.Date(from=as.Date('2014-12-01', format='%Y-%m-%d'), 
                to=as.Date('2017-07-01', format='%Y-%m-%d'), by='month')

clientes<-seq(1,1000,1)

pagos<-data.frame(expand.grid(clientes, fechas))
colnames(pagos)<-c('cliente', 'fechas')
#sum(is.na(pagos$fechas))
#orderno por cliente y dp fecha
pagos<-pagos[order(pagos$cliente, pagos$fecha),]
head(pagos)
row.names(pagos)<-1:nrow(pagos)

##defino una fecha random para cada cliente como origen del prestamo
origenes<-data.frame(cliente=seq(1,1000,1), origen=sample(fechas, rep=T,1000))

#mergeo pagos con origenes para borrar los registros anteriores al origen
pagos<-merge(pagos, origenes, by='cliente')
head(pagos)
pagos$borrar<-pagos$fechas-pagos$origen
pagos<-pagos[pagos$borrar>=0,]
pagos$borrar<-NULL

#tengo que calcular  los pagos
##necesito los meses ac
###los pagos ,  pagos ac y mora se an a ir definiendo en el loop
library(dplyr)
pagos$contador<-rep(1,nrow(pagos))
pagos<-data.frame(pagos%>%group_by(cliente)%>%mutate(meses=cumsum(contador)))
pagos$contador<-NULL
head(pagos)
#voy a llenar:
pagos$pago<-rep(NA, nrow(pagos))
pagos$pagosAc<-rep(NA, nrow(pagos))
pagos$mora<-rep(NA, nrow(pagos))

#veo si hay alguno desordenado
pagos<-pagos[order(pagos$cliente, pagos$fechas),]
head(pagos)
row.names(pagos)<-1:nrow(pagos)

for (i in unique(pagos$cliente)){
  #i=1
  tbl<-pagos[pagos$cliente==i,]
  fs<-tbl$fecha
  fs<-fs[order(fs)] #por las dudas
  for (j in (1:length(fs)) ){
    #j=1
      f<-fs[j]
      indice_hoy<-pagos$cliente==i & pagos$fechas==f
      if (f==fs[1]){
        pagos$pago[indice_hoy]<-sample(0:1,1)
        #la mora se calcula inmediatamente dp del pago de ese periodo
        pagos$pagosAc[indice_hoy]<-pagos$pago[indice_hoy]
        pagos$mora[indice_hoy]<- 1-pagos$pagosAc[indice_hoy]
        } 
      if (f>fs[1]) {
        ##me traigo del periodo anterior
        fAnt<-fs[j-1]
        indice_anterior=pagos$cliente==i & pagos$fechas==fAnt
        #la mora
        moraAnt=pagos$mora[indice_anterior]
        #defino pago, pagoAc y mora del per
        pagos$pago[indice_hoy]<-sample(max(moraAnt-2,0):(moraAnt+1),1) #asi  lo dejo llegar a 3
        pagos$pagosAc[indice_hoy]<-pagos$pagosAc[indice_anterior]+pagos$pago[indice_hoy]
        pagos$mora[indice_hoy]<-pagos$meses[indice_hoy]-pagos$pagosAc[indice_hoy]
          
      }
  }
}
head(pagos)
head(pagos[pagos$mora<0,])
pagos[pagos$cliente==2,]
hist(pagos$pago)

table(pagos$mora)
length(unique(pagos$cliente[pagos$mora==3]))

##con esta forma si bien empiezan en distintas fechas, todos llegan al final
##tengo que definir quienes van a caer en mora
###ahora para cada mes 

pagos$entra<-ifelse(pagos$mora==3,1,0)

pagos2<-data.frame(pagos%>%group_by(cliente)%>%mutate(entraAc=cumsum(entra)))
pagos2$queda<-ifelse(pagos2$mora==3 & pagos2$entraAc==1, 1, 
                     ifelse(pagos2$entraAc==0,1,0))

table(pagos2$queda)
pagos2[pagos2$queda==0,]
pagos2[pagos2$cliente==399,]

##ahora elimino los registros siguientes
pagos2<-pagos2[pagos2$queda==1,]

###hay demasiados en mora, hago un rdn para sacar algunos y decir que su prestamo termino ahi

pagos2$rdm<-sample(0:100,nrow(pagos2), rep=T)
pagos2$borrar<-ifelse(pagos2$mora==3 & pagos2$rdm<50,1,0)
length(unique(pagos2$cliente[pagos2$mora==3]))
table(pagos2$borrar)

pagos3<-pagos2[pagos2$borrar==0,]


###me falta definir cuanto duraban los prestamos
morosos<-data.frame(cliente=unique(pagos$cliente[pagos$mora==3]), moroso=1)

#hasta ahora todos terminan el ultimo mes, excepto los morosos
###entonces, por cada cliente con la fecha de origen defino una cantidad de cuotas
origenes
origenes2<-merge(origenes, morosos, all.x=T, by=('cliente'))
origenes2$moroso[is.na(origenes2$moroso)]<-0

##que dsitribucion quiero de entrega de prestamos
distPrestamos<-data.frame(cuotas=c(3,6,12,18,36),
                          porcAc=c(.50, .70, .85, .95, 1))
origenes2$rdn<-runif(nrow(origenes2))
origenes2$cuotas<-findInterval(origenes2$rdn, distPrestamos$porcAc)
origenes2$cuotas1<-origenes2$cuotas+1
origenes2$cuotasTot<-distPrestamos$cuotas[origenes2$cuotas1]
origenes2$cuotas<-NULL
origenes2$cuotas1<-NULL

###ahora mergeo con los pagos
pagos4<-merge(pagos3, origenes2[,c('cliente', 'moroso', 'cuotasTot')], by=c('cliente'), all.x=T)


##para evitar que si saco pagosAc>cuotasTot, no llegue porque pago 2 juntas y se paso del total asignado
#calculo la diferencia >=0 y me quedo cuando es menor, ese registro lo dejo y le cambio los pagos
##por las cuotas los pagos-la dif positiva


pagos4$diferenciaPos<-pagos4$pagosAc-pagos4$cuotasTot

mDP.df<-data.frame(pagos4%>%filter(diferenciaPos>=0 & moroso==0)%>%group_by(cliente)%>%
                     summarise(mDP=min(diferenciaPos)))
mDP.df$cortar<-1



#ahora mergeo con mDP.df

pagos5<-data.frame(merge(pagos4, mDP.df, by.x=c('cliente', 'diferenciaPos'), 
                         by.y=c('cliente', 'mDP'), all.x=T))
pagos5$cortar[is.na(pagos5$cortar)]<-0
pagos5<-pagos5[order(pagos5$cliente, pagos5$fechas),]



mDP.df2<-data.frame(pagos5%>%filter(cortar==1)%>%group_by(cliente)%>%
                      summarise(minFDP=min(fechas)))

mDP.df2$cortar2<-1
head(mDP.df2)

pagos6<-data.frame(merge(pagos5, mDP.df2, by.x=c('cliente', 'fechas'), 
                         by.y=c('cliente', 'minFDP'), all.x=T))
           
pagos6$cortar2[is.na(pagos6$cortar2)]<-0
pagos6<-pagos6[order(pagos6$cliente, pagos6$fechas),]

pagos6<-data.frame(pagos6%>%group_by(cliente)%>%mutate(cortarF=cumsum(cortar2)))
pagos6<-data.frame(pagos6%>%group_by(cliente)%>%mutate(cortarFF=cumsum(cortarF)))
head(pagos6[pagos6$cliente==3,])
pagos6<-pagos6[pagos6$cortarFF<=1,]
pagos6$cortar<-NULL
pagos6$cortar1<-NULL
pagos6$cortar2<-NULL
pagos6$cortarF<-NULL

###ahora debo modificar el ultimo registro de cada uno
###si cortarFF=1 then pagos=pagos-dif
###ahora saco los registros que tienen en pagosAc>cuotasTot

pagos6$pago<-ifelse(pagos6$cortarFF==1,pagos6$diferenciaPos+pagos6$pago, pagos6$pago)
#pagos6[pagos6$cortarFF>1 & pagos6$moroso==1,'cliente']

pagos6$mora<-ifelse(pagos6$cortarFF==1,0, pagos6$mora)
pagos6$pagosAc<-ifelse(pagos6$cortarFF==1,pagos6$cuotasTot, pagos6$pagosAc)

pagos6$cortarFF<-NULL
#***********************veamos algunas estadisticas********************
##cuantos clientes hay por mes?
head(pagos6)
library(dplyr)
x<-data.frame(pagos6%>%group_by(fechas)%>%summarise(n()))
plot(x$fechas, x$n..)

##cuantos clientes empiezan por mes?
x<-data.frame(pagos6%>%group_by(cliente)%>%summarise(minF=min(fechas)))
xx<-data.frame(x%>%group_by(minF)%>%summarise(clis=n()))
plot(xx$minF, xx$clis, type='o')

colnames(pagos6)
##cuantos clientes defaultean por mes?
x<-data.frame(pagos6%>%filter(mora==1)%>%
                group_by(fechas)%>%summarise(clis=n()))
plot(x$fechas, x$clis)


#cual es la tasa de default por mes?
#cual es la distribución de los préstamos de acuerdo a su longitud por mes?
#cual es la tasa de default para cada longitud de prestamos?
#cuál es la evolución de la tasa de defaut de acuerdo a las distintas fechas de originación (cohortes)?


#*********************************MATRIZ DE TRANSICION
#MERGE entre t y t+1 por cli
pagos6$tmas1=sapply( pagos6$fechas, function(x) {seq(x, x+35, by='month')[2]})
pagos6$tmas1<- as.Date(pagos6$tmas1, origin='1970-01-01')
head(pagos6)
pagos7<-pagos6[,c('cliente', 'fechas', 'mora')]
colnames(pagos7)[3]<-'moraTmas1'
##podría hacerlo con dinero en vez de clientes

m<-data.frame(merge(pagos6, pagos7, by.x=c('cliente', 'tmas1'), 
                    by.y=c('cliente', 'fechas'), all.x=T))

x<-data.frame(m%>%group_by( mora, moraTmas1)%>%summarise(n()))

library(reshape2)
xx<-data.frame(dcast(x, mora~moraTmas1))
xx[is.na(xx)]<-0
xx$NA.<-NULL
xx<-xx[1:3,]
xx$tot=xx$X0+xx$X1+xx$X2+xx$X3
y<-xx/xx$tot
y$tot<-NULL
y$mora<-c(0,1,2)
y

#***************************************

