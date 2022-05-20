## ----setup, include=FALSE----------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(tidyverse)
library(knitr)
library(pointblank)


## ----------------------------------------------------------------------------------------------------------------
raw_data <- read.csv(file = 'raw_data.csv')

cleaned_data <- raw_data %>% 
  mutate("Category" = case_when(
    Background.characteristic == 'Urban' | Background.characteristic == 'Rural' ~ 'Residence',
    Background.characteristic == 'Illiterate' ~ 'Education',
    Background.characteristic == 'Literate_less_than_middle' ~ 'Education',
    Background.characteristic == 'Middle_school_complete' ~ 'Education',
    Background.characteristic == 'High_school_and_above' ~ 'Education',
    Background.characteristic == 'Hindu' ~ 'Religion',
    Background.characteristic == 'Muslim' ~ 'Religion',
    Background.characteristic == 'Christian' ~ 'Religion',
    Background.characteristic == 'Sikh' ~ 'Religion',
    Background.characteristic == 'Jain' ~ 'Religion',
    Background.characteristic == 'Buddhist' ~ 'Religion',
    Background.characteristic == 'Other' ~ 'Religion',
    Background.characteristic == 'None' ~ 'Number of Children',
    Background.characteristic == '1_child' ~ 'Number of Children',
    Background.characteristic == '2_children' ~ 'Number of Children',
    Background.characteristic == '3_children' ~ 'Number of Children',
    Background.characteristic == '4_children_and_above' ~ 'Number of Children',
    Background.characteristic == 'Total' ~ 'Total') ) %>% 
  relocate(Category, .after = 'Background.characteristic') %>% 
  subset(, -1)

cleaned_data <- cleaned_data[!is.na(cleaned_data$Category), ]
cleaned_data <- cleaned_data[-14, ]

cleaned_data$Female.sterilization <- as.numeric(cleaned_data$Female.sterilization)
cleaned_data$Number.of.women <- as.numeric(cleaned_data$Number.of.women)


## ----------------------------------------------------------------------------------------------------------------
test <- create_agent(tbl = cleaned_data) %>% 
  col_is_character(columns = vars(Background.characteristic, Category)) %>% 
  col_is_numeric(columns = vars(Any.method, Any.modern.method, Any.modern.temporary.method, Pill, IUD, Condom, Female.sterilization, Male.sterilization, Any.trad..method, Periodic.abstinence, Withdrawal, Not.using.any.method, Total.percent, Number.of.women)) %>% 
  col_vals_between(columns = vars(Any.method, Any.modern.method, Any.modern.temporary.method, Pill, IUD, Condom, Female.sterilization, Male.sterilization, Any.trad..method, Periodic.abstinence, Withdrawal, Not.using.any.method), left = 0, right = 100) %>% 
  col_vals_equal(columns = Total.percent, value = 100.0) %>% 
  col_vals_in_set(columns = Background.characteristic,
                  set = c("Urban", "Rural", "Illiterate", "Literate_less_than_middle", "Middle_school_complete", "High_school_and_above", "Hindu", "Muslim", "Christian", "Sikh", "Jain", "Buddhist", "Other", "None", "1_child", "2_children", "3_children", "4_children_and_above", "Total")) %>% 
  col_vals_in_set(columns = Category,
                  set = c("Residence", "Education", "Religion", "Number of Children", "Total")) %>% 
  interrogate()

test


## ----------------------------------------------------------------------------------------------------------------
write.csv(cleaned_data, "cleaned_data.csv")

