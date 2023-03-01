* Used car data for LA and Chicago
* prep - cleans the data, makes it ready for work
* v1.2 2018 Nov

********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book/"
* cd "C:\Users\Viki\Dropbox\bekes_kezdi_textbook"
 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data
 

global data_in	  "da_data_repo/used-cars/raw" 
global data_out	  "da_data_repo/used-cars/clean"

import delimited "$data_in/used_cars_2cities.csv", varnames(1) clear

* check for duplicates
drop v1
duplicates drop
*********************************************
*********************************************

*********************************************
*********************************************
* FEATURE ENGINEERING
* price
rename price pricestr
gen price=substr(pricestr,2,5)
destring price, force replace
drop if price==.
gen lnprice=ln(price)

*********************************************
* age
gen str4 year=substr(name,1,4)
destring year,replace
tab year,mis
gen age=2017-year+1

*********************************************
* odometer: miles
destring odometer, replace force
 replace odometer=odometer/10000
 lab var odometer "Odometer, '0,000 miles"
tab age if odometer<1, sum(odometer)
drop if odom<1 & age>=3
* count missing odometer
count if odometer==.
* mean fill for missing odometer (by age)
*  (for some ages all are missing, these are replaced by grouping age inti 2y)
cap drop temp*
egen temp=mean(odometer), by(age)
 replace odometer=temp if odometer==.
 egen temp2=cut(age), at(1(2)25)
 egen temp3=mean(odometer), by(temp2)
 replace odometer=temp3 if odometer==.
 drop temp*
gen lnodometer=ln(odometer)
sum price lnp age odom

*********************************************
* parse text info out

 gen temp1=strpos(name," le")
 gen temp2=strpos(name," LE")
 gen LE= (temp1>0 | temp2>0)
 cap drop temp1 temp2

 gen temp1=strpos(name," xle")
 gen temp2=strpos(name," XLE")
 gen XLE= (temp1>0 | temp2>0)
 cap drop temp1 temp2

 gen temp1=strpos(name," se")
 gen temp2=strpos(name," SE")
 gen SE= (temp1>0 | temp2>0)
 cap drop temp1 temp2

 
 gen temp1=strpos(name," hybrid")
 gen temp2=strpos(name," Hybrid")
 gen temp3=strpos(name," HYBRID")
 gen Hybrid = (temp1>0 | temp2>0 | temp3>0)
 cap drop temp1 temp2 temp3

sum LE SE XLE Hybrid 

*********************************************
*********************************************


export delimited using "$data_out/used-cars_2cities_prep.csv", replace
saveold "$data_out/used-cars_2cities_prep.dta", replace

