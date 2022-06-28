select * from project1.dbo.Data1;

select * from project1.dbo.Data2;

--no of rows
select count(*) from project1.dbo.Data1;
select count(*) from project1.dbo.Data2;

--dataset from jharkhand and bihar
select * from project1.dbo.Data1 where state in ('Jharkhand','Bihar');

--population of the country
select sum (Population) as Population from project1.dbo.data2;

--average growth of india
select avg (Growth) as Avg_Growth from project1.dbo.data1;

--average growth per state
select State, avg(Growth) as Avg_Growth from project1.dbo.Data1 group by State;

--average sex ratio
select avg(Sex_Ratio) as Avg_SexRatio from project1.dbo.data1;

--average sex ratio per state
select state,round(avg(Sex_Ratio),0) as AvgSexRatio from project1.dbo.Data1 group by state;

--in descending order
select state,round(avg(Sex_Ratio),0) as AvgSexRatio from project1.dbo.Data1 group by state Order by AvgSexRatio DESC;

--sum of literacy rates
select state,round(sum(Literacy),0) as Literacy from project1.dbo.Data1 group by state;

--average of literacy rates in descending order
select state,round(avg(Literacy),0) as Literacy from project1.dbo.Data1 group by state order by Literacy DESC;

--states with literacy rates more than 90
select state, round(avg(Literacy),0) as literacy from project1.dbo.data1 where(literacy>90) group by state order by literacy DESC;

--top 3 states showing highest growth rate
select top 3 state,avg(Growth)as growth from project1.dbo.Data1 group by state order by growth DESC;

--top 3 states with highest population
select top 3 State,sum(Population) as population from project1.dbo.Data2 group by state order by population DESC;

--bottom 3 states showing lowest literacy rates
select top 3 state,round(avg(Literacy),0) as literacy from project1.dbo.Data1 group by state order by literacy ASC;

--top and bottom 3 states in literacy 
drop table if exists top_states;

create table top_states(
state varchar(250),
liteary_score float)

insert into  top_states
select top 3 State,round(avg(Literacy),0) as literacy from project1.dbo.Data1 group by State order by literacy DESC;

select * from  top_states

drop table if exists bottom_states;

create table bottom_states(
state varchar(250),
literacy_score float)

insert into bottom_states
select top 3 State,round(avg(Literacy),0) as literacy from project1.dbo.Data1 group by State order by literacy ASC;

select * from bottom_states

--states starting with letter A
select distinct state from project1.dbo.Data1 where state like 'A%' or state like 'B%'

--starting with A and ending with M
select distinct state from project1.dbo.Data1 where state like 'A%' and state like '%m'

--joining two tables
select a.District, a.State, a.Sex_Ratio, b.Population from project1.dbo.Data1 a inner join project1.dbo.Data2 b on a.District=b.District

--total males and females

select d.state,sum(d.males) as total_males,sum(d.females) as total_females from
(select c.district,c.state as state,round(c.population/(c.sex_ratio+1),0) as males,round((c.population*c.sex_ratio)/(c.sex_ratio+1),0)as females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project1.dbo.Data1 a inner join project1.dbo.Data2 b on
a.district=b.district)c)d group by d.state

--total literates and illiterates

select d.state,sum(literate_people) as literates,sum(illiterate_people) as illiterates from
(select c.district,c.state,c.literacy_rate*c.population as literate_people,(1-c.literacy_rate)*c.population as illiterate_people from
(select a.district, a.state,a.literacy/100 as literacy_rate, b.population from project1.dbo.Data1 a inner join project1.dbo.Data2 b on 
a.state=b.state)c ) d group by d.state


