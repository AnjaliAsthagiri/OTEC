library(R.matlab)

##### shape plots
power = c(0.0032, 0.0015, 0.0016, 0.005)
heat = c(0.0837383177570051, 0.0422202665477739, 0.156417832137682, 0.06)

par(mfrow=c(2,1))
barplot(heat, main="Heat Transfer per TE Leg Pair v.s. Shape", xlab="Shape", ylab="Heat Transfer per Module (watts)", names.arg=c("Rectangle", "Trapezoid", "Inverse Trapezoid", "Hourglass"), col="#FF6F63", border="#FF6F63")

barplot(power, main="Power per TE Leg Pair v.s. Shape", xlab="Shape", ylab="Power per Module (watts)", names.arg=c("Rectangle", "Trapezoid", "Inverse Trapezoid", "Hourglass"), col="#FF6F63", border="#FF6F63")


# CHANGE THIS!!!!!!!!
d <- readMat('/Users/anjali/Downloads/data_matrix_091022_252000.mat') 
mat = d$data.matrix








plot.new()
par(mfrow=c(1,1))
##### thickness plots
filtered_mat = mat;
filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.001 & filtered_mat[,5]>0 & filtered_mat[,1]==.021 & filtered_mat[,2]==4.85 & mat[,7]==.1,]
filtered_mat[,5] = filtered_mat[,5]/997;

par(mar = c(5,5,2,5))
p1 <- plot(filtered_mat[,8], filtered_mat[,4], type="l", col = "#ff6f63", xlab = "TE Thickness (m)", ylab="", lwd=3)

# set parameter new=True for a new axis
par(new = TRUE)

# Draw second plot using axis y2
p2 <- plot(filtered_mat[,8], filtered_mat[,5], type="l", col = "#098b48", axes = FALSE, xlab="", ylab="", lwd=3)

axis(side = 4, at = pretty(range(filtered_mat[,5])))
mtext(expression("TE Material Required (m"^3*")"), side = 2, line = 3, col = "#ff6f63")
title("Effect of TE Thickness on Material and Water Usage")

##### width plots
# CHANGE THIS!!!!!!!!
d2 <- readMat('/Users/anjali/Desktop/OTEC_Source/data/Sept5_RectangleDataSim20_WidthData_Height0.0011DT9.mat')
width_arr = d2$width.arr * d2$width.ar
material_arr = d2$num.modules.arr * d2$mod.volume.arr
water_arr = d2$kg.water.pump.per.sec.arr / 997

par(mar = c(5,5,2,5))
p1 <- plot(width_arr, material_arr, type="l", col = "#ff6f63", xlab = expression("TE Cross-Sectional Area (m"^2*")"), ylab="", lwd=3, ylim = c(1000, 1800))

# set parameter new=True for a new axis
par(new = TRUE)

# Draw second plot using axis y2
p2 <- plot(width_arr, water_arr, type="l", col = "#098b48", axes = FALSE, xlab="", ylab="", lwd=3, ylim = c(1000, 1800))

axis(side = 4, at = pretty(range(1000,1800)))
mtext(expression("Water Flow Required (m"^3*"s"^-1*")"), side = 4, line = 3, col = "#098b48")
title("Effect of TE Cross-Sectional Area on Material and Water Usage")








plot.new()
par(mfrow=c(1,3))
##### velocity plots
filtered_mat = mat;
filtered_mat[,8] = round(filtered_mat[,8],4)
filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.001 & filtered_mat[,5]>0 & filtered_mat[,1]==.021 & filtered_mat[,2]==4.85 & filtered_mat[,8]==.0011,]

filtered_mat[,5] = filtered_mat[,5]/997;


p1 <- plot(filtered_mat[,7], filtered_mat[,4], type="l", col = "#ff6f63", xlab = "Velocity (m/s)", ylab="", lwd=3, ylim = c(0, 1400))

# set parameter new=True for a new axis
par(new = TRUE)

# Draw second plot using axis y2
p2 <- plot(filtered_mat[,7], filtered_mat[,5], type="l", col = "#098b48", axes = FALSE, xlab="", ylab="", lwd=3, ylim = c(0, 1400))

