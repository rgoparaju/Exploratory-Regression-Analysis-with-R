air_quality = read.csv("AirQualityUCI.csv")
air_quality = subset(air_quality, CO.GT. != -200 & PT08.S1.CO. != -200 & NMHC.GT. != -200 & C6H6.GT. != -200 & PT08.S2.NMHC. != -200 & NOx.GT. != -200 & PT08.S3.NOx. != -200 & NO2.GT. != -200 & PT08.S4.NO2. != -200 & PT08.S5.O3. != -200 & T != -200 & RH != -200 & AH != -200)

CO = air_quality$CO.GT.
S1.CO = air_quality$PT08.S1.CO.
NMHC = air_quality$NMHC.GT.
C6H6 = air_quality$C6H6.GT.
S2.NMHC = air_quality$PT08.S2.NMHC.
NOx = air_quality$NOx.GT.
S3.NOx = air_quality$PT08.S3.NOx.
NO2 = air_quality$NO2.GT.
S4.NO2 = air_quality$PT08.S4.NO2.
S5.O3 = air_quality$PT08.S5.O3.
T = air_quality$T
RH = air_quality$RH
AH = air_quality$AH

###########################
# Since we want out linear regression to rely on as few predictors as possible, we want to see if particulates that were measured by the same sensor are correlated.
# Let's start with CO and PT08.S1, Tin oxide, which were measured by sensor 1:
cor(CO, S1.CO)
plot(CO ~ S1.CO, xlab = "SnO₂", ylab = "CO")
abline(lm(CO ~ S1.CO))
# We find that the correlation is 0.9362607 which is highly linear, which is supported by the scatter plot. Including both in a model would affect how the model behaves. Similarly, let's look at Non-metanic hydrocarbons and what the researchers call 'titania' PT08.S2:
cor(NMHC,S2.NMHC)
plot(NMHC ~ S2.NMHC, xlab = "TiO2", ylab = "NMHC")
abline(lm(NMHC ~ S2.NMHC))
log_NMHC = log(NMHC)
plot(log_NMHC ~ S2.NMHC, xlab = "TiO2", ylab = "log(NMHC)")
abline(lm(log_NMHC ~ S2.NMHC))
cor(S2.NMHC, log_NMHC)
# Once again, we get a strong linear correlation, 0.8750609. This means that including both as explanatory variables in unnecessary. We can see that their plot kind of resembles an exponential plot, which still means they are highly related. When taking log(NMHC), we find that the correlation coeff. increases, which supports that conclusion. Let's look at total nitrogen oxides, NOx, and PT08.S3 tungsten oxide:
cor(NOx, S3.NOx)
plot(NOx ~ S3.NOx, xlab = "WO3", ylab = "NOx")
abline(lm(NOx ~ S3.NOx))
log_NOx = log(NOx)
plot(log_NOx ~ S3.NOx, xlab = "WO3", ylab = "log(NOx)")
abline(lm(log_NOx ~ S3.NOx))
cor(log_NOx, S3.NOx)
# Another highly linear relationship, with coeff. -0.8142965. Here we also see that NOx seems to be exponentially related to tungsten oxide. Once again, we find that the correlation coeff. increases in magnitude when taking log(NOx). Finally, we see that sensor 4 is also reading tungsten oxide, but nominally targeting NO2:
cor(NO2, S4.NO2)
plot(NO2 ~ S4.NO2, xlab = "WO3", ylab = "NO2")
abline(lm(NO2 ~ S4.NO2))
# We get a coeff. of 0.8077916, once again very linear. 


# We want to exclude these columns labelled with PT08 since we find that they are all highly correlated with the material their sensor nominally targets. We can still include PT08.S5.O3 however, since no ground true readings of O3 exist. 
# Next, we want to look at the relationship between absolute and relative humidity:
cor(AH, RH)
# We get a smaller correlation of 0.4757759, but this is still fairly indicative of a somewhat linear relationship. We can also look at the plot of RH and AH:
plot(AH ~ RH)
abline(lm(AH ~ RH))
# Though weakly linear, we can still assume that they are correlated, so we will use a model which does not include both AH and RH.

