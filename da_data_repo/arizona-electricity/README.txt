****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
arizona-electricity dataset

used in case study 12B Electricity consumption and temperature

****************************************************************
Data source

The electricity consumption data was collected and released by the
US Energy Information Administration (EIA) 
as part of their Open Data framework
https://www.eia.gov/opendata/
The Arizona resudential monthly time series can be obtained 
by clicking through the API Query Browser
EIA Data Sets > Electricity > Retail sales of electricity > Residential
selecint Arizona monthly
and dowloading the "data" (a comma-delimited csv file with heading rows)
Our data was downloaded in June 2018

The temperature data was collected and released by the
US National Oceanic and Atmospheric Administration (NOAA)
through their Climate Data Online Search page
https://www.ncdc.noaa.gov/cdo-web/search
Select "Global Summary of Month", date range from Jan 1 2001, 
Search for "Stations" and Enter a Search Term "Phoenix"
then from the several items there select 
"PHOENIX AIRPORT, AZ US, station ID: GHCND:USW00023183"
then go to your cart, select that you want csv, 
and then select the variables Station name and Air Temperature
give them your email address and they will email it to you
Our data was downloaded in June 2018

WARNING: NEW VERSION IS DIFFERENT
In the new version of the data (at least since Oct 2020)
cooling and heating degree days are given as cumulative since January of the year
So, for example, the CDSD entry is 355 in 4/2001, which is
is Apr CDSD = Jan CDD + Feb CDD + Mar CDD + Apr CDD (= 355)
From this you need to calculate the Apr CDD
(one way is to subtract the previous month CDSD value)
so that 2001 Apr CDD = 355-108=247
and the same for HDD (from HDSD)

****************************************************************
Data access and copyright

You can use this publicly available data for educational purposes


****************************************************************
Raw data tables

electricity_resid_AZ.csv
 monthly time series of AZ residential electricity consumption
 Sep 1990 - April 2018 (T=332)
 ID variable: MY (month-year, first day of the month in date format)
 important variables: Q (residential electricity consumption in AZ, millin KWh)

climate_Phoenix_AZ.csv
 Jan 2001 - March 2018 (T=207)
 monthly time series of temperature data in Phoenix, AZ
 ID variable: DATE (year-month, in string format)
 important variables: 	CLDD (cooling degree days, Fahrenheit)
 			HTDD (heeting degree days, Fahrenheit)
 
****************************************************************
Tidy data tables

There are no tidy data files in this directory
because all data is tidy already

Note: if you are using new climate data from NOAA, 
need to redefine the cooling and heating degree days variables 
(see warning note above)

In the workfiles the cooling and heating degree variables are used as 
daily average in the month as opposed to the monthly total that's in the data
(by dividing by 28, 30, or 31, depending on the month).
