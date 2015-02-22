library(dplyr)
library(tidyr)

test_x <- read.table("UCI HAR Dataset//test//X_test.txt")
test_y <- read.table("UCI HAR Dataset//test/y_test.txt")
test_s <- read.table("UCI HAR Dataset//test//subject_test.txt")

train_x <- read.table("UCI HAR Dataset//train//X_train.txt")
train_y <- read.table("UCI HAR Dataset//train/y_train.txt")
train_s <- read.table("UCI HAR Dataset//train//subject_train.txt")

test_x <- bind_rows(test_x, train_x)
test_y <- bind_rows(test_y, train_y)
test_s <- bind_rows(test_s, train_s)

rm("train_x", "train_y", "train_s")

act <- read.table("UCI HAR Dataset//activity_labels.txt")
cn <- read.table("UCI HAR Dataset//features.txt")
colnames(test_y) <- "activity"
colnames(test_s) <- "subject"
colnames(test_x) <- cn$V2

test_x <- test_x[,grepl("-mean\\(\\)|-std\\(\\)",colnames(test_x))]

test <- tbl_df(bind_cols(test_s, test_y, test_x))


tidyData <- test %>%
        gather(measure, value, -c(subject, activity)) %>%
        merge(act, by.x = "activity", by.y = "V1", all = T) %>%
        tbl_df() %>%
        mutate(activity = V2) %>%
        select(1:4) %>%
        separate(measure, c("variable","measure"), extra = "merge") %>%
        mutate(measure = gsub("[[:punct:]]", "", measure))

rm("test_x", "test_y", "test_s", "act", "cn", "test")

tidyMean <- tidyData %>%
        group_by(activity, subject, variable, measure) %>%
        summarize(meanVal = mean(value))