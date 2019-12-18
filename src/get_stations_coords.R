#' @title Get Stations Coordinates
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@fondationbiodiversite.fr}



#' ----------------------------------------------------------------------------- @ImportStationsInformations


filename <- file.path(
  "data",
  "New Caledonia RORC",
  "Invertebrates_Observation_allstations_2003-2019.xls"
)

infos <- readxl::read_xls(path = filename, sheet = 1)
infos <- as.data.frame(infos)

station <- sort(unique(infos[ , "Station"]))

stations <- as.data.frame(matrix(ncol = 10, nrow = length(station)))
colnames(stations) <- c("SITE", "station", "lon_d", "lon_m", "lon_s", "lat_d", "lat_m", "lat_s", "longitude", "latitude")
stations$station <- station

col_names <- c("Site", "Station", "LatDegStation", "LatMinStation", "LatSecStation", "LongDegStation", "LongMinStation", "LongSecStation")

for (col_name in col_names[-c(1, 2)]) { infos[ , col_name] <- as.numeric(as.character(infos[ , col_name])) }


for (i in 1:nrow(stations)) {

  xxx <- infos[which(infos[ , "Station"] == station[i]), col_names]

  stations[i, "SITE"] <- xxx[1, "Site"]

  if (xxx[1, "LatDegStation"] != 0) {

    stations[i, "latitude"]  <- -1 * (xxx[1, "LatDegStation"]  + (xxx[1, "LatMinStation"]  / 60) + (xxx[1, "LatSecStation"]  / 3600))
    stations[i, "longitude"] <-  1 *  xxx[1, "LongDegStation"] + (xxx[1, "LongMinStation"] / 60) + (xxx[1, "LongSecStation"] / 3600)

    stations[i, "lat_d"] <- xxx[1, "LatDegStation"]
    stations[i, "lat_m"] <- xxx[1, "LatMinStation"]
    stations[i, "lat_s"] <- xxx[1, "LatSecStation"]

    stations[i, "lon_d"] <- xxx[1, "LongDegStation"]
    stations[i, "lon_m"] <- xxx[1, "LongMinStation"]
    stations[i, "lon_s"] <- xxx[1, "LongSecStation"]
  }
}

stations <- stations[with(stations, order(SITE, station)), ]

write.csv(stations, file.path(res_dir_get_stations_coords, "stations_coords.csv"), row.names = FALSE)






# library("sf")
# library("ggplot2")
# library("rnaturalearth")
# library("rnaturalearthdata")
# library("rnaturalearthhires")

# stations <- sf::st_as_sf(
#   x      = stations[!is.na(stations$longitude), ],
#   coords = c("longitude", "latitude"),
#   crs    = 4326
# )

# world <- ne_countries(scale = "large", returnclass = "sf")
# class(world)
#
#
# myplot <- ggplot(data = world) +
#   geom_sf(fill = "#e5e0ce", colour = "#84ddfd") +
#   geom_sf(data = stations, colour = "black") +
#   xlim(163.75, 168.5) + ylim(-23.0, -20) + xlab("") + ylab("") +
#   ggsflabel::geom_sf_label_repel(data = stations, aes(label = station, fill = SITE)) +
#   theme(
#     legend.position   = c(0.085, 0.15),
#     legend.title      = element_text(size = 12, face = "bold"),
#     legend.text       = element_text(size = 12),
#     legend.background = element_rect(fill = "#ffffff88")
#   ) +
#   theme(
#     text             = element_text(family = "serif"),
#     panel.background = element_rect(fill = "#d4effc", colour = NA),
#     panel.grid       = element_line(color = "#84ddfd", size = 0.1)
#   ) +
#   annotate(geom = "text", x = 165.90, y = -21.25, label = "Grande Terre", color = "#555555", fontface = "italic", size = 5, family = "serif") +
#   annotate(geom = "text", x = 166.70, y = -20.55, label = "Ouvéa", color = "#555555", fontface = "italic", size = 5, family = "serif") +
#   annotate(geom = "text", x = 167.40, y = -20.70, label = "Lifou", color = "#555555", fontface = "italic", size = 5, family = "serif") +
#   annotate(geom = "text", x = 168.10, y = -21.40, label = "Maré", color = "#555555", fontface = "italic", size = 5, family = "serif") +
#   annotate(geom = "text", x = 167.70, y = -22.70, label = "Isle of Pines", color = "#555555", fontface = "italic", size = 5, family = "serif") +
#   annotate(geom = "text", x = 164.97, y = -22.80, label = "CORAL SEA", color = "#84ddfd", fontface = "italic", size = 6, family = "serif") +
#   annotate(geom = "text", x = 167.97, y = -20.20, label = "SOUTH PACIFIC\nOCEAN", color = "#84ddfd", fontface = "italic", size = 6, family = "serif")
#
# ggsave(myplot, filename = "~/Desktop/RORC_stations.png", dpi = 300)


#                Site           Station
#  1        Mont Dore     Bancs du Nord
#  2         Ile Ouen             Bodjo
#  3        Mont Dore           Charbon
#  4         Ile Ouen            Da Moa
#  5             Easo            Engeny
#  6    Chateaubriand             Honem
#  7    Chateaubriand            Jothie
#  8             Easo               Jua
#  9         Ile Ouen          Menondja
# 10             Easo            N'Goni
# 11        Mont Dore             Tombo
