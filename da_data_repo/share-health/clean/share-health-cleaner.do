*********************************************************
*
* DATA ANALYSIS TEXTBOOK
* CH 11 PROBABILITY MODELS
* SMOKING AND STAYING HEALTHY
*
* easySHARE dataset, release 7.1.0

* v1.2 2020-11-05
*********************************************************************

********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book/"


global data_in   "da_data_repo/share-health/raw" /*data_in*/
global data_out	 "da_data_repo/share-health/clean" /*data_out*/

********************************************************************

** IMPORT AND SELECT DATA
use "$data_in/easySHARE_rel7-1-0.dta", clear


keep mergeid wave country country_mod int_year int_month female age eduyears_mod ///
 sphus br015 smoking ever_smoked income_pct_w4 bmi mar_stat

saveold "$data_out/share-health.dta", replace
