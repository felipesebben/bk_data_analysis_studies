* set your directory here
cd "/Users/vigadam/Dropbox/work/data_book/da_data_repo/asia-industry"

* usa imports
clear
import excel "raw/usa-imports.xls", sheet("FRED Graph") cellrange(A11:B375) firstrow
rename observation_date date
rename IMP0004 usa_imp_sa
gen year=year(date)
gen month=month(date)
gen time=ym(y,m)
format time %tm
drop date
order time year month
save "clean\usa-imports.dta", replace


* asia monthly industrial production plus some others (exchange rate)
clear
import delimited "raw/worldbank-monthly-asia-2019_long.csv", encoding(utf8)

keep series country countrycode time value 


*create time
split time, parse("M") gen(temp)
rename temp2 month
drop if month==""
destring month, replace
rename temp year
destring year, replace
keep if year>1990
drop time


	replace series ="ind_prod_const" if series=="Industrial Production, constant US$,,,"
	replace series ="cpi_sa" if series=="CPI Price, seas. adj.,,,"
	replace series ="exchnage_rate_vs_usd" if series=="Exchange rate, new LCU per USD extended backward, period average,,"
	replace series ="ind_prod_const_sa" if series=="Industrial Production, constant US$, seas. adj.,,"
	replace series ="exchange_rate_neer" if series=="Nominal Effecive Exchange Rate,,,,"
	replace series ="exchange_rate_reer" if series=="Real Effective Exchange Rate,,,,"
	replace series ="cpi_yoy_nsa" if series=="CPI Price, % y-o-y, not seas. adj.,,"

* tidy data: have variables as columns

reshape wide value, i( country countrycode year month ) j(series)  string
rename value* *

gen time=ym(y,m)
format time %tm
sort time
order time year month country*

save "clean/asia-indprod_tidy.dta", replace


* merge the two files
use "clean/asia-indprod_tidy.dta", replace
merge m:1 time using "clean/usa-imports.dta", nogen keep(3)
save "clean/asia-industry_tidy.dta", replace



