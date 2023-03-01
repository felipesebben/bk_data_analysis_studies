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

# WHAT THIS CODES DOES:
# Import stata file and save to csv

# Clear memory
rm(list=ls())

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "billion-prices/raw/"
data_out <- "billion-prices/clean/"

library(haven)

# LOAD DATA
pd <- read_dta(paste(data_in,"online_offline_ALL_clean.dta",sep=""))

write.csv(pd, paste0(data_out,"online_offline_ALL_clean.csv"), row.names = F)

