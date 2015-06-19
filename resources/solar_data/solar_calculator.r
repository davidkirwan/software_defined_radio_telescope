#FILE FORMAT (MISSING VALUE CODE IS -9999):

#01-06 STAID: Station identifier
#08-13 SOUID: Source identifier
#15-22 DATE : Date YYYYMMDD
#24-28 SS   : sunshine in 0.1 Hours
#30-34 Q_SS : Quality code for SS (0='valid'; 1='suspect'; 9='missing')

#This is the series (SOUID: 107654) of IRELAND, WATERFORD (TYCOR) (STAID: 1760)
#See file sources.txt for more info.

#STAID, SOUID,    DATE,   SS, Q_SS


solar_data = read.table("data.csv", header=TRUE, sep=",")

#ss_data = unlist(solar_data$SS)
#ss_data[ss_data<0] <- 0 # Replace missing values with 0

ss_data = c()

for(i in solar_data$SS){
  if(i > 0){
    ss_data = c(ss_data, i * 6 / 60)
  }
}


print(mean(ss_data))
print(sd(ss_data))

png(filename="62.png")
par(mar=c(8.1,4.1,4.1,2.1))

boxplot(ss_data,
        main='Sunshine Waterford Ireland',
        ylab='Hours')

dev.off()

print(summary(ss_data))
