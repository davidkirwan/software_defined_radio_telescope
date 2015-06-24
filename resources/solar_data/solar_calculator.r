####################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to handle calculation of solar power plots.
#
# @usage Rscript solar_calculator.r
#
# @date 2015-06-24
####################################################################################################


#FILE FORMAT (MISSING VALUE CODE IS -9999):

#01-06 STAID: Station identifier
#08-13 SOUID: Source identifier
#15-22 DATE : Date YYYYMMDD
#24-28 SS   : sunshine in 0.1 Hours
#30-34 Q_SS : Quality code for SS (0='valid'; 1='suspect'; 9='missing')

#This is the series (SOUID: 107654) of IRELAND, WATERFORD (TYCOR) (STAID: 1760)
#See file sources.txt for more info.

#STAID, SOUID,    DATE,   SS, Q_SS

# Read the data in
solar_data <- read.table("data.csv", header=TRUE, sep=",")

ss_data <- list()

for(i in 1:365){
  ss_data[[i]] <- data.frame(total=0, count=0)
}

index <- 274 # Data starts off on the 1st October 1961
for(i in solar_data$SS){
  if(i > 0){
    ss_data[[index]]$total <- ss_data[[index]]$total + i
    ss_data[[index]]$count <- ss_data[[index]]$count + 1
  }
  if(index %% 365 == 0){
    index <- 1
  }
  else{
    index <- index + 1
  }
}

ss_data_plot = c()
for(i in 1:length(ss_data)){
  avg = ss_data[[i]]$total / ss_data[[i]]$count
  hours <- (avg * 6) / 60
  ss_data_plot <- c(ss_data_plot, hours)
}

# Print a summary of the ss_data
print(ss_data_plot)
print(summary(ss_data_plot))

# Generate boxplot image
png(filename="62.png")
par(mar=c(8.1,4.1,4.1,2.1))
boxplot(ss_data_plot,
        main='Sunshine Waterford Ireland',
        ylab='Hours')
dev.off()


# Barplot of the hours of sunlight each day
png(filename="66.png")
par(mar=c(8.1,4.1,4.1,2.1))
barplot(ss_data_plot, main="Daily Hours of Sunlight",
       xlab="Jan - Dec (Day)", ylab="Hours(h)") 
abline(h = 4.446, lty = 2, col = 'grey')
text(10, 4.7, "mean", col = "grey") 
dev.off()


# Generate data frame to plot Watts vs Current for a 12V system
watts_vector = c(0:50)
volts_vector = rep.int(12, 51)
amps_vector = c()

for(i in 0:51){
  amps_vector = c(amps_vector, watts_vector[i] / 12)
}

watt_data <- data.frame(
  watts  = watts_vector,
  volts  = volts_vector,
  amps = amps_vector
)

print(summary(watt_data))
png(filename="63.png")
par(mar=c(5.1,4.1,4.1,2.1))
plot(y=watt_data$watts, x=watt_data$amps,
     main='Power vs Current at 12V',
     xlab='Current(A)',
     ylab='Power(W)')
dev.off()

# battery calculator
battery_calculator <- function(watts, voltage, time){
  # Returns capacity of the battery in Ah to power system load watts at 
  # voltage for time hours
  amps <- watts / voltage
  result <- amps * time
  return(result)
}

# solar panel size calculator
solar_panel_calculator <- function(voltage, amps, time){
  # Returns the size of the solar panel in W to charge
  # battery of voltage(V) and amps(Ah) capacity in time(h)
  amps_per_1_hour = amps / time
  watts = voltage * amps_per_1_hour
  result = watts
  return(result)
}

##########################

# Generate data frame to plot battery capacity vs solar pannel size for a 12V system
watts_vector = c()
amps_vector = c()

for(i in 0:51){
  amps_vector = c(amps_vector, battery_calculator(i, 12.0, 48.0))
}

for(i in 0:51){
  watts_vector = c(watts_vector, solar_panel_calculator(12, 50, i))
}

solar_battery_data <- data.frame(
  watts  = watts_vector,
  amps = amps_vector
)
  
png(filename="64.png")
par(cex=.8, mar=c(5.1,4.1,4.1,2.1))
plot(solar_battery_data$amps,c(0:51), 
     yaxs="i", 
     xaxs="i",
     main='48hr Load vs Battery Capacity at 12V',
     xlab='Capacity(Ah)',
     ylab='Load(W)')

dev.off()

png(filename="65.png")
par(cex=.8, mar=c(5.1,4.1,4.1,2.1))
x <- 1:11
y <- solar_battery_data$watts[1:11]
plot(x, y,
     yaxs="i", 
     xaxs="i",
     main='Time to charge 50Ah 12V Battery',
     xlab='Charge Time(h)',
     ylab='Solar Panel Power(W)')

lines(y~x, col='red', lwd=2)
abline(v = 4.446, lty = 2, col = 'grey')
text(4.7, 400, "mean daily hours of sunlight", col = "grey", srt=90) 

dev.off()

