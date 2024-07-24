library(rpart)
library(rpart.plot)
library(dplyr)

library(readr)
pi_cycles <- read_csv("Desktop/my_whoop_data_2024_04_23/physiological_cycles.csv")


# DATA MUNGING
pi_cycles <- pi_cycles %>%
  mutate(Recovery_category = case_when(
    `Recovery score %` < 40 ~ "low",
    `Recovery score %` >= 40 & `Recovery score %` <= 80 ~ "moderate recovery",
    `Recovery score %` > 80 ~ "very good"
  ))

#View(pi_cycles)

cycles <- pi_cycles %>% select(`REM duration (min)`, `Sleep need (min)`, `Asleep duration (min)`, `Respiratory rate (rpm)`
                           ,`Heart rate variability (ms)`, `Energy burned (cal)`, `Day Strain`
                           , `Blood oxygen %`, `Skin temp (celsius)`, Recovery_category)
colnames(cycles) <- c("REM_duration_min", "Sleep_need_min", "Asleep_duration_min", "Respiratory_rate_rpm", "Heart_rate_variability_ms", "Energy_burned_cal", "Day_Strain", "Blood_oxygen_percent", "Skin_temp_celsius", "Recovery_category")




cycles<- cycles %>% mutate_if(is.character, as.factor)

#view(cycles)


# DATA SPLITTING 

create_train_test <- function(cycles, size = 0.8, train = TRUE) {
  n_row = nrow(cycles)
  total_row = size * n_row
  train_sample <- 1: total_row
  if (train == TRUE) {
    return (cycles[train_sample, ])
  } else {
    return (cycles[-train_sample, ])
  }
}





data_train <- create_train_test(cycles, 0.8, train = TRUE)
data_test <- create_train_test(cycles, 0.8, train = FALSE)

data_test <- na.omit(data_test)

numeric_data_train <- data_train[sapply(data_train, is.numeric)]
scaled_numeric_data_train <- scale(numeric_data_train)



scaled_data_train <- cbind(scaled_numeric_data_train, data_train[!sapply(data_train, is.numeric)])


clean_train <- na.omit(scaled_data_train)


# FITTING A NUERAL NET
library(neuralnet)



nn <- neuralnet(Recovery_category ~ .,
                  data = clean_train, 
                  hidden = c(5,4,3), 
                  linear.output = FALSE)



plot(nn)

pred <- predict(nn, data_test)
labels <- c("very good", "moderate recovery", "low")
prediction_label <- data.frame(max.col(pred)) %>%     
  mutate(pred=labels[max.col.pred.]) %>%
  select(2) %>%
  unlist()

table(data_test$Recovery_category, prediction_label)

check = as.numeric(data_test$Recovery_category) == max.col(pred)
accuracy = (sum(check)/nrow(data_test))*100
print(accuracy)



