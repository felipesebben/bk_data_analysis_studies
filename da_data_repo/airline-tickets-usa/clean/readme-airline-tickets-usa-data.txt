Airlines data
Gabor Kezdi
2019.02.26.

notes
y = year (for now 2011 and 2016 only)
q = quarter (1 to 4)
aiport code used here is the 3-letter string


Raw data tables

DB1B_COUPONS_y_q.dta
 observations: itinerary level, n~3 million per quarter
 ID variable: itinid
 key variable(s): dest_id string for "destination:" all airports in the route except origin

Origin_and_Destination_Survey_DB1BTicket_y_q.csv
 observations: itinerary level, n ~ 3 million per quarter
 ID variable: itinid
 key variable(s): origin string for origin airport
		  dollarcred dollar credibility indicator
		  rpcarrier reporting carrier (airline)
		  passengers # passengers on itinerary (ticket)
		  itinfare airfare (total price of ticket)
 source of data: Airlien Origin and Destination Sruvey (DB1B), https://www.transtats.bts.gov/DatabaseInfo.asp?DB_ID=125
 " The Airline Origin and Destination Survey (DB1B) is a 10% sample of airline tickets from reporting carriers collected by the Office of Airline Information of the Bureau of Transportation Statistics. "


Tidy data tables

route_airline_panel.dta
 observations: 	route X year X quarter level, n ~ 500 th per quarter
 		  route: unique combination of airports in itinerary (e.g., DTW MSP DTW)
		merged DB1B_COUPONS and DB!B_Ticket files, by itinid wihtin each quarter
			(ISSUE: some 20% of itineraries don't match; mostly only in DB1B_Ticket)
 ID variables:	route (string) year quarter
		  created from "origin" and "dest_id"
 key variables: passengers total # passengers 
		itinfare sum of airfare
		return if return route (calculated from route; if first 3 letters same as last 3 letters)
		stops  # stops (non-return routes: # airports between first and last airport
				return routes: only if symmetric route, # airport between first 
						and middle airport)

originfinaldest_airline_panel.dta
 observations: 	origin X finaldest X year X quarter level, n ~ 150 th per quarter
		aggregated from route_airlines_panel.dta (missing finaldest dropped)
			(ISSUE: some 20% of itineraries don't match; mostly only in DB1B_Ticket)
 ID variables:	origin (string) finaldest (string) year quarter
 		finaldest: final destination, created from route
			   (non-return routes: last airport
			    return routes: middle airport, defined only for symmetric routes
			    missing value for 10% of passengers b/c non-symmetric return route)
 key variables: passengers total # passengers 
		itinfare sum of airfare
		return if return route 
		stops  # stops 


Workfiles

