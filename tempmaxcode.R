setwd('C:\\Users\\harik\\OneDrive\\Documents\\oelp')
dir()
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(viridis)
library(weathermetrics)
library(ncdf4)
library(chron)
library(RColorBrewer)
library(lattice)

file<-nc_open("tasmax_day_GFDL-ESM2M_rcp26_r1i1p1_EWEMBI_20910101-20991231.nc4")
lon<-ncvar_get(file,"lon")
print(file)
lat<-ncvar_get(file,"lat")
tmp.array<-ncvar_get(file,"tasmax")
dunits<-ncatt_get(file,"tasmax","units")
dunits
tmp.array<-tmp.array-273.15
tunits<-ncatt_get(file,"time","units")
tunits
nc_close(file)
tmp.slice<-tmp.array[,,180]
image(tmp.slice)
image(lon,lat,tmp.slice)
mapCDFtemp <- function(lat,lon,tas) 
{
   titletext <- "title"
   expand.grid(lon, lat) %>%
   rename(lon = Var1, lat = Var2) %>%
   mutate(lon = ifelse(lon > 180, -(360 - lon), lon),
            tas = as.vector(tas)) %>% 
    ggplot() + 
    geom_point(aes(x = lon, y = lat, color = tas),
                size = 0.8) + 
    borders("world", colour="black", fill=NA) + 
    scale_color_viridis(na.value="white",name = "Temperature") + 
    theme(legend.direction="vertical", legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    coord_quickmap() + 
    ggtitle("worldmap") 
}
mapCDFtemp(lat,lon,tmp.slice)
tmp.slice<-tmp.array[,,180]
mapCDFtemp(lat,lon,tmp.slice)
