
#import data from UCI Archive and unzip to working directory
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "getdata-projectfiles-UCI_HAR_Dataset.zip")
unzip("getdata-projectfiles-UCI_HAR_Dataset.zip", exdir = "dataset")

#run data.table
library(data.table)

## Step 1 - Merges the training and the test sets to create one data set
#find and combine
x_train <- read.table("dataset/UCI HAR Dataset/train/X_train.txt")
x_train <- read.table("dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("dataset/UCI HAR Dataset/train/Y_train.txt")
subject_train <-read.table("dataset/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test <-read.table("dataset/UCI HAR Dataset/test/subject_test.txt")

#create x data set with bind()
x_data <- rbind(x_train, x_test)

#create y data set with bind()
y_data <- rbind(y_train, y_test)

#create subjec data set with bind()
subject_data <- rbind(subject_train, subject_test)

##Step 2 - Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("dataset/UCI HAR Dataset/features.txt")

#get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

#subset those columns
x_data <- x_data[, mean_and_std_features]

#fix column names
names(x_data) <- features[mean_and_std_features, 2]

##Step 3 - Uses descriptive activity names to name the activities in the data set
activities <- read.table("dataset/UCI HAR Dataset/activity_labels.txt")

#now can update values with correct activity names and edit column name
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

##Step 4 - Appropriately labels the data set with descriptive variable names.
names(subject_data) <- "subject"

#bind all data into a single data set
all_data <- cbind(x_data, y_data, subject_data)

##Step 5 - create second, indepedent data set with avg. of each variable

library(plyr)
#66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)

## @end - rename file to run_analysis.R
