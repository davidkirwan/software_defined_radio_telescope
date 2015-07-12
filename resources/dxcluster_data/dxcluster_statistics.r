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

# Read in the json to dataframe
json_file = "2015-07-11_processed.json"
json_data <- suppressWarnings(fromJSON(file=json_file, unexpected.escape="keep"))

len <- length(json_data$dxdata)
print(paste(c("Length of data: ", len), collapse = " "))
