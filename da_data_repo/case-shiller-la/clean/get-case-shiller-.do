************************************************************************************************
* Prepared for the textbook:
* Data Analysis for Business, Economics, and Policy
* by Gabor BEKES and  Gabor KEZDI 
* Cambridge University Press 2021
* 
* License: Free to share, modify and use for educational purposes. 
* Not to be used for business purposes.
*
***********************************************************************************************x

* CHAPTER 18
* CH18B Forecasting a house price index
* case-shiller-la dataset

* set your directory
cd "/Users/vigadam/Dropbox/work/data_book/da_data_repo/"
*cd your diretory for data repo here
global data_out "case-shiller-la/clean"


* IN: Get data directly from FRED API
 
* TIDY DATA: data_out/
	* houseprices-data-1990-2018-f, t=1990-
	* end date depends on when you get the data
	* the case study code will set the years used in the case study


* get data from FRED
* need to register to the FRED site
* then request a key

* first set your key
* 
set fredkey c8892aed9910ada07d34c6d369e72437

* then get case-shiller Los Angeles Home Price Index series
clear
import fred CANA	CANAN	CAUR	CAURN	LXXRNSA	LXXRSA	

* create Stata date
gen date = date(datestr,"YMD")
format date %td
gen year=year(date)
gen month=month(date)


* keep 2000 onward
keep if year>=2000


* create variables

*Home price index, seasonally adjusted
gen ps = LXXRSA 

*Home price index, not seasonally adjusted
gen pn = LXXRNSA

*Unemployment rate, seasonally adjusted
gen us = CAUR

*Unemployment rate, not seasonally adjusted
gen un = CAURN

*Total employment, seasonally adjusted
gen emps = CANA

*Total employment, not seasonally adjusted
gen empn = CANAN

* order and keep variables 
order date year month ps-empn
keep date-empn

* save tidy csv file
* 2000 - 2018 
keep if year<=2018
outsheet using "$data_out/homeprices-data-2000-2018.csv", comma replace
