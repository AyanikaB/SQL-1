select * from project2..coviddeaths
where continent is not null
order by 3,4

select location,date,total_cases,new_cases, total_deaths,population
from project2..coviddeaths order by 1,2

--death percentage 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from project2..coviddeaths order by 1,2

--total cases vs population in INDIA
select location,date,total_cases,population,(total_cases/population)*100 as infection_percentage
from project2..coviddeaths where location like '%india%' order by 1,2


--highest infection
select location,population,MAX(total_cases) as highest_infections from project2..coviddeaths 
where continent is not null
group by location,population
order by highest_infections DESC

--HIGHEST DEATH COUNT
select location,MAX(cast(total_deaths as int)) as highest_deathCounts from project2..coviddeaths 
where continent is not null
group by location
order by highest_deathCounts DESC

--continent with highest death and infection
select continent,MAX(total_cases) as highest_infections,MAX(cast(total_deaths as int)) as highest_deathCounts from project2..coviddeaths 
where continent is not null
group by continent
order by highest_infections DESC

--global numbers
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from project2..coviddeaths where continent is not null order by 1,2

select date,sum(new_cases) as newcases, sum(cast(new_deaths as int)) as newdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as 
death_percentage from project2..coviddeaths 
where continent is not null
group by date
order by 1,2

select * from project2..covidvaccinations

--total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from project2..coviddeaths dea join project2..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--rolling people vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from project2..coviddeaths dea join project2..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


--Temp table
drop table if exists PercentageOfPeopleVaccinated
create table PercentageOfPeopleVaccinated
(
continent varchar(250),
location varchar(250),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into PercentageOfPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from project2..coviddeaths dea join project2..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *,(rollingpeoplevaccinated/population)*100 as Percentageofpeoplevaccinated from PercentageOfPeopleVaccinated


--creating view to store data
CREATE VIEW People_Vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from project2..coviddeaths dea join project2..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null


select * from People_Vaccinated 

