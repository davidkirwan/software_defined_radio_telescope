###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to generate lightning strike plots from data collected on the blitzortung
#              cluster.
#
# @usage Rscript generate_maps.r
#
# @date 2015-08-03
####################################################################################################

# loading the required packages
require(ggplot2)
require(ggmap)
library("rjson")


# Convert from degrees to radians
deg2rad <- function(deg) return(deg*pi/180)

# Calculates the geodesic distance between two points specified by radian latitude/longitude using the
# Haversine formula (hf)
# http://www.r-bloggers.com/great-circle-distance-calculations-in-r/
haversine <- function(long1, lat1, long2, lat2) {
  R <- 6371 # Earth mean radius [km]
  delta.long <- (long2 - long1)
  delta.lat <- (lat2 - lat1)
  a <- sin(delta.lat/2)^2 + cos(lat1) * cos(lat2) * sin(delta.long/2)^2
  c <- 2 * asin(min(1,sqrt(a)))
  d = R * c
  return(d) # Distance in km
}


json_file_name <- "2015-08-05-00-10.json"
json_data <- suppressWarnings(fromJSON(file=json_file_name, unexpected.escape="keep"))
blitzortung_data <- json_data$blitzortung

len <- length(blitzortung_data)
print(paste(c("Length of data: ", len), collapse = " "))

site_lat <- deg2rad(52.653264)
site_lon <- deg2rad(-7.251160)

lat <- c(52.653264)
lon <- c(-7.251160)

for(i in blitzortung_data){
  distance = haversine(site_lat, site_lon, deg2rad(as.numeric(i$latitude)), deg2rad(as.numeric(i$longitude)))
  
#  if(distance <= 1000.0){
    cat(sprintf("Lat:%f Long:%f Distance:%fkm\n", as.numeric(i$latitude), as.numeric(i$longitude), distance))

    lat <- c(lat, as.numeric(i$latitude))
    lon <- c(lon, as.numeric(i$longitude))
#  }
}


# creating a sample data.frame with your lat/lon points
#lat <- c(52.253811)
#lon <- c(-7.115605)
df <- as.data.frame(cbind(lon,lat))

# getting the map
mapgilbert <- get_map(location = c(lon = mean(df$lon), lat = mean(df$lat)), zoom = 4,
                            maptype = "satellite", scale = 2)

# plotting the map with some points on it
png(filename="test.png")
par(mar=c(10.1,4.1,4.1,2.1))
ggmap(mapgilbert) +
  geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)

dev.off()
