#' Sogamoso
#'
#' A list with multiple feautures from the Sogamoso River Basin (Colombia)
#'
#' @format The list contains
#' \describe{
#'   \item{basins}{Shapefile featuring subbasins accross the Sogamosos Basin.}
#'   \item{cells}{Data frame, cells coordinates and its ID number.}
#'   \item{dwb_results}{List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'         aet- real evapo-transpiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'         s- soil storage, g- groundwater storage.}
#'   \item{GRU}{Raster, it represents the Group Response Units across the Sogamoso Basin.}
#'   \item{In_ground}{Raster, initial conditions in the soil storage.}
#'   \item{In_storage}{Raster, initial conditions in the groundwater storage.}
#'   \item{P_sogamoso}{Data frame, it should represent the cells in each row, and the precipitation
#'         info. by month in each column. The cell rank should match the cell ID in the cells data frame.}
#'   \item{param}{Data frame, it should represent a GRU in each row, and parameter values in each
#'         column. GRU rank should match the GRU number used in the GRU raster.}
#'   \item{PET_sogamoso}{Data frame, it contains evapotranspiration data, following the same
#'          format as the P_sogamoso variable.}
#'   \item{r.cells}{Raster, data frame Cells converted to raster format.}
#'   \item{setup_data}{Data frame, set-up and print options to run DWB model.}
#'}
"sogamoso"

#' basins
#' 
#' XXXXX
#' 
#' @format The list contains
#' \describe{
#'   \item{basins}{Shapefile featuring subbasins accross the Sogamosos Basin.}
#' }
"basins"

#' cells
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{cells}{Data frame, cells coordinates and its ID number.}
#' }
"cells"

#' dwb_results
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{dwb_results}{List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'         aet- real evapo-transpiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'         s- soil storage, g- groundwater storage.}
#' }
"dwb_results"

#' GRU
#' 
#' XXX
#' 
#' @format The list contains
#' \describe{
#'   \item{GRU}{Raster, it represents the Group Response Units across the Sogamoso Basin.}
#' }
"GRU"

#' In_ground
#' 
#' XXX
#' 
#' @format The list contains
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
