#!/bin/R

library(data.table)
library(pbivnorm)

LSH_ascertain <- function(h2Obs,P,K){
  tP <- qnorm(P)
  tK <- qnorm(K)
  z <- dnorm(tK)
  xx <- h2Obs
  a1 <- 0
  a2 <- 1
  it <- 1
  while(abs(a2-a1) > 0.00000001){
    it <- it+1
    res <- h2Obs * (xx * z**2 + K - pbivnorm::pbivnorm(tK,tK,xx))**2 / z**2 * (1/(P*(1-P))) - xx

    if(res > 0){ #Find the solution from between xx and a2
      a1 <- xx
      xx <- 0.5*(a2 + xx)
    }
    if(res < 0){
      a2 <- xx
      xx <- 0.5*(a1 + xx)
    }
    if(it > 100){
      print("Has not converged in 100 steps")
      return(xx)
    }
  }

  return(xx)
}

h2_df <- read.table('Total_observed_h2.csv',sep='\t',header=T)
h2_df$LSH_h2 <- apply(h2_df[,c('h2_observe','samp_prev','pop_prev')], MARGIN = 1, function(x) LSH_ascertain(x[1],x[2],x[3]))
write.csv(h2_df,"Total_LSH_h2.csv")
