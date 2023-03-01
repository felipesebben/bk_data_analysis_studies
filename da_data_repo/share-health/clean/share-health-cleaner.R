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

# CLEAR MEMORY
rm(list=ls())

# Import libraries
library(haven)
library(tidyverse)

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "share-health/raw/"
data_out <- "share-health/clean/"

# load in raw data and save in csv
share <- haven::read_stata(paste0(data_in, "easySHARE_rel6-0-0.dta"))

names(share)[names(share) == 'br015_'] <- 'br015'

share <- subset(share, select=c(mergeid, wave, country, country_mod, int_year, 
                                int_month, female, age, eduyears_mod, sphus, 
                                br015, smoking, ever_smoked, income_pct_w4, 
                                bmi, mar_stat))

write.csv(share, paste0(data_out, "share-health.csv"), row.names = F)
