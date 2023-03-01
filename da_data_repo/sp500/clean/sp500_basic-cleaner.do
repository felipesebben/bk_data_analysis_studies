********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book/"
 
 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data

*location folders
global data_in   	"da_data_repo/sp500/raw"
global data_out   	"da_data_repo/sp500/clean"

***************************************************************
* load raw data 
import delimited "$data_in/SP500_2006_16_data.csv", clear varnames(1)
des

***************************************************************
* data cleaning

* drop observations with missing values when market was not open
count if value=="#N/A"
drop if value=="#N/A"

* re-formulate values to number
destring value,replace


* re-formulate date from string to date
rename date datestring
gen date=date(datestring,"YMD")
format date %td
sort date

saveold "$data_out/SP500_2006_16_data.dta", replace
