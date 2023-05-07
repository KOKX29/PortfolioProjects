---ELECT * FROM CovidDeaths
---SELECT DATA THAT WE WILL BE USING

SELECT location,date,total_cases,new_cases,total_deaths,population from CovidDeaths
where continent is not null
order by 1,2

---Total Cases vs Total Deaths Shows likelihood of one dying if they contract covid 19
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as PercentageDeath
from CovidDeaths where continent is not null
order by 1,2

----Total Cases vs Population show percentage of population infected with covid
 select location,date,total_cases,population,
(Total_cases/population)*100 as Percentageinfected from CovidDeaths where continent is not null
order by 1,2

----countries with the highest infection rate compared to population
select location,MAX(total_cases),population,MAX((total_cases/population))*100 as percentageinfected
from CovidDeaths where continent is not null
group by location,population
order by percentageinfected desc

----showing countries with the highest death count per location
select location,MAX(cast(total_deaths as int))
 as TotaLDeathCount from CovidDeaths 
where continent is not null
group by location
order by TotaLDeathCount desc

----showing continent with the highest death rate

select continent,MAX(cast(total_deaths as int)) as TotalDeathspercontinent from CovidDeaths
where continent is not null 
group by continent
order by TotalDeathspercontinent desc

----Global Numbers
select sum(new_cases) as TotalCases,SUM(CAST(new_deaths as int)) as TotalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPaercentage
from CovidDeaths
where continent is not null
order by 1,2

----Looking at the total populaton vs vacination


select CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccinations.new_vaccinations from CovidDeaths
join CovidVaccinations on CovidDeaths.location=CovidVaccinations.location
and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 1,2,3

select CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int))
over (partition by CovidDeaths.location order by CovidDeaths.location,CovidDeaths.date) as RollingPeopleVacinated
from CovidDeaths
join CovidVaccinations on CovidDeaths.location=CovidVaccinations.location
and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 1,2,3

---- Using CTE to perform Calculation on Partition By in previous query
with PopvsVac(continent,Location,Date,Population,new_vaccinations,RollingPeopleVacinated)
as
(
select CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int))
over (partition by CovidDeaths.location order by CovidDeaths.location,CovidDeaths.date) as RollingPeopleVacinated
from CovidDeaths
join CovidVaccinations on CovidDeaths.location=CovidVaccinations.location
and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
)
select * ,(RollingPeopleVacinated/Population)*100 as PercentageRollingPeopleVacinated
from PopvsVac

---- Using Temp table perform Calculation on Partition By in previous query
drop table if Exists  #PercentPopulationVacvinated
 create table #PercentPopulationVacvinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVacvinated
 select CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int))
over (partition by CovidDeaths.location order by CovidDeaths.location,CovidDeaths.date) as RollingPeopleVacinated
from CovidDeaths
join CovidVaccinations on CovidDeaths.location=CovidVaccinations.location
and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 1,2,3

select * ,(RollingPeopleVaccinated/Population)*100 as PercentVaccinated
from #PercentPopulationVacvinated

----Creating view to store data for later visualization
create view PercentPopulationVacvinated as
select CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int))
over (partition by CovidDeaths.location order by CovidDeaths.location,CovidDeaths.date) as RollingPeopleVacinated
from CovidDeaths
join CovidVaccinations on CovidDeaths.location=CovidVaccinations.location
and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null

create View TotalDeathPerContinent as
select continent,MAX(cast(total_deaths as int)) as TotalDeathspercontinent from CovidDeaths
where continent is not null 
group by continent

