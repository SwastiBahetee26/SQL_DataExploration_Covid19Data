# SQL_DataExploration_Covid19Data
# COVID-19 Data Exploration with SQL Server

## Project Overview

This project involves exploring and analyzing COVID-19 data using SQL Server. The data was initially obtained from a CSV file and was further refined into two separate Excel files for focused analysis on deaths and vaccinations. By running SQL queries on these datasets, you can gain insights into global infection rates, mortality, and vaccination trends.

## Data Source

The original data was sourced from the [Our World in Data COVID-19 Dataset](https://ourworldindata.org/covid-deaths) and was downloaded as a CSV file named `owid-covid-data.csv`. From this file, two Excel files were created:

1. **CovidDeaths.xlsx** - Contains data specific to COVID-19 deaths.
2. **CovidVaccinations.xlsx** - Contains data specific to COVID-19 vaccinations.

## How to Use

To work with this project, follow these steps:

1. **Set Up SQL Server**:
   - Install SQL Server if it’s not already installed on your computer.
   - Create new databases named `CovidDeaths` and `CovidVaccinations`.
   - Import the `CovidDeaths.xlsx` and `CovidVaccinations.xlsx` files into their respective databases.

2. **Run SQL Queries**:
   - Open SQL Server Management Studio (SSMS).
   - Connect to the `CovidDeaths` and `CovidVaccinations` databases.
   - Execute the provided SQL scripts to analyze the data and generate insights.

## Example Queries

Here’s an example query to identify the countries with the highest infection rates compared to their population:

### For Highest Infection Rate Compared to Population:

```sql
SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfectionCount, 
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM 
    PortfolioProject..CovidDeaths  
WHERE 
    continent IS NOT NULL
GROUP BY 
    location, population
ORDER BY 
    PercentPopulationInfected DESC;
