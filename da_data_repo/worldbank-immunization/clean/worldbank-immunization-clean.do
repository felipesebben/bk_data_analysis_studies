**********************************************
* Chapter 02, 23
*
* world bank immunization rates
* input: 
*      fac51cfc-e0cd-4938-927b-b82e828f5ca4_Data.csv.csv

* output: 
*       world-bank_immunization-panel.dta

* v1.3
**********************************************
*cd "C:\Users\GB\Dropbox (MTA KRTK)\bekes_kezdi_textbook"
*cd "C:\Users\kezdi\Dropbox\bekes_kezdi_textbook"
cd "/Users/vigadam/Dropbox/My Mac (MacBook-Air.local)/Documents/work/data_book/"

*location folders
global data_in   "da_data_repo/worldbank-immunization/raw"
global data_out   "da_data_repo/worldbank-immunization/clean"





clear
insheet using "$data_in/fac51cfc-e0cd-4938-927b-b82e828f5ca4_Data.csv", comma names

    
gen year=real(Time)
encode countrycode, gen(c)
gen pop = real(populationtotal)/1000000
 lab var pop "Population, million"
gen mort = real(mortalityrate)
 lab var mort "Child mortality (0-5y), per 1000"
gen surv = (1000 - mort)/10
 lab var surv "Child survival (0-5y), %"
gen imm = real(immunizationm)
 lab var imm "Imminuzation rate agains measles (12-23mo), %"
gen gdppc = real(gdppercap)
 lab var gdppc "GDP per capita, PPP, 2011 USED"
gen lngdppc=ln(gdppc)
gen hexp = real(currenthealthexp)
 lab var hexp "Health expenditures, % of GDP"
 
keep year c country* pop mort surv imm gdppc lngdp hexp
order year c country* pop mort surv imm gdppc lngdp hexp

compress
keep if year>=1998
keep if imm!=.
keep if mort!=.
keep if pop!=.
sum

xtset c year
xtdes
*save immun_measles,replace
saveold "$data_out/worldbank_immunization-panel.dta", replace



*** CONTINENTS
clear
insheet using "$data_in/ac7b6203-6a02-4e39-aad1-da9ad65319d5_Data.csv", comma names
gen year=real(Time)
encode countrycode, gen(c)
gen mort = real(mortalityrate)
 lab var mort "Child mortality (0-5y), per 1000"
gen surv = 1000 - mort
 lab var surv "Child survival (0-5y), per 1000"
gen imm = real(immunizationm)
 lab var imm "Imminuzation rate agains measles (12-23mo), %"

keep if year>=1998
keep if imm!=.
*tab year
*tab countryname
compress

tab countryname, sum(c)
drop if countryname=="World" 
keep year c imm surv
reshape wide imm surv, i(year) j(c)
saveold "$data_out/worldbank_immunization-continents.dta", replace

