
library(tidyverse)
library(skimr)

#Import data
nyc_squirrels <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")

#Output the tidy dataset for future use.
write.csv(nyc_squirrels, file = "squirrels.csv")

nyc_squirrels %>% skim_tee()

