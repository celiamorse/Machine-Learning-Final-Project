library(rpart)
library(rpart.plot)
library(dplyr)

library(readr)
pi_cycles <- read_csv("Desktop/my_whoop_data_2024_04_23/physiological_cycles.csv")


# DATA MUNGING

# binning the predictor variable
pi_cycles <- pi_cycles %>%
  mutate(Recovery_category = case_when(
    `Recovery score %` < 40 ~ "low",
    `Recovery score %` >= 40 & `Recovery score %` <= 80 ~ "moderate recovery",
    `Recovery score %` > 80 ~ "very good"
  ))


#View(pi_cycles)

# getting rid of redundant variables
cycles <- pi_cycles %>% select(`REM duration (min)`, `Sleep need (min)`, `Asleep duration (min)`, `Respiratory rate (rpm)`
                            ,`Heart rate variability (ms)`, `Energy burned (cal)`, `Day Strain`
                            , `Blood oxygen %`, `Skin temp (celsius)`, Recovery_category)

# getting rid of spaces in attribute names
colnames(cycles) <- c("REM_duration_min", "Sleep_need_min", "Asleep_duration_min", "Respiratory_rate_rpm", "Heart_rate_variability_ms", "Energy_burned_cal", "Day_Strain", "Blood_oxygen_percent", "Skin_temp_celsius", "Recovery_category")


#View(cycles)


# SPLITTING DATA

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




set.seed(1)
shuffle_index <- sample(1:nrow(cycles))
head(shuffle_index)
cycles <- cycles[shuffle_index, ]
glimpse(cycles)

data_train <- create_train_test(cycles, 0.8, train = TRUE)
data_test <- create_train_test(cycles, 0.8, train = FALSE)

# Check for missing values in data_test and get rid of them
data_test <- data_test[!is.na(data_test), ]
any(is.na(data_test))

# MODELING A DECISION TREE

fit <- rpart(Recovery_category~., data = data_train, method = 'class')
rpart.plot(fit, extra = 106)

predict_unseen <-predict(fit, data_test, type = 'class')

table_mat <- table(data_test$Recovery_category, predict_unseen)
table_mat

accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
accuracy_Test



pred_test <- predict(fit, data_test, type = "class")






