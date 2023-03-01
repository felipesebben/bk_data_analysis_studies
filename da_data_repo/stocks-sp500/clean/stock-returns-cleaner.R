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

# set working directory for data_repo
setwd("/Users/vigadam/Dropbox/work/data_book/da_data_repo/")
data_in <- "stocks-sp500/raw/"
data_out <- "stocks-sp500/clean/"

# load and extract MSFT

df <- read_delim(paste(data_in,"ready_sp500_45_cos.csv",sep=""),
                 delim = ",",
                 quote = '"',)

df <- df %>% filter(ticker == "MSFT") %>% 
  mutate(date = as.Date(ref.date),
         p_MSFT = price.close)

df_MSFT <- df %>% select(c("date","p_MSFT"))

# load and extract SP500

df <- read_delim(paste(data_in,"ready_sp500_index.csv",sep=""),
                 delim = ",",
                 quote = '"',)

df <- df %>% mutate(date = as.Date(ref.date),
                    p_SP500 = price.close)

df_SP500 <- df %>% select(c("date","p_SP500"))

# merge data and filter by date

df <-  merge(df_SP500, df_MSFT, all=FALSE, by="date")

df <- df %>% mutate(year = format(date,"%Y"),
              month = format(date,"%m"),
              ym = format(date, "%Y-%m"))

col_order <- c("ym", "year", "month", "date", "p_SP500", "p_MSFT")
df <- df[, col_order]

df <- df %>% filter(date >= "1997-12-31") %>% filter(date <= "2018-12-31")

df %>% write.csv(paste(data_out,"stock-prices-daily.csv",sep=""), row.names=FALSE)

