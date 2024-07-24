library(performanceEstimation)
library(mosaic)


library(factoextra)

library(rpart)
library(rpart.plot)
library(dplyr)

library(readr)

pi_cycles <- read_csv("Desktop/my_whoop_data_2024_04_23/physiological_cycles.csv")


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
#View(cycles)

#because this is a preprocessing step for supervised learning, remove dependent variable
saveOriginalCycles = cycles
cycles <- cycles[, !names(cycles) %in% "Recovery_category"]
#View(cycles)

cycles <- na.omit(cycles)
any(is.na(cycles))

saveOriginalCycles <- na.omit(saveOriginalCycles)

pca <- prcomp(cycles, center = TRUE,scale = TRUE)
summary(pca)
print(pca$rotation)
#screeplot(pca, type = "lines", main = "Scree Plot for PCA")
fviz_eig(pca)



components <- cbind(Recovery_category = saveOriginalCycles[, "Recovery_category"], pca$x[, 1:5]) %>%
  as.data.frame()
components$Recovery_category <- as.factor(components$Recovery_category)

library(caTools)
sample = sample.split(components$Recovery_category, SplitRatio = .75)
train = subset(components, sample == TRUE)
test  = subset(components, sample == FALSE)
dim(train)
dim(test)

fit <- rpart(Recovery_category ~ .,
             data=train, method="class")
rpart.plot(fit, extra = 102)

predict_unseen <-predict(fit, test, type = 'class')

table_mat <- table(test$Recovery_category, predict_unseen)
table_mat

accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
accuracy_Test


