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

# Range being monitored
high <- 40000.0
low <- 18000.0

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

  # Filter out the signals outside the range being monitored
  val <- as.numeric(freq)
  if(val > low && val <= high){
    spotterlist <- c(spotterlist, spotter)
    freqlist <- c(freqlist, freq)
    dxlist <- c(dxlist, dx)
    msglist <- c(msglist, msg)
    timelist <- c(timelist, time)
    cclist <- c(cclist, cc)
  }
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

tick <- 12
at <- seq(1, length(dxframe$time), by=tick)
png(filename="69.png")
par(mar=c(10.1,4.1,4.1,2.1))
plot(dxframe$time, 
     main='Time Range',
     xlab='',
     ylab='Signal Occurances',
     las=2,
     pch=19,
     xaxt="n"
     )
axis(1, at=at, labels=dxframe$time[at], las=2)
dev.off()

tick <- 4
at <- seq(1, length(dxframe$freq), by=tick)
png(filename="70.png")
par(mar=c(10.1,4.1,4.1,2.1))
plot(sort(dxframe$freq), 
     main='Frequency Range',
     xlab='',
     ylab='Signal Occurances',
     las=2,
     pch=19,
     xaxt="n"
     )
axis(1, at=at, labels=sort(dxframe$freq)[at], las=2)
dev.off()
