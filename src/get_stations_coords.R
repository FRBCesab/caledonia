#' @title Get Stations Coordinates
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@fondationbiodiversite.fr}



#' ----------------------------------------------------------------------------- @ImportStationsInformations


filename <- file.path(
  "data",
  "New Caledonia RORC",
  "stations_coordinates.xlsx"
)


infos <- readxl::read_xlsx(path = filename, sheet = 1, skip = 0)


library("sf")
library("ggplot2")
library("rnaturalearth")
library("rnaturalearthdata")
library("rnaturalearthhires")

infos <- sf::st_as_sf(
  x      = infos,
  coords = c("longitude", "latitude"),
  crs    = 4326
)

world <- ne_countries(scale = "large", returnclass = "sf")
class(world)


myplot <- ggplot(data = world) +
  geom_sf(fill = "#e5e0ce", colour = "#84ddfd") +
  geom_sf(data = infos, colour = "black") +
  xlim(163.75, 168.5) + ylim(-23.0, -20) + xlab("") + ylab("") +
  ggsflabel::geom_sf_label_repel(data = infos, aes(label = station_name, fill = site_name)) +
  theme(
    legend.position   = c(0.085, 0.16),
    legend.title      = element_text(size = 12, face = "bold"),
    legend.text       = element_text(size = 12),
    legend.background = element_rect(fill = "#ffffff88")
  ) +
  theme(
    text             = element_text(family = "serif"),
    panel.background = element_rect(fill = "#d4effc", colour = NA),
    panel.grid       = element_line(color = "#84ddfd", size = 0.1)
  ) +
  guides(fill = guide_legend("Site names")) +
  annotate(geom = "text", x = 165.90, y = -21.25, label = "Grande Terre", color = "#555555", fontface = "italic", size = 5, family = "serif") +
  annotate(geom = "text", x = 166.70, y = -20.55, label = "Ouvéa", color = "#555555", fontface = "italic", size = 5, family = "serif") +
  annotate(geom = "text", x = 167.40, y = -20.70, label = "Lifou", color = "#555555", fontface = "italic", size = 5, family = "serif") +
  annotate(geom = "text", x = 168.10, y = -21.40, label = "Maré", color = "#555555", fontface = "italic", size = 5, family = "serif") +
  annotate(geom = "text", x = 167.70, y = -22.70, label = "Isle of Pines", color = "#555555", fontface = "italic", size = 5, family = "serif") +
  annotate(geom = "text", x = 164.97, y = -22.80, label = "CORAL SEA", color = "#84ddfd", fontface = "italic", size = 6, family = "serif") +
  annotate(geom = "text", x = 167.97, y = -20.20, label = "SOUTH PACIFIC\nOCEAN", color = "#84ddfd", fontface = "italic", size = 6, family = "serif")

ggsave(myplot, filename = "~/Desktop/RORC_stations.png", dpi = 300)
