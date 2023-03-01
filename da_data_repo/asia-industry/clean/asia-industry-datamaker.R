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

#### SET UP
# It is advised to start a new session for every case study
# CLEAR MEMORY
rm(list=ls())

library(tidyverse)
library(readxl)
library(plyr)

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")
data_in <- "asia-industry/raw/"
data_out <- "asia-industry/clean/"

# usa imports
df <- read_excel(paste(data_in, "usa-imports.xls",sep=""),
                 sheet = "FRED Graph",
                 skip = 10)

colnames(df) <- c("date", "usa_imp_sa")

df <- df %>% mutate(year = as.Date(as.character(date),"%Y-%m-%d") %>% format("%Y"),
                    month = as.Date(as.character(date),"%Y-%m-%d") %>% format("%m"),
                    time = as.Date(as.character(date), "%Y-%m-%d") %>% format("%Y-%m")) %>% 
             select(c("time", "year", "month", "usa_imp_sa"))

df %>% write.csv(paste(data_out,"usa-imports.csv",sep=""),row.names=FALSE)


# asia monthly industrial production plus some others (exchange rate)

df <- read_delim(paste(data_in,"worldbank-monthly-asia-2019_long.csv",sep=""),
               delim = ",",
               quote = '"',)

df <- df %>% select(c("Series", "Country", "Country Code", "Time", "Value"))

colnames(df) <- names(df) %>% tolower() %>% str_replace_all(" ","")

# create time

df <- df %>% separate(time, c("year","month"), sep="M",remove=FALSE) %>% 
             drop_na(month) %>%
             mutate(year = as.integer(year), month = as.character(month)) 

# filter by year
df <- df %>% filter(year > 1990)

# rename variables

series_recode <- c("Industrial Production, constant US$,,," = "ind_prod_const",
                   "CPI Price, seas. adj.,,," = "cpi_sa",
                   "Exchange rate, new LCU per USD extended backward, period average,," = "exchnage_rate_vs_usd",
                   "Industrial Production, constant US$, seas. adj.,," = "ind_prod_const_sa",
                   "Nominal Effecive Exchange Rate,,,," = "exchange_rate_neer",
                   "Real Effective Exchange Rate,,,," = "exchange_rate_reer",
                   "CPI Price, % y-o-y, not seas. adj.,," = "cpi_yoy_nsa")

df <- df %>% mutate(series = recode(series, !!!series_recode))

# tidy data: have variables as columns (long to wide dataset)

df <- df %>% pivot_wider(names_from = series,values_from=value) %>% select(-c(time))


dropna_cols <- c("ind_prod_const","exchnage_rate_vs_usd","cpi_sa","cpi_yoy_nsa",
                 "ind_prod_const_sa","exchange_rate_neer","exchange_rate_reer")

df <- df %>% filter_at(vars(dropna_cols), any_vars(!is.na(.)))

df <- df %>% mutate(time = paste(as.character(year),"-",month, "-01",sep="")) %>% 
             mutate(time = as.Date(time, "%Y-%m-%d") %>% format("%Y-%m"))

df <- cbind(df %>% select(c("time", "year", "month", "country", "countrycode")),
            df %>% select(-c("time", "year", "month", "country", "countrycode")))


df %>% write.csv(paste(data_out,"asia-indprod_tidy.csv",sep=""), row.names=FALSE)

# merge the two dataset

df_right <- read_csv(paste(data_out,"asia-indprod_tidy.csv",sep = ""))

df_left <- read_csv(paste(data_out,"usa-imports.csv",sep = ""))

merged <- merge(df_right,df_left,by=c("time","year","month"),all=FALSE)

merged <- merged %>% mutate(month = as.integer(month))

merged %>% write.csv(paste(data_out,"asia-industry_tidy.csv",sep=""), row.names=FALSE)




