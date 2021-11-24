# Exercice 2.1
library(tidyverse)
library(vroom)
library(scales)
library(glmmTMB)
library(DHARMa)
library(fitdistrplus)
library(MASS)
library(viridis)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
lpd <- vroom("./LivingPlanetIndex.csv")

lpd_piv <- lpd %>%
                ##and then apply this function
                pivot_longer(cols = -c(ID:System),
                             names_to = "Date")

lpd_piv_uk <- lpd_piv %>% filter(lpd_piv$Country == "United Kingdom")
min(lpd_piv_uk$Date)

# Exercice 2.2
#unique(lpd_piv_uk$Species)

lpd_piv_uk$newvalue <- as.numeric(lpd_piv_uk$value)

lpd_piv_uk_nonull <- na.omit(lpd_piv_uk)

max(lpd_piv_uk_nonull$Date)

# Exercice 2.3

lpd_piv$newvalue <- as.numeric(lpd_piv$value)
lpd_piv_nonull <- na.omit(lpd_piv)

unique(lpd_piv_nonull$Country)

count(lpd_piv_uk)

for (val in unique(lpd_piv_nonull$Country))
{
    #print(val)
    val <- lpd_piv_nonull %>% filter(lpd_piv_nonull$Country == val)
    valcount <- count(val)
    print(max)
}

