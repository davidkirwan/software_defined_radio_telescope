library("Hmisc")

d = data.frame(
  x  = c(2, 4, 6, 8),
  y  = c(13.3, 14.65, 15, 16.8),
  sd = c(0.0, 1.343503, 0.0, 0.4242641)
)

png(filename="error_bars.png")
par(mar=c(8.1,4.1,4.1,2.1))
plot(d$x,
     d$y,
     main="SDRT Power Usage",
     xlab="",
     ylab="Power (W)",
     xaxt='n',
     type="n",
     xlim=c(0, 10),
     ylim=c(10, 35))
with (
  data = d,
  expr = errbar(x, y, y+sd, y-sd, add=T, pch=1, cap=.1)
)

axis(1, at=d$x, labels=c("Idle","heatmap.py","rtl_power", "rtl_power and\nheatmap.py"), las=2)

dev.off()
