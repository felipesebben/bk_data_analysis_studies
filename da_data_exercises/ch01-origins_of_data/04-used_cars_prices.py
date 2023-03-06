import pandas as pd
import numpy as np
import requests
import os
from bs4 import BeautifulSoup
import json
from difflib import SequenceMatcher
from selenium import webdriver
import time
from datetime import date
import re
from selenium import webdriver 
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

current_path = os.getcwd()
print(current_path)
dirname = f"{current_path}/da_data_exercises/ch01-origins_of_data/"
output = f"{dirname}data/output/"


time.sleep(8)
option = webdriver.ChromeOptions() 
option.add_argument('--headless')
option.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36')

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=option)

time.sleep(5)

list_json = []

def search_data(pages, manufacturer, model):
    for x in range(0, pages):
        print(f" Loop n.: {str(x)}")
        url = f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/{manufacturer}/{model}/estado-rs/'
        if x == 0:
            print('Only one page returned')
        else:
            url=f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/{manufacturer}/{model}/estado-rs?o={str(x)}'
        
        PARAMS = {
            'authority': 'olx.com.br',
            'method': 'GET',
            'path': f'/autos-e-pecas/carros-vans-e-utilitarios/{manufacturer}/{model}/estado-rs',
            'scheme': 'https',
            'referer': 'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/estado-rs',
            'sec-fetch-mode': 'navigate',
            'sec-fetch-site': 'same-origin',
            'sec-fetch-user': '?1',
            'upgrade-insecure-requests': '1',
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
        }
        # page = requests.get(url=url, headers=PARAMS)
        # soup = BeautifulSoup(page.content, 'lxml')
        driver.get(url)
        sel_soup = BeautifulSoup(driver.page_source, 'lxml')
        items = sel_soup.find_all('li', {'class': 'sc-1fcmfeb-2 dvcyfD'})
        # print(len(items))
        
        # items_soup = sel_soup.find_all('li', {'class': 'sc-1fcmfeb-2 dvcyfD'})
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
                # print(city)
                # print(district)
                # print('----')
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
       
search_data(10,'hyundai', 'hb20')


df_cars = pd.DataFrame(list_json)

df_cars.to_csv(f"{output}WS_car_prices.csv", index=False)