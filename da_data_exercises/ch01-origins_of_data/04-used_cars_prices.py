# from selenium import webdriver
# from webdriver_manager.chrome import ChromeDriverManager
# from selenium.webdriver.chrome.service import Service as ChromeService 
# from bs4 import BeautifulSoup
# import pandas as pd

# options = webdriver.ChromeOptions() 
# options.headless = True 

# driver_path = 'C:/Users/Felipe/python_work/Projects/bk_data_analysis/da_data_repo/chromedriver.exe'
# driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)

# pages = list(range(6))
# pages = pages[1:] #remove 0 from list

# for page in pages:
#     url = f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/hyundai/hb20/estado-rs?o={page}'
#     resposnse = driver.get(url=url)
    

# # store the html in a variable
# html = driver.page_source

# # transform the variable into parsed text with bs
# soup = BeautifulSoup(html, 'html.parser')

# # split the html into parts according to the class we're looking for
# html_splited = html.split('sc-1fcmfeb-2 eNBJyg')

# links = []

# for ad in html_splited:
#     try:
#         soup = BeautifulSoup(ad, 'html.parser')
#         link_element = soup.find('a', {'data-lurker-detail':'list_id'})
#         link = link_element.get('href')
#     except:
#         None
#     else:
#         links.append(link)

# print(links)
# titles = []
# prices = []
# descriptions = []

# for u in links:
#     try:
#         response = driver.get(url=u)
#         html = driver.page_source
#         soup = BeautifulSoup(html, 'html.parser')
#         content = soup.find('h1', {'id':'content'})
#         title = content.find('h1', {'tag':'h1'})
#         title_text = title.text
#         price = content.find('h2', {'tag':'h2'})
#         price_text = price.text
#         description = content.find('span', {'class':'ad__sc-1sj3nln-1 fMgwdS sc-ifAKCX cmFKIN'})
#         description_text = description.text
#     except:
#         titles.append('None')
#         prices.append('None')
#         descriptions.append('None')
#     else:
#         titles.append(title_text)
#         prices.append(price_text)
#         descriptions.append(description_text)

# print(titles)

import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup
import json
from difflib import SequenceMatcher
from selenium import webdriver
import time
from datetime import date
import re
from selenium import webdriver 
from selenium.webdriver.chrome.service import Service as ChromeService 
from webdriver_manager.chrome import ChromeDriverManager 

driver = webdriver.Chrome('C:/Users/Felipe/python_work/Projects/bk_data_analysis/da_data_repo/chromedriver.exe')
# driver.maximize_window()
time.sleep(8)
options = webdriver.ChromeOptions() 
options.headless = True 
options.add_argument('--headless=new')

time.sleep(5)


def search_data(pages=2, region='POA'):
    # f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/estado-rs/{region}'
    search_state = {
        'POA': 'regioes-de-porto-alegre-torres-e-santa-cruz-do-sul',
        'SUL': 'regioes-de-pelotas-rio-grande-e-bage',
        'NOR': 'regioes-de-caxias-do-sul-e-passo-fundo',
        'CTR': 'regioes-de-santa-maria-uruguaiana-e-cruz-alta',
        }
    for x in range(0, pages):
        print(f" Loop n.: {str(x)}")
        url = f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/estado-rs/{search_state[region]}'
        if x == 0:
            print('Only one page returned')
        else:
            url=f'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/estado-rs/{search_state[region]}?o={str(x)}'
        
        PARAMS = {
            'authority': 'olx.com.br',
            'method': 'GET',
            'path': '/autos-e-pecas/carros-vans-e-utilitarios/estado-rs/regioes-de-porto-alegre-torres-e-santa-cruz-do-sul',
            'scheme': 'https',
            'referer': 'https://www.olx.com.br/autos-e-pecas/carros-vans-e-utilitarios/estado-rs',
            'sec-fetch-mode': 'navigate',
            'sec-fetch-site': 'same-origin',
            'sec-fetch-user': '?1',
            'upgrade-insecure-requests': '1',
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
        }
        page = requests.get(url=url, headers=PARAMS)
        soup = BeautifulSoup(page.content, 'lxml')
        items = soup.find_all('li', {'class': 'sc-1fcmfeb-2 dvcyfD'})
        # print(len(items))
        driver.get(url)
        sel_soup = BeautifulSoup(driver.page_source, 'lxml')
        items_soup = sel_soup.find_all('li', {'class': 'sc-1fcmfeb-2 dvcyfD'})
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
                location = item.find_all('span', {'class': 'sc-1c3ysll-1 cLQXSQ sc-ifAKCX lgjPoE'})[0].contents[0]
                print(location)

            except:
                print('Error')
        for item_soup in items_soup:
            try:
                mileage = item_soup.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[0].contents[0]
                mileage = mileage.split('km')[0]
                mileage = float(mileage.replace('.', ''))
                year = item_soup.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[1].contents[0]
                gear = item_soup.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[2].contents[0]
                fuel = item_soup.find_all('span', {'class': 'sc-ifAKCX lgjPoE'})[3].contents[0]
            except:
                print('Error')
search_data(pages=2)

