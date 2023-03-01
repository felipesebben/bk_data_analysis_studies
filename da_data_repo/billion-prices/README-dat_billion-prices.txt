****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
billion-prices dataset

used in case study 6A Comparing online and offline prices: testing the difference

****************************************************************
Data source

The Billion Prices project collects online and offline prices of selected products sold by selected retailers. 
It was founded in 2008 by Alberto Cavallo and Roberto Rigobon and aims to collect price information all over the world.

More information: http://www.thebillionpricesproject.com/

The data we use is the replication dataset for
Cavallo, Alberto, 2017, "Are Online and Offline Prices Similar? Evidence from Large Multi-Channel Retailers" - American Economic Review - Vol. 107(1), p.283–303", https://doi.org/10.7910/DVN/XXOUHF, Harvard Dataverse, V4


****************************************************************
Data access and copyright

You can use this replication dataset for educational purposes


****************************************************************
Raw data table

online_offline_ALL_clean
 a Stata data file
A data table with products with both online and offline prices 
From 10 countries and 56 large retailers
Observations are price mesurements
Most products from a retailer in a country are observed once
Some products are observed twice or more at the same retailer and country, at different dates
n = 45,253 observations
Identifier variables 	id 	product/retailer/country-specific identifier
			date	date
Most important variables 	price		offline price
				price_online 	online price
				PRICE_TYPE	whether offline price is regular or sales
				sales_online	whether online prices is sales

****************************************************************
Tidy data table

online_offline_ALL_clean
 same as the raw data 


