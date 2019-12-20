#' @title Clean BENTHOS database
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@fondationbiodiversite.fr}



#' ----------------------------------------------------------------------------- @ImportHabitatsCodes

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "habitats_code.csv"
)

codes <- readr::read_csv2(filename)



#' ----------------------------------------------------------------------------- @ImportHabitatsData

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "RORC_Benthos_180807.xlsx"
)

habitats <- readxl::read_excel(path = filename, sheet = 1)

habitats <- as.data.frame(habitats)
habitats <- habitats[ , c(9, 11:26)]
colnames(habitats)[1:4] <- c("year", "site", "station", "transect")

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "RORC_Benthos_191027.xlsx"
)

temp <- readxl::read_excel(path = filename, sheet = 1)

temp <- as.data.frame(temp)
temp <- temp[ , c(9, 11:26)]
colnames(temp)[1:4] <- c("year", "site", "station", "transect")

habitats <- rbind(habitats, temp)



#' ----------------------------------------------------------------------------- @SelectYears

habitats[ , "year"] <- habitats[ , "year"] + 1

habitats <- habitats[habitats[ , "year"] > 2003, ]



#' ----------------------------------------------------------------------------- @RemoveDuplicates

keys <- paste(
  habitats[ , "year"],
  habitats[ , "site"],
  habitats[ , "station"],
  habitats[ , "transect"],
  sep = "__"
)

pos <- which(duplicated(keys))

if (length(pos) > 0) { habitats <- habitats[-pos, ] }


habitats <- habitats[with(habitats, order(year, site, station, transect)), ]
rownames(habitats) <- NULL

habitats <- reshape2::melt(habitats, id = c("year", "site", "station", "transect"))

habitats <- merge(habitats, codes[ , -2], by.x = "variable", by.y = "code", all = TRUE)



#' ----------------------------------------------------------------------------- @OpenTemplate

filename <- file.path(
  "data",
  "Templates",
  "Datasheet_Template_Benthic.xlsx"
)

col_names <- readxl::read_xlsx(path = filename, sheet = 2, col_types = "text", n_max = 0)
col_names <- as.data.frame(col_names)

template <- as.data.frame(matrix(nrow = nrow(habitats), ncol = ncol(col_names)))
colnames(template) <- colnames(col_names)

template[ , "DatasetID"]    <- "RORC (New Caledonian Coral Reef Monitoring Network)"
template[ , "SurveyID"]     <- NA
template[ , "Ocean"]        <- "Pacific"
template[ , "Country"]      <- "France"
template[ , "Archipelago"]  <- "New Caledonia"
template[ , "Location"]     <- habitats[ , "site"]
template[ , "Site"]         <- habitats[ , "station"]
template[ , "Replicate"]    <- habitats[ , "transect"]
template[ , "Year"]         <- habitats[ , "year"]
template[ , "CategoryFine"] <- habitats[ , "english"]
template[ , "Cover"]        <- habitats[ , "value"]
template[ , "Precision"]    <- "Group"
template[ , "Observer"]     <- "Admin"
template[ , "Method"]       <- "Point intersect transect, 50 m transect length, every 50 cm"



#' ----------------------------------------------------------------------------- @ImportStationsCoords


filename <- file.path(
  "data",
  "New Caledonia RORC",
  "stations_coordinates.xlsx"
)


sta_coords <- readxl::read_xlsx(path = filename, sheet = 1, skip = 0)
sta_coords <- as.data.frame(sta_coords)

sta_coords <- sta_coords[ , c("station", "site_name", "station_name", "longitude", "latitude")]

template <- merge(x = template, y = sta_coords, by.x = "Site", by.y = "station", all = TRUE)

template[ , "Longitude"] <- template[ , "longitude"]
template[ , "Latitude"]  <- template[ , "latitude"]
template[ , "Site"]      <- template[ , "station_name"]
template[ , "Location"]  <- template[ , "site_name"]



#' ----------------------------------------------------------------------------- @ImportStationsInfos


filename <- file.path(
  res_dir_fish_data_clean,
  "RORC_NCL_Fish_Dataset.xlsx"
)


sta_infos <- readxl::read_xlsx(path = filename, sheet = 1, skip = 0)
sta_infos <- as.data.frame(sta_infos)

sta_infos <- sta_infos[ , c("Location", "Site", "Replicate", "Year", "Zone", "Depth")]

keys <- unique(
  paste(
    sta_infos[ , "Location"],
    sta_infos[ , "Site"],
    sta_infos[ , "Replicate"],
    sta_infos[ , "Year"],
    sta_infos[ , "Zone"],
    sta_infos[ , "Depth"],
    sep = "__"
  )
)

sta_infos <- strsplit(keys, "__")
sta_infos <- data.frame(
  matrix(
    unlist(sta_infos),
    nrow = length(sta_infos),
    byrow = TRUE
  )
)

colnames(sta_infos) <- c("Location", "Site", "Replicate", "Year", "Zone", "Depth")

template[ , "key"] <- paste(
  template[ , "Location"],
  template[ , "Site"],
  template[ , "Replicate"],
  template[ , "Year"],
  sep = "__"
)

sta_infos[ , "key"] <- paste(
  sta_infos[ , "Location"],
  sta_infos[ , "Site"],
  sta_infos[ , "Replicate"],
  sta_infos[ , "Year"],
  sep = "__"
)

sta_infos <- sta_infos[ , c("key", "Zone", "Depth")]
colnames(sta_infos) <- tolower(colnames(sta_infos))

template <- merge(x = template, y = sta_infos, by = "key", all = TRUE)

pos <- which(is.na(template$Country))
if (length(pos) > 0) { template <- template[-pos, ] }

template[ , "Depth"] <- template[ , "depth"]
template[ , "Zone"]  <- template[ , "zone"]

template <- template[with(template, order(Year, Location, Site, Replicate, CategoryFine)), colnames(col_names)]
rownames(template) <- NULL

writexl::write_xlsx(x = template, path = file.path(res_dir_benthos_data_clean, "RORC_NCL_Benthic_Dataset.xlsx"))
