****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
australia-weather-forecast dataset

used in case study 11B Are Australian weather forecasts well calibrated?

****************************************************************
Data source

The Bureau of Meteorology of the Australian Government
https://data.gov.au/data/dataset
Rainfall and temperature forecast and observations - verification 2015-05 to 2016-04
NOTE: this dataset is not available anymore, but very similar ones are, such as
 Rainfall and temperature forecast and observations - verification 2017-05 to 2018-04
 these are large datasets with many files (separate data tables for each day)


****************************************************************
Data access and copyright

You can use this publicly available data for educational purposes


****************************************************************
Raw data table - downloaded in 2019

bometa20150501-20160430.zip downloaded from https://data.gov.au/data/data set/weather-forecasting-verification-data-2015-05-to-2016-04
BoM_ETA_20150501-20160430/fcst 
BoM_ETA_20150501-20160430/obs 
BoM_ETA_20150501-20160430/spatial/?StationData.csv

We use stations <- c(14015, 32040, 17126) #Darwin, Townsville, Marree


Not available as of now - similar data is available. 
 
****************************************************************
Tidy data table

rainfall_australia.csv
 weather station - forecast horizon - day panel of rain forecast and actuall rainfall
 ID variables bd_Start_time (date format), bd_fc_before_start (forecast time period) station_name (string)
   (note: bd_fc_before_start=39 means forecast is 2 days ahead)
 Important vairables
	prob: the predicted probability of rain for the day of the forecast time period
	daily_sum: whether rained on the predicted day



