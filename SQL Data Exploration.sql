SELECT *
FROM CovidDeaths
ORDER BY 1,2

SELECT *
FROM CovidVaccinations
ORDER BY 1,2

--Death percentage

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM CovidDeaths
WHERE location like '%Italy'
ORDER BY 1,2

--Infectionpercentage

Select Location, date, total_cases,population, (total_cases/population)*100 as InfectionRate
FROM CovidDeaths
WHERE location like '%mbabwe'
ORDER BY 1,2

--Highest infection per country
Select Location, max(total_cases) as HighestInfectionCount, population, (max(total_cases)/population)*100 as InfectionRate
FROM CovidDeaths
--WHERE location like '%states%'
Group BY location, population
ORDER BY InfectionRate DESC

--Highest Death Count per population
Select Location, max(cast(total_deaths as int)) as HighestDeathCount, population, (max(cast(total_deaths as int))/population)*100 as Deathpercentage
From CovidDeaths
WHERE continent is not null
Group BY Location, population
ORDER BY Deathpercentage DESC

--Breaking things down by Continent
Select Location, max(cast(total_deaths as int)) as HighestDeathCount
From CovidDeaths
WHERE continent is null
Group BY Location
ORDER BY HighestDeathCount DESC

--Breaking things down globally 
Select sum(new_cases) as Totalcases, sum(cast(new_deaths as int)) as Totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
FROM CovidDeaths
WHERE continent is not null

--Breaking things down Total population vs vaccinations
SELECT Dea.date, Dea.continent, Dea.location, Dea.population, Vac.new_vaccinations
FROM CovidDeaths Dea
Join CovidVaccinations Vac
ON Dea.Location = Dea.Location
And Dea.date = Vac.date
WHERE Dea.continent is not null
Order By 3,2

--Creating view to store data for visualizations

 
Create view PercentPopulationVaccinated as
SELECT Dea.date, Dea.continent, Dea.location, Dea.population, Vac.new_vaccinations
, SUM(CONVERT(int,Vac.new_vaccinations)) Over(Partition by Dea.population order by Dea.population, Dea.date) as RollingPeopleVaccinated
FROM CovidDeaths Dea
Join CovidVaccinations Vac
ON Dea.Location = Dea.Location
And Dea.date = Vac.date
WHERE Dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated