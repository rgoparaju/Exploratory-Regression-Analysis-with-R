## Exploratory Regression Analysis with R
I acquired a data set about air quality from the UCI Machine Learning Repository to perform some simple regression using R. The data set is about different hourly air quality measures in an Italian city spanning over almost an entire year, that measured amounts of different trace particulates present in the air in a polluted area. The different materials include carbon monoxide(CO), Non Metanic Hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), Total Nitrogen Oxides (NO<sub>x</sub>) and Nitrogen Dioxide (NO<sub>2</sub>). The dataset also tracks measurements of Temperature (T), and Absolulte and Relative Humidities (AH and RH, respectively). Find the data set and more info here: https://archive.ics.uci.edu/ml/datasets/Air+Quality

### Goal
My aim was to find a model that used as few predictors as possible to predict the temperature using the other variables in the data set, by exploring any significant statistical correlations between the local temperature and the other substances, as well as any significance in the relation between the humidity and chemicals.

### Method
The first step was to clean up the data so it becomes easy to use in R. Since the data came from European researchers, instead of periods as decimal points they used commas, and as a result the researchers separated the data columns by semicolons. To fix this I simply opened the file in another program and replaced every comma with a period, then every semicolon with a comma, so it could be easily read as a .csv file by R.

I loaded the data into R, then cleaned up the missing values in the file. These missing values were marked with '-200' in the columns which were missing a value for that row. I just removed any rows that had a -200 in any of its columns, leaving a total of 827 records to perform regression on.

According to the authors five sensors recorded the Ground True concentrations of carbon monoxie (CO), Non-metanic hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), nitrogen oxides (NO<sub>x</sub>), and nitrogen dioxide (NO<sub>2</sub>). Additionally, these five sensors also recorded measurements of one additional particulate. Sensor 1, which targeted CO also recorded measurements of 

I first tried a linear regression model in which every particulate, along with the Absolute Humidity, was used as a predictor, and sought to keep only the ones that were statistically significant. I only considered AH, since Relative Humidity is correlated to absolute humidity, and this may affect the other variables. When looking at the calculated p-value of a chemical, I considered p-values less than 0.05 to be significant. Then, I removed each insignificant variable one by one until all the remaining variables were statistically significant. This model served as a fairly accurate predictor of the average temperature.

However, I also wanted to examine the cross effects between these particulates and the Absolute Humidity, AH. I added in the term for each variable from the latest iteration of the model mulitiplied with the AH
