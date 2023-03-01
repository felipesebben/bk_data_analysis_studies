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

# Chapter 04
# wms-management-survey
# using WMS data 2004-2015

######################################################################

# Clear memory
rm(list=ls())

# Import libraries
require(readstata13)
library(dplyr)


# Set the path

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "wms-management-survey/raw/"
data_out <- "wms-management-survey/clean/"

########################################################################

# Import raw data 
data <- read.dta13(paste0(data_in, "wms_da_textbook.dta"))

# create xsec
# keep the last row when a firm is sampled many times

data <- data %>% arrange(firmid,wave) %>% distinct(firmid, .keep_all = TRUE)


# Save file
write.csv(data, paste0(data_out, "wms_da_textbook-xsec.csv"), row.names = F)

