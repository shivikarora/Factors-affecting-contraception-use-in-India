## ----setup, include=FALSE-------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(janitor)
library(lubridate)
library(tidyverse)


## -------------------------------------------------------------------------------------------------------------------------
set.seed(895)

simulated_data <- tibble(
  Background.characteristic = c('Urban', 'Rural', 'Illiterate', 'Literate_less_than_middle', 'Middle_school_complete', 'High_school_and_above', 'Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist', 'Other_religion', 'No_children', '1_child', '2_children', '3_children', '4_children_and_above', 'Total'),
  Category = c(rep('Residence', 2), rep('Education', 4), rep('Religion', 7), rep('Number of Children', 5), 'Total'),
  Any.method = runif(n = 19, min = 0, max = 100),
  Any.modern.method = runif(n = 19, min = 0, max = 100),
  Any.modern.temporary.method = runif(n = 19, min = 0, max = 100),
  Pill = runif(n = 19, min = 0, max = 10),
  IUD = runif(n = 19, min = 0, max = 10),
  Injection = runif(n = 19, min = 0, max = 0.1),
  Condom = runif(n = 19, min = 0, max = 15),
  Female.sterilizaion = runif(n = 19, min = 0, max = 100),
  Male.sterilizaion = runif(n = 19, min = 0, max = 20),
  Any.trad..method = runif(n = 19, min = 0, max = 10),
  Periodic.abstinence = runif(n = 19, min = 0, max = 10),
  Withdrawal = runif(n = 19, min = 0, max = 5),
  Other.methods = runif(n = 19, min = 0, max = 1),
  Not.using.any.method = runif(n = 19, min = 0, max = 100),
  Total.percent = rep(100, 19),
  Number.of.women = c(sample(1:84678, size = 18, replace = TRUE), 84678)
  )

simulated_data <- tibble(simulated_data$Background.characteristic,
                         simulated_data$Category,
                         round(simulated_data[3:18], digits = 2))

