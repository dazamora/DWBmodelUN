#' dds
#'  
#' @title
#' DDS algorithm to calibrate the model
#'
#' @description This function allows the user to calibrate the DWB or other models with the Dynamical Dimension Search (DDS) algorithm \cite{(Tolson & Shoemaker, 2007)}.
#' As the calibration is performed based on a single value, one should average or create a scalar to evaluate the model's performance. The evaluation can be made using all
#' the streamflow stations, or other variables, between the observed and the simulated values.
#' 
#' @param xBounds.df must be a dataframe which defines the parameter range for searching, with 1st column as the minimum and 2nd column as the maximum of the parameter space.
#' @param numIter is an integer that defines the total number of simulations so as to calibrate the model.
#' @param iniPar is a vector which contains an optional initial parameter set.
#' @param r is a double between 0 and 1 which defines the range of searching in the DDS algorithm, the default value is 0.2.
#' @param OBJFUN is a function which returns a scalar value which one is trying to minimize. In this case, the scalar is
#' the Objective Function used to evaluate the model performance.
#' @param ... other variables and datasets needed to run the model.
#'
#' @return \code{outputs.df} is a four entry list, containing \code{X_BEST}, \code{Y_BEST}, \code{X_TEST} and \code{Y_TEST}, as they evolve over \code{numIter} iterations.
#' \code{X_BEST} and \code{Y_BEST} are the parameters found by the algorithm, parameters which produce a good value of the \strong{Objective Function} \code{Y_BEST}.
#' \code{X_TEST} and \code{Y_TEST} are the evaluated parameters and their respective performance value.
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#'
#' @references Tolson, B. A., & Shoemaker, C. A. (2007). "Dynamically
#' dimensioned search algorithm for computationally efficient watershed
#' model calibration". Water Resources Research, 43(1), 1-16.
#'
#' @examples
#' 
#' # Load P and PET databases
#' data(P_sogamoso, PET_sogamoso)
#' 
#' # Verify that the coordinates of the databases match
#' Coord_comparison(P_sogamoso, PET_sogamoso)
#' 
#' # Load geographic info of GRU and basins where calibration will be performed
#' data(GRU,basins)
#' cellBasins <- cellBasins(GRU, basins)
#' 
#' # Establish the initial modeling conditions
#' GRU.maps <- buildGRUmaps(GRU, param)
#' init <- init_state(GRU.maps$smaxR)
#' g_v <- init$In_ground
#' s_v <- init$In_storage
#' rm(init)
#' 
#' # Load general characteristics of modeling
#' setup_data <- readSetup(Read = TRUE)
#' Dates <- seq(as.Date( gsub('[^0-9.]','',colnames(P_sogamoso)[3]), 
#' format = "%Y.%m.%d"), 
#'              as.Date(gsub('[^0-9.]','',tail(colnames(P_sogamoso),1)) , 
#'              format = "%Y.%m.%d"), by = "month")
#' 
#' # For this calibration exercise, the last date of simulation is 
#' # the same as the final date of calibration
#' Start.sim <- which(Dates == setup_data[8,1])
#' End.sim <- which(Dates == setup_data[10,1])
#' # the first two columns of the P and PET are the coordinates of the cells
#' Sim.Period <- c(Start.sim:End.sim)+2 
#' Start.cal <- which(Dates == setup_data[9,1])
#' End.cal <- which(Dates == as.Date("2004-12-01"))
#' # the first two columns of the P and PET are the coordinates of the cells
#' Cal.Period <- c(Start.cal:End.cal)+2  
#' 
#' #Load observed runoff
#' data(EscSogObs)
#' 
#' # Function that runs the DWB model
#' NSE_Sogamoso_DWB <- function(parameters, P, PET, g_v,s_v, Sim.Period, EscObs, Cal.Period){
#' 
#' parameters <- as.vector(parameters)
#' # Transform the parameters to the format that the model needs
#' nGRU <- max(terra::values(terra::rast(GRU)), na.rm = TRUE)
#' param <- matrix(parameters, nrow = nGRU)
#' 
#' # Construction of parameter maps from values by GRU
#' GRU.maps <- buildGRUmaps(GRU, param)
#' alpha1_v <- GRU.maps$alpha1
#' alpha2_v <- GRU.maps$alpha2
#' smax_v <- GRU.maps$smax
#' d_v <- GRU.maps$d
#' DWB.sogamoso <- DWBCalculator(P_sogamoso[ ,Sim.Period], PET_sogamoso[ ,Sim.Period],
#'                               g_v,s_v, alpha1_v, alpha2_v, smax_v,d_v, calibration = TRUE)
#' Esc.Sogamoso <- varBasins(DWB.sogamoso$q_total, cellBasins$cellBasins)
#' 
#' # model evaluation; in case of possible NA results in the simulation,
#' # add a conditional assignment to a very high value
#' sim <- Esc.Sogamoso$varAverage[Cal.Period - 2, ]
#' # align the observations with the simulated basins (named by gauge code)
#' obs <- EscSogObs[Cal.Period - 2, paste0("X", colnames(sim))]
#' 
#' if (sum(!is.na(sim)) == prod(dim(sim))){
#'   numer <- apply((sim - obs)^2, 2, sum, na.rm = TRUE)
#'   demom <- apply((obs - apply(obs, 2, mean, na.rm = TRUE))^2, 2, sum, na.rm = TRUE)
#'   nse.cof <- 1 - numer / demom
#' } else {
#'   nse.cof <- NA
#' }
#' 
#' Perf <- (-1)*nse.cof
#' if(!is.na(mean(Perf))){ 
#'   Mean.Perf <- mean(Perf)
#'   } else {Mean.Perf <- 1e100}
#'      return(Mean.Perf)
#' }
#' 
#' # coupling with the DDS algorithm
#' xBounds.df <- data.frame(lower = rep(0, times = 40), upper = rep(c(1, 2000), times = c(30, 10)))
#' result <- dds(xBounds.df=xBounds.df, numIter=2, OBJFUN=NSE_Sogamoso_DWB,
#'               P=P_sogamoso, PET=PET_sogamoso, g_v=g_v, s_v=s_v, Sim.Period=Sim.Period, 
#'               EscObs=EscSogObs, Cal.Period=Cal.Period)
#' 
dds <- function(xBounds.df, numIter, iniPar = NA, r = 0.2, OBJFUN, ...){
  
  if (missing(xBounds.df) || ncol(xBounds.df) < 2) {
    stop("xBounds.df must have at least two columns: lower and upper bounds")
  }
  
  if (missing(numIter) || length(numIter) != 1 || numIter < 1) {
    stop("numIter must be an integer greater than or equal to 1")
  }
  
  if (missing(OBJFUN) || !is.function(OBJFUN)) {
    stop("OBJFUN must be a function")
  }
  
  if (length(r) != 1 || r <= 0 || r > 1) {
    stop("r must be greater than 0 and lower than or equal to 1")
  }
  
  xBounds.df <- as.data.frame(xBounds.df[, 1:2])
  colnames(xBounds.df) <- c("min", "max")
  
  if (any(!is.finite(as.matrix(xBounds.df)))) {
    stop("xBounds.df must contain finite numeric bounds")
  }
  
  if (any(xBounds.df$min >= xBounds.df$max)) {
    stop("Each lower bound must be smaller than its upper bound")
  }
  
  numIter <- as.integer(numIter)
  xDims <- nrow(xBounds.df)
  sigma <- xBounds.df$max - xBounds.df$min
  
  evaluate_objfun <- function(x) {
    y <- OBJFUN(as.numeric(x), ...)
    
    if (length(y) != 1) {
      stop("OBJFUN must return a single scalar value")
    }
    
    if (!is.finite(y) || is.na(y)) {
      y <- Inf
    }
    
    as.numeric(y)
  }
  
  reflect_bounds <- function(x) {
    below <- which(x < xBounds.df$min)
    if (length(below) > 0) {
      x[below] <- xBounds.df$min[below] + (xBounds.df$min[below] - x[below])
      still_below <- below[x[below] > xBounds.df$max[below]]
      if (length(still_below) > 0) {
        x[still_below] <- xBounds.df$min[still_below]
      }
    }
    
    above <- which(x > xBounds.df$max)
    if (length(above) > 0) {
      x[above] <- xBounds.df$max[above] - (x[above] - xBounds.df$max[above])
      still_above <- above[x[above] < xBounds.df$min[above]]
      if (length(still_above) > 0) {
        x[still_above] <- xBounds.df$max[still_above]
      }
    }
    
    pmin(pmax(x, xBounds.df$min), xBounds.df$max)
  }
  
  if (length(iniPar) == 1 && is.na(iniPar)) {
    x_current <- stats::runif(xDims, min = xBounds.df$min, max = xBounds.df$max)
  } else {
    x_current <- as.numeric(iniPar)
    
    if (length(x_current) != xDims) {
      stop("iniPar must have the same length as the number of parameters in xBounds.df")
    }
    
    x_current <- reflect_bounds(x_current)
  }
  
  y_current <- evaluate_objfun(x_current)
  
  x_best <- x_current
  y_best <- y_current
  
  X_TEST <- matrix(NA_real_, nrow = numIter, ncol = xDims)
  X_BEST <- matrix(NA_real_, nrow = numIter, ncol = xDims)
  Y_TEST <- rep(NA_real_, numIter)
  Y_BEST <- rep(NA_real_, numIter)
  
  X_TEST[1, ] <- x_current
  X_BEST[1, ] <- x_best
  Y_TEST[1] <- y_current
  Y_BEST[1] <- y_best
  
  pb <- utils::txtProgressBar(min = 0, max = numIter, style = 3)
  on.exit(close(pb), add = TRUE)
  utils::setTxtProgressBar(pb, 1)
  
  if (numIter > 1) {
    for (i in 2:numIter) {
      
      prob <- 1 - log(i) / log(numIter)
      idx <- which(stats::rbinom(xDims, size = 1, prob = prob) == 1)
      
      if (length(idx) == 0) {
        idx <- sample.int(xDims, size = 1)
      }
      
      x_candidate <- x_best
      perturbation <- rep(0, xDims)
      perturbation[idx] <- r * stats::rnorm(length(idx)) * sigma[idx]
      x_candidate <- reflect_bounds(x_candidate + perturbation)
      
      y_candidate <- evaluate_objfun(x_candidate)
      
      X_TEST[i, ] <- x_candidate
      Y_TEST[i] <- y_candidate
      
      if (y_candidate < y_best) {
        x_best <- x_candidate
        y_best <- y_candidate
      }
      
      X_BEST[i, ] <- x_best
      Y_BEST[i] <- y_best
      
      utils::setTxtProgressBar(pb, i)
    }
  }
  
  colnames(X_TEST) <- paste0("par_", seq_len(xDims))
  colnames(X_BEST) <- paste0("par_", seq_len(xDims))
  
  output.list <- list(
    X_BEST = X_BEST,
    Y_BEST = Y_BEST,
    X_TEST = X_TEST,
    Y_TEST = Y_TEST
  )
  
  return(output.list)
}