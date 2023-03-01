global RANDHRS "V:\LIBRARY\Contrib\RAND\RandHrs\RandHrs2016V2\stata"


use hhidpn r12iwstat ragender r12agey_m h12itot r12height ///
 using "$RANDHRS\randhrs1992_2016v2",replace

keep if r12iwstat==1 /* respondent participated in wave 12 */
drop r12iwstat

rename r12age age
rename r12height height
rename h12itot hhincome
replace hhincome = hhincome/1000
gen female=ragender==2
drop ragen

lab var hhidpn "Unique person ID (household ID and person number)"
lab var age "Age in years (RAND-HRS r12agey_m)"
lab var female "Whether female (from RAND-HRS ragender)"
lab var hhincome "Household (respondent+spouse) total income, '000 USD (RAND-HRS h12itot)"
lab var height "Body height (self-report, RAND-HRS r12height)"

qui compress
saveold hrs_height_income,replace
outsheet using hrs_height_income.csv, comma replace