# Let's also look at the relationship between NO2 and NOx, since NO2 is a type of nitrogen oxide:
cor(NO2, NOx)
plot(NOx ~ NO2)
abline(lm(NOx ~ NO2))
plot(log_NOx ~ NO2)
abline(lm(log_NOx ~ NO2))
cor(log_NOx, NO2)
# It is clear that NOx and NO2 are related, but is unclear whether the relation is exponential, even though the correlation coeff. increases after taking log(NOx), but the plot of log(NOx)~NO2 does not look more linear than NOx~NO2. Thus, we will discard NO2 as a predictor for the model.


# Therefore, the initial set of predictors for the Temperature are: CO, NMHC, C6H6, NOx, and lastly indium oxide PT08.S5. The reason we include indium oxide is that no other column contains results that contain readings from sensor 5. We get:
reg_1 = lm(T ~ . -Date -Time -PT08.S1.CO. -PT08.S2.NMHC. -PT08.S3.NOx. -NO2.GT. -PT08.S4.NO2. -RH, data = air_quality)
summary(reg_1)
# We see that NMHC, InO2 and AH are not significant predictors since their p-values are > 0.05, so we will remove them from the model:
reg_2 = lm(T ~ . -Date -Time -NMHC.GT. -PT08.S1.CO. -PT08.S2.NMHC. -PT08.S3.NOx. -NO2.GT. -PT08.S4.NO2. -PT08.S5.O3. -AH -RH, data = air_quality)
summary(reg_2)

# So we have arrived a a very good model that contains few predictors that are all statistically significant. Now we want to examine the cross effects between AH and the particulates that remain:
reg_3 = lm(T ~ . -Date -Time -NMHC.GT. -PT08.S1.CO. -PT08.S2.NMHC. -PT08.S3.NOx. -NO2.GT. -PT08.S4.NO2. -RH +CO.GT.*AH +C6H6.GT.*AH +NOx.GT.*AH, data = air_quality)
summary(reg_3)
# None of the cross effects are significant, so we will continue to use reg_2

sum_of_perc_errs = 0
mag_sum_of_perc_errs = 0
calc = 0
for(i in 1:length(air_quality$Date)){
  calc = 0
  calc = calc + 15.309530 + -3.371883*air_quality$CO.GT.[i] + 1.329935*air_quality$C6H6.GT.[i] + -0.042487*air_quality$NOx.GT.[i]

  sum_of_perc_errs = sum_of_perc_errs + 100*((air_quality$T[i] - calc)/air_quality$T[i])
  mag_sum_of_perc_errs = mag_sum_of_perc_errs + 100*((abs(air_quality$T[i] - calc))/air_quality$T[i])
}
avg_perc_err = sum_of_perc_errs/length(air_quality$Date)
avg_mag_perc_err = mag_sum_of_perc_errs/length(air_quality$Date)
avg_perc_err # average percent error in predicting the temperature
avg_mag_perc_err # average of magnitude of percent error in predicting temperature

# Let's try with a different model:
reg_4 = lm(T ~ . -Date -Time -PT08.S1.CO. -NMHC.GT. -C6H6.GT., data = air_quality)
summary(reg_4)
# Here we have eliminated PT08.S1.CO., NMHC.GT. and C6H6.GT.
sum_of_perc_errs = 0
avg_perc_err = 0
for(i in 1:length(air_quality$Date)){
  calc = 0
  calc = calc + 8.7298019 + -0.9481553*air_quality$CO.GT.[i] + 0.0108770*air_quality$PT08.S2.NMHC.[i] + 0.0047004*air_quality$NOx.GT.[i] + 0.0031592*air_quality$PT08.S3.NOx.[i] + 0.0078420*air_quality$NO2.GT.[i] + -0.0031558*air_quality$PT08.S4.NO2.[i] + -0.0013385*air_quality$PT08.S5.O3.[i] + -0.3271813*air_quality$RH[i] + 19.9436334*air_quality$AH[i]
  
  sum_of_perc_errs = sum_of_perc_errs + 100*((air_quality$T[i] - calc)/air_quality$T[i])
}
avg_perc_err = sum_of_perc_errs/length(air_quality$Date)
avg_perc_err
