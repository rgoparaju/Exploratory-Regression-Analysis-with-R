## Exploratory Regression Analysis with R
I acquired a data set about air quality from the UCI Machine Learning Repository to perform some simple regression using R. The data set is about different hourly air quality measures in an Italian city spanning over almost an entire year, that measured amounts of different trace particulates present in the air in a polluted area. The different materials include carbon monoxide(CO), Non-Metanic Hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), Total Nitrogen Oxides (NO<sub>x</sub>) and Nitrogen Dioxide (NO<sub>2</sub>). The dataset also tracks measurements of Temperature (T), and Absolulte and Relative Humidities (AH and RH, respectively). The concentration of these chemicals is given as micrograms per cubic meter (ug/m^3). Find out more about the data set [here](https://archive.ics.uci.edu/ml/datasets/Air+Quality).

### Goal
My aim was to find a model that used as few predictors as possible to predict the temperature using the other variables in the data set, by exploring any significant statistical correlations between the local temperature and the other substances, as well as any significance in the relation between the humidity and chemicals.

### Method
#### Pre-Processing
The first step was to clean up the data so it becomes easy to use in R. Since the data came from European researchers, instead of periods as decimal points they used commas, and as a result the researchers separated the data columns by semicolons. To fix this I simply opened the file in another program and replaced every comma with a period, then every semicolon with a comma, so it could be easily read as a .csv file by R. I loaded the data into R, then cleaned up the missing values in the file. These missing values were marked with '-200' in the columns which were missing a value for that row. I just removed any rows that had a -200 in any of its columns, leaving a total of 827 records to perform regression on.

#### Analyzing the Variables
According to the authors five sensors recorded the Ground True concentrations of carbon monoxide (CO), Non-metanic hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), nitrogen oxides (NO<sub>x</sub>), and nitrogen dioxide (NO<sub>2</sub>). Additionally, these five sensors also recorded measurements of one additional particulate; as a result, I wanted to consider the relation between the primary and secondary particulate that was measured by each sensor. 

Sensor 1, which targeted CO also recorded measurements of tin oxide, SnO<sub>2</sub>. The column in the data is labelled PT08.S1. When we plot CO against SnO<sub>2</sub>, we find that there is a highly linear relationship between them, since they have a correlation coefficient of about 0.94. This implies that knowing one can predict the other, and having both as predictors for the temperature is unneccesary.

![](plots/CO_SnO2.png)

Similarly, sensor 2 primarily took measurements of NMHC but also of a material the researchers refer to as titania, which is just titanium dioxide TiO<sub>2</sub>. The relation between NMHC and TiO<sub>2</sub> seemed to be exponential, which I confirmed by plotting log(NMHC) against TiO<sub>2</sub>, which gave a correlation of about 0.93. Once again, since the secondary chemical TiO<sub>2</sub> is highly related to the primary chemical NMHC, I only consider NMHC.

![](plots/NMHC_TiO2.png)

Sensor 3 took measurements primarily of the total nitrogen oxides NO<sub>x</sub>, but also of tungsten oxide WO<sub>3</sub>. Like NMHC, there was an exponential relationship between NO<sub>x</sub> and WO<sub>3</sub>, which I saw by plotting log(NO<sub>x</sub>) against WO<sub>3</sub> which gave a correlation coeff. of about -0.90. Thus, I only consider NO<sub>x</sub> for the regression.

![](plots/NOx_WO3.png)

Sensor 4 primarily recorded NO<sub>2</sub>, but also secondarily recorded tungsten oxide as well. I found that the correlation was very linear, with a correlation coeff. of about 0.81. I did not see an exponential relationship between the two, so I did not take log(NO<sub>2</sub>). I decided to only use NO<sub>2</sub> as a predictor.

![](plots/NO2_WO3.png)

Lastly, sensor 5 recorded measurements of indium oxide In<sub>2</sub>O<sub>3</sub>, but it nominally targets ozone, O<sub>3</sub>. But since the data does not contain a column for O<sub>3</sub>, I did not need to consider its relation to indium oxide.

Thus, I did not consider the secondary particulates when forming the model for the Temperature, since the primary particulate would be sufficient, and I wanted to avoid any cross-effects. Another factor to note is that one of the columns of the data records the amounts of nitrogen dioxide, NO<sub>2</sub>, and another column records the amounts of total nitrogen oxides, NO<sub>x</sub>; since NO<sub>2</sub> is a form of nitrogen oxide, this implies that the two variables may be related. To test this, I plotted them, and found their correlation coefficient to be about 0.86. Since there is a strong linear relationship, I decided to discard NO<sub>2</sub> for my analysis, and only consider NO<sub>x</sub>.

![](plots/NOx_NO2.png)

Similarly, I also wanted to examine the relationship between relative humidity (RH) and absolute humidity (AH). I found that they are weakly linearly correlated, with a coefficient of about 0.48, so I wanted to exclude RH from the regression model, since there would be a weak cross-effect between RH and AH.

![](plots/AH_RH.png)

#### Prediction with Linear Regression
I first tried a linear regression model in which every primary particulate along with the Absolute Humidity were used as predictors, and sought to keep only the ones that were statistically significant. When looking at the calculated p-value of a chemical, I considered p-values less than 0.05 to be significant. I found that NMHC, In<sub>2</sub>O<sub>3</sub> and AH all had p=values greater than, so I removed them in the next iteration. I came up with a model that has the 3 explanatory variables CO, C<sub>6</sub>H<sub>6</sub>, NO<sub>x</sub>. This model seemed to be a fairly accurate predictor of the average temperature, as shown below:

![](reg/reg_2.JPG)

However, I also wanted to examine the cross effects between these particulates and the Absolute Humidity, AH. I added in the term for each variable from the model mulitiplied with the AH, along with AH itself. Once again, I examined the significance level and found that neither the absolute humidity nor any of the cross-terms had any significance in the regression, as shown below, since all their p-values were much greater than 0.05.

![](reg/reg_3.JPG)

I decided to continue using the second version of the regression model, since that serves as the model with the least number of statistically significant predictors. Using this model I wanted to make predictions of the temperature, and calculate the percent error for the true value. Using the coefficients given by the regression, I have the equation

                                                    T = 15.31 - 3.37c + 1.33b - 0.04n

where *T* is the temperature in Celsius, *c* is the amount of carbon monoxide (CO), *b* is the amount of benzene (C<sub>6</sub>H<sub>6</sub>), and *n* is the amount of total nitrogen oxides (NO<subx</sub>). I wanted to calculate the average percent error the model achieves when estimating the temperature. Using the given data, I calculated the estimate, then the percent difference between the actual value and calculated value. Then I averaged all these values to find that the average percent difference between the actual temperature and estimates is approximately -6.57%. This implies that the model was consistently underestimating the correct temperature. In order to fix this problem, one solution might be to include more explanatory variables; the value of the adjusted R-squared for this model is about 0.37, and interpreting this in context, this means that only about 37% of the variance in the temperature can be explained by the explanatory variables. Since adding more variables will increase the model's effectiveness. 

Going back and looking at my method, I found that including the predictors that I had initially discarded, that is, the secondary chemicals which were measured by 4 of the 5 sensors, I found that including them all and then removing those which were insignificant dramatically improved the model's adjusted R-squared value, to over 95%. This meant that the regression was doing a much better job at fitting the parameters to the temperature. Likewise, when I calculated the average percent error, I found that it decreased drastically to about -0.03%, which is extremely good. In conclusion, I've learned that even though there may be strong relationships or correlations between variables in a data set, ignoring them may prove to be detrimental to a regression model. 


