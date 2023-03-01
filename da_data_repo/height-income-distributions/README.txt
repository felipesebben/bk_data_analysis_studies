****************************************************************
Prepared for Gabor's Data Analysis

Data Analysis for Business, Economics, and Policy
 by Gabor Bekes and  Gabor Kezdi
 Cambridge University Press 2021
 gabors-data-analysis.com 

Description of the 
height-income-distribution dataset

used in case study 3D Distributions of Body Height and Income


****************************************************************
Data source

The Health and Retirement Study of the USA.

The University of Michigan Health and Retirement Study (HRS) is a longitudinal panel study that surveys a representative sample of approximately 20,000 people in America, supported by the National Institute on Aging (NIA U01AG009740) and the Social Security Administration. 
https://hrs.isr.umich.edu/

This data is from the public release longitudinal RAND-HRS datafile, which is a single (wide format) xt panel data table with the most important public-use variables from the HRS.
Downloadable from here: https://hrsdata.isr.umich.edu/data-products/rand
Description here: https://www.rand.org/well-being/social-and-behavioral-policy/centers/aging/dataprod/hrs-data.html

We share the clean tidy data table and the Stata code that creates it but not the raw RAND-HRS data table (which is a very large Stata file).

****************************************************************
Data access and copyright

If you want to use this data, you need to register as a user of the HRS.
Registering is fairly easy and can be done here: https://hrsdata.isr.umich.edu/user/register
After registering, you can use not only the data table in our repo but the entire public release HRS dataset, including the RAND-HRS longitudinal file.

See more about the conditions here: https://hrs.isr.umich.edu/data-products/access-to-public-data/conditions-of-use

****************************************************************
Raw data table

randhrs1992_2016v2
RAND-HRS Longitudinal File V2; from HRS waves 1992-2016, version 2
This is a wide format panel dataset
Observations are all individuals who have ever participated in the survey; n=42,052
Survey waves are identified in the variables names, by numbering (1,2, ...)
ID variable 		HHIDPN (numeric) unique identifier for each respondent
Important variables	there are thousands of variables in this data table

Note. The data table is large, and its wide format makes it hard to use. 
We use a single cross-section, which is easily extracted from the large data table.
If you want to use it for other purposes you will probably want to use a data table with a small subset of the variables and reshape it into a long format

IMPORTANT. We do not ristribute this raw data table. We distribute the code that uses it to create a tidy cross-sectional data table that we use for case study 3D


****************************************************************
Tidy data table

hrs_height_income
A cross-sectional subsample of HRS, including observations from survey wave 2014 (#12)
Observations are respondents who gave an interview in HRS 2014, n=18,747
ID variable:		hhidpn (numeric) unique identifier for each respondent
important variables	age (in years)
			female (whether female, 0 or 1)
			height (in meters)
			hhincome (total yearly household income in thousand current US dollars, 
				referring to year before interview)

