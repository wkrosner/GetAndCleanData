


if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")){
  
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "getdata_projectfiles_UCI HAR Dataset.zip", mode="wb" )
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip("getdata_projectfiles_UCI HAR Dataset.zip") 
}

# Load Labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character( activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Load standard deviations and means
MeanStd <- grep(".*mean.*|.*std.*", features[,2])
MeanStd.names <- features[MeanStd,2]
MeanStd.names = gsub('-mean', 'Mean', MeanStd.names)
MeanStd.names = gsub('-std', 'Std', MeanStd.names)
MeanStd.names <- gsub('[-()]', '', MeanStd.names)


# import Train Data
T <- read.table("UCI HAR Dataset/train/X_train.txt")[MeanStd]
TActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
TSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
T <- cbind(TSubjects, TActivities, T)

# import test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[MeanStd]
testAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSub, testAct, test)

# merge datasets  
CombineData <- rbind(T, test)

#add labels
colnames(CombineData) <- c("subject", "activity", MeanStd.names)

# Run factor command
CombineData$activity <- factor(CombineData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
CombineData$subject <- as.factor(CombineData$subject)

#Melt data

library(reshape2)
CombineData.melted <- melt(CombineData, id = c("subject", "activity"))
CombineData.mean <- dcast(CombineData.melted, subject + activity ~ variable, mean)
# write to table
write.table(CombineData.mean, "FinalDataSet.txt", row.names = FALSE, quote = FALSE)