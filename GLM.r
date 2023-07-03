library(ggplot2)
library(caret)
library(dplyr)
library(stats)
library(pROC)

# loading data
data <- read.csv("adult.csv", sep=',', header=TRUE)
head(data)

str(data)

cols.num <- c("workclass","marital.status","native.country")
data[cols.num] <- sapply(data[cols.num],as.character)
sapply(data, class)

data$workclass[data$workclass %in% c("Local-gov","Federal-gov")] <- "SL-gov"
unique(data$workclass)

data$workclass[data$workclass %in% c("Self-emp-inc","Self-emp-not-inc")] <- "Self-emp"
unique(data$workclass)

data$marital.status[data$marital.status %in% c("Divorced","Widowed")] <- "Not-Married"

data$marital.status[data$marital.status %in% c("Separated", "Married-civ-spouse",
                                               "Married-spouse-absent",
                                               "Married-AF-spouse")] <- "Married"

unique(data$marital.status)

data$native.country[data$native.country %in% c("United-States", "Canada", "Outlying-US(Guam-USVI-etc)",
                         "Mexico", "Cuba", "Jamaica", "Haiti", "Dominican-Republic",
                         "Guatemala", "El-Salvador", "Nicaragua", "Trinadad&Tobago",
                         "Puerto-Rico", "Honduras")] <- "North-America"
data$native.country[data$native.country %in% c("England", "Germany", "Italy","Poland","Portugal",
                         "France", "Yugoslavia", "Scotland", "Greece",
                         "Ireland", "Hungary", "Holand-Netherlands")] <- "Europe"
data$native.country[data$native.country %in% c("Ecuador", "Peru", "Columbia", "South")] <- "South-America"
data$native.country[data$native.country %in% c("India", "Iran", "Philippines", "Cambodia",
                         "Thailand", "Laos", "Taiwan", "China", "Japan",
                         "Vietnam", "Hong")] <- "Asia"

unique(data$native.country)

data[data == "?"] <- NA
table(is.na(data))

data <- data[complete.cases(data), ]
table(is.na(data))

data$age <- as.numeric(data$age)
data$fnlwgt <- as.numeric(data$fnlwgt)
data$educational.num <- as.numeric(data$educational.num)
data$capital.gain <- as.numeric(data$capital.gain)
data$capital.loss <- as.numeric(data$capital.loss)
data$hours.per.week <- as.numeric(data$hours.per.week)

data$workclass <- as.factor(data$workclass)
data$marital.status <- as.factor(data$marital.status)
data$native.country <- as.factor(data$native.country)

sapply(data, class)

table(data$income)
y <- data$income

set.seed(321)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
train_set <- data[test_index, ]
test_set <- data[-test_index, ]

dim(train_set)
dim(test_set)

model = glm(income ~ ., data = train_set, family = "binomial")
summary(model)

step.model <- step(model)
summary(step.model)

step.model$call

pred <- predict(step.model, newdata = test_set)
y_hat <- ifelse(pred> 0.5, ">50K", "<=50K")
y_hat <- factor(y_hat, levels = levels(test_set$income))

pred.table = table(predicted = y_hat, actual = test_set$income)
pred.table

confusionMatrix(data = y_hat, reference = test_set$income)

roc <- roc(test_set$income, pred)
plot(roc, main = "ROC curve", xlab = "1 - Specificity", ylab = "Sensitivity")

auc <- auc(roc)
auc

gc <- 2*auc-1
gc

TP <- pred.table[1,1]
FP <- pred.table[1,2]
FN <- pred.table[2,1]
TN <- pred.table[2,2]

TPR <- TP/(TP+FN)
TPR

TNR <- TN/(TN+FP)
TNR

PPV <- TP/(TP+FP)
PPV

f1_score = 2*(TPR*PPV)/(TPR+PPV)
f1_score

set.seed(321)
test_index <- createDataPartition(y, times = 1, p = 0.8, list = FALSE)
train_set <- data[test_index, ]
test_set <- data[-test_index, ]

model = glm(income ~ ., data = train_set, family = "binomial")
summary(model)

step.model <- step(model)
summary(step.model)

pred <- predict(step.model, newdata = test_set)
y_hat <- ifelse(pred> 0.5, ">50K", "<=50K")
y_hat <- factor(y_hat, levels = levels(test_set$income))
pred.table = table(predicted = y_hat, actual = test_set$income)
pred.table

TP <- pred.table[1,1]
FP <- pred.table[1,2]
FN <- pred.table[2,1]
TN <- pred.table[2,2]

TPR <- TP/(TP+FN) #dokładność
TNR <- TN/(TN+FP) #specyficzność
PPV <- TP/(TP+FP) #precyzja

f1_score = 2*(TPR*PPV)/(TPR+PPV)
f1_score
