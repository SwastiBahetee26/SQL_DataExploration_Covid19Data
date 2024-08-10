Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4


--Selecting useful data

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Total cases v/s Total deaths
--Indicates possibility of dying if you catch covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
where location like '%india%'  
where continent is not null
order by 1,2


--Total cases v/s Population
--Indicates what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths 
where location like '%india%' 
where continent is not null
order by 1,2


--Indicateses countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths  
--where location like '%india%'
where continent is not null
Group by location, population
order by PercentPopulationInfected desc


--Indicateses countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths  
--where location like '%india%'
where continent is not null
Group by location
order by HighestDeathCount desc


--Break things down by Continents
 
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths  
--where location like '%india%'
where continent is null
Group by location
order by HighestDeathCount desc


--Continents with highest death count

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths  
--where location like '%india%'
where continent is not null
Group by continent
order by HighestDeathCount desc








--GLOBAL NUMBERS

Select date, SUM(new_cases) as TotalCases , SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/nullif(SUM(new_cases),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--where location like '%india%'  
where continent is not null
group by date
order by 1,2



--Total cases around the world

Select SUM(new_cases) as TotalCases , SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/nullif(SUM(new_cases),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--where location like '%india%'  
where continent is not null
order by 1,2




--Joining two tables

Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date


--Looking at total population v/s vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
order by 2,3


--With CTE
With PopvsVac (continent, location, population, date, new_vaccinations, RollingPeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated / CONVERT(float, population) * 100) as VaccinationPercentage
From PopvsVac




--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentpopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 --where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated / CONVERT(float, population) * 100) as VaccinationPercentage
From #PercentpopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
--order by 2,3


