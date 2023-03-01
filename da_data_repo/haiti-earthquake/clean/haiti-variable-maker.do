*********************************************************************
*
* DATA ANALYSIS TEXTBOOK

* ch24
* synth for Haiti
* prep
*********************************************************************


********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book"

 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data

global data_in	 "da_data_repo/haiti-earthquake/raw" 
global data_out	 "da_data_repo/haiti-earthquake/clean" 

use "$data_in/section1.dta", clear


*Variables
gen gdppc_w = real(gdp_t) 
gen remit = real(remit_t)/1000000000
gen consus = real(consus_t)/1000000000
gen cons = real(cons_t) 
gen gcf = real(gcf_t)
gen gcfu = real(gcfu_t)/1000000000
gen impus = real(impus_t)/1000000000
gen imp = real(imp_t)
gen exp = real(exp_t)
gen expus = real(expus_t)/1000000000
gen pop = real(pop_t)
gen popl = real(popl_t) /1000000
gen odat = real(odat_t)/1000000
gen inf = real(inf_t)
gen extus = real(extus_t)/1000000000
gen gdpt_us = real(gdp_us10_t)
gen gdppc_us = real(gdppc_us_t)
gen gdp_grow = real(gdp_grow_t)
gen land = real(land_t)
gen rev = real(valuerev)
gen expend = real(valueexpend)

*scaling
gen gdptb_us = gdpt_us/1000000000
gen revtb    = rev*gdptb_us /100
gen expendtb = expend*gdptb_us/100 


lab var year "Year"
lab var gdptb_us "Total GDP, constant USD, billion"

drop if year<2004
drop if year>2015

save "$data_out/haiti-earthquake-mod.dta", replace
