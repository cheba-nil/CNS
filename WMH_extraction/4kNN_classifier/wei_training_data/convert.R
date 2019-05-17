#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

data<-read.csv(args[1],sep=' ',header=FALSE)
data$V5<- data$V5 - (3*log(1.5))

write.table(data,file=paste('editted',args[1],sep='-'),sep=' ',row.names=FALSE,col.names=FALSE)
