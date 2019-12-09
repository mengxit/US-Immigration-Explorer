# Gov1005 Project, Mengxi Tan

*mtan@mde.harvard.edu*

GitHub Repo: https://github.com/mengxit/US-Immigration-Explorer

GitHub Profile: https://github.com/mengxit

Learn more about my work: https://mengxitan.com

This webapp is the final project for the Harvard Gov1005 class.
Free feel to pull the Git repo (this project is open-sourced!), or contact me if you are curious about the project :)

**Raw Data Source**

My raw data comes from two sources: 

1. Homeland Security, 2007 - 2017: 
https://www.dhs.gov/immigration-statistics/yearbook

    covering annual immigration count by different characteristics (visa type, country of origin etc.)

2. American Fact Finder(US Census Bureau), 2007 - 2017:
https://factfinder.census.gov/faces/nav/jsf/pages/searchresults.xhtml?refresh=t#none

    covering US resident census data(immigration status, english speaking capability, in labor force or not, etc.)
    
Both data sets address the issue of immigrants to US, segmented by country and state of origin. Note that the US Census Bureau data covers all immigrants *living* in US in that particular year, while the Homeland Security data covers immigrants *moving* to US in that year. Therefore, there is strong connection between the two datasets, yet keep in mind that the Homeland Security sample population is only part of the US Census Bureau sample population.

**Data Cleaning**

Besides standard join, aggregation and new metric creation, there are two data cleaning decisions that might be of importance/interest to those interpreting this data visualization:

1. For the Homeland Security immigration data, records with "D" or "-" (cannot disclose) were treated as 0.

2. For the immigration map on homepage, I used a manual fuzzy match to map political regions to geographical regions(full record in raw_data/country_fuzzy_match_record.xlsx). An example is the Homeland Security are documenting certain immigrants as from Soviet Union, even after the 1991 Soviet Union disintegration. This happened because certain former Soviet Union residents never claimed a new passport. Since the majority of former Soviet Union population are now in Russia and Ukraine, I distributed the Soviet Union immigration amount propotioanlly to Russia and Ukraine. Similar treatments were done to the other 46 countries/regions with renames and political changes. 

**Limitation and Future Steps**

The regressions done in the *Story* panel were only using the data of the top 10 US immigrant source countries, given the limitation of the scope and time of this project. In the future, I will hopefully include all documented groups in US Census Bureau to have more robust regressions and models. 




