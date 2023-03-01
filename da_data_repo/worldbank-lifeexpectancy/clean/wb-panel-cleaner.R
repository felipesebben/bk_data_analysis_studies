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

#Life expectancy and GDP (per capita), xcountry regression
#data downloaded from the World Bank

#WHAT THIS CODES DOES:
  
#Imports data to R
#Manages data to get a clean dataset to work with
#Transforms GDP variable into per capita

#********************************************************************

# CLEAR MEMORY
rm(list=ls())
library(tidyverse)
library(dplyr)
library(foreign)
library(labelled)

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "worldbank-lifeexpectancy/raw/"
data_out <- "worldbank-lifeexpectancy/clean/"

data <- read_csv(paste(data_in,"worldbank-lifeexpectancy-raw.csv",sep="/"))

data <- data %>% filter(`Country Code` != "") %>% na_if("..") %>% drop_na() %>% 
  rename(year = "Time",
         lifeexp = "Life expectancy at birth, total (years) [SP.DYN.LE00.IN]",
         countrycode = "Country Code",
         countryname = "Country Name") %>% 
  mutate(population = as.numeric(`Population, total [SP.POP.TOTL]`)/1000000,
         gdppc = as.numeric(`GDP per capita, PPP (constant 2011 international $) [NY.GDP.PCAP.PP.KD]`)/1000,
         lifeexp = as.numeric(lifeexp)) %>% 
  select(-c("Time Code",
            "GDP per capita, PPP (constant 2011 international $) [NY.GDP.PCAP.PP.KD]",
            "Population, total [SP.POP.TOTL]")) %>% 
  set_variable_labels(year = "",
                      countryname= "Country Name",
                      countrycode= "Country Code",
                      lifeexp= "Life expectancy at birth, total (years) [SP.DYN.LE00.IN]",
                      population= "Population, million",
                      gdppc= "GDP per capita, '000 USD (PPT constant 2011 prices)")


write.csv(data,paste(data_out,"worldbank-lifeexpectancy.csv",sep="/"),row.names=FALSE)
