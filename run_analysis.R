library(dplyr)
library(reshape2)

filename <- "Data_Files.zip"

if(!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}

if(!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

## Read in labels for column names
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Code", "Feature"))

## Read in dictionary for translating activity code to activity name
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Activity"))

## Read in data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Feature, check.names = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Feature, check.names = FALSE)

## Read in activity data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")

## Read in subject data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

## Concatenate rows from test and train for data, activity data, and subject data
X <- rbind(x_test, x_train)
Y <- rbind(y_test, y_train)
Subject <- rbind(subject_test, subject_train)

## Take only the columns that contain the mean or std of a measurement
X <- X[,grepl("mean\\(\\)|std\\(\\)", names(X))]

## Then concatenate the columns into one table
Merged_Data <- cbind(Subject, Y, X)

## Rename columns to be descriptive
names(Merged_Data) <- gsub("^t", "Time", names(Merged_Data))
names(Merged_Data) <- gsub("^f", "Frequency", names(Merged_Data))
names(Merged_Data) <- gsub("Acc", "Accelerometer", names(Merged_Data))
names(Merged_Data) <- gsub("Mag", "Magnitude", names(Merged_Data))
names(Merged_Data) <- gsub("Gyro", "Gyroscope", names(Merged_Data))

## Convert activity code to descriptive activity name
Merged_Data$Activity <- activities$Activity[match(Merged_Data$Activity, activities$Code)]

## Melt and cast to group by Subject and Activity variables
## and take the mean of each of the associated variables
melt <- melt(Merged_Data, id = c("Subject", "Activity"))
tidy <- dcast(melt, Subject + Activity ~ variable, mean)

## Output tidy data set
write.table(tidy, "./tidyData.txt", row.names = FALSE)