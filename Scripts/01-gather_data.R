## ----setup, include=FALSE----------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)


## ----------------------------------------------------------------------------------------------------------------
download.file("https://dhsprogram.com/pubs/pdf/FRIND1/FRIND1.pdf", 
  "1992_India_DHS.pdf",
  mode="wb")

all <- pdf_text("1992_India_DHS.pdf")


## ----------------------------------------------------------------------------------------------------------------
line <- stri_split_lines(all[[169]])[[1]] %>% 
  str_squish()

line <- line[line != ""]

discription <- line[2] %>% 
  str_squish()

title_of_table <- line[1] %>% 
  str_squish()

no_header <- line[12:length(line)]
no_header_no_footer <- no_header[1:45] 

data <- tibble(all = no_header_no_footer)

data <- data %>% 
  mutate(all = str_squish(all)) %>%  # Any space more than two spaces is reduced
  mutate(all = str_replace(all, "Ecb::ation", "Education")) %>%
  mutate(all = str_replace(all, "< middle", "Literate_less_than_middle")) %>% 
  mutate(all = str_replace(all, "corrplete", "Middle_school_complete")) %>%
  mutate(all = str_replace(all, "corrplete", "Middle_school_complete")) %>%
  mutate(all = str_replace(all, "1. 7", "1.7")) %>%
  mutate(all = str_replace(all, "3,8", "3.8")) %>% 
  mutate(all = str_replace(all, "and above", "High_school_and_above")) %>%
  mutate(all = str_replace(all, "caste", "Scheduled_caste")) %>%
  mutate(all = str_replace(all, "31. 7", "31.7")) %>%
  mutate(all = str_replace(all, "tribe", "Scheduled_tribe")) %>%
  mutate(all = str_replace(all, "living children", "Number_sex_living_children")) %>%
  mutate(all = str_replace(all, "1 child", "1_child")) %>%
  mutate(all = str_replace(all, "80. 7'", "80.7")) %>%
  mutate(all = str_replace(all, "1 son", "1_son")) %>%
  mutate(all = str_replace(all, "2 children", "2_children")) %>%
  mutate(all = str_replace(all, "2 sons", "2_sons")) %>%
  mutate(all = str_replace(all, "2 eons", "2_sons")) %>%
  mutate(all = str_replace(all, "3 children", "3_children")) %>%
  mutate(all = str_replace(all, "3 sons", "3_sons")) %>%
  mutate(all = str_replace(all, "No son", "No_son"))

data[20,1] <- 'Caste/Tribe'
data <- data[-c(6, 8, 10, 21, 23, 26), ]

data <- data %>% 
  separate(col = all,
           into = c("Background characteristic", "Any method", "Any modern method", "Any modern temporary method", "Pill", "IUD", "Condom", "Female sterilization", "Male sterilization", "Any trad. method", "Periodic abstinence", "Withdrawal", "Other methods", "Not using any method", "Total percent", "Number of women"),
           sep = " ", # Works fine because the tables are nicely laid out
           remove = TRUE,
           fill = "right",
           extra = "drop") %>% 
  add_column("Injection" = "<0.05", .after = "IUD")


## ----------------------------------------------------------------------------------------------------------------
# Correct Some Values Manually

data[13, 15:17] <- data[13, 14:16]
data[13, 14] <- "<0.05"

data[14, 15:17] <- data[14, 14:16]
data[14, 14] <- "<0.05"

data[15, 15:17] <- data[15, 14:16]
data[15, 14] <- "<0.05"

data[22, 15:17] <- data[22, 14:16]
data[22, 14] <- "<0.05"

data[24, 7:16] <- data[24, 8:17]
data[24, 17] <- as.character(7271)

data[28, 7:16] <- data[28, 8:17]
data[28, 17] <- as.character(9134)

data[35,] <- list('4_children_and_above', as.character(52.4), as.character(49.0), as.character(3.4), as.character(1.0), as.character(1.0), as.character(0.1), as.character(1.3), as.character(40.9), as.character(4.6), as.character(3.4), as.character(2.1), as.character(0.9), as.character(0.4), as.character(47.6), as.character(100.0), as.character(24672))
data[35, 16] <- as.character(100.0)

data[36,] <- list('2_sons_and_above', as.character(53.8), as.character(50.5), as.character(3.0), as.character(0.9), as.character(0.8), as.character(0.1), as.character(1.2), as.character(42.8), as.character(4.7), as.character(3.3), as.character(2.0), as.character(0.9), as.character(0.5), as.character(46.2), as.character(100.0), as.character(19408))
data[36, 16] <- as.character(100.0)

data[37, 7:16] <- data[37, 8:17]
data[37, 17] <- as.character(4471)
data[37, 10] <- as.character(36.1)

data[38, 7:13] <- data[38, 8:14]
data[38, 14] <- "<0.05"


## ----------------------------------------------------------------------------------------------------------------
data[1,7] <- NA
data[4,7] <- NA
data[9,7] <- NA
data[17,7] <- NA
data[21,7] <- NA


## ----------------------------------------------------------------------------------------------------------------
write.csv(data, "raw_data.csv")

