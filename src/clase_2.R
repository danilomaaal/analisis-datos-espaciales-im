# vim:fenc=utf-8:ff=unix:ft=r:ts=2:sw=2:et:tw=80:

library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(jsonlite)

# importar datos
victimas_fgj <- read_csv("./data/raw/victimasFGJ_2024.csv")

fgj_limpia <- victimas_fgj |>
  select(delito,latitud,longitud) |>
  filter(str_detect(delito,"SEX")) |>
  na.omit()

# mapa de calor
ds <- leaflet() |>
  addProviderTiles(providers$CartoDB) |>
  addHeatmap(data=fgj_limpia,
             lng = ~longitud,
             lat = ~latitud,
             radius = 60) |>
  addCircleMarkers(data=fgj_limpia,
                   lng = ~longitud,
                   lat = ~latitud,
                   clusterOptions = TRUE)


htmlwidgets::saveWidget(ds,
                        file = "./assets/ds_heatmap.html",
                        selfcontained = TRUE) 


# consultas a API del DENUE
# obtener negocios en las inmediaciones del im
negocios_im <- fromJSON("https://www.inegi.org.mx/app/api/denue/v1/consulta/Buscar/todos/19.376185074658263,-99.1843916300812/500/5782893c-bfe7-42da-8ee4-02d141d52797")

negocios_im <- negocios_im |>
  as_tibble() |>
  janitor::clean_names()
  

negocios_im <- negocios_im |>
  mutate(
    longitud = as.numeric(longitud),
    latitud = as.numeric(latitud)
  )


leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addCircles(data = negocios_im,
    lng = ~longitud,
    lat = ~latitud,
    color="red",
    label = ~clase_actividad)

negocios_im |>
  count(clase_actividad,
    sort = TRUE)

