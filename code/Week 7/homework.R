# libraries
library(tidyverse)
library(vroom)
library(scales)
library(glmmTMB)
library(DHARMa)
library(fitdistrplus)
library(MASS)
library(viridis)

# set current working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data1 <- vroom("../../data/Workshop 6/data 1.csv")
data2 <- vroom("../../data/Workshop 6/data 2.csv")
data3 <- vroom("../../data/Workshop 6/data 3.csv")
data4 <- vroom("../../data/Workshop 6/data 4.csv")