axis(side = 4, at = pretty(range(filtered_mat[,5])))
mtext(expression("TE Material Required (m"^3*")"), side = 2, line = 3, col = "#ff6f63")
title("Effect of Velocity on Material and Water Usage")


##### length plots
filtered_mat = mat;
filtered_mat[,8] = round(filtered_mat[,8],4)
filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.001 & filtered_mat[,5]>0 & filtered_mat[,1]==.021 & filtered_mat[,7]==0.1 & filtered_mat[,8]==.0011,]

filtered_mat[,5] = filtered_mat[,5]/997;


p1 <- plot(filtered_mat[,2], filtered_mat[,4], type="l", col = "#ff6f63", xlab = "Pipe Length (m)", ylab="", lwd=3)

# set parameter new=True for a new axis
par(new = TRUE)

# Draw second plot using axis y2
p2 <- plot(filtered_mat[,2], filtered_mat[,5], type="l", col = "#098b48", axes = FALSE, xlab="", ylab="", lwd=3)

axis(side = 4, at = pretty(range(filtered_mat[,5])))
title("Effect of Pipe Length on Material and Water Usage")


##### radius plots
filtered_mat = mat;
filtered_mat[,8] = round(filtered_mat[,8],4)
filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.001 & filtered_mat[,5]>0 & filtered_mat[,2]==4.85 & filtered_mat[,7]==0.1 & filtered_mat[,8]==.0011,]

filtered_mat[,5] = filtered_mat[,5]/997;


p1 <- plot(filtered_mat[,1], filtered_mat[,4], type="l", col = "#ff6f63", xlab = "Pipe Radius (m)", ylab="", lwd=3)

# set parameter new=True for a new axis
par(new = TRUE)

# Draw second plot using axis y2
p2 <- plot(filtered_mat[,1], filtered_mat[,5], type="l", col = "#098b48", axes = FALSE, xlab="", ylab="", lwd=3)

axis(side = 4, at = pretty(range(filtered_mat[,5])))
mtext(expression("Water Flow Required (m"^3*"s"^-1*")"), side = 4, line = 3, col = "#098b48")
title("Effect of Pipe Radius on Material and Water Usage")








#################BIG PLOTS

plot.new()
par(bg="#ffffff")
# ##### big plot
filtered_mat = mat;
filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.0005 & filtered_mat[,5]>0,]
filtered_mat[,8] = round(filtered_mat[,8],4)
point = matrix(, nrow = 4, ncol = 9)
point[1,] = filtered_mat[filtered_mat[,2]==4.85 & filtered_mat[,7]==0.1 & filtered_mat[,8]==.0011 & filtered_mat[,1]==.021,]
point[2,] = mat[114941,]
point[3,] = mat[243776,]
point[4,] = filtered_mat[filtered_mat[,2]==4.85 & filtered_mat[,7]==0.1 & filtered_mat[,8]==.0087 & filtered_mat[,1]==.011,]

point[,5] = point[,5]/997;
filtered_mat[,5] = filtered_mat[,5]/997;

plot(filtered_mat[,5], filtered_mat[,4], col = "#ff6f63", ylab = expression("TE Material Required (m"^3*")"), xlab=expression("Water Flow Required (m"^3*"s"^-1*")"),log="xy", pch=19, cex=0.1)
points(point[,5], point[,4], col = "#098b48", ylab="", xlab="", pch=19)

title("Material and Water Usage")


# filtered_mat = mat;
# filtered_mat = filtered_mat[filtered_mat[,4]>0 & filtered_mat[,9]<=9 & filtered_mat[,8]>=0.0005 & filtered_mat[,5]>0,]
# filtered_mat[,8] = round(filtered_mat[,8],5)
# plot(filtered_mat[,5], filtered_mat[,4], col = filtered_mat[,2], ylab = expression("TE Material Required (m"^3*")"), xlab=expression("Water Flow Required (m"^3*"s"^-1*")"),log="xy", pch=19, cex=0.1)