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

json_file_name <- "2015-07-11_processed.json"
json_data <- suppressWarnings(fromJSON(file=json_file_name, unexpected.escape="keep"))

len <- length(json_data$dxdata)
print(paste(c("Length of data: ", len), collapse = " "))

dxhash = hash()

for(i in json_data$dxdata){
  if( !has.key(i$dx, dxhash) ){
    dxhash[[i$dx]] <- i
  }
  else{
    dxhash[[i$dx]] <- c(dxhash[[i$dx]], i)
  }
}

print(dxhash)
