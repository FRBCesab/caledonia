#' @title Clean FISH database
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@fondationbiodiversite.fr}



#' ----------------------------------------------------------------------------- @ImportFishCounts

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Intermediate_allstations_2003-2019.xls"
)

counts <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")
counts <- as.data.frame(counts)
counts <- counts[!is.na(counts[ , "Survey ID"]), ]

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Intermediate_RORC2018_IleOuen.xls"
)

temp <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")
temp <- as.data.frame(temp)

counts <- rbind(counts, temp)



#' ----------------------------------------------------------------------------- @ImportStationsInfos


filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Observation_allstations_2003-2019.xls"
)

stations <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")
stations <- as.data.frame(stations)
stations <- stations[!is.na(stations[ , "sample_ID"]), ]

filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Fish_Observation_RORC2018_IleOuen.xls"
)

temp <- readxl::read_xls(path = filename, sheet = 1, col_types = "text")
temp <- as.data.frame(temp)

stations <- rbind(stations, temp)



#' ----------------------------------------------------------------------------- @CreateIdentifiers


stations[ , "Date de l'Observation"] <- as.Date(
  stations[ , "Date de l'Observation"],
  format = "%d/%m/%Y"
)

years <- substr(stations[ , "Date de l'Observation"], 3, 4)

sites <- paste0("0", stations[ , "Identifiant Site"])
sites <- substr(sites, nchar(sites) - 1, nchar(sites))

stas <- paste0("0", stations[ , "Identifiant Station"])
stas <- substr(stas, nchar(stas) - 1, nchar(stas))

stations[ , "noid"] <- paste0(
  "NCLI",
  years,
  stations[ , "Cible"],
  sites,
  stas
)



#' ----------------------------------------------------------------------------- @MergeDatasets


datas <- merge(
  x     = stations,
  y     = counts,
  by.x  = "sample_ID",
  by.y  = "Survey ID",
  all.x = TRUE,
  all.y = FALSE
)



#' ----------------------------------------------------------------------------- @RemoveDuplicates


datas <- datas[grep("A$", datas$sample_ID), ]

keys <- paste(
  datas[ , "noid"],
  datas[ , "Replicate"],
  datas[ , "Scientific name"],
  sep = "__"
)

kkeys <- keys[which(duplicated(keys))]

if (length(kkeys) > 0) {
  for (key in kkeys) {
    pos <- which(keys == key)
    datas[pos[1], "Number of individus"] <- sum(as.numeric(datas[pos, "Number of individus"]))
  }

  datas <- datas[-which(duplicated(keys)), ]
}




#' ----------------------------------------------------------------------------- @OpenTemplate


filename <- file.path(
  "data",
  "Templates",
  "Datasheet_Template_Fish.xlsx"
)

col_names <- readxl::read_xlsx(path = filename, sheet = 2, col_types = "text", n_max = 0)
col_names <- as.data.frame(col_names)

template <- as.data.frame(matrix(nrow = nrow(datas), ncol = ncol(col_names)))
colnames(template) <- colnames(col_names)


template[ , "DatasetID"]   <- "RORC (New Caledonian Coral Reef Monitoring Network)"
template[ , "SurveyID"]    <- NA
template[ , "Area"]        <- "Pacific"
template[ , "Country"]     <- "France"
template[ , "Archipelago"] <- "New Caledonia"
template[ , "Zone"]        <- unlist(
  lapply(
    datas[ , "Type de Récif"], function(x) {
      switch(x,
        "Récif frangeant" = "Fringing reef",
        "Récif barrière"  = "Barrier reef"
      )
    }
  )
)


template[ , "Method"]      <- paste("Belt transect, 20 x 5 m (x 4 zones)")
template[ , "Total_area"]  <- 100
template[ , "Location"]    <- datas[ , "Site"]
template[ , "Site"]        <- datas[ , "Station"]
template[ , "Replicate"]   <- datas[ , "Replicate"]
template[ , "Depth"]       <- datas[ , "Profondeur"]
template[ , "Observer"]    <- datas[ , "Nom de famille Observateur"]
template[ , "Date"]        <- datas[ , "Date de l'Observation"]
template[ , "Year"]        <- substr(datas[ , "Date de l'Observation"], 1, 4)

template[ , "Family"]      <- datas[ , "Family"]
template[ , "Species"]     <- unlist(
  lapply(
    strsplit(datas[ , "Scientific name"], " \\("),
    function(x) x[1]
  )
)

template[ , "Size_class"] <- unlist(
  lapply(
    strsplit(datas[ , "Scientific name"], " \\(size |\\)"),
    function(x) x[2]
  )
)

template[ , "Size_class"] <- gsub("16-30m", "16-30cm", template[ , "Size_class"])
template[ , "Size_class"] <- gsub("-", " - ", template[ , "Size_class"])
template[ , "Size_class"] <- gsub(">", "> ", template[ , "Size_class"])
template[ , "Size_class"] <- gsub("cm", " cm", template[ , "Size_class"])

template[ , "Density"] <- datas[ , "Number of individus"]

template[ , "Source"]       <- "Bureau d'étude CORTEX"
template[ , "Precision"]    <- "Family"
template[ , "Sampling_all"] <- "Only target species"

template <- template[template[ , "Species"] != "Rien / nothing", ]



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

template <- template[with(template, order(Date, Location, Site, Replicate, Family, Size_class)), colnames(col_names)]
rownames(template) <- NULL

writexl::write_xlsx(x = template, path = file.path(res_dir_fish_data_clean, "RORC_NCL_Fish_Dataset.xlsx"))


Hnasse, Honem, Jothie, Luecilla 1, Luecilla 2, Qanono
