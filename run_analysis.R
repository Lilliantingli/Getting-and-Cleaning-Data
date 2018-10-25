#Load labels and features
activityLabels <- read.table("UCI HAR Dateset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
Features <- read.table("UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])

#Extract the data on mean and standard deviation
FeatureNeed <- grep(".*mean.*|.*std.*", Features[,2])
FeatureNeed.names <- Features[FeatureNeed,2] 
FeatureNeed.names <- gsub('-mean', 'Mean', FeatureNeed.names)
FeatureNeed.names <- gsub('-std', 'Std', FeatureNeed.names)
FeatureNeed.names <- gsub('[-()]', '', FeatureNeed.names)

#Load datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[FeatureNeed]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[FeatureNeed]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#Merge datasets and labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", FeatureNeed.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

library(reshape2)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)