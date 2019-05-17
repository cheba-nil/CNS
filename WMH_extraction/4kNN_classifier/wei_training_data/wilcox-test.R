#!/bin/sh

fn<-read.csv('FN_features.txt',sep=' ',header=FALSE)
tn<-read.csv('TN_features.txt',sep=' ',header=FALSE)
fp<-read.csv('FP_features.txt',sep=' ',header=FALSE)
tp<-read.csv('TP_features.txt',sep=' ',header=FALSE)

tables<-list(fn=fn,tn=tn,fp=fp,tp=tp)

cat(' ',c(1:9),sep=',')
cat('\n')

for(i in 1:3){
    for(j in (i+1):4){
        namei=names(tables)[i]
        namej=names(tables)[j]
        cat(namei,namej,sep='--')
        for(k in c(1:9)){
            cat(',')
            cat(wilcox.test(unlist(tables[[i]][paste('V',k,sep='')]),unlist(tables[[j]][paste('V',k,sep='')]))$p.value)
        }
        cat('\n')
    }
}

