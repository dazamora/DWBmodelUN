#' @title Sogamoso River Basin data
#'
#' @format  The list contains
#' \itemize{
#'   \item{basins:}{ Shapefile featuring subbasins accross the Sogamosos Basin.}
#'   \item{cells:}{ Data frame, cells coordinates and its ID number.}
#'   \item{dwb_results:}{ List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'         aet- real evapo-transpiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'         s- soil storage, g- groundwater storage.}
#'   \item{GRU:}{ Raster, it represents the Group Response Units across the Sogamoso Basin.}
#'   \item{In_ground:}{ Raster, initial conditions in the soil storage.}
#'   \item{In_storage:}{ Raster, initial conditions in the groundwater storage.}
#'   \item{P_sogamoso:}{ Data frame, it should represent the cells in each row, and the precipitation
#'         info. by month in each column. The cell rank should match the cell ID in the cells data frame.}
#'   \item{param:}{ Data frame, it should represent a GRU in each row, and parameter values in each
#'         column. GRU rank should match the GRU number used in the GRU raster.}
#'   \item{PET_sogamoso:}{ Data frame, it contains evapotranspiration data, following the same
#'          format as the P_sogamoso variable.}
#'   \item{r.cells:}{ Raster, data frame Cells converted to raster format.}
#'   \item{setup_data:}{ Data frame, set-up and print options to run DWB model.}
#'   \item{basins:}{ Shapefile featuring subbasins accross the Sogamosos Basin.}
#'   \item{cells:}{ Data frame, cells coordinates and its ID number.}
#'   \item{dwb_results:}{ List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'         aet- real evapo-transpiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'         s- soil storage, g- groundwater storage.}
#'   \item{GRU:}{ Raster, it represents the Group Response Units across the Sogamoso Basin.}
#'   \item{In_ground:}{ Raster, initial conditions in the soil storage.}
#'   \item{In_storage:}{ Raster, initial conditions in the groundwater storage.}
#'   \item{P_sogamoso:}{ Data frame, it should represent the cells in each row, and the precipitation
#'         info. by month in each column. The cell rank should match the cell ID in the cells data frame.}
#'   \item{param:}{ Data frame, it should represent a GRU in each row, and parameter values in each
#'         column. GRU rank should match the GRU number used in the GRU raster.}
#'   \item{PET_sogamoso:}{ Data frame, it contains evapotranspiration data, following the same
#'          format as the P_sogamoso variable.}
#'   \item{r.cells:}{ Raster, data frame Cells converted to raster format.}
#'    \item{setup_data:}{ Data frame, set-up and print options to run DWB model.}
#'    \item{EscSogObs:}{ Mean runoff at discharge station}
#'    \item{simDWB.sogamoso:}{ Simulation results from Sogamoso using the model}
#' }
#' 
"sogamoso"

#' basins
#' 
#' The polygons of the 23 subbasins accross the Sogamosos Basin
#' 
#' @format SpatialPolygonsDataFrame (S4)
#' \describe{
#'   \item{basins}{Shapefile featuring subbasins accross the Sogamosos Basin.}
#' }
#'
#' @references
#' Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data scarce colombian watersheds,
#' by blending remote sensed and rain gauge data, using kernel functions. Master thesis.
#' Universidad Nacional de Colombia, Bogotá, Colombia. 
#'
"basins"

#' cells
#' 
#' Coordinates (Latitud and Longitud) and ID number of cells in Sogamoso River Basin
#' 
#' @format Data frame 
#' \describe{
#'   \item{cells}{Data frame (3 colums by 677 rows), cells coordinates and its ID number.}
#' }
#'
#' @references
#' Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data scarce colombian watersheds,
#' by blending remote sensed and rain gauge data, using kernel functions. Master thesis.
#' Universidad Nacional de Colombia, Bogotá, Colombia. Retrieved from http://bdigital.unal.edu.co/71663/.
#'
"cells"

#' dwb_results
#' 
#' Results from DWB in Sogamoso River Basin
#' 
#' @format A list with seven output variables from DWB results
#' \describe{
#'   \item{dwb_results}{List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'         aet- real evapotranspiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'         s- soil storage, g- groundwater storage.}
#' }
"dwb_results"

#' GRU
#' 
#' Raster data of Group Response Units in Sogamoso River Basin
#' 
#' @format A raster 
#' \describe{
#'   \item{GRU}{Raster, it represents the ten (10) Group Response Units across the Sogamoso River Basin.}
#' }
"GRU"

#' In_ground
#' 
#' XXX
#' 
#' @format A raster
#' \describe{
#'   \item{In_ground}{Raster, initial conditions in the soil storage.}
#' }
"In_ground"

#' In_storage
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{In_storage}{Raster, initial conditions in the groundwater storage.}
#' }
"In_storage"

#' P_sogamoso
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{P_sogamoso}{Data frame, it should represent the cells in each row, and the precipitation
#'         info. by month in each column. The cell rank should match the cell ID in the cells data frame.}
#' }
#'
#' @references
#' Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data scarce colombian watersheds,
#' by blending remote sensed and rain gauge data, using kernel functions. Master thesis.
#' Universidad Nacional de Colombia, Bogotá, Colombia. Retrieved from http://bdigital.unal.edu.co/71663/.
#'
"P_sogamoso"

#' param
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{param}{Data frame, it should represent a GRU in each row, and parameter values in each
#'         column. GRU rank should match the GRU number used in the GRU raster.}
#' }
"param"

#' PET_sogamoso
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{PET_sogamoso}{Data frame, it contains evapotranspiration data, following the same
#'          format as the P_sogamoso variable.}
#' }
#'
#' @references
#' Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data scarce colombian watersheds,
#' by blending remote sensed and rain gauge data, using kernel functions. Master thesis.
#' Universidad Nacional de Colombia, Bogotá, Colombia. Retrieved from http://bdigital.unal.edu.co/71663/.
#'
"PET_sogamoso"

#' r.cells
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{r.cells}{Raster, data frame Cells converted to raster format.}
#' }
"r.cells"

#' setup_data
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'    \item{setup_data}{Data frame, set-up and print options to run DWB model.}
#' }
"setup_data"

#' EscSogObs
#' 
#' XXX
#' 
#' @format XXX
#' \describe{
#'    \item{EscSogObs}{}
#' }
#' 
#' @references
#' Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data scarce colombian watersheds,
#' by blending remote sensed and rain gauge data, using kernel functions. Master thesis.
#' Universidad Nacional de Colombia, Bogotá, Colombia. Retrieved from http://bdigital.unal.edu.co/71663/.
#'
"EscSogObs"

#' simDWB.sogamoso
#' 
#' XXX
#' 
#' @format XXX
#' \describe{
#'    \item{simDWB.sogamoso}{}
#' }
"simDWB.sogamoso"
