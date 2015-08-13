####################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to generate radio propagation power signal plots.
#
# @usage Rscript radio_propagation.r
#
# @date 2015-07-19
####################################################################################################

library("hash")

# Read in the radio signal strength data gathered on March 20th
radio_data_raw <- read.table("2015-03-20_radio_propagation.csv", header=TRUE, sep=",")

# Create list to hold the processed data
radio_data <- hash()

time_index <- unique(radio_data_raw$time)

for(i in 1:length(radio_data_raw$time)){
  index <- toString(radio_data_raw$time[i])
  signal_strength <- radio_data_raw$signal_strength[i]

  if(!has.key(index, radio_data)){
    radio_data[[index]] <- signal_strength
  }
  else{
    radio_data[[index]] <- c(radio_data[[index]], signal_strength)
  }
}

print(radio_data)

radio_data_processed <- list()
ymean = c()
yhigh = c()
ylow = c()

for(i in time_index){
  ymean <- c(ymean, mean(radio_data[[i]]))
  yhigh <- c(yhigh, max(radio_data[[i]]))
  ylow <- c(ylow, min(radio_data[[i]]))
}

print(ymean)
print(yhigh)
print(ylow)

png(filename="67.png")
par(cex=.8, mar=c(5.1,4.1,4.1,2.1))

plot(time_index, ymean,
     ylim=c(-55, -25),
     yaxs="i", 
     xaxs="i",
     main='RSGB Radio Propagation Experiment',
     xlab='Time(m)',
     ylab='Signal Strength (dB)')


lines(time_index, yhigh, col = 'chartreuse1', lwd=2)
lines(time_index, ylow, col = 'dodgerblue', lwd=2)

polygon(c(time_index, rev(time_index)), c(ylow, rev(yhigh)),
         col = "seashell", border = NA)

lines(ymean~time_index, col='red', lwd=2)

legend('topright', c("mean","max","min"), 
       lty=2, col=c('red', 'chartreuse1', 'dodgerblue'), bty='n', cex=1)

dev.off()
