import os
import pandas as pd
import warnings
import numpy as np
from numpy.random import choice
import wbgapi as wb
warnings.filterwarnings("ignore")


# Current script folder
dirname = os.getcwd()

# Get location folders

data_out = f"{dirname}/da_data_exercises/ch05-generalizing_from_data/05-WDI_CO2_GDP/data/clean/"
output = f"{dirname}/da_data_exercises/ch05-generalizing_from_data/05-WDI_CO2_GDP/data/output/"
paths = [data_out, output]

for path in paths:
    if not os.path.exists(path):
        os.makedirs(path)


indicators = {
    "NY.GDP.PCAP.PP.CD": "GDP_PPP",
    "EN.GHG.CO2.PC.CE.AR5": "CO2_Capita"
}

# Get ten years worth of data, return columns as series
df_raw = wb.data.DataFrame(indicators,
                           economy="all",
                           time=range(2014, 2025),
                           skipAggs=True, # Remove regional/world aggregates
                           numericTimeKeys=True, # Return years as integers
                           labels=True, # Add Country Column name
                           columns="series"
                           )

# Clean index
df = df_raw.reset_index()

# Rename columns
df = df.rename(columns=indicators)

# Drop missing values for metrics.
df_complete = df.dropna(subset=["GDP_PPP", "CO2_Capita"])

# Sort values by country and time, rename columns, drop columns
df_final = df_complete.sort_values(["Country", "time"], ascending=[True, False])

df_final = df_final.rename(columns={
    "economy": "Country_ISO",
    "Time": "Year"
})

df_final = df_final.drop(columns="time").reset_index(drop=True)

# Keep latest data for each country
df_final = df_final.drop_duplicates(subset="Country_ISO", keep="first")

# 1. Cleaning ---
print("--- Step 1: Cleaning ---")
# Drop Palau (Extreme outlier – see notebook)
df_clean = df_final[df_final["Country"] != "Palau"].copy()
print(f"Dropped Palau.\nNew Max CO2: {df_clean["CO2_Capita"].max():.2f} ({df_clean.loc[df_clean["CO2_Capita"].idxmax()]["Country"]})")

# 2. Prepare the "Observed World" Dataset
df_tableau = df_clean.copy()

# 2.1 Recalculate the Median for the final label
median_gdp = df_tableau["GDP_PPP"].median()

# 2.2 Assign groups
df_tableau["Income_Group"] = np.where(
    df_tableau["GDP_PPP"] > median_gdp,
    "Higher Income",
    "Lower Income"
)


# 1.3 Save to CSV
df_tableau.to_csv(f"{data_out}co_gdp_countries.csv", index=False)
print(f"File 1 Saved: 'co2_gdp_countries.csv ({len(df_tableau)} countries)")

# 3. Prepare the "Bootstrap Simulation" Dataset

def generate_boostrap_data(df, n_iterations=3000):
    stats = []
    n_obs = len(df)
    gdp_data = df["GDP_PPP"].values
    co2_data = df["CO2_Capita"].values

    print(f"Running {n_iterations} simulations...")

    for i in range(n_iterations):
        # Resample
        indices = np.random.choice(n_obs, n_obs, replace=True)
        sample_gdp = gdp_data[indices]
        sample_co2 = co2_data[indices]

        # Dynamic split
        median_split = np.median(sample_gdp)
        is_high_income = sample_gdp > median_split

        # Calculate difference
        diff = np.mean(sample_co2[is_high_income]) - np.mean(sample_co2[~is_high_income])

        # Append with ID (useful for Tableau unique counts if needed)
        stats.append({"Iteration ID" : i+1, "CO2_Gap_Difference": diff})
    
    return pd.DataFrame(stats)

n_iterations = 3000
# Run and Save
df_sim = generate_boostrap_data(df_final, n_iterations=n_iterations)
df_sim.to_csv(f"{data_out}bootstrap_simulation.csv", index=False)
print(f"File 2 Saved! 'boostrap_simulation.csv ({n_iterations} iterations)" )
