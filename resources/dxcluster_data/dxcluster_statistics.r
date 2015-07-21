###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to handle calculation of statistics for data collected from the dxcluster.
#
# @usage Rscript dxcluster_statistics.r
#
# @date 2015-07-13
####################################################################################################

# Imports
library("rjson")
library("hash")

# "dxdata":[{"spotter":"w3lpl","freq":"50107.0","dx":"yv4nn","msg":"Heard in NH","time":"23:03","cc":"germany"}]

json_file_name <- "2015-07-13_processed.json"
json_data <- suppressWarnings(fromJSON(file=json_file_name, unexpected.escape="keep"))
dxdata <- json_data$dxdata

len <- length(dxdata)
print(paste(c("Length of data: ", len), collapse = " "))

dxhash <- hash()

for(i in dxdata){
  index <- toString(i$time)
  element <- i

  if(!has.key(index, dxhash)){
    dxhash[[index]] <- element
  }
  else{
    dxhash[[index]] <- c(dxhash[[index]], element)
  }
}

time_vector <- keys(dxhash)
country_hash = hash()

for(i in time_vector){
  country <- dxhash[[i]]$cc

  if( has.key(country, country_hash) ){
    country_hash[[country]]<- country_hash[[country]] + 1
  }
  else {
    country_hash[[country]] <- 1
  }
}

for(i in country_hash){
  country_vector <- c(country_vector, )
  country_counts <- c(country_counts, country_hash[[i]])
}
print(country_counts)

# Create the plot for country data
png(filename="68.png")
par(mar=c(5.1,4.1,4.1,2.1))
plot(country_counts,
     main='',
     xlab='',
     ylab='',
     labels=country_vector)
dev.off()
