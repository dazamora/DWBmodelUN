#' @name 
#' UH
#'
#' @title
#' Unit hydrograph
#'
#' @description Txxx
#'
#' @param branch xx
#' 
#' @param OrdUH xx
#' 
#' @param NH xx
#' 
#' @param C xx
#' 
#' @param D xx
#' 
#' @return xxx
#'  
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' Camila García-Echeverri <cagarciae@unal.edu.co> \cr
#'  
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#' 
#' @examples
#' 

UH <- function(branch, NH, C, D=2.5){
  if(branch == 1){
    OrdUH1 <- list()
    
    SS1_fun <- function(I, C, D){
      FI <- I
      if(FI<=0){SS1 <- 0
      } else if(FI>0 & FI <= C){SS1 <- FI/C**D
      } else {SS1 <- 1}
    }
    
    # SS1_1 <- rep(NA, length(C))
    # SS1_2 <- rep(NA, length(C))

    for(p in 1:length(C)){
      OrdUH1[[p]] <- rep(NA, NH)
      for(I in 1:NH){
        # SS1_1 <-  SS1_fun(I,C[p],D)
        # SS1_2 <-  SS1_fun(I-1,C[p],D)
      
        OrdUH1[[p]][I] <- SS1_fun(I,C[p],D)- SS1_fun(I-1,C[p],D)
    
      }
    }

    return(OrdUH1)   
    
  } else if(branch == 2){
    OrdUH2 <- list()
    
    SS2_fun <- function(I, C, D){
      FI <- I
      if(FI<=0){SS2 <- 0
      } else if(FI>0 & FI <= C){SS2 <- 0.5*(FI/C)**D
      } else if(FI>C & FI <= 2*C){SS2 <- 1-0.5*(2-FI/C)**D
      } else {SS2 <- 1}
    }
    
    for(p in 1:length(C)){
      OrdUH2[[p]] <- rep(NA, NH)
      for(I in 1:(2*NH)){
        # SS1_1 <-  SS1_fun(I,C[p],D)
        # SS1_2 <-  SS1_fun(I-1,C[p],D)
        
        OrdUH2[[p]][I] <- SS2_fun(I,C[p],D)- SS2_fun(I-1,C[p],D)
        
      }
    }
    
    # for(I in 1:NH){
    #   OrdUH2[I] <- SS2_fun(I,C,D)- SS2_fun(I-1,C,D)
    # }

    return(OrdUH2)  
    
  } else {
    stop('Wrong type of branch')
  }
} 
