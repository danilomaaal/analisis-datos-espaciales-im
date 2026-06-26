# vim:fenc=utf-8:ff=unix:ft=r:ts=2:sw=2:et:tw=80:

library(sf)
library(tidyverse)
library(readxl)
library(cowplot)

muns <- st_read("./data/raw/mg_2020_integrado/conjunto_de_datos/00mun.shp")

muns <- muns |>
	janitor::clean_names()

plot(muns[,2])


ent_int <- muns |>
  filter(cve_ent==11)



conapo <- read_excel("./data/raw/IMM_2020.xlsx",
                     sheet = "IMM_2020") |>
          janitor::clean_names()


final_data <- ent_int |>
  left_join(conapo, by=c("cvegeo"="cve_mun"))


ggplot(final_data) +
  geom_sf(aes(fill = pob_tot)) +
  scale_fill_viridis_b()


plot_1 <- ggplot(final_data) +
  geom_sf(aes(fill=sbasc)) +
  scale_fill_viridis_b()



plot_2 <- ggplot(final_data) +
  geom_density(aes(sbasc))


plot_grid(plot_1, plot_2)


# ordenando factores -> mapa mal hecho
ggplot(final_data) +
  geom_sf(aes(fill=gm_2020)) +
  scale_fill_viridis_d()


# var con factores ordenados
final_data <- final_data |>
  mutate(gm_2020 = forcats::fct_reorder(gm_2020, imn_2020))



mapa <- ggplot(final_data) +
  geom_sf(aes(fill=gm_2020)) +
  scale_fill_viridis_d()


ggplot(final_data) +
  geom_density(aes(sbasc, fill = gm_2020), alpha = 0.5)



ggsave(filename = "mapa.svg", plot = mapa)


