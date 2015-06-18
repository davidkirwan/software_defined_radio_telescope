library("Hmisc")

d = data.frame(
  x  = c(2, 4, 6, 8, 10),
  y  = c(2.18, 2.53, 2.3, 2.8, 3.4),
  sd = c(0.0521637, 0.243503, 0.07, 0.333, 0.04676462)
)

png(filename="59.png")
par(mar=c(8.1,4.1,4.1,2.1))
plot(d$x,
     d$y,
     main="Raspberry Pi B+",
     xlab="",
     ylab="Power (W)",
     xaxt='n',
     type="n",
     xlim=c(0, 12),
     ylim=c(0, 5))
with (
  data = d,
  expr = errbar(x, y, y+sd, y-sd, add=T, pch=1, cap=.1)
)

axis(1, at=d$x, labels=c("Idle","heatmap.py","rtl_power", "rtl_power and\nheatmap.py", "100%"), las=2)

dev.off()

  
# ====================================================================================================  
  
d = data.frame(
  x  = c(2, 4, 6, 8, 10),
  y  = c(1.98, 2.4, 2.2, 2.6, 3.29),
  sd = c(0.0421637, 0.343503, 0.03, 0.433, 0.05676462)
)

png(filename="60.png")
par(mar=c(8.1,4.1,4.1,2.1))
plot(d$x,
     d$y,
     main="Raspberry Pi B2",
     xlab="",
     ylab="Power (W)",
     xaxt='n',
     type="n",
     xlim=c(0, 12),
     ylim=c(0, 5))
with (
  data = d,
  expr = errbar(x, y, y+sd, y-sd, add=T, pch=1, cap=.1)
)

axis(1, at=d$x, labels=c("Idle","heatmap.py","rtl_power", "rtl_power and\nheatmap.py", "100%"), las=2)

dev.off()

# ====================================================================================================  

  
  
d = data.frame(
  x  = c(2, 4, 6, 8, 10),
  y  = c(13.3, 14.65, 15, 16.8, 25),
  sd = c(0.0, 1.343503, 0.0, 0.4242641, 0.0)
)

png(filename="61.png")
par(mar=c(8.1,4.1,4.1,2.1))
plot(d$x,
     d$y,
     main="Intel Atom N550",
     xlab="",
     ylab="Power (W)",
     xaxt='n',
     type="n",
     xlim=c(0, 12),
     ylim=c(10, 30))
with (
  data = d,
  expr = errbar(x, y, y+sd, y-sd, add=T, pch=1, cap=.1)
)

axis(1, at=d$x, labels=c("Idle","heatmap.py","rtl_power", "rtl_power and\nheatmap.py", "100%"), las=2)

dev.off()
