********************************************************************************
* Chapter 20
*
* work-from-home
* v1.0

* using
*		Bloom et al. (2015): Does Working from Home Work? 
*			Evidence from a Chineses Experiment. QJE. 165-218
*
**********************************************************************
* Working from Home
* From raw data to tidy data
* Then from tidy data to workfile
**********************************************************************

**********************************************
* Cleaning file
* 
**********************************************


* set the path
*cd "C:\Users\GB\Dropbox (MTA KRTK)\bekes_kezdi_textbook"

cd "/Users/vigadam/Dropbox/work/data_book"

*location folders
global data_in   "da_data_repo/working-from-home/raw"
global data_out   "da_data_repo/working-from-home/clean"

* load in clean and tidy data and create workfile
use "$data_in/performance_during_exper.dta", clear

clear

**********************************************************************
* 1 Tidy Data table at person level
* two raw data files: quit_data, tc_comparison

use "$data_in/quit_data.dta", replace
codebook personid

rename expgroup treatment
rename men male
drop perform10_ex perform11_exp

order personid treatment quit perform* 
compress
save "$data_out/wfh_tidy_person.dta",replace

use "$data_in/tc_comparison.dta", replace
codebook personid

rename expgroup treatment
rename men male

compress

merge 1:1 personid using "$data_out/wfh_tidy_person.dta", nogen
order personid treatment quit perform* 

save "$data_out/wfh_tidy_person.dta",replace


**********************************************************************
* 2 Tidy Data table at person x week level
* one raw data file: performance_during_exper
* need this only for one outcome measure: calls (for order takers)

use "$data_in/performance_during_exper.dta",replace
codebook personid
codebook year_week

* keep only 249 persons in experiment (treatment or control group)
tab expgroup treatment,mis
keep if expgroup==0 | expgroup==1
codebook personid

* create binary variable for during experiment vs before experiment
gen experiment_time = experiment_treatment + experiment_control
 *tabstat year_week, by(experiment_time) s(min max)
 *tabstat date, by(experiment_time) s(min max) format(%dmy)

rename phonecallraw phonecalls 
replace phonecalls = phonecalls/1000
order personid year_week experiment_time treatment phonecalls
keep personid year_week experiment_time treatment phonecalls

save "$data_out/wfh_tidy_personweek.dta",replace

* aggregate to person level 
* (and create y before experiment vs during experiment)
collapse (sum) phonecalls (mean) treatment, by(personid experiment_time)
reshape wide phonecalls, i(personid) j(experiment_time)

order personid treatment
lab var treatment "In treatment group"
lab var phonecalls0 "'000 phone calls prior to experiment"
lab var phonecalls1 "'000 phone calls during experiment"
compress

merge 1:1 personid using "$data_out/wfh_tidy_person.dta", nogen

* create "ordertaker" variable for whom phonecalls are relevant measure
* type variable = 1
tabstat phonecalls0, by(type) s(min p10 p50 max)
tabstat phonecalls1, by(type) s(min p10 p50 max)
gen ordertaker = type==1
 lab var ordertaker "Order taker: working phone calls"
 lab var type "Job type"

order personid treatment ordertaker type quitjob 
compress

save "$data_out/wfh_tidy_person.dta",replace


