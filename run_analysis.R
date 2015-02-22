# Clean up workspace
rm(list=ls())

# 1. Read tables, then merge the training and the test sets to create one data set.
TrainData <- read.table("./data/train/X_train.txt")
TrainLabel <- read.table("./data/train/y_train.txt")
TrainSubject <- read.table("./data/train/subject_train.txt")
TestData <- read.table("./data/test/X_test.txt")
TestLabel <- read.table("./data/test/y_test.txt")
TestSubject <- read.table("./data/test/subject_test.txt")
JoinData <- rbind(TrainData, TestData)
      dim(JoinData)
JoinLabel <- rbind(TrainLabel, TestLabel)
      dim(JoinLabel)
JoinSubject <- rbind(TrainSubject, TestSubject)
      dim(JoinSubject)

# 2. Extracts the mean and standard deviation for each measurement. 
features <- read.table("./data/features.txt")
      dim(features)
MeanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
      length(MeanStdIndices)
joinData <- JoinData[, MeanStdIndices]
      dim(JoinData)
names(JoinData) <- gsub("\\(\\)", "", features[MeanStdIndices, 2]) # remove "()"
names(JoinData) <- gsub("mean", "Mean", names(JoinData)) # capitalize "M" in mean
names(JoinData) <- gsub("std", "Std", names(JoinData)) # capitalize "S" in Std
names(JoinData) <- gsub("-", "", names(JoinData)) # remove "-" in column names 

# 3. Change activity names in the activity dataset.
activity <- read.table("./data/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", " ", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
ActivityLabel <- activity[JoinLabel[, 1], 2]
JoinLabel[, 1] <- ActivityLabel
names(JoinLabel) <- "activity"


# 4. Labels the data set with activity names.

names(JoinSubject) <- "subject"
CleanedData <- cbind(JoinSubject, JoinLabel, JoinData)
      dim(CleanedData)
write.table(CleanedData, "merged_data.txt") # write out the 1st dataset

# 5. Creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.
SubjectLength <- length(table(JoinSubject)) 
ActivityLength <- dim(activity)[1] 
ColumnLength <- dim(CleanedData)[2]
result <- matrix(NA, nrow=SubjectLength*ActivityLength, ncol=ColumnLength)
result <- as.data.frame(result)
colnames(result) <- colnames(CleanedData)
row <- 1
for(i in 1:SubjectLength) {
      for(j in 1:ActivityLength) {
            result[row, 1] <- sort(unique(JoinSubject)[, 1])[i]
            result[row, 2] <- activity[j, 2]
            subset1 <- i == CleanedData$subject
            subset2 <- activity[j, 2] == CleanedData$activity
            result[row, 3:ColumnLength] <- colMeans(CleanedData[subset1&subset2, 3:ColumnLength])
            row <- row + 1
      }
}

head(result)
write.table(result, "tidy_dataset.txt") # write out the 2nd dataset
