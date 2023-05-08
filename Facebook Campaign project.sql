select * from FacebookCampaign
---Checking for null Values
select ad_id from FacebookCampaign where ad_id is null

---checking for duplicates
select distinct count(ad_id )from FaceBookCampaign

---Number of campaign run
select distinct (xyz_campaign_id) from FacebookCampaign
---Replace the existing compaign level with level1,level2 and level 3
select distinct xyz_campaign_id,
CASE
when xyz_campaign_id=916 then 1
when xyz_campaign_id=936 then 2
when xyz_campaign_id=1178 then 3
end as CampaignCategory
from FacebookCampaign
----Updating the Table
update FaceBookCampaign set xyz_campaign_id=CASE
when xyz_campaign_id=916 then 1
when xyz_campaign_id=936 then 2
when xyz_campaign_id=1178 then 3
end

---Number of Female

select distinct count(gender) from  FacebookCampaign 
where gender ='F'

---Number of Male
select distinct count(gender) from  FacebookCampaign 
where gender ='M'
---Observetion the number of Male is slightly higher than the number of Females

---Click to Impression Rate
select SUM(Clicks)/SUM(Impressions)*100 as ClickRate from FaceBookCampaign

---Cost Per Click
Select SUM(spent)/SUM(Clicks)*100 as CostPerClick from FaceBookCampaign

---Conversion Rate
select SUM(Approved_Conversion)/SUM(Clicks)*100 as ConversionRate from FaceBookCampaign

---DEMOGRAPHIC CHARACTERISTICS

----Impression by age group
select age,xyz_campaign_id,SUM(impressions) as TotalImpression,
rank() over (partition by age order by	SUM(impressions) desc) as ranking
from FaceBookCampaign
group by age,xyz_campaign_id
order by TotalImpression desc
----Observation; Age group 30-34 had the highest impressions for campaign level 3 and 1 while age group 45-49 had the Highest impression for campaing level 2

---Clicks Per Age Group

Select age,xyz_campaign_id,sum(Clicks) as TotalClicks,
rank() over(partition by age order by sum(Clicks) desc ) as ClickRanking 
from FaceBookCampaign
group by age,xyz_campaign_id
order by TotalClicks desc
---Observation:Age group 45-49 had the highest clicks in campaign level 1 and 2 

---Total Conversion per age group
select age,xyz_campaign_id,sum(Total_Conversion) as TotalConversion,
rank() over (partition by age order by sum(Total_Conversion) desc) as Ranking 
 from FaceBookCampaign 
group by age,xyz_campaign_id
order by TotalConversion desc
---Observation;age group 30-34 had the highest conversion

---Approved Conversion per age group
select age,xyz_campaign_id,count(Approved_Conversion) as TotalConversion,
rank() over (partition by age order by count(Approved_Conversion)  desc) as Ranking 
 from FaceBookCampaign 
group by age,xyz_campaign_id
order by TotalConversion desc
---Observation;age group 30-34 had the highest Approved  conversion

----Total conversion vs Clicks per age group
select age ,xyz_campaign_id,SUM(Clicks) as TotalClicks,sum(Total_Conversion) as TotalConversion from FacebookCampaign
group by age,xyz_campaign_id
order by TotalConversion desc , TotalClicks desc

---Average stastics for each age group
---select * from FacebookCampaign
select age,avg(impressions) as AvgImpression,avg(Clicks) as AvgClicks,AVG(Spent) as AvgSpent,AVG(Total_Conversion) as AvgConversion,AVG(Approved_Conversion) as AvgApprovedConversion
from FacebookCampaign
group by age
---Observetion:Age group 30-34 had the highest conversions rate and the least amount spent

---CAMPAIGN ANALYSIS BY GENDER

----Impressions per Gender
select gender,xyz_campaign_id,SUM(Impressions) as TotalImpression,
RANK() over (partition by gender order by SUM(Impressions) desc) as Ranking
from FacebookCampaign
group by gender,xyz_campaign_id
order by TotalImpression desc
---Females had a high impression in campaign level 2 and 3 while Male had a high impression on campaign level 1

---Clicks Per Gender
select gender,xyz_campaign_id,SUM(Clicks) as TotalClicks,
RANK() over (partition by gender order by SUM(Clicks ) desc) as Ranking
from FacebookCampaign
group by gender,xyz_campaign_id
order by  TotalClicks DESC
---Females had higher clicks in campaign level 2 and 3 while Male had higher clicks on campaign level 1

---Total Conversion per gender
select gender,xyz_campaign_id,SUM(Total_Conversion) as TotalConversion,
RANK() over (partition by gender order by SUM(Total_Conversion) desc) as Ranking
from FacebookCampaign
where xyz_campaign_id=3
group by gender,xyz_campaign_id
order by  TotalConversion DESC
----Male had a higher Total conversion in campaign level 1 and and 3 while female had a higher conversion in camapaign level 2

---Total Approved Conversion per gender
select gender,xyz_campaign_id,SUM(Approved_Conversion) as TotalApprovedConversion,
RANK() over (partition by gender order by SUM(Approved_Conversion) desc) as Ranking
from FacebookCampaign
group by gender,xyz_campaign_id
order by  TotalApprovedConversion DESC
----Male had a higher Approved Total conversion in campaign level 1 and and 3 while female had a higher  approved conversion in camapaign level 2


---Average stastics for per gender
select gender,avg(impressions) as AvgImpression,avg(Clicks) as AvgClicks,AVG(Spent) as AvgSpent,AVG(Total_Conversion) as AvgConversion,AVG(Approved_Conversion) as AvgApprovedConversion
from FacebookCampaign
group by gender
---Observetion:Although male had the lowest clicks and average conversion they had the highets approved convesrion rate

---Average stastics for per gender and age 
select  age,gender,avg(impressions) as AvgImpression,avg(Clicks) as AvgClicks,AVG(Spent) as AvgSpent,AVG(Total_Conversion) as AvgConversion,AVG(Approved_Conversion) as AvgApprovedConversion
from FacebookCampaign
group by gender,age
order by AvgApprovedConversion desc
---male in the age group 30-34 made most of the purchases

----Comparing individual Campaigns
select  xyz_campaign_id,avg(impressions) as AvgImpression,avg(Clicks) as AvgClicks,AVG(Spent) as AvgSpent,AVG(Total_Conversion) as AvgConversion,AVG(Approved_Conversion) as AvgApprovedConversion,
SUM(Clicks)/SUM(Impressions)*100 as ClickRate,SUM(spent)/SUM(Clicks)*100 as CostPerClick
from FacebookCampaign
group by xyz_campaign_id
order by AvgApprovedConversion desc
---Campaign level 3 had the highest approved conversion