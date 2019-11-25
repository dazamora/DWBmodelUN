# DWBmodelUN
The R package DWBmodelUN aims to implement Dynamic Water Balance model proposed by Zhang el al.  (2008) in a monthly time step. It is a tool for hydrologic modelling using the Budyko Framework and the Dynamic Water Balance Model, with other tools to calibrate the model and analyze de outputs.


## CONCEPTS BEHIND DWBmodelUN
Two physical laws are taken into account in Dynamic Water Balance model (DWB), mass balance and energy balance. To represent the mass conservation, Dynamic Water Balance is based on the equilibrium of water balance shown in equation (1).  
ddtSct=Pt-ETSc,t -QSc,t-RSc,t       (1)

Where S is the total stored water in the basin, P is the precipitation, ET is actual evapotranspiration, Q corresponds to surface runoff and Q to aquifers recharge. To evaluate the water balance of a basin is necessary to know several kind information like climatic variables, catchment physical characteristics and further uniqueness relationships of each study. In the case of water balance models, some information can be replaced by equations and mathematical relations physically based, which makes the models much simpler but functional.
To represent energy conservation the model includes a conceptualization made by Budyko (1958) where the energy availability influences over the atmospheric water demand which is represented by potential evapotranspiration (PET). The conceptualization also states that the dominant control of the water balance is atmospheric demand and water availability (P), which impose a limit to how much water can be evapotranspirated. Zhang et al (2008) worked on the mathematical assumption presented by Fu (1981) (equation 2) that is a continuation of Budyko framework.

ETP=1+PETP-1-PETP11+∝1+∝    (2)

Where α is a model parameter with an interval of [0-1]. Zhang et al. (2008) detailed the influence of α parameter on the hydrological response in their model DWB.
Dynamic Water Balance (DWB) is a lumped conceptual hydrological model developed for annual and monthly time step. The model inputs are precipitation, potential evapotranspiration and streamflow. In general terms, DWB calculates the streamflow using two tanks and doing the following processes:
Precipitation is partitioned to basin water consumption and basin water yield. When it rains the soil is replenished and part of the rainfall is returned to the atmosphere, this process corresponds to basin water consumption, by the other hand, the remaining rainfall is the basin water yield.
Total water available for evapotranspiration is divided into water remaining in the soil storage and actual evapotranspiration.
The basin water yield is divided into surface runoff and water that supplies the groundwater store.
The base flow is the result of groundwater storage drainage.
The total monthly flow is the result of adding base flow and surface runoff.

All these processes are done under the Top Down approach so only four parameters are added to the model structure: α1, precipitation catchment efficiency; α, evapotranspiration efficiency; d, groundwater store time constant; Smax, maximum water holding capacity of soil store (Zhang et al., 2008)

## DESRCIPTION
The R package DWBmodelUN aims to implement Dynamic Water Balance model proposed by Zhang el al.  (2008) in a monthly time step. It is a tool for hydrologic modelling using the Budyko Framework and the Dynamic Water Balance Model, with other tools to calibrate the model and analyze de outputs.
DWBmodelUN contains 12 functions, most of them have a practical example about their usage. The functions are:
BuildGRUmaps(): This function builds raster maps for each parameter based on a raster file where the location of the Grouped Response Units (GRUs) are defined. 
cellBasins(): This function identifies the cells that are within a basin.
Coord_comparison():  This function compares three characteristics from two rasters: coordinates, resolution, and number of layers
dds(): This function allows the user to calibrate the DWB or other models with the Dynamical Dimension Search (DDS) algorithm (Tolson & Shoemaker, 2007). 
DWBCalculator(): The function performs the distributed DWB hydrological model calculations in the defined domain and time period.
funFU(): Fu's function for relationship between precipitation and potential evapotranspiration.
graphDWB(): This function dynamically graphs the inputs and results of the DWBmodelUN. It has four types of graphs.
init_state(): This function uploads or creates the initial conditions of the two-state variables present in the DWB model, in raster format. 
printVar(): This function that allows to print some of the variables simulated by the DWB model.
readSetup(): This function reads the setup features of the model. These include the dates that define the simulated time period, and also the variables that will be printed in individual directories
upForcing(): This function loads the precipitation and evapotranspiration estimates that will be used to run or force the DWB model 
varBasins(): This function retrieves the value of a variable in each of the cells that are within a basin boudary. It also returns the time serie average value of the variable.

DWBmodelUN also contains 11 data that allow to run the practical examples:
basins: 
cells: 
dwb_results:
EscSogObs: 
GRU: 
param: 
PET_sogamoso
setup_data
simDWB.sogamoso
sogamoso: Sogamoso River Basin data
P_sogamoso:
r.cells:

##EXAMPLES OF USE

USING buildGRUmaps
# library(raster)
data(GRU)    
data(param)
gru_maps <- buildGRUmaps(GRU, param)

# Not run, this an example on how to upload your own files
# GRU <- raster("./directory/gru2_cober_location.tif")
# param <- read.csv("./directory/param_dwb.csv")
# gru_maps <- buildGRUmaps(GRU, param)

USING cellBasins
data("GRU","basins")
cellBasins <- cellBasins(GRU, basins)

USING Coord_comparison
data(P_sogamoso, PET_sogamoso)
Coord_comparison(P_sogamoso, PET_sogamoso)

USING dds
# Load P and PET databases
data(P_sogamoso, PET_sogamoso)

# Verify that the coordinates of the databases match
Coord_comparison(P_sogamoso, PET_sogamoso)

# Load geographic info of GRU and basins where calibration will be performed
data(GRU,basins)
cellBasins <- cellBasins(GRU, basins)

# Establish the initial modeling conditions
GRU.maps <- buildGRUmaps(GRU, param)
init <- init_state(GRU.maps$smaxR, "/in_state/")
g_v <- init$In_ground
s_v <- init$In_storage
rm(init)

# Load general characteristics of modeling
setup_data <- readSetup(Read = TRUE)
Dates <- seq(as.Date(colnames(P_sogamoso)[3], format = "%Y.%m.%d"), 
             as.Date(tail(colnames(P_sogamoso),1), format = "%Y.%m.%d"), by = "month")

# For this calibration exercise, the last date of simulation is 
# the same as the final date of calibration
Start.sim <- which(Dates == setup_data[8,1])
End.sim <- which(Dates == setup_data[11,1])
# the first two columns of the P and PET are the coordinates of the cells
Sim.Period <- c(Start.sim:End.sim)+2 
Start.cal <- which(Dates == setup_data[9,1])
End.cal <- which(Dates == setup_data[11,1])
# the first two columns of the P and PET are the coordinates of the cells
Cal.Period <- c(Start.cal:End.cal)+2  

#Load observed runoff
data(EscSogObs)

# Function that runs the DWB model
NSE_Sogamoso_DWB <- function(parameters, P, PET, g_v,s_v, Sim.Period, EscObs, Cal.Period){

parameters <- as.vector(parameters)
# Transform the parameters to the format that the model needs
param <- matrix(parameters, nrow = raster::cellStats(GRU,stat="max"))  

# Construction of parameter maps from values by GRU
GRU.maps <- buildGRUmaps(GRU, param)
alpha1_v <- GRU.maps$alpha1
alpha2_v <- GRU.maps$alpha2
smax_v <- GRU.maps$smax
d_v <- GRU.maps$d
DWB.sogamoso <- DWBCalculator(P_sogamoso[ ,Sim.Period], PET_sogamoso[ ,Sim.Period],
                              g_v,s_v, alpha1_v, alpha2_v, smax_v,d_v, calibration = TRUE)
Esc.Sogamoso <- varBasins(DWB.sogamoso$q_total, cellBasins$cellBasins)

# model evaluation; in case of possible NA results in the simulation, 
# add a conditional assingment to a very high value
sim <- Esc.Sogamoso$varAverage[Cal.Period, 1]
obs <- EscSogObs[Cal.Period, 1]
nse.cof <- 1-sum((sim - obs)^2, na.rm = TRUE)/sum((obs - mean(obs, na.rm = TRUE))^2, na.rm = TRUE)
Perf <- (-1)*nse.cof
if(!is.na(mean(Perf))){ 
  Mean.Perf <- mean(Perf)
  } else {Mean.Perf <- 1e100}
     return(Mean.Perf)
}

# coupling with the DDS algorithm
xBounds.df <- data.frame(lower = rep(0, times = 40), upper = rep(c(1, 2000), times = c(30, 10)))
result <- dds(xBounds.df = xBounds.df, numIter=200, OBJFUN=NSE_Sogamoso_DWB,
              P = P_sogamoso, PET = PET_sogamoso, g_v = g_v, s_v = s_v, Sim.Period = Sim.Period, 
              EscObs = EscSogObs, Cal.Period = Cal.Period)

USING DWBCalculator
# Load P and PET databases
data(P_sogamoso, PET_sogamoso)
 
# Verify that the coordinates of the databases match
Coord_comparison(P_sogamoso, PET_sogamoso)
# Load geographic info of GRU and parameters per cell
data(GRU, param)
# Construction of parameter maps from values by GRU
GRU.maps <- buildGRUmaps(GRU, param)
alpha1_v <- GRU.maps$alpha1
alpha2_v <- GRU.maps$alpha2
smax_v <- GRU.maps$smax
d_v <- GRU.maps$d

# Establish the initial modeling conditions
init <- init_state(GRU.maps$smaxR, "/in_state/")
g_v <- init$In_ground
s_v <- init$In_storage
rm(init)

# Load general characteristics of modeling
setup_data <- readSetup(Read = TRUE)
Dates <- seq(as.Date(colnames(P_sogamoso)[3],format = "%Y.%m.%d"), 
             as.Date(tail(colnames(P_sogamoso),1),format="%Y.%m.%d"), by = "month")
Start.sim <- which(Dates == setup_data[8,1]); End.sim <- which(Dates == setup_data[10,1])
# Sim.Period: the 1st two columns of the P and PET are the coordinates of the cells
Sim.Period <- c(Start.sim:End.sim)+2  

# Run DWB model
DWB.sogamoso <- DWBCalculator(P_sogamoso[ ,Sim.Period], 
                    PET_sogamoso[ ,Sim.Period],
                    g_v, s_v, alpha1_v, alpha2_v, smax_v, d_v)
                    

USING funFU
PET <- 1000
P <- 2000
alpha <- 0.69  # value used by Zhang et al. (2008) 
funFU(PET, P, alpha)


USING graphDWB
# Example 1
data(P_sogamoso)
P.est <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
var <- list("Precipitation" = P.est)
 graphDWB(var, tp = 1, main = "Precipitation Lat:7.0 Lon:-72.94")




# Example 2
data(simDWB.sogamoso, EscSogObs)
runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
var <- list("Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
 graphDWB(var, tp = 2, main = "Runoff: Gauge 23147020")



# Example 3
data(P_sogamoso, simDWB.sogamoso, EscSogObs)
P.est <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
var <- list("Precipitation" = P.est,"Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
graphDWB(var, tp = 3, main = "DWB results at Sogamoso Basin")



# Example 4
data(P_sogamoso, PET_sogamoso, simDWB.sogamoso)
P <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
PET <- ts(c(t(PET_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
var <- list("P" = P,"PET" = PET, "Runoff.sim" = runoff.sim)
graphDWB(var, tp = 4, main = "General Comparison Sogamoso Basin")



USING printVAR
data(dwb_results)
data(cells)
dates <- seq(as.Date("2001-01-01"), as.Date("2016-12-01"), by="month")
coord_sys <- "+init=epsg:4326"
printVar(dwb_results[[3]], cells, var = "r", coord_sys, dates, "NetCDF")


USING readSetup
setup <- readSetup(Read = TRUE)  # run if you would like to upload the example setup

data(setup_data)
setup <- readSetup(Read = TRUE, setup_data)

# example on how to create your own setup
a <- rep("no",7)
b <- "1990-01-01"
c <- "1991-01-01"
d <- "2012-12-15"
e <- "2012-12-10"
table_setup <- data.frame(set=a,stringsAsFactors = FALSE)
table_setup <- rbind(table_setup, b, c, d, e)
setup <- readSetup(Read = FALSE, table_setup)


USING upForcing
#Not run
# meteo <- upForcing(path_p = "./precip/", path_pet = "./pet/",
# file_type = "raster", format = "NCDF")
# meteo <- upForcing(path_p = "./precip/", path_pet = "./pet/",
# file_type = "csv")

USING varBasins
data(dwb_results,GRU,basins)
Run <- dwb_results$q_total
cellBasins <- cellBasins(GRU, basins)
cellBasins <- cellBasins$cellBasins
Runfoff.Sogamoso <- varBasins(Run, cellBasins)



## INSTALLATION
You can install the DWBmodelUN package from CRAN as follows:
For the stable version	install.package(“DWBmodelUN”)
Depends		R (>= 3.4.1)
Imports			dygraphs, hmltools, raster, rgdal, ncdf4.
Suggets			hydroGOF


## REFERENCES
Budyko, M. . (1958). The heat balance of the earth’s surface (U. . D. of Commerce, ed.). Washington D.C: Translate from russian by N.A Stepanova.
Fu, B. (1981). On the calculation of the evaporation from land surface. Chinese Journal of Atmospheric Sciences, 23–31.
Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). Water balance modeling over variable time scales based on the Budyko framework - Model development and testing. Journal of Hydrology, 360(1–4), 117–131. https://doi.org/10.1016/j.jhydrol.2008.07.021