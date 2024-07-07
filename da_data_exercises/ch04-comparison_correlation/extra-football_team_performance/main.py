import requests
import pandas as pd
import os

from dotenv import load_dotenv
load_dotenv(r"C:\Users\Felipe\python_work\Projects\bk_data_analysis\da_data_exercises\ch04-comparison_correlation\05-football_team_performance\.env")

API_KEY = os.getenv("API_KEY")
url = "https://v3.football.api-sports.io/"


def call_api(url_endpoint, params):
    url_call = f"{url}{url_endpoint}"

    response = requests.get(url=url_call, headers=headers, params=params)
    print(response.status_code)
    data = response.json()
    return data

parameters = {"season": 2022,
              "league": 71,
              }
headers = {
    "x-rapidapi-key": f"{API_KEY}",
    "x-rapidapi-host": "v3.football.api-sports.io",
    }

request = call_api(url_endpoint="fixtures", params=parameters)
df = pd.DataFrame(request["response"])
print(df.head(20))