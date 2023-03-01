*********************************************************************
*
* DATA ANALYSIS TEXTBOOK
* FUNDAMENTALS OF REGRESSION ANALYSIS
* ILLUSTRATION STUDY FOR CHAPTER 8
* Life expectancy and GDP (per capita), xcountry regression
*
* data downloaded from the World Bank
*
*********************************************************************

* WHAT THIS CODES DOES:

* Imports data to Stata
* Manages data to get a clean dataset to work with
* Transforms GDP variable into per capita and then log
* Performs regression analysis of E[lifeexp|ln(GDP/capita)]


********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
*cd "C:/Users/GB/Dropbox (MTA KRTK)/bekes_kezdi_textbook"
*cd "D:/Dropbox (MTA KRTK)/bekes_kezdi_textbook"
cd "/Users/vigadam/Dropbox/My Mac (MacBook-Air.local)/Documents/work/data_book/"
clear all
set more off

 
 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data

global data_in   "da_data_repo/worldbank-lifeexpectancy/raw"
global data_out   "da_data_repo/worldbank-lifeexpectancy/clean"


*********************************************************************
*** IMPORT DATA
clear
import delimited using "$data_in/worldbank-lifeexpectancy-raw.csv", varnames(1) ///
 numericcols(5 6 7)
 
drop if countrycode=="" /* drop completely empty rows */
rename time year
 lab var year ""
gen population=populationtotal/1000000
gen gdppc=gdppercapita/1000
rename lifeexpect lifeexp
 lab var gdppc "GDP per capita, '000 USD (PPT constant 2011 prices)"
 lab var population "Population, million"
drop timecode gdppercapita populationtotal

drop if lifeexp==.
drop if pop==.
drop if gdppc==.

compress
saveold "$data_out/worldbank-lifeexpectancy.dta", replace
