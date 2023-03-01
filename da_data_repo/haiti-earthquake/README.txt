****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
haiti-earthquake

used in case study 
 24A Estimating the effect of the 2010 Haiti earthquake on GDP

****************************************************************
Data source

The published article by
Rohand Best and Paul J. Burke,
"Macroeconomic impacts of the 2010 earthquake in Haiti."
Empirical Economics (2019) 56:1647-1681
https://doi.org/10.1007/s00181-017-1405-4

The data is part of their supplementary material, 
https://link.springer.com/article/10.1007%2Fs00181-017-1405-4
downoladable in a zip file 181_2017_1405_MOESM1_ESM.zip
https://static-content.springer.com/esm/art%3A10.1007%2Fs00181-017-1405-4/MediaObjects/181_2017_1405_MOESM1_ESM.zip
The data is contained in several Stata .dta files,
of which we use section1.dta

The original source of the variables is the World Development Indicators data
distributed by the World Bank

****************************************************************
Data access and copyright

You can use this dataset for educational purposes.


****************************************************************
Raw data table

section1
country-year panel data with macroeconomic variables
275 countries, 1996-2015, n=4,574 (balanced for 217 countries)
ID variables
	country	
	year
important vairables
	gdp_us10_t	Total GDP in US dollars (constant 2010 USD, current exchange rate)
	pop_t		Population (total)

****************************************************************
Tidy data table

haiti-earthquake-mod
a smaller country-year panel data with macroeconomic variables
228 countries, 2004-2015, n=2,725 (balanced for 217 countries)
ID variables
	country	
	year
important vairables
	gdptb_us	Total GDP in billion US dollars (constant 2010 USD, current exchange rate)
	pop		Population (total)

