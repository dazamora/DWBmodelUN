#'Sogamoso
#'
#' A list with multiple feautures from the Sogamoso River Basin (Colombia)
#'
#'@format The list contains
#'\describe{
#'\item{basins}{Shapefile featuring subbasins accross the Sogamosos Basin}
#'\item{cells}{Data frame, cells coordinates and its ID number}
#'\item{dwb_results}{List, it contains the DWB model's outputs in matrix format, q_total- total runoff,
#'aet- real evapo-transpiration, r- recharge, qd- Surface runoff, qd- baseflow,
#'s- soil storage, g- groundwater storage}
#'\item{GRU}{Raster, it represents the Group Response Units across the Sogamoso Basin}
#'\item{In_ground}{Raster, initial conditions in the soil storage}
#'\item{In_storage}{Raster, initial conditions in the groundwater storage}
#'\item{P_sogamoso}{Data frame, it should represent the cells in each row, and the precipitation
#'info. by month in each column. The cell rank should match the cell ID in the cells data frame}
#'\item{param}{Data frame, it should represent a GRU in each row, and parameter values in each
#'column. GRU rank should match the GRU number used in the GRU raster}
#'\item{PET_sogamoso}{Data frame, it contains evapotranspiration data, following the same
#'format as the P_sogamoso variable}
#'\item{r.cells}{Raster, data frame Cells converted to raster format}
#'\item{setup_data}{Data frame, set-up and print options to run DWB model}
#'
#'sogamoso = list(basins = basins,cells = cells,dwb_results = dwb_results,GRU = GRU,In_ground = In_ground,In_storage = In_storage,P_sogamoso = P_sogamoso,param = param,PET_sogamoso = PET_sogamoso,r.cells = r.cells, setup_data = setup_data)
#'
#'}
#'
#'
#'
#'
#'
#'