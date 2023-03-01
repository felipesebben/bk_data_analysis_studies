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

# create tidy data from original data (in stata dta format)

# Clear memory
rm(list=ls())

library(tidyverse)
library(haven)

# set your work directory to da_data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo")

# Set location folders -----------------------------------------------
data_in <- "working-from-home/raw/"
data_out <- "working-from-home/clean/"

# to compile final data set, we use 3 data sources, original data in Stata .dta format
data_quit <- read_dta(paste0(data_in, "quit_data.dta"))
data_tc   <- read_dta(paste0(data_in, "tc_comparison.dta"))
data_perf <- read_dta(paste0(data_in, "performance_during_exper.dta"))

# first combine 1st and 2nd source
data_join <- inner_join(data_quit, data_tc, by = c("personid"))

# make some changes to joint df
data_join <- data_join %>% select(-perform10_expgroup, -perform11_expgroup, -matches("\\.y")) %>% 
  rename(male = men.x, age = age.x, costofcommute = costofcommute.x, children = children.x, treatment = expgroup.x, married = married.x)


# prepare 3rd source: data_perf; keep if expgroup is 0 or 1
data_perf <- data_perf %>% filter(expgroup == 0 | expgroup ==1) %>% mutate(experiment_time = experiment_treatment + experiment_control)

data_perf <- data_perf %>% mutate(phonecalls = phonecallraw / 1000) %>% select(personid, year_week, experiment_time, treatment, phonecalls)


# aggregates from 3rd source that will be used as new columns in final combined df
data_sum <- data_perf %>% group_by(personid, experiment_time) %>% summarise(sum = sum(phonecalls, na.rm = TRUE))

data_sum <- data_sum %>% spread(key = experiment_time, value = sum, sep = "") %>% 
  rename(phonecalls0 = experiment_time0, phonecalls1 = experiment_time1)

# merge aggregates from 3rd df
data_tidy <- inner_join(data_join, data_sum, by = c("personid"))

# add new variable
data_tidy <- mutate(data_tidy, ordertaker = type == 1)

# reorder columns
nm1 <- c("personid", "treatment", "ordertaker", "type", "quitjob")

data_tidy <- data_tidy[,c(nm1,setdiff(names(data_tidy),nm1))]


# save tidy tables
write_csv(data_perf, paste0(data_out, "wfh_tidy_personweek.csv"))
write_csv(data_tidy, paste0(data_out, "wfh_tidy_person.csv"))




