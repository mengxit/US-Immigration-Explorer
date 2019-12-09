# Gov1005 Project, Mengxi Tan

*mtan@mde.harvard.edu*

GitHub Repo: https://github.com/mengxit/US-Immigration-Explorer

GitHub Profile: https://github.com/mengxit

Learn more about my work: https://mengxitan.com

This webapp is the final project for the Harvard Gov1005 class.
Free feel to pull the Git repo (this project is open-sourced!), or contact me if you are curious about the project :)

**Raw Data Source**

To answer these two main questions raised above, I used three public datasets:
i.	US Homeland Security Immigration Data, 2007 – 2017
https://www.dhs.gov/immigration-statistics/yearbook

The Homeland Security immigration yearbook documents all new legal immigrants admitted through US customs. In this dataset, immigration counts by country, year and class of admission (visa type) are recorded.

ii.	US Census Bureau American Community Survey (American Fact Finder), 2007 – 2017
https://factfinder.census.gov/faces/nav/jsf/pages/searchresults.xhtml?refresh=t#none

The US Census Bureau American Community Survey documents socioeconomic status of US residents, which can be further segmented by different group characteristics. In this analysis, I used English speaking capability, labor force participation rate and labor force employment rate as the indicators of “fitting into society”. These metrics are available in individual groups based on country of origin, and I gathered data for the top 10 countries with most immigration into US (based on Homeland Security data). Note that the immigration group in this dataset are all immigrants living in US in a particular year, while the group in the Homeland Security dataset are immigrants moving into US in a particular year. Therefore, though connection and correlation can be made between the two groups, the population sampled here in dataset I and II are different. 

iii.	Natural Earth Data, 2019 Version
https://www.naturalearthdata.com/

The Natural Earth Data library contains geographical and basic fact data about countries. I used country shape and total population count in this dataset for the heatmap.


**Data Cleaning**

Besides standard join, aggregation and new metric creation, there are two data cleaning decisions that might be of importance/interest to those interpreting this data visualization:

1. For the Homeland Security immigration data, records with "D" or "-" (cannot disclose) were treated as 0.

2. For the immigration map on homepage, I used a manual fuzzy match to map political regions to geographical regions(full record in raw_data/country_fuzzy_match_record.xlsx). An example is the Homeland Security are documenting certain immigrants as from Soviet Union, even after the 1991 Soviet Union disintegration. This happened because certain former Soviet Union residents never claimed a new passport. Since the majority of former Soviet Union population are now in Russia and Ukraine, I distributed the Soviet Union immigration amount propotioanlly to Russia and Ukraine. Similar treatments were done to the other 46 countries/regions with renames and political changes. 

**Limitation and Future Steps**

One limitation in the regression part is that the data used were only for the top 10 source countries across 10 years given the time limitation of this project. Going forward, including all countries will deliver a more cohesive and robust analysis.

Another future direction to go to will be including past immigration data before 2007. During 2007 -2017, we are observing relatively stable trends in US immigration. However, if we go further back in time, we might be able to observe more interesting trends in immigration, and speculate how these trends relate to historical or political events. 


**Walk-Through Video**

Watch the video below for highlights in the visualization!

https://vimeo.com/378216482





