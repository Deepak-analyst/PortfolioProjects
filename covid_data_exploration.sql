select *
from PortfolioProject..CovidDeaths

select *
from PortfolioProject..CovidVaccinations

--Looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100
as DeathPercentage
from portfolioproject..coviddeaths
where location like '%states%'
order by 1,2

--Looking at total cases vs population
--shows what percentage of population got covid
 
 select location, date, total_cases, total_deaths, (cast(total_deaths as int)/population)*100 as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as highestinfectioncount,
(max(total_cases/population))*100 as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
--where location like'%states%'
group by location, population
order by percentofpopulationInfected desc

--Showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like'%states%'
group by location
order by TotalDeathCount desc

--Lets break things down by continent 

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

select date, SUM(new_cases), SUM(cast(new_deaths as float)), SUM(cast(new_deaths as float))/nullif(SUM
(New_cases),0)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
group by date
order by 1,2

--Looking at Total population vs vaccinations

select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as float)) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE

with PopvsVac (continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float, vac.new_vaccinations )) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3
)
select * ,(RollingPeopleVaccinated/Population)*100
from PopvsVac


--TEMP TABLE

drop table if exists  #PercentPopulationVaccinated 
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date  datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float, vac.new_vaccinations )) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
from #PercentPopulationVaccinated

 
CREATE VIEW PercentPopulationVaccinated as 
select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float, vac.new_vaccinations )) over(partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from dbo.PercentPopulationVaccinated