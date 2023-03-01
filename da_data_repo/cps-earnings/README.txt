****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
cps-earnings dataset

used in case studies 9A and 10A 
 Estimating gender and age differences in earnings and
 Understanding the gender difference in earnings

****************************************************************
Data source

The NBER (National Bureau of Economic Research in the USA) extracts of the CPS Annual Earnings File (also known as the Merged Outgoing Rotation Groups or morg).
http://www2.nber.org/data/morg.html

The Current Population Survey (CPS) is the monthly household survey conducted in the USA by the Bureau of Labor Statistics. Its primary goal is to measure labor force participation and employment. It interviews 50-60,000 households per month.
New households enter the CPS in each month by carefule random sampling. Each household is then interviewed once in each month for 4 months. They are not interviewed for 8 months, after which they are interviewed again for 4 more months. As a result, the data collected in each month contains data from four subsamples that give their 1st-4th or 5th-8th interview in that month. The question about usual weekly hours and earnings are asked only at households in their 4th and 8th interview; for each participating household these two interviews are 12 months apart from each other.

The NBER morg extracts include data on households who provide their 4th or 8th interview. These monthly data tables are then combined to yearly data tables.

All persons in the household of age 16 or more are included in the extract files.

****************************************************************
Data access and copyright

No copyright restrictions; you can use this dataset for educational purposes.


****************************************************************
Raw data tables


morg79 - morg19
 yearly cross-sectional data tables
 orignally in Stata format (.dta extension)

We converted the 2014 file into csv for our data repository
 morg14.csv
 observations are individuals age 16 or over
 ID variables 	hhid 	houeshold id
 		hrhhid2 2nd part of houeshold id (some original hhid-s are split)
		lineno  person ("line") number in household
 important vars	age	age
		sex	gender
		earnwke weakly earnings
		uhourse usual work hours
		occ2012	occupational code (census 2010 classification)
		grade92	highest educational grade completed
labels of the variables are downlodable from here: http://data.nber.org/morg/docs/cpsx.pdf
for the occupational classification (census 2010) coodes: https://www.bls.gov/cps/cenocc2010.htm

****************************************************************
Tidy data table

morg-2014-emp
 cross-sectional data
 observations are individuals age 16 or over
  with usual hours non-missing and greater than zero 
  and weakly earnings non-missing and greater than zero
 ID variables 	hhid 	houeshold id
 		hrhhid2 2nd part of houeshold id (some original hhid-s are split)
		lineno  person ("line") number in household
 important vars	age	age
		sex	gender
		earnwke weakly earnings
		uhourse usual work hours
		occ2012	occupational code (census 2010 classification)
		grade92	highest educational grade completed
labels of the variables are downlodable from here: http://data.nber.org/morg/docs/cpsx.pdf
for the occupational classification (census 2010) coodes: https://www.bls.gov/cps/cenocc2010.htm

