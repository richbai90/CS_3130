library("jsonlite")
library("ggplot2")
library("viridis")
library("hrbrthemes")
library("dplyr")
library("purrr")
library("geosphere")

setwd("hw1")

knitr::opts_chunk$set(message = FALSE)
knitr::opts_chunk$set(echo = FALSE)
knitr::opts_chunk$set(warning = FALSE)

price_level_to_dollars <- function(lvl = NA) if (is.na(lvl)) "NA" else strrep("$", lvl)

slc_data <- jsonlite::stream_in(con = file("slc_restaurants.json"))
sd_data <- jsonlite::stream_in(con = file("sd_restaurants.json"))
slc_data <- data.frame(slc_data)
sd_data <- data.frame(sd_data)

sd_data$loc <- "San Diego"
slc_data$loc <- "Salt Lake City"

sd_raw_data <- sd_data
slc_raw_data <- slc_data

slc_geometry <- slc_raw_data$geometry$location
sd_geometry <- sd_raw_data$geometry$location

sd_data <- data.frame(sd_raw_data$rating, sd_raw_data$price_level, sd_raw_data$loc, sd_geometry$lat, sd_geometry$lng)
slc_data <- data.frame(slc_raw_data$rating, slc_raw_data$price_level, slc_raw_data$loc, slc_geometry$lat, slc_geometry$lng)

slc_data$origin_lat <- 40.771428
slc_data$origin_lng <- -111.893880
sd_data$origin_lat <- 32.715672
sd_data$origin_lng <- -117.161045

colnames(sd_data) <- c("rating", "price_level", "loc", "lat", "lng", "origin_lat", "origin_lng")
colnames(slc_data) <- c("rating", "price_level", "loc", "lat", "lng", "origin_lat", "origin_lng")

complete_data <- rbind(slc_data, sd_data)


data <- complete_data %>% group_by(loc) %>%
rowwise() %>%
mutate(
    distance = distHaversine(c(origin_lng, origin_lat), c(lng, lat))
)
