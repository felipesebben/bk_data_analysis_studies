#########################################################################################
# Prepared for Gabor's Data Analysis
#
# Data Analysis for Business, Economics, and Policy
# by Gabor Bekes and  Gabor Kezdi
# Cambridge University Press 2021
#
# gabors-data-analysis.com 
#
# License: Free to share, modify and use for educational purposes. 
# 	Not to be used for commercial purposes.

# Chapter 11
# CH11B Are Australian weather forecasts well calibrated?
# CREATING the australia-weather-forecasts dataset from raw data
# version 1.1 2021-05-16
#########################################################################################



# ------------------------------------------------------------------------------------------------------
#### SET UP
# It is advised to start a new session for every case study
# CLEAR MEMORY
rm(list=ls())

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

data_in <- "australia-weather-forecasts/raw"
data_out <- "australia-weather-forecasts/clean"

library(data.table)
library (dplyr)


### Preparation
# downloaded from 
# Go to https://data.gov.au/data/dataset/weather-forecasting-verification-data-2015-05-to-2016-04
# Download and extract bometa20150501-20160430.zip  from  https://data.gov.au/data/dataset/weather-forecasting-verification-data-2015-05-to-2016-04/resource/16083945-3309-4c8a-9b64-49971be15878

Dir <- paste(data_in,"BoM_ETA_20150501-20160430", sep = "/")
Dir

#in Dir there will be subdirectories are "fcst" and "obs" and "spatial" folders containing forecast and observation csvs. 

# set stations
Stations <- c(14015, 32040, 17126) #Darwin, Townsville, Marree

### Functions to avoid memory explosion
onefile_read <- function(filename, param)
{
  tmp <- fread (filename)
  return (tmp[station_number %in% Stations & parameter == param,])
}

Allfiles_read <- function (Subdir, filter_param)
{
  Tmp_Dir <- paste0 (Dir, "/",Subdir)
  files <- list.files (path = Tmp_Dir, full.names = TRUE, pattern = "*.csv")
  ret_tab <- do.call (rbind, lapply (files, onefile_read, param = filter_param))
  return(ret_tab)
}
  

### Reading data
fcst <- Allfiles_read( "fcst", "DailyPoP1")
obs <- Allfiles_read("obs", "PRCP")


# base_time: present only for forecast data. Time in seconds since the Epoch. This is a standardised base time that represents when a forecast is prepared
# valid_start integer time in seconds since the Epoch. This is the start of the time period for which the forecast or observed value correspond to.
# valid_end integer time in seconds since the Epoch. This is the end of the time period for which the forecast or observed value correspond to.

### Converting timestamps to artificial forecast days
fcst [, bd_FC_time := as.POSIXct(base_time, origin="1970-01-01", tz="Australia/Darwin") - 30*60]
fcst [, bd_Start_time := as.POSIXct(valid_start, origin="1970-01-01", tz="Australia/Darwin") - 30*60]
fcst [, bd_End_time := as.POSIXct(valid_end, origin="1970-01-01", tz="Australia/Darwin") -30*60]
fcst [, bd_FC_Before_Start := (valid_start - base_time)/3600]

obs [, bd_Start_time := as.POSIXct(valid_start, origin="1970-01-01", tz="Australia/Darwin") - 30*60]
obs [, bd_End_time := as.POSIXct(valid_end, origin="1970-01-01", tz="Australia/Darwin") - 30*60]
obs [, bd_qc_Start_time := as.POSIXct(qc_valid_minutes_start, origin="1970-01-01", tz="Australia/Darwin") - 30*60]
obs [, bd_qc_End_time := as.POSIXct(qc_valid_minutes_end, origin="1970-01-01", tz="Australia/Darwin") - 30*60]



### daily_rain: summarizing hourly rainfall levels to daily
daily_rain <- obs %>%
  group_by (station_number, date = substr(as.character(bd_qc_Start_time),1,10)) %>%
  summarise (daily_sum = sum(value)) %>%
  data.table()
  

### Merging FC and observation per day
fc_and_obs <- fcst [, .(bd_Start_time = as.character(bd_Start_time), prob = value, bd_FC_Before_Start, station_number)] %>%
  left_join (daily_rain, by = c("bd_Start_time" = "date", "station_number" = "station_number")) %>%
  filter (!is.na(daily_sum)) %>%
  mutate (daily_sum = ifelse (daily_sum >= 1,1,0)) %>%
  data.table()

### Adding Station name
Station_number_name <- fread (paste0 (Dir, "/spatial/StationData.csv")) %>% select (station_number, station_name)
fc_and_obs <- fc_and_obs %>% left_join (Station_number_name)

### Saving 
fwrite (file = (paste(data_out, "rainfall_australia.csv", sep = "/")), fc_and_obs)

