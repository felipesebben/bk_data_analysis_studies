clear
cd "your directory"
global ROOT "da_data_repo\airline-tickets-usa"


**************************************************************
* Raw data stored in /raw 
* READ "ticket" csv, select variables, save temp Stata file
* READ "coupon" csv, select variables, 
*  coupon file at coupon level, AGGREGATE to itinerary level 
*  (reshape and then create new variables)
* MERGE "ticket" and "coupon", 
* SAVE Stata file itinerary-level

* SAVE "originfinal-panel.dta" for analysis

cd $ROOT\raw

forvalue y = 2010/2016 {
	forvalue q = 1/4 {
		
		noisily display " "
		noisily display "`y'  `q'"
		
	capture {
		clear
		noisily insheet using "$ROOT\raw\DB1BTicket\Origin_and_Destination_Survey_DB1BTicket_`y'_`q'.csv"
		keep if dollarcred==1 /* if credible dollar amount */
		keep itinid origin rpcarrier passen itinfare
		compress
		noisily save temp1,replace
		
		clear
		noisily insheet using "$ROOT\raw\DB1BCoupon\Origin_and_Destination_Survey_DB1BCoupon_`y'_`q'.csv"
		keep itinid seqnum dest tkcarrier opcarrier
		quietly sum seqnum, d
		local s = r(max)
		*dis `s'
		reshape wide dest tkcarrier opcarrier, i(itinid) j(seqnum)
		gen temp=tkcarrier1
		 drop tkcarrier*
		 rename temp tkcarrier
		qui foreach x in dest opcarrier {
			gen str45 `x'_seq = ""
			forvalue i=1/`s' {
				cap replace `x'_seq  =`x'_seq + `x'`i' if `x'`i'!=""
				cap drop `x'`i'
			}
		}
		compress
		noisily save temp2,replace
		
		use temp1,replace
		noisily merge 1:1 itinid using temp2, nogen keep(3)
		 * a few non-matches, coupon only b/c dropped in tickets (dollarcred)
		noisily save itin_`y'_`q',replace
		}
	
	}
}


**************************************************************
* TIDY
* CREATE aggregate panel file
* airline - route - year_quarter level data

cd $ROOT

clear
set obs 1
gen temp=1
save airline-route-panel,replace

forvalue y = 2010/2016 {
	forvalue q = 1/4 {
	
	capture {
		noisily dis ""
		noisily dis "`y'   `q'"
		use "$ROOT\raw\itin_`y'_`q'",replace
		compress
		gen str60 route = origin + dest_seq
		rename tkcarrier airline
		drop dest_seq

		collapse (first) origin opcarrier_seq rpcarrier ///
			(sum) passen itinfare ////
			, by(route airline)
		gen year = `y'
		gen quarter = `q'
		noisily tab year quarter
		order route airline year quarter origin
		compress
		append using "$ROOT\airline-route-panel"
		noisily save "$ROOT\airline-route-panel",replace
		}
	}
}

drop if temp==1
drop temp
sort route airline year quarter
save "$ROOT\airline-route-panel",replace



***************************************************** 
* CREATE variables describing type of route
cd $ROOT

use airline_route_panel,replace

gen airports = int(strlen(route)/3)
gen return = substr(route,1,3)==substr(route,-3,.)
gen stops = 0 if strlen(route)==6 & return==0 
 replace stops = 1 if strlen(route)==9  & return==0
 replace stops = 2 if strlen(route)==12 & return==0
 replace stops = 3 if strlen(route)==15 & return==0
 replace stops = 0 if strlen(route)==9  & return==1 
 replace stops = 1 if strlen(route)==15 & return==1 
 replace stops = 2 if strlen(route)==21 & return==1 
 replace stops = 3 if strlen(route)==27 & return==1 
 tab stops return,mis
 
gen return_sym = airports==3 if return==1
 replace return_sym = 1 if airports==5 & return==1 ///
	& substr(route,4,3)==substr(route,-6,3) 	
 replace return_sym = 1 if airports==7 & return==1 ///
	& substr(route,4,3)==substr(route,-6,3) ///	
	& substr(route,7,3)==substr(route,-9,3) 	
 replace return_sym = 1 if airports==9 & return==1 ///
	& substr(route,4,3)==substr(route,-6,3) ///	
	& substr(route,7,3)==substr(route,-9,3) ///
	& substr(route,10,3)==substr(route,-12,3) 	

tabstat pass if return==0, by(stops) mis s(sum n) format(%11.0fc)
tabstat pass if return==1, by(stops) mis s(sum n) format(%11.0fc)

gen str3 finaldest = substr(route,-3,3) if return==0 & airports<=4
 replace finaldest = substr(route,4,3)  if return==1 & airports==3
 replace finaldest = substr(route,7,3)  if return==1 & airports==5
 replace finaldest = substr(route,10,3) if return==1 & airports==7
 replace finaldest = substr(route,13,3) if return==1 & airports==9

tabstat pass if finaldest!="", by(return) mis s(sum n) format(%11.0fc)
tabstat pass if finaldest=="", by(return) mis s(sum n) format(%11.0fc)
 
replace airline = rpcarrier 
drop rpcarrier opcarrier
 
lab var airline "Airline (reporting)"
 lab var return "return route"
 lab var airports "# airports in route (inc. origin)"
 lab var return_sym "return route, symmetric (same stops both way)"
 lab var stops "# stops (for return routes: with airport in middle only)"
 lab var finaldest "Airport of final destination (if straightforward to tell)"
 lab var origin "Airport of origin"
 
 
compress
order route airline year quarter origin finaldest airports return* stops
save airline-route-panel,replace



***************************************************** 
* TIDY
* CREATE origin X final destination - airline - yq level panel file
* (where final destination is straighforward)
cd $ROOT
use airline_route_panel,replace

drop if finaldest==""
 
collapse (first) airports return* stops (sum) passengers itinfare, ///
 by(origin finaldest airline year quarter)
 compress
save originfinal-panel,replace


***************************************************** 
* TIDY
* CREATE origin - airline - yq level panel file

use airline_route_panel,replace

 
collapse (first) airports return* stops (sum) passengers itinfare, ///
 by(origin airline year quarter)
 compress
save airline-origin-panel,replace





***************************************************** 
* TIDY
* CREATE origin X final destination yq level panel file
* (where final destination is straighforward)
*  new variable: share of each airline in market
use airline_originfinal_panel,replace

qui tab airline, gen(temp)
foreach v of varlist temp* {
	dis " "
	des `v'
	local varlab: variable label `v'
	dis "`varlab'"
	local newname = substr("`varlab'", 10, .)
	dis "`newname'"
	rename `v' ptotal`newname'
	replace ptotal`newname' = ptotal`newname' *passengers
}

 
collapse (first) airports return* stops (sum) passengers itinfare ptotal*, ///
 by(origin finaldest year quarter)
 
rename ptotal* share*
foreach v of varlist share* {
	replace `v' = `v'/pass
	cap local a = substr(`v',6,.)
	cap local a = substr("`v'",6,.)
	lab var `v' "Market share of airline `a'"
}
egen sharelargest = rowmax(share*)
 lab var sharelargest "Market share of airline with largest share"

gen avgprice = itinfare/pass
order origin finaldest year quarter airports return* stops avgp pass itinf sharelargest
 compress
save originfinal-panel,replace

tabstat sharelargest, by(year) s(min p50 p75 p90 p95 max mean)
tabstat shareAA, by(year) s(min p50 p75 p90 p95 max mean)
tabstat shareUS, by(year) s(min p50 p75 p90 p95 max mean)


***************************************************** 
* TIDY
* CREATE origin yq level panel file
*  new variable: share of each airline in market
use airline_origin_panel,replace

qui tab airline, gen(temp)
foreach v of varlist temp* {
	dis " "
	des `v'
	local varlab: variable label `v'
	dis "`varlab'"
	local newname = substr("`varlab'", 10, .)
	dis "`newname'"
	rename `v' ptotal`newname'
	replace ptotal`newname' = ptotal`newname' *passengers
}

 
collapse (first) airports return* stops (sum) passengers itinfare ptotal*, ///
 by(origin year quarter)
 
rename ptotal* share*
foreach v of varlist share* {
	replace `v' = `v'/pass
	cap local a = substr(`v',6,.)
	cap local a = substr("`v'",6,.)
	lab var `v' "Market share of airline `a'"
}
egen sharelargest = rowmax(share*)
 lab var sharelargest "Market share of airline with largest share"

gen avgprice = itinfare/pass
order origin year quarter airports return* stops avgp itinf sharelarge
 compress
save airline-origin-panel,replace


tabstat sharelargest, by(year) s(min p50 p75 p90 p95 max mean)
tabstat shareAA, by(year) s(min p50 p75 p90 p95 max mean)
tabstat shareUS, by(year) s(min p50 p75 p90 p95 max mean)
