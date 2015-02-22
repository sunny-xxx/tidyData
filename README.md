## Hi! Here is an explonation on what is going on while the script runs:

At the beginning of script required packages should be initialized:

>     library(dplyr)
>     library(tidyr)

Next step is to read given data from files:
>     test_x <- read.table("UCI HAR Dataset//test//X_test.txt")
>     test_y <- read.table("UCI HAR Dataset//test/y_test.txt")
>     test_s <- read.table("UCI HAR Dataset//test//subject_test.txt")
>     
>     train_x <- read.table("UCI HAR Dataset//train//X_train.txt")
>     train_y <- read.table("UCI HAR Dataset//train/y_train.txt")
>     train_s <- read.table("UCI HAR Dataset//train//subject_train.txt")
>     act <- read.table("UCI HAR Dataset//activity_labels.txt")

Binding train and test datasets: 
>     test_x <- bind_rows(test_x, train_x)
>     test_y <- bind_rows(test_y, train_y)
>     test_s <- bind_rows(test_s, train_s)

Deleting unnecessary tables from memory:
>     rm("train_x", "train_y", "train_s")

Correcting the column names:
>     cn <- read.table("UCI HAR Dataset//features.txt")
>     colnames(test_y) <- "activity"
>     colnames(test_s) <- "subject"
>     colnames(test_x) <- cn$V2

Subsetting only the interesting information from the dataset:
>     test_x <- test_x[,grepl("-mean\\(\\)|-std\\(\\)",colnames(test_x))]

Binding measurements with subjects and activities
>     test <- tbl_df(bind_cols(test_s, test_y, test_x))

Cleaning and reshaping data
>     tidyData <- test %>%
>     gather(measure, value, -c(subject, activity)) %>%
>     merge(act, by.x = "activity", by.y = "V1", all = T) %>%
>     tbl_df() %>%
>     mutate(activity = V2) %>%
>     select(1:4) %>%
>     separate(measure, c("variable","measure"), extra = "merge") %>%
>     mutate(measure = gsub("[[:punct:]]", "", measure))

Removing files which are not needed anymore:
>     rm("test_x", "test_y", "test_s", "act", "cn", "test")

Summarizing mean values:
>     tidyMean <- tidyData %>%
>     group_by(activity, subject, variable, measure) %>%
>     summarize(meanVal = mean(value))