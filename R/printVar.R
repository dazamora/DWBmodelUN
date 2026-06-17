#' @name 
#' printVar
#'  
#' @title
#' Print or write variables of interest
#' 
#' @description This function allows to print or write some of the variables simulated by the DWB model.
#' 
#' @param variable corresponds to the results of a specific variable of the DWBCalculator.
#' @param coor_cells coordinates of the cells in the same order that were simulated and that will be used to
#' create the results in raster format, this is done from the data frames which contain the simulated results
#' @param var_name name of the variable that will be printed (e.g., q_total, aet, r, qd, qb, s, g)
#' @param coord_sys geographic or projected coordinate system, in any notation accepted by \pkg{terra}
#' (e.g., \code{"EPSG:4326"} or a WKT string).
#' @param dates dates that were simulated.
#' @param as option to print the results as independent 'raster' (\emph{\code{.tif}}) files or in a single
#' 'NetCDF' (\emph{\code{.nc}}) file. Writing NetCDF files requires the \pkg{ncdf4} package.
#' @param path_var path of the directory where one wants to print the files. It is created if it does not exist.
#'
#' @author 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @return It writes in the requested folder a set of raster files (or a NetCDF file) with the results of the
#' variable of interest, and returns (invisibly) the written \code{SpatRaster}.
#'
#' @export 
#' 
#' @examples
#' data(sogamoso)
#' dwb_results <- sogamoso$dwb_results
#' data(cells)
#' dates <- seq(as.Date("2001-01-01"), as.Date("2010-12-01"), by="month")
#' coord_sys <- "EPSG:4326"
#' r <- dwb_results[[3]][,1:20]
#' printVar(r, cells, var_name = "r", coord_sys, dates, as = "NetCDF", path_var = tempdir())
#' 
printVar <- function(variable, coor_cells, var_name, coord_sys, dates, as, path_var = ""){
  
  if (missing(variable) || missing(coor_cells) || missing(var_name) ||
      missing(coord_sys) || missing(dates) || missing(as)) {
    stop("variable, coor_cells, var_name, coord_sys, dates, and as must be provided")
  }
  
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("The 'terra' package is required. Install it with install.packages('terra').")
  }
  
  if (path_var == "") {
    stop("There is no path_var, files can not be stored")
  }
  
  if (!dir.exists(path_var)) {
    dir.create(path_var, recursive = TRUE)
  }
  
  as <- match.arg(as, choices = c("raster", "NetCDF"))
  
  variable <- as.data.frame(variable)
  coor_cells <- as.data.frame(coor_cells)
  
  if (ncol(coor_cells) < 2) {
    stop("coor_cells must have at least two columns with x and y coordinates")
  }
  
  if (nrow(variable) != nrow(coor_cells)) {
    stop("variable and coor_cells must have the same number of rows")
  }
  
  if (length(dates) < ncol(variable)) {
    stop("dates must have at least as many values as the number of columns in variable")
  }
  
  xyz_data <- data.frame(
    x = coor_cells[[1]],
    y = coor_cells[[2]],
    variable
  )
  
  var_r <- terra::rast(xyz_data, type = "xyz", crs = coord_sys)
  names(var_r) <- paste0(var_name, "_", seq_len(terra::nlyr(var_r)))
  
  if (as == "raster") {
    for (i in seq_len(terra::nlyr(var_r))) {
      output_file <- file.path(
        path_var,
        paste0(var_name, "_", as.character(dates[i]), ".tif")
      )
      
      terra::writeRaster(
        var_r[[i]],
        filename = output_file,
        filetype = "GTiff",
        overwrite = TRUE
      )
    }
  } else if (as == "NetCDF") {
    if (!requireNamespace("ncdf4", quietly = TRUE)) {
      stop("The 'ncdf4' package is required to write NetCDF files. Install it with install.packages('ncdf4').")
    }

    output_file <- file.path(path_var, paste0(var_name, ".nc"))

    terra::writeCDF(
      x = var_r,
      filename = output_file,
      varname = var_name,
      overwrite = TRUE
    )
  }
  invisible(var_r)
}