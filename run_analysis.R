## Load the required library for the script to operate successfully..

library(dplyr)

## Read the train data..

X_train <- read.table("~/Coursera/UCI_HAR_Data/train/X_train.txt")
Y_train <- read.table("~/Coursera/UCI_HAR_Data/train/Y_train.txt")
Sub_train <- read.table("~/Coursera/UCI_HAR_Data/train/subject_train.txt")


## Read the test data..

X_test <- read.table("~/Coursera/UCI_HAR_Data/test/X_test.txt")
Y_test <- read.table("~/Coursera/UCI_HAR_Data/test/Y_test.txt")
Sub_test <- read.table("~/Coursera/UCI_HAR_Data/test/subject_test.txt")


## Read the data description..

variable_names <- read.table("~/Coursera/UCI_HAR_Data/features.txt")


## Read the activity labels..

activity_labels <- read.table("~/Coursera/UCI_HAR_Data/activity_labels.txt")


## Merge the training data and the test data sets to create one data set..

X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)


## Extract only the the mean and standard deviation for each measurement..

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",
                                    variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]


## Use descriptive activity names to name the activities within the data set..

colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, 
                                labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]


## Appropriately labels the data set with descriptive variable names..

colnames(X_total) <- variable_names[selected_var[,1],2]

## From the data set created by the previous action, creates a second, 
## independent tidy data set with the average of each variable for each 
## activity and each subject.

colnames(Sub_total) <- "subject"

total <- cbind(X_total, activitylabel, Sub_total)

total_mean <- total %>% 
              group_by(activitylabel, subject) %>% 
              summarize_each(list(mean))

write.table(total_mean, file = "~/Coursera/UCI_HAR_Data/tidydata.txt", 
            row.names = FALSE, col.names = TRUE)