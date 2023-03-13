# ================
# LOAD ENVIRONMENT
# ================
library(tidyverse) #wrangle data
library(lubridate) #wrangle date attributes
library(ggplot2) #vvisualize data
setwd("/Users/wan/Desktop/Case Study Dataset/Scope") #set working directory

# ============
# WRANGLE DATA
# ============
# Load .csv files (March 2022 until February 2023)
mar2022_df <- read.csv("202203-divvy-tripdata.csv")
apr2022_df <- read.csv("202204-divvy-tripdata.csv")
may2022_df <- read.csv("202205-divvy-tripdata.csv")
jun2022_df <- read.csv("202206-divvy-tripdata.csv")
jul2022_df <- read.csv("202207-divvy-tripdata.csv")
aug2022_df <- read.csv("202208-divvy-tripdata.csv")
sep2022_df <- read.csv("202209-divvy-tripdata.csv")
oct2022_df <- read.csv("202210-divvy-tripdata.csv")
nov2022_df <- read.csv("202211-divvy-tripdata.csv")
dec2022_df <- read.csv("202212-divvy-tripdata.csv")
jan2023_df <- read.csv("202301-divvy-tripdata.csv")
feb2023_df <- read.csv("202302-divvy-tripdata.csv")

# Bind all data frames
bike_sharing_df <- rbind(mar2022_df, apr2022_df, may2022_df, jun2022_df, jul2022_df, aug2022_df, sep2022_df, oct2022_df, nov2022_df, dec2022_df, jan2023_df, feb2023_df)

# Clean up unneeded data frames
remove(mar2022_df, apr2022_df, may2022_df, jun2022_df, jul2022_df, aug2022_df, sep2022_df, oct2022_df, nov2022_df, dec2022_df, jan2023_df, feb2023_df)

# Check data frame
glimpse(bike_sharing_df)
View(bike_sharing_df)


# =============================================
# CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
# =============================================
# Check distinct values for rideable_type
bike_sharing_df %>% 
  group_by(rideable_type) %>% 
  summarize(distinct_rideable_type = n_distinct(rideable_type))

# Check distinct values for member_casual
bike_sharing_df %>% 
  group_by(member_casual) %>% 
  summarize(distinct_member_casual = n_distinct(member_casual))

# Convert started_at and ended_at, from character to datetime
bike_sharing_df <- mutate(bike_sharing_df, 
                          started_at = as_datetime(started_at),
                          ended_at = as_datetime(ended_at))

# Calculate length for each ride in minutes
bike_sharing_df$ride_length_mins <- difftime(bike_sharing_df$ended_at, bike_sharing_df$started_at, units = "mins")



# Calculate day, month & hour
bike_sharing_df$day <- weekdays(bike_sharing_df$started_at, abbreviate = TRUE)
bike_sharing_df$month <- months(bike_sharing_df$started_at, abbreviate = TRUE)
bike_sharing_df$hour <- hour(bike_sharing_df$started_at)

# Create times_of_day column
bike_sharing_df <- bike_sharing_df %>% 
  mutate(times_of_day = 
           case_when(hour == "0" ~ "Night",
                     hour == "1" ~ "Night",
                     hour == "2" ~ "Night",
                     hour == "3" ~ "Night",
                     hour == "4" ~ "Night",
                     hour == "5" ~ "Morning",
                     hour == "6" ~ "Morning",
                     hour == "7" ~ "Morning",
                     hour == "8" ~ "Morning",
                     hour == "9" ~ "Morning",
                     hour == "10" ~ "Morning",
                     hour == "11" ~ "Morning",
                     hour == "12" ~ "Afternoon",
                     hour == "13" ~ "Afternoon",
                     hour == "14" ~ "Afternoon",
                     hour == "15" ~ "Afternoon",
                     hour == "16" ~ "Afternoon",
                     hour == "17" ~ "Evening",
                     hour == "18" ~ "Evening",
                     hour == "19" ~ "Evening",
                     hour == "20" ~ "Night",
                     hour == "21" ~ "Night",
                     hour == "22" ~ "Night",
                     hour == "23" ~ "Night")
)

# Check the mean, median, min & max of ride_length_mins
mean(bike_sharing_df$ride_length_mins) #average ride length
median(bike_sharing_df$ride_length_mins) #midpoint value of ride length
min(bike_sharing_df$ride_length_mins) #shortest ride length
max(bike_sharing_df$ride_length_mins) #longest ride length

# Clean up for NA values; duplicate rows, 0 or negative values in ride_length_mins
bike_sharing_clean_df <- na.omit(bike_sharing_df) #remove NA values
bike_sharing_clean_df <- distinct(bike_sharing_clean_df) #remove duplicates
bike_sharing_clean_df <- bike_sharing_clean_df[(bike_sharing_clean_df$ride_length_mins > 0), ] #keep only ride length that is larger than 0 minutes

