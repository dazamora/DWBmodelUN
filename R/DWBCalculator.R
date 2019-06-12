#' @name 
#' DWB model function
#' 
#' @title
#' DWB model function
#'
#' @description The function performs the distibuted DWB hydrological model calculations in the defined domain and
#' time period. It is a model based on the postulates of Budyko, which stated that not only does the actual
#' evapotrasnpiration depend on potential evapotranspiration, but it is also contrained by water availability
#' \cite{(Budyko, 1974)}. The monthly Dynamic Water Balance is underpinned in the demand and supply limits demonstrated
#' by \code{\link{Fu's function}}, postulate that is applied to three variables in order to acquire the values
#' of the fluxes and state variables on a monthly time step. The named variables affected by \code{\link{Fu's function}} 
#' are: the available storage capacity (\emph{\code{X}}), the evapotranspiration oportunity (\emph{\code{Y}})
#' and the actual evapotranspiration (\emph{\code{ET}}). The model is controlled by four parameters: retention
#' efficiency (\emph{\code{\expression{alpha_1}}}), evapotranspiration efficiency (\emph{\code{\expression{alpha_2}}}),
#' soil water storage capacity (\emph{\code{\expression{S_max}}}), and a recession parameter in the groundwater
#' storage that controls the baseflow (\emph{\code{\expression{d}}}). 
#'
#' @param p_v matrix comprised by the precipitation records and that has as raws the number of cells that will be simulated and as columns the number of time steps to be simulated
#' @param pet_v matrix comprised by the potential evapotranspiration records and that has as raws the number of cells that will be simulated and as columns the number of time steps to be simulated
#' @param g_v vector comprised by the initial values of the ground water storage, it must have as many values as cells defined to simulate
#' @param s_v vector comprised by the initial values of the soil water storage, it must have as many values as cells defined to simulate
#' @param alpha1_v vector comprised by the values of the retention efficiency that must be between 0 and 1, it must have as many values as cells defined to simulate
#' @param alpha2_v vector comprised by the values of the evapotranspiration efficiency that must be between 0 and 1, it must have as many values as cells defined to simulate
#' @param smax_v vector comprised by the values of the soil water storage capacity that must be above 0, it must have as many values as cells defined to simulate
#' @param d_v vector comprised by the values of the recession constant that must be between 0 and 1, it must have as many values as cells defined to simulate 
#'
#' @details \code{dwbCalculator()} only performs one simulation of the distributed hydrological model. The decision to perform
#' other kind of procedure, such as calibration or assimilation, is entirely on modellers' requirements and necessities.
#' A complementary function is available in the package to calibrate the model (\code{\link{dds}}), which has proved to
#' be effective in calibrating models with several GRUs.
#' 
#' To start the model one should set the model features using the (\code{\link{readSetup}}) function, load the precipitation
#' and evapotranspiration forcings with the (\code{\link{upForcing}}) function, build the GRU and parameter maps with the
#' (\code{\link{buildGRUmaps}}) function, compare the coordinates of the uploaded datasets (i.e. the forcings and GRU cells),
#' set the initial conditions of the soil moisture and the groundwater storage, and run the model with \code{dwbCalculator} function.
#'
#' @return a list comprised by the time series of the hydrological fluxes calculated by the model. The fluxes are:
#' the total runoff, the actual evapotranspiration, the groundwater recharge, the surface runoff, the baseflow and
#' the soil water storage. The time series have the same length as the forcings that where employed to run the model
#' 
#' @references 
#' Budyko. (1974). Climate and life. New York: Academic Press, INC.
#' 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). 
#' Water balance modeling over variable time scales based on the Budyko framework - 
#' Model development and testing. Journal of Hydrology, 360(1-4), 117-131.
#' https://doi.org/10.1016/j.jhydrol.2008.07.021
#' 
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>
#' David Andres Zamora Avila<dazamoraa@unal.edu.co>
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @export
#'
#' @examples
#' 
#' 
DWBCalculator <- function(p_v, pet_v, g_v, s_v, alpha1_v, alpha2_v, smax_v, d_v){
  
  # total number of cells and time steps to be simulated
  ncells <- NROW(p_v)
  nmonths <- NCOL(p_v)
  
  # ---- Set the object variables with NA values ----
  xo <- matrix(nrow = ncells, ncol = nmonths)  # demand limit of rainfall retention
  x  <- matrix(nrow = ncells, ncol = nmonths)  # rainfall retention
  qd <- matrix(nrow = ncells, ncol = nmonths)  # surface runoff
  w  <- matrix(nrow = ncells, ncol = nmonths)  # water availability
  yo <- matrix(nrow = ncells, ncol = nmonths)  # demand limit of evapotranspiration opportunity
  y  <- matrix(nrow = ncells, ncol = nmonths)  # evapotranspiration opportunity
  r  <- matrix(nrow = ncells, ncol = nmonths)  # Groundwater recharge
  aet <- matrix(nrow = ncells, ncol = nmonths) # actual evapotranspiration
  s  <- matrix(nrow = ncells, ncol = nmonths)  # soil moisture storage
  qb <- matrix(nrow = ncells, ncol = nmonths)  # base flow
  g  <- matrix(nrow = ncells, ncol = nmonths)  # groundwater storage
  q_total <- matrix(nrow = ncells, ncol = nmonths)  # total runoff
  
  # Calculation of the variables and fluxes for the first time step
  dummy   <- smax_v - s_v
  xo[, 1] <- dummy + pet_v[, 1]
  x[, 1]  <- p_v[, 1] * fun_FU(PET = xo[, 1], P = p_v[, 1], param = alpha1_v)
  qd[, 1] <- p_v[, 1] - x[, 1]
  w[, 1]  <- x[, 1] + s_v
  yo[, 1] <- pet_v[, 1] + smax_v
  y[, 1]  <- w[, 1] * fun_FU(PET = yo[, 1], P = w[, 1], param = alpha2_v)
  r[, 1]  <- w[, 1] - y[, 1]
  aet[, 1] <- w[, 1] * fun_FU(PET = pet_v[, 1], P = w[, 1], param = alpha2_v)
  s[, 1]  <- y[, 1] - aet[, 1]
  qb[, 1] <- d_v * g_v
  g[, 1]  <- (1 - d_v) * g_v + r[, 1]
  q_total[, 1] <- qb[, 1] + qd[, 1]
  
  # Loop defined to calculate the variables and fluxes in the following timesteps
  pb <- txtProgressBar(min = 0, max = nmonths, style = 3)
  for(i in 2:nmonths){
    
    dummy   <- smax_v - s[, (i-1)]
    xo[, i] <- dummy + pet_v[, i]
    x[, i]  <- p_v[, i] * fun_FU(PET = xo[, i], P = p_v[, i], param = alpha1_v)
    qd[, i] <- p_v[, i] - x[, i]
    w[, i]  <- x[, i] + s[, (i-1)]
    yo[, i] <- pet_v[, i] + smax_v
    y[, i]  <- w[, i] * fun_FU(PET = yo[, i], P = w[, i], param = alpha2_v)
    r[, i]  <- w[, i] - y[, i]
    aet[, i] <- w[, i] * fun_FU(PET = pet_v[, i], P = w[, i], param = alpha2_v)
    s[, i]  <- y[, i] - aet[, i]
    qb[, i] <- d_v * g[, (i-1)]
    g[, i] <- (1-d_v) * g_v + r[, i]
    q_total[, i] <- qb[, i] + qd[, i]
    
    setTxtProgressBar(pb, i)
  }
  close(pb)
  
  #---- return ----
  dwb_aux <- list(q_total, aet, r, qd, qb, s, g)
  return(dwb_aux)
  
}