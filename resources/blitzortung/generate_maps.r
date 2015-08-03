###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to generate lightning strike plots from data collected on the blitzortung
#              cluster.
#
# @usage ruby generate_maps.r
#
# @date 2015-08-03
####################################################################################################

# loading the required packages
require(ggplot2)
require(ggmap)

# creating a sample data.frame with your lat/lon points
lat <- c(52.253811)
lon <- c(-7.115605)
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
