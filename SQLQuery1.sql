--basic select comment of sql
select * from
portfolioproject..CovidDeaths



select location,date,new_cases,total_cases,total_deaths,population
from 
portfolioproject..CovidDeaths
where continent is not null
order by 1,2


select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths,  population
from portfolioproject..CovidDeaths
order by 1,2


--looking for the country with the highest covid cases compared to percentpopulatioinfected
select location,population,max(total_cases) as highestcases, (max((total_cases/population))*100) as percentpopulatioinfected 
from portfolioproject..CovidDeaths
where continent is not null
group by location,population
order by percentpopulatioinfected desc


--checking out highest death count with respective to the population
select location,population,max(cast(total_deaths as int)) as total_death_count
from portfolioproject..CovidDeaths
where continent is not null
group by location,population
order by total_death_count desc

--let's do it wit continent
select continent,max(cast(total_deaths as int)) as total_death_count
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc


--global number

select date,sum(new_cases) as total,
sum(cast(new_deaths as int)),
sum(new_cases)/ sum(cast(new_deaths as int))*100 as Deatg_percentage_lobally
--total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from portfolioproject..CovidDeaths
where continent is not null
group by date
order by 1,2 

select sum(new_cases) as total,
sum(cast(new_deaths as int)),
sum(new_cases)/ sum(cast(new_deaths as int))*100 as Deatg_percentage_lobally
--total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from portfolioproject..CovidDeaths
where continent is not null
order by 1,2 


--joining two tables vccination and death
select count(*) from portfolioproject..CovidDeaths as dea 
join 
portfolioproject..CovidVaccinations as vac
on dea.location=vac.location 
and
dea.date=vac.date


--looking at total vaccination vs total population
select  dea.continent,dea.date,dea.location,dea.population
,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as rolling_count
from portfolioproject..CovidDeaths as dea 
join 
portfolioproject..CovidVaccinations as vac
on dea.location=vac.location 
and
dea.date=vac.date
where dea.continent is not null 
order by 3,4



--using cte
with popvsvac(continent,date,location,population,new_vaccination,rolling_vac_count)
as
(select  dea.continent,dea.date,dea.location,dea.population
,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as rolling_count
from portfolioproject..CovidDeaths as dea 
join 
portfolioproject..CovidVaccinations as vac
on dea.location=vac.location 
and
dea.date=vac.date
where dea.continent is not null and dea.location='India')
select*,
(rolling_vac_count/population)*100 as percentage_rool_vacc
from popvsvac

--creating temp table
drop table if exists #percentageppoplulation
create table #percentageppoplulation
(
continent nvarchar(2550),
date datetime,
location nvarchar(255),
population numeric,
new_vaccination numeric,
rollingvaccinationcount numeric
)
insert into #percentageppoplulation
select  dea.continent,dea.date,dea.location,dea.population
,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as rolling_count
from portfolioproject..CovidDeaths as dea 
join 
portfolioproject..CovidVaccinations as vac
on dea.location=vac.location 
and
dea.date=vac.date
where dea.continent is not null 
select*,
(rollingvaccinationcount/population)*100 as percentage_rool_vacc
from #percentageppoplulation


--creating a veiw for data visualization

create view percentagepoplulation as
select  dea.continent,dea.date,dea.location,dea.population
,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as rolling_count
from portfolioproject..CovidDeaths as dea 
join 
portfolioproject..CovidVaccinations as vac
on dea.location=vac.location 
and
dea.date=vac.date
where dea.continent is not null 
--creating another view
create view globali as
select date,sum(new_cases) as total,
sum(cast(new_deaths as int)) as new_no_deaths,
sum(new_cases)/ sum(cast(new_deaths as int))*100 as Deatg_percentage_lobally
--total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths
from portfolioproject..CovidDeaths
where continent is not null
group by date
--order by 1,2 

























 















