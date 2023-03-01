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

#**********************************************
#  Chapter 02, 23
#
#  world bank immunization rates
#inputs: 
#       fac51cfc-e0cd-4938-927b-b82e828f5ca4_Data.csv.csv
#       ac7b6203-6a02-4e39-aad1-da9ad65319d5_Data.csv

# outputs: 
#      world-bank_immunization-panel.csv
#      worldbank-immunization-continents.csv

# **********************************************

# CLEAR MEMORY
rm(list=ls())

library(tidyverse)
library(dplyr)

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "worldbank-immunization/raw/"
data_out <- "worldbank-immunization/clean/"

data <- read_csv(paste(data_in,"fac51cfc-e0cd-4938-927b-b82e828f5ca4_Data.csv",sep="/"))

data <- data %>% head(-5) %>% na_if("..") %>% 
  mutate(year = as.numeric(`Time`),
         c = `Country Code`,
         pop = as.numeric(`Population, total [SP.POP.TOTL]`)/ 1000000,
         mort = as.numeric(`Mortality rate, under-5 (per 1,000 live births) [SH.DYN.MORT]`),
         surv = (1000 - mort) / 10,
         imm = as.numeric(`Immunization, measles (% of children ages 12-23 months) [SH.IMM.MEAS]`),
         gdppc = as.numeric(`GDP per capita, PPP (constant 2011 international $) [NY.GDP.PCAP.PP.KD]`),
         lngdppc = log(gdppc),
         hexp = as.numeric(`Current health expenditure (% of GDP) [SH.XPD.CHEX.GD.ZS]`),
         ) %>% rename(countryname = "Country Name", countrycode = "Country Code") %>% 
  select(c("year","c","countryname","countrycode","pop","mort","surv","imm","gdppc","lngdppc","hexp",)) %>% 
  filter(year >= 1998) %>% drop_na(c("imm", "mort", "pop"))

write.csv(data,paste(data_out,"worldbank-immunization-panel.csv",sep="/"),row.names=FALSE)

# CONTINENT

data <- read_csv(paste(data_in,"ac7b6203-6a02-4e39-aad1-da9ad65319d5_Data.csv",sep="/"))

data <- data %>% head(-5) %>% na_if("..") %>% 
  mutate(year = as.numeric(`Time`),
         c = `Country Code`,
         mort = as.numeric(`Mortality rate, under-5 (per 1,000 live births) [SH.DYN.MORT]`),
         surv = 1000 - mort,
         imm = as.numeric((`Immunization, measles (% of children ages 12-23 months) [SH.IMM.MEAS]`))) %>% 
  drop_na("imm") %>% filter(year >= 1998 & `Country Name` != "World") %>% 
  select(c("year", "c", "imm", "surv")) %>% arrange(year,c) %>% 
  pivot_wider(names_from = c(c),values_from=c(imm,surv))
  
write.csv(data,paste(data_out,"worldbank-immunization-continents.csv",sep="/"),row.names=FALSE)