# Check clean data frame
glimpse(bike_sharing_clean_df)
View(bike_sharing_clean_df)


# ============================
# CONDUCT DESCRIPTIVE ANALYSIS
# ============================
# Use clean data frame bike_sharing_clean_df
# Check for mean, median, min & max of ride_length_mins
mean(bike_sharing_clean_df$ride_length_mins) #average ride length
median(bike_sharing_clean_df$ride_length_mins) #midpoint value of ride length
min(bike_sharing_clean_df$ride_length_mins) #shortest ride length
max(bike_sharing_clean_df$ride_length_mins) #longest ride length

# Compare median, min & max between members and casual riders
aggregate(bike_sharing_clean_df$ride_length_mins ~ bike_sharing_clean_df$member_casual, FUN = median)
aggregate(bike_sharing_clean_df$ride_length_mins ~ bike_sharing_clean_df$member_casual, FUN = min)
aggregate(bike_sharing_clean_df$ride_length_mins ~ bike_sharing_clean_df$member_casual, FUN = max)

# Set order of days
bike_sharing_clean_df$day <- ordered(bike_sharing_clean_df$day, levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))

# Set order of month
bike_sharing_clean_df$month <- ordered(bike_sharing_clean_df$month, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

# Check for rider type
rider_type <- bike_sharing_clean_df %>% 
  group_by(member_casual) %>% 
  count(member_casual) %>% 
  print()

# Check for bike type
bike_type <- bike_sharing_clean_df %>% 
  group_by(rideable_type) %>% 
  count(rideable_type) %>% 
  print()

# Check for average ride length by rider type
average_ride_length_by_type <- bike_sharing_clean_df %>% 
  group_by(member_casual) %>% 
  summarize(average_ride_length = mean(ride_length_mins)) %>% 
  print()

# Create data frame for total and average ridership by rider type and day
daily_ridership <- bike_sharing_clean_df %>% 
  group_by(member_casual, day) %>% 
  summarize(number_of_rides = n(), average_ride_length = mean(ride_length_mins)) %>% 
  print()

# Create data frame for total rides per hour
hourly_ridership <- bike_sharing_clean_df %>% 
  group_by(times_of_day, hour) %>% 
  summarize(number_of_rides = n()) %>% 
  print(n = 24)

# Create data frame for total rides per month
monthly_ridership <- bike_sharing_clean_df %>% 
  group_by(month, member_casual) %>% 
  summarize(number_of_rides = n()) %>% 
  print(n = 24)

# =========
# VISUALIZE
# =========
# Plot bar chart: Rider Type
ggplot(rider_type, aes(y = n, x=member_casual)) +
  geom_bar(stat = "identity", fill = "chartreuse3") +
  labs(title = "Rider Type",
       x = "Rider Type",
       y = "Number of Rides")

# Plot bar chart: Bike Type
ggplot(bike_type, aes(y = n, x= rideable_type)) +
  geom_bar(stat = "identity", fill = "chartreuse3") +
  labs(title = "Bike Type",
       x = "Bike Type",
       y = "Number of Bikes")

# Plot bar chart: Average Ride Length by Rider Type
ggplot(average_ride_length_by_type, aes(y = average_ride_length, x= member_casual)) +
  geom_bar(stat = "identity", fill = "chartreuse3") +
  labs(title = "Average Ride Length by Rider Type",
       x = "Rider Type",
       y = "Average Ride Length")

# Plot grouped bar chart: Total Daily Rides per Rider Type 
ggplot(daily_ridership, aes(fill = member_casual, y = number_of_rides, x = day)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Total Daily Rides vs. Rider Type",
       x = "Day",
       y = "Number of Rides",
       fill = "Rider Type")

# Plot grouped bar chart: Daily Average Ride Length per Rider Type 
ggplot(daily_ridership, aes(fill = member_casual, y = average_ride_length, x = day)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Total Daily Rides vs. Rider Type",
       x = "Day",
       y = "Ride Length (minutes)",
       fill = "Rider Type")

# Plot grouped bar chart: Total Rides per Hour
ggplot(hourly_ridership, aes(fill = times_of_day, y = number_of_rides, x = hour)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Rides per Hour",
       x = "Hour",
       y = "Number of Rides",
       fill = "Times of Day")

# Plot bar chart: Total Rides per Month
ggplot(monthly_ridership, aes(fill = member_casual, y = number_of_rides, x = month)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Rides per Month",
       x = "Month",
       y = "Number of Rides",
       fill = "Rider Type")


# =======
# EXPORT
# =======
# Remove unnecessary columns to reduce file size
bike_sharing_clean_tableau <- bike_sharing_clean_df %>% 
  select(-c(start_station_name, start_station_id, start_lat, start_lng, end_station_name, end_station_id, end_lat, end_lng))

# Export clean csv file for use in Tableau
write.csv(bike_sharing_clean_tableau, "bike_sharing_clean_tableau.csv")