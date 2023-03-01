****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
asia-industry dataset

used in case study 22A Import demand and industrial production

****************************************************************
Data source

The industrial production data was downloaded from the World Bank's Databank
https://databank.worldbank.org
Click on Databases and type in global economic monitor
one item should pop up, click on it, 
It should lead you to https://databank.worldbank.org/source/global-economic-monitor-(gem)
Database shuld be already selected to be Global Economic Monitor (GEM)
Select the countries you want
Select the series Industrial production, constant US$, seas. adj.
 and select other series if you want 
Select all time periods
 (note that this willn include months as well quarters, 
  however confusing it is there doesn't seem to be a way around it)
IMPORTANT. Change the Layout settings to Time: row Series: row Country: row
Download the data as csv

The US imports data is downloaded from the FRED
(Feredeal Reserve Economic Data) website maintained by the Federal Reserve Bank of St Louis (USA)
search for Imports of Goods by Customs and click on
U.S. Imports of Goods by Customs Basis from World 
Download the data as xls
WARNING: Newer versions have revised numbers, but differences are very small.

****************************************************************
Data access and copyright

You can use this publicly available data for educational purposes


****************************************************************
Raw data tables

usa-imports.xls
 monthly time series of US total imports, customs based
 Sep 1989 - April 2019 (T=364)
 ID variable: date (month-year, first day of the month in date format)
 important variables: IMP0004 (total imports to USA, seasonally adjusted)

worldbank-monthly-asia-2019_long.csv
 Jan 1987 - June 2018 
 monthly time series of industrial production and other variables
   NOTE: raw file includes quarterly and yealy observations, those are redundant
   NOTE: this is a "super-long" format file
	with different variables in different rows
	except for the Time variable that is in a separate column
 ID variable: Time (year-month, in string format)
 important variables: Series (string telling which variable this is)
			of this we'll need Industrial Production, constant US$, seas. adj. 
 
****************************************************************
Tidy data tables

usa-imports
 monthly time series of US total imports, customs based
 Sep 1989 - April 2019 (T=364)
 ID variable: time (month-year, first day of the month in date format)
 important variables: usa_imp_sa (total imports to USA, seasonally adjusted)

asia-indprod_tidy
 15 countries, Jan 1991 - June 2018 (n=4950)
 country - month panel of industrial production and other variables
 ID variables: 	time (month-year, first day of the month in date format)
		country (string for country)
 important variables: 	ind_prod_cons_sa (Industrial Production, constant US$, seas. adj.)

asia-industry_tidy
 merged usa-imports and asia-indprod_tidy
 15 countries, Jan 1987 - June 2018 (n=4950)
 country - month panel of industrial production and other variables
 ID variables: 	time (month-year, first day of the month in date format)
		country (string for country)
 important variables: 	ind_prod_cons_sa (Industrial Production, constant US$, seas. adj.)
			usa_imp_sa (total imports to USA, seasonally adjusted)

 
