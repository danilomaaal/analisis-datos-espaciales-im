# vim:fenc=utf-8:ff=unix:ft=r:ts=2:sw=2:et:tw=80:

library(tidyverse)
library(leaflet)

# importar datos
victimas_fgj <- read_csv("./data/raw/victimasFGJ_2024.csv")

fgj_cols <- victimas_fgj |>
  select(delito,latitud,longitud)

# mapa delito mas denunciado
mas_denunciado <- fgj_cols |> 
  count(delito, sort = TRUE) |>
  head(n = 1) |>
  pull(delito)

del_mas_denunciado <- fgj_cols |>
  filter(delito == mas_denunciado) |>
  filter(!is.na(latitud)) |>
  filter(!is.na(longitud))

# general
violencia_fam <- leaflet() |>
  addProviderTiles(providers$CartoDB) |>
  addCircles(data = del_mas_denunciado,
             lng = ~longitud,
             lat = ~latitud)


# agrupado
violencia_fam_cluster <- leaflet() |>
  addProviderTiles(providers$CartoDB) |>
  addCircleMarkers(
    data = del_mas_denunciado,
    lng = del_mas_denunciado$longitud,
    lat = del_mas_denunciado$latitud,
    clusterOptions = TRUE)


htmlwidgets::saveWidget(
  violencia_fam_cluster,
  file = "./assets/index.html",
  selfcontained = TRUE) 


# datos sobre co
ocved <- readxl::read_excel("./data/raw/OCVED_2.0/OCVED_2.0.xlsx") |>
  mutate(latitude=as.numeric(latitude))

leaflet(data=ocved) |>
  addProviderTiles(providers$CartoDB) |>
  addCircles(group = ~actor_main) |>
  addLayersControl(overlayGroups = ~actor_main,
                   options = layersControlOptions(collapsed=FALSE)
                   )


# publicar en posit cloud
rsconnect::connectCloudUser()

rsconnect::deployDoc("./assets/index.html")

