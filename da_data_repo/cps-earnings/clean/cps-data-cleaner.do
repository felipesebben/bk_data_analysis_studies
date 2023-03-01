*********************************************************************
*
* DATA ANALYSIS TEXTBOOK
* FUNDAMENTALS OF REGRESSION ANALYSIS
* ILLUSTRATION STUDY FOR CHAPTER 9
*
* DATA US CPS 2014
*********************************************************************

* WHAT THIS CODES DOES:

* Loads the data csv
* Filter the dataset and save a sample used in the analysis
* save

********************************************************************
* SET YOUR DIRECTORY HERE
*********************************************************************
*cd  /*set your dir*/
cd "/Users/vigadam/Dropbox/work/data_book/"
*cd "C:\Users\GB\Dropbox (MTA KRTK)\bekes_kezdi_textbook"

 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data
 
global data_in	 da_data_repo/cps-earnings/raw 
global data_out	 da_data_repo/cps-earnings/clean


clear
import delimited $data_in/morg2014.csv

*  select variables and rename (to get smaller file)
keep lfsr94 hhid  lineno intmonth  stfips  weight  earnwke  uhourse  grade92  race  ethnic  age  sex  marital  ownchild  chldpres  prcitshp  state ind02  occ2012  class94  unionmme unioncov
rename class94 class
rename uhourse uhours

count

*******************************************
** SAMPLE SELECTION

keep if age>=16 & age<=64
keep if lfsr94 =="Employed-At Work" |  lfsr94 =="Employed-Absent"

drop if uhours==0 
drop if  uhours==.
drop if earnwke==0 
drop if  earnwke==.
count

saveold "$data_out/morg-2014-emp.dta" , replace
