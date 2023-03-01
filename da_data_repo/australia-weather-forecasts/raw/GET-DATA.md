To get data for Australian weather forecast


## Download data
Go to [Data source website](https://data.gov.au/data/dataset/weather-forecasting-verification-data-2015-05-to-2016-04)
Download and extract `bometa20150501-20160430.zip`  
[from HERE](https://data.gov.au/data/dataset/weather-forecasting-verification-data-2015-05-to-2016-04/resource/16083945-3309-4c8a-9b64-49971be15878)

## Set up folders
Unzip to create
`bometa20150501-20160430/BoM_ETA_20150501-20160430` folder

There will be subdirectories are `fcst` and `obs` and `spatial` folders containing forecast and observation csvs. 

It's gonna be a very large folder, like 10GB when unzipped. 

## Data prep

Run the australia_get_data.R to combine all the small csv files into a larger one. 
The code will save a simple and small csv into the /clean folder. 

