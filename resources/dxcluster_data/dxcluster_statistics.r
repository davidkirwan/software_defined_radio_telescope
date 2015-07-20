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

json_file_name <- "2015-07-13_processed.json_tmp"
json_data <- suppressWarnings(fromJSON(file=json_file_name, unexpected.escape="keep"))
dxdata <- json_data$dxdata

len <- length(dxdata)
print(paste(c("Length of data: ", len), collapse = " "))

dxhash = hash()

time_vector = unique(dxdata$time)

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


print(dxhash)



#png(filename="63.png")
#par(mar=c(5.1,4.1,4.1,2.1))
#plot(dxhash$time, dxhash$cc, 
#     main='Power vs Current at 12V',
#     xlab='Current(A)',
#     ylab='Power(W)')
#dev.off()
