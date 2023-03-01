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

# ILLUSTRATION STUDY FOR CHAPTER 9
# DATA US CENSUS 2014

# WHAT THIS CODES DOES:

# Loads the data csv
# Filter the dataset and save a sample used in the analysis

# CLEAR MEMORY
rm(list=ls())

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")

#location folders
data_in <- "cps-earnings/raw/"
data_out <- "cps-earnings/clean/"


#import data
data_all <- read.csv(paste0(data_in,"morg2014.csv"),
                     stringsAsFactors = F)

#  select variables and rename (to get smaller file)
data_all <- data_all[, c("hhid", "intmonth", "stfips", "weight", "earnwke", "uhourse", 
                          "grade92", "race", "ethnic", "age", "sex", "marital", "ownchild", "chldpres", "prcitshp",
                         "state","ind02", "occ2012", "class94", "unionmme","unioncov", "lfsr94")]

colnames(data_all)[colnames(data_all) == 'uhourse'] <- 'uhours'
colnames(data_all)[colnames(data_all) == 'class94'] <- 'class' 


#SAMPLE SELECTION
data_all<-subset(data_all,data_all$uhours!=0 & !is.na(data_all$uhours))
data_all<-subset(data_all,data_all$earnwke!=0 & !is.na(data_all$earnwke))
data_all<-subset(data_all,data_all$age>=16 & data_all$age<=64)

write.csv(data_all,paste(data_out,"morg-2014-emp.csv",sep=""))
