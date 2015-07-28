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

# "dxdata":[{"spotter":"w3lpl","freq":"50107.0","dx":"yv4nn","msg":"Heard in NH","time":"23:03","cc":"germany"}]
# spotter
# freq
# dx
# msg
# time
# cc

json_file_name <- "2015-07-13_processed.json"
json_data <- suppressWarnings(fromJSON(file=json_file_name, unexpected.escape="keep"))
dxdata <- json_data$dxdata

len <- length(dxdata)
print(paste(c("Length of data: ", len), collapse = " "))

spotterlist <- c()
freqlist <- c()
dxlist <- c()
msglist <- c()
timelist <- c()
cclist <- c()


for( i in 1:length(dxdata) ){
  spotter <- dxdata[[i]]$spotter
  freq <- dxdata[[i]]$freq
  dx <- dxdata[[i]]$dx
  msg <- dxdata[[i]]$msg
  time <- dxdata[[i]]$time
  cc <- dxdata[[i]]$cc

  spotterlist <- c(spotterlist, spotter)
  freqlist <- c(freqlist, freq)
  dxlist <- c(dxlist, dx)
  msglist <- c(msglist, msg)
  timelist <- c(timelist, time)
  cclist <- c(cclist, cc)
}


# Create element dataframe
dxframe <- data.frame(
  spotter=spotterlist,
  freq=freqlist,
  dx=dxlist,
  msg=msglist,
  time=timelist,
  cc=cclist
)


print(summary(dxframe))

png(filename="68.png")
par(mar=c(10.1,4.1,4.1,2.1))
plot(dxframe$cc,
     main='DXCluster Signals Europe',
     xlab='',
     ylab='Signal Occurances',
     las=2
     )
dev.off()

png(filename="69.png")
par(mar=c(10.1,4.1,4.1,2.1))
plot(dxframe$cc,dxframe$time, 
     main='DXCluster Signals Europe',
     xlab='',
     ylab='Signal Occurances',
     las=2,
     pch=19
     )
dev.off()
