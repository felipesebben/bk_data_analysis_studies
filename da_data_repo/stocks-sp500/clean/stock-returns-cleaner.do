***************************************************************
* Stock market regression
* chapter 12
* sandp-stocks
*
* Loading and cleaning data
***************************************************************



********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd "" /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book/"
 
 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data

*location folders
global data_in   	"da_data_repo/stocks-sp500/raw"
global data_out   	"da_data_repo/stocks-sp500/clean"


* WORKFILE
clear
insheet using "$data_in/ready_sp500_45_cos.csv", comma names
keep if ticker=="MSFT"
gen date = date(refdate, "YMD")
format date %d
gen p_MSFT = priceclose

keep date p_MSFT
compress
save "$data_out/temp.dta",replace

clear
insheet using "$data_in/ready_sp500_index.csv", comma names
gen date = date(refdate, "YMD")
format date %d
gen p_SP500 = priceclose

keep date p_SP500
compress

merge 1:1 date using "$data_out/temp.dta", nogen keep(3)

gen year=year(date)
gen month=month(date)
gen ym=ym(year,month)
format ym %tm
sort date
order ym year month date 

* drop 2019 jan first price
drop if date<date("31/12/1997","DMY")
drop if date>date("31/12/2018","DMY")

save "$data_out/stock-prices-daily.dta",replace
erase "$data_out/temp.dta"


