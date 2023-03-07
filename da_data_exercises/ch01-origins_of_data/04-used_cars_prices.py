import pandas as pd
import numpy as np
import os
from bs4 import BeautifulSoup
from selenium import webdriver
import time
import datetime
from selenium import webdriver 
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

#  Get dirname and output path to store scraped data
current_path = os.getcwd()
dirname = f"{current_path}/da_data_exercises/ch01-origins_of_data/"
output = f"{dirname}data/output/"

# Set the options for the selenium webdriver and install the driver
option = webdriver.ChromeOptions() 
option.add_argument('--headless')
option.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36')

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=option)

time.sleep(5)

#  Create empty list in which the data will be stored
list_json = []

def search_data(pages, manufacturer, model):
    """
    Access a url for car ads, extracts relevant data properly formated,
    and stores it in a json file.
    """
    for x in range(0, pages):
        # Define two different urls as the webpage uses pagination
        print(f" Loop n.: {str(x)}")
        url = f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/{manufacturer}/{model}/estado-rs/'
        if x == 0:
            print('Only one page returned')
        else:
            url=f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/{manufacturer}/{model}/estado-rs?o={str(x)}'
        
        # Access the url with selenium
        driver.get(url)
        # Parse each page and get the main element that contains the data
        sel_soup = BeautifulSoup(driver.page_source, 'lxml')
        items = sel_soup.find_all('li', {'class': 'sc-1fcmfeb-2 dvcyfD'})
        
        # Loop through each element and discard others that are ads using try-except
        for item in items:
            try:
                car_name = item.find_all('h2')[0].contents[0]
                price = item.find_all('span', {'class': 'm7nrfa-0 eJCbzj sc-ifAKCX jViSDP'})[0].contents[0]
                price = price.split('R$')[1]
                price = float(price.replace('.', ''))
                post_date = item.find_all('span', {'class': 'sc-11h4wdr-0 javKJU sc-ifAKCX lgjPoE'})[0].contents[0]
                post_day = post_date.split(',')[0].rstrip()
                post_hour = post_date.split(',')[1].lstrip()
                car_url = item.find('a')['href']
                mileage = item.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[0].contents[0]
                mileage = mileage.split('km')[0]
                mileage = float(mileage.replace('.', ''))
                year = item.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[1].contents[0]
                gear = item.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[2].contents[0]
                fuel = item.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[3].contents[0]
                location = item.find_all('span', {'class': 'sc-1c3ysll-1 cLQXSQ sc-ifAKCX lgjPoE'})[0].contents[0]
                try:
                    city = location.split(',')[0].rstrip()
                    city_clean = city.split('-')[0].rstrip()                    
                except:
                    city = location
                try:
                    district = location.split(',')[1].lstrip()
                    district_clean = district.split('-')[0].rstrip()
                except:
                    pass
                
                # Store the content in a json dict and append each observation to the empty list
                json = {
                    "car_model": car_name,
                    "car_price": price,
                    "date": post_day,
                    "time": post_hour,
                    "total_mileage": mileage,
                    "year": year,
                    "gear_type": gear,
                    "fuel_type": fuel,
                    "url": car_url,
                    "city": city_clean,
                    "area": district_clean,
                }
                
                list_json.append(json)
            except:
                pass
       
search_data(15,'hyundai', 'hb20')

# Convert the json to a pandas DataFrame
df_cars = pd.DataFrame(list_json)

# Replace strings that represent "today" and "yesterday" to equivalent dates
df_cars['date'].mask(df_cars['date'] == 'Hoje', datetime.date.today(), inplace=True)
df_cars['date'].mask(df_cars['date'] == 'Ontem', datetime.date.today() - datetime.timedelta(days=1), inplace=True)

# Export the data to a csv for later use
df_cars.to_csv(f"{output}WS_car_prices.csv", index=False)