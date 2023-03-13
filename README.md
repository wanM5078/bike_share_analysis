<img src="https://github.com/wanM5078/bike_share_analysis/blob/main/img/cyclistic_logo.png" width="100">

## Background 
This is one of the case study for the capstone project in the Google Data Analytics certification. 

In this case study, Cyclistic, a fictional bike-share company based in Chicago is trying to convert more casual riders into annual members for the future growth of the company. As such, it requires an analysis of how the casual riders and annual members differ in how they use its service. The analysis should include the last 12 months of Cyclistic trip data.

### Business Task
"How do annual members and casual riders use Cyclistic bikes differently?"


## Tools Used
* Excel (for quick check on how the data looks like)
* RStudio (using R as it's free and can handle large dataset with ease (1.11 GB, with almost 6 million rows of data in 18 columns). Cleaning, analysis and visualization can all be done in a single platform)
* Keynote (for creating presentation slide)

## Analysis
### Getting Started
1. Download all trip data files (in .csv format) for the past 12 months (Mar 2022 to Feb 2023) using this [link](https://divvy-tripdata.s3.amazonaws.com/index.html).
2. Use excel to briefly inspect formatting in each files (check for number of columns, column names, data types). All are identical.
3. Check filenames for consistency.

### Load into R Studio
1. Set working directory to the local folder where the trip data files are stored.
2. Load R libraries (_tidyverse_, _lubridate_, _ggplot_).
3. Load all .csv files and then bind them all into a single data frame. Then, delete all the other data frames to keep the environment clutter-free.
4. Check data frame using _glimpse_ and _View_ function

### Clean Up
1. Check for distinct values for columns ("rideable_type" and "member_casual") to identify how many distinct values for said columns.
2. Since columns that contains date and time are in _character_ type, convert them to _datetime_. 
3. Calculate the ride length using _difftime_ function.
4. Get the name of the day & month, including the hour number using _weekdays_, _months_ and _hour_ functions.
5. Set the hour to times of the day (Morning, Afternoon, Evening, Night) using the _mutate_ function.
6. Check the _median_, _mean_, _min_ & _max_ for the ride length. Notice that there are negative values for the mean and min of the ride length. This should not be the case as ride length should be more than 0 minutes. Remove these data by keeping rows with ride length that is longer than 0 minutes.
7. Remove rows with NA values and duplicates using the _na.omit_ and _distinct_ functions.
8. Create new data frame with all the above cleaning steps.

### Descriptive Analysis
1. Use the clean data frame to proceed with the analysis. 
2. Set the order for days and months using the _ordered_ function
3. Check the number of rider type and bike type using the _group_by_ function
4. Get the _median_, _mean_, _min_ & _max_ for the ride length, by rider type
5. Create additional data frames for total rides per hour and per month.

### Visualize
Using _ggplot_ function, plot the charts for:
   - bar chart: Rider Type
   - bar chart: Bike Type
   - bar chart: Average Ride Length by Rider Type
   - grouped bar chart: Total Daily Rides per Rider Type 
   - grouped bar chart: Daily Average Ride Length per Rider Type 
   - grouped bar chart: Total Rides per Hour
   - bar chart: Total Rides per Month

### Export
For further analysis in other visualization software such as Tableau, export the clean data frame to a .csv file. Remove unnecessary columns in the data frame that were not used in the earlier analysis to significantly reduce the output file size.

## Presentation
Prepare a presentation slide using the charts exported from R Studio to answer the business task.


## License
[Divvy Data License Agreement](https://ride.divvybikes.com/data-license-agreement)
