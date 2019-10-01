#' @title Clean FISH database
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@gmail.com}



#' ----------------------------------------------------------------------------- @ImportFishCounts

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Intermediate_allstations_2003-2019.xls"
)

counts <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")



#' ----------------------------------------------------------------------------- @ImportStationsInfos

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Observation_allstations_2003-2019.xls"
)

stations <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")
