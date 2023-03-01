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
# version 1.1 2021-05-16
#########################################################################################

# Chapter 18 time series - swim ticket sales
# WHAT THIS CODES DOES:
# cleans data and aggregates to daily. 

###########################################################


# Clear memory -------------------------------------------------------
rm(list=ls())

# Import libraries ---------------------------------------------------
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyverse)
library(Hmisc)
library(timeDate)
library(caret)

# Change working directory -------------------------------------------
# Make sure you are set up such that 
# 1. you are in the folder designated for Data Analysis.
# 2. You have a folder called da_case_studies, with the saved folder for this case study
# 3. You have a folder called da_data_repo, with data for this case study on it.


# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "swim-transactions/raw/"
data_out <- "swim-transactions/clean/"


#############################################
# DATA CLEANING
#############################################

# Load raw data ------------------------------------------------------

raw <- as.data.frame(read.table(paste0(data_in,"SwimmingPoolAdmissionsCABQ-en-us.csv"),
                                sep = "\t",
                                header = TRUE,
                                fileEncoding = "UCS-2LE",
                                strip.white = TRUE))

# Filter data, create workfile --------------------------------------------------------

data <- raw

data <- data %>%
  filter(Location == 'AQSP01') %>% #a single outdoor pool Sunport
  filter(Category %in% c("ADMISTIER1","ADMISTIER2")) %>%
  mutate(date = as.Date(Date_Time, format = "%Y-%m-%d")) 
Hmisc::describe(data$ITEM)

data <- data %>%
  mutate(core1 =  (ITEM %in%  c("ADULT" , "SENIOR" ,"TEEN" ,"CHILD", "TOT"))) %>%
  mutate(core2 =  (ITEM %in%  c("CHILD PM","ADULT PM","SENIOR PM", "TOT PM", "TEEN PN"))) %>%
  filter(core1 | core2) %>%
  mutate(date = as.Date(Date_Time, format = "%Y-%m-%d")) 

# Agrregate date to daily freq --------------------------------------

daily_agg <- aggregate(QUANTITY ~ date, data = data, sum)

# replace missing days with 0 
daily_agg <- daily_agg %>% 
  merge(data.frame(date = seq(from = min(daily_agg[,"date"]), to = max(daily_agg[,"date"]), by = 1)),
        all = TRUE) %>% 
  mutate(QUANTITY = ifelse(is.na(QUANTITY),0,QUANTITY))

# Create date/time variables ----------------------------------------

# 2010-2016 only full years used. 
daily_agg <- daily_agg %>%
  filter(date >= as.Date("2010-01-01")) %>%
  filter(date < as.Date("2017-01-01"))
Hmisc::describe(daily_agg)

# Save workfile
write.csv(daily_agg,paste(data_out,"swim_work.csv",sep=""), row.names = FALSE)               
