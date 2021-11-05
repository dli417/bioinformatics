# Libraries

library(tidyverse)
library(vroom)
library(wbstats)
library(countrycode)
# library(lubridate)
# library(multcomp)


# find out how to get GDP for the countries (hint - we have used the package in a previous week)
## set current working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# # query wbstats for GDP column/indicator
# test1 <- wb_search("gdp")
# test2 <- wb_search("ny.gdp.mktp.cd")
# test3 <- wb_search("ny.gdp.mktp")

##extract GDP data for all countries
gdp_data <- wb_data(indicator = "NY.GDP.MKTP.CD",
                    start_date = 2020,
                    end_date = 2020)

##convert to tibble
gdp_data <- as_tibble(gdp_data)

# rename GDP column
gdp_data <- gdp_data %>% rename(GDP = NY.GDP.MKTP.CD)

# merge the GDP data into the medal table (hint - check previous weeks for how to do this too)
# import medal database
medal_data <- vroom("../../data/Workshop 5/Tokyo 2021 medals.csv")

# add country code column to medal_data
medal_data$iso3c <- countrycode(medal_data$Country,
                                  origin = "country.name",
                                  destination = "iso3c")
# fix country code errors
medal_data$iso3c[which(medal_data$Country == "Kosovo")] <- "XKX"
medal_data$iso3c[which(medal_data$Country == "Republic of China")] <- "CHN"

medal_gdp_data <- left_join(medal_data,
                         gdp_data %>% select(iso3c, GDP),
                         by = c("iso3c" = "iso3c"))

# Visualise the relationship between GDP and position in the table (hint - which is your predictor variable?)

# Sort by Gold, Silver, Bronze, then alphabetical
medal_gdp_sort <- arrange(medal_gdp_data,
                           desc(medal_gdp_data$Gold),
                           desc(medal_gdp_data$Silver),
                           desc(medal_gdp_data$Bronze),
                           medal_gdp_data$Country)

# Omit NA GDPs
medal_gdp_sort <- medal_gdp_data[complete.cases(medal_gdp_data$GDP), ]

ggplot(medal_gdp_sort, aes(x = GDP, y = Country)) +
  geom_jitter(aes(col = GDP)) +
  theme_bw()

# fit an appropriate GLM to the data and check its assumptions
