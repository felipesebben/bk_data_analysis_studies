import requests
import yaml
import pandas as pd

with open(r"C:\Users\Felipe\python_work\Projects\bk_data_analysis\da_data_exercises\ch03-exploratory_data_analysis\config\config.yaml") as f:
    config = yaml.safe_load(f)

API_KEY = config["api_key"]
url = "https://v3.football.api-sports.io/"




# response = requests.get(url, headers=headers, params=params )

# print(response.text)

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