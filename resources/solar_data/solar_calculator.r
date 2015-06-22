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
solar_data = read.table("data.csv", header=TRUE, sep=",")

ss_data = c()

# Convert the data to hours
for(i in solar_data$SS){
  if(i > 0){
    ss_data = c(ss_data, i * 6 / 60)
  }
}

# Generate boxplot image
png(filename="62.png")
par(mar=c(8.1,4.1,4.1,2.1))
boxplot(ss_data,
        main='Sunshine Waterford Ireland',
        ylab='Hours')
dev.off()

# Print a summary of the ss_data
print(summary(ss_data))


# Generate data frame to plot Watts vs Current for a 12V system
watts_vector = c(0:1000)
volts_vector = rep.int(12, 1001)
amps_vector = c()

for(i in 0:1001){
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

# Solar Calculator Function
solar_calculator <- function(data)
  # Returns size of the battery required to run data$w watts at data$voltsion(data){
  if(data$type == "battery"){
    amps <- data$w / data$v
    result <- amps * 48  
  }
  # Returns size of the solar panel required to run 
  ifelse(data$type == "solarpanel"){
    amps <- data$w / data$v
    result <- amps * 48 
  }
  return(result)
}


d <- data.frame( w=24.0, v=12.0, a=50, type="battery" ) 
val = solar_calculator(d)
print(val)

png(filename="64.png")
par(mar=c(5.1,4.1,4.1,2.1))

watts <- watt_data$watts
amps <- watt_data$amps
plot(watts~amps)
dev.off()
