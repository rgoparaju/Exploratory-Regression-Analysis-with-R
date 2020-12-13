## Exploratory Regression Analysis with R
I acquired a data set about air quality from the UCI Machine Learning Repository to perform some simple regression using R. The data set is about different hourly air quality measures in an Italian city spanning over almost an entire year, that measured amounts of different trace particulates present in the air in a polluted area. The different materials include carbon monoxide(CO), Non Metanic Hydrocarbons (NMHC), Benzene (C<sub>6</sub>H<sub>6</sub>), Total Nitrogen Oxides (NO<sub>x</sub>) and Nitrogen Dioxide (NO<sub>2</sub>). The dataset also tracks measurements of Temperature (T), and Absolulte and Relative Humidities (AH and RH, respectively). Find the data set and more info here: https://archive.ics.uci.edu/ml/datasets/Air+Quality

My aim was to find any significant statistical correlations between carbon monoxide and the other substances, as well as any significance in the relation between the temperatures and absolute/relative humidities to the presence of these substances. That is, I wanted to discover if the cross-effects between temperature or humidity, and particulates were statistically significant. 
