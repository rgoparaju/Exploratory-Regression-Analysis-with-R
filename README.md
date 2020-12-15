## Exploratory Regression Analysis with R
I acquired a data set about air quality from the UCI Machine Learning Repository to perform some simple regression using R. The data set is about different hourly air quality measures in an Italian city spanning over almost an entire year, that measured amounts of different trace particulates present in the air in a polluted area. The different materials include carbon monoxide(CO), Non Metanic Hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), Total Nitrogen Oxides (NO<sub>x</sub>) and Nitrogen Dioxide (NO<sub>2</sub>). The dataset also tracks measurements of Temperature (T), and Absolulte and Relative Humidities (AH and RH, respectively). Find the data set and more info here: https://archive.ics.uci.edu/ml/datasets/Air+Quality

### Goal
My aim was to find a model that used as few predictors as possible to predict the temperature using the other variables in the data set, by exploring any significant statistical correlations between the local temperature and the other substances, as well as any significance in the relation between the humidity and chemicals.

### Method
The first step was to clean up the data so it becomes easy to use in R. Since the data came from European researchers, instead of periods as decimal points they used commas, and as a result the researchers separated the data columns by semicolons. To fix this I simply opened the file in another program and replaced every comma with a period, then every semicolon with a comma, so it could be easily read as a .csv file by R. I loaded the data into R, then cleaned up the missing values in the file. These missing values were marked with '-200' in the columns which were missing a value for that row. I just removed any rows that had a -200 in any of its columns, leaving a total of 827 records to perform regression on.



According to the authors five sensors recorded the Ground True concentrations of carbon monoxide (CO), Non-metanic hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), nitrogen oxides (NO<sub>x</sub>), and nitrogen dioxide (NO<sub>2</sub>). Additionally, these five sensors also recorded measurements of one additional particulate; as a result, I wanted to consider the relation between the primary and secondary particulate that was measured by each sensor. 

Sensor 1, which targeted CO also recorded measurements of tin oxide, SnO<sub>2</sub>. The column in the data is labelled PT08.S1. When we plot CO against SnO<sub>2</sub>, we find that there is a highly linear relationship between them, since they have a correlation coefficient of about 0.94. This implies that knowing one can predict the other, and having both as predictors for the temperature is unneccesary.

![](CO ~ SnO2.png)


Similarly, sensor 2 primarily took measurements of NMHC but also of a material the reserchears refer to as 'titania' (labelled PT08.S2). I couldn't figure out what this material was however, but I assumed it to be related to titnaium, perhaps titanium dioxide. Sensor 3 took measurements primarily of (NO<sub>x</sub>), but also of tungsten oxide (labelled PT08.S3). Sensor 4, primarily (NO<sub>2</sub>) but also tungsten oxide (labelled PT08.S4). Lastly, sensor 5 recorded measurements of indium oxide In<sub>2</sub>O<sub>3</sub>, but it nominally targets ozone, O<sub>3</sub>. But since the data does not contain a column for O<sub>3</sub>, I did not need to consider its relation to indium oxide.

I plotted the primary particulates against their respective secondaries, and found that all were strongly correlated. As a result, I did not consider the secondary particulates when forming the model for the Temperature, since the primary particulate would be sufficient, and I wanted to avoid any cross-effects. Similarly, I also wanted to examine the relationship between relative humidity (RH) and absolute humidity (AH). I found that they are weakly linearly correlated, so I wanted to exclude RH from the regression model, since there would be a weak cross-effect between RH and AH.

I first tried a linear regression model in which every primary particulate along with the Absolute Humidity were used as predictors, and sought to keep only the ones that were statistically significant. When looking at the calculated p-value of a chemical, I considered p-values less than 0.05 to be significant. I found that NMHC had a p-value > 0.05, so after removing it, I came up with a model that has the 6 explanatory variables CO, C<sub>6</sub>H<sub>6</sub>, NO<sub>x</sub>, NO<sub>2</sub>, In<sub>2</sub>O<sub>3</sub> and AH. This model served as a fairly accurate predictor of the average temperature.

However, I also wanted to examine the cross effects between these particulates and the Absolute Humidity, AH. I added in the term for each variable from the latest iteration of the model mulitiplied with the AH
