********************************************************************************
* Chapter 21
*
* wms-management
*
* v1.0. 2020-04-21 makes xsec
**********************************************************************


* set the path
cd "/Users/vigadam/Dropbox/work/data_book/"


*location folders
global data_in   "da_data_repo/wms-management-survey/raw"
global data_out  "da_data_repo/wms-management-survey/clean"

clear
use "$data_in/wms_da_textbook.dta"

* count original data 
count
* 14,277

* create xsec
* keep the last row when a firm is sampled many times
sort firmid wave
bys firmid: gen latest=_n==_N
keep if latest==1
drop latest
count 
* 10,282


save "$data_out/wms_da_textbook-xsec.dta",replace
