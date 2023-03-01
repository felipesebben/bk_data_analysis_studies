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

# CHAPTER 18
# CH18B Forecasting a house price index
# case-shiller-la dataset

# get data from FRED

# ------------------------------------------------------------------------------------------------------
#### SET UP
# It is advised to start a new session for every case study
# CLEAR MEMORY
rm(list=ls())

# Import libraries
library(fredr) # to get data
library(tidyverse)
library(fpp3)


# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")
data_out <- "case-shiller-la/clean/"


#############################
# DATA PREP
#############################
#load data

# ask a key https://research.stlouisfed.org/docs/api/api_key.html
# fredr_set_key("f00b551c3f32b72b5e7dcb106fa05a98")
fredr_set_key("ba2782707066352117665b91a93b6e26")


series <- list(
  series_id = c("LXXRSA", "CAUR", "CANA", "LXXRNSA", "CAURN", "CANAN"),
  frequency = c("m", "m", "m", "m", "m", "m")
)

data_orig <- purrr::pmap_dfr(series, ~{
  fredr(series_id = .x, frequency = .y)
})


data <- data_orig %>% mutate(date = as.Date(date, "%Y-%m-%d")) %>% 
                      mutate(year = format(date, "%Y"),
                             month = format(date, "%m"))

# keep 2000 onward

data <- data %>% filter(year >= 2000)

# Create variables

data <-  data %>% pivot_wider(names_from = c(series_id),values_from=c(value))

data <- data %>% 
  mutate(ps = LXXRSA, # Home price index, seasonally adjusted
         pn = LXXRNSA, # Home price index, not seasonally adjusted
         us = CAUR, # Unemployment rate, seasonally adjusted
         un = CAURN, # Unemployment rate, not seasonally adjusted
         emps = CANA, # Total employment, seasonally adjusted
         empn= CANAN, # Total employment, not seasonally adjusted
          )

# order and keep variables

data <- data %>% select("date","year","month","ps","pn","us" ,"un","emps","empn")

# save tidy csv file
# 2000 - 2018 
data <- data %>% filter(year <= 2018)

# Save workfile 
write_csv(data, paste0(data_out, "homeprices-data-2000-2018.csv"))





