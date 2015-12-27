library(data.table)

renamefeatures <- function(features){
  features <- gsub("-", "_", features)
  features <- gsub("mean()", "MEAN", features, fixed=TRUE)
  features <- gsub("std()","STDDEV", features, fixed=TRUE)
  features <- gsub("()", "", features, fixed=TRUE)
  features <- gsub("Acc", "Acceleration", features, fixed=TRUE) 
  return(features)
}

mergelabels <- function(labels){
  names(activity_labels) <- c("activity_id", "activity")
  names(labels) <- c("activity_id")
  
  return(merge(labels, activity_labels, by.x = 'activity_id', by.y = 'activity_id'))
}

getdata <- function(){
  features <- read.table("UCI HAR Dataset/features.txt")[[2]]
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
  testds <- read.table("UCI HAR Dataset/test/X_test.txt")
  test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
  test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
  trainds <- read.table("UCI HAR Dataset/train/X_train.txt")
  train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
  train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")  
}

getdata()
renamed <- renamefeatures(features)
test_labels <- mergelabels(test_labels)
train_labels <- mergelabels(train_labels)

colnames(testds) <- renamed
colnames(trainds) <- renamed

testds <- testds[, !duplicated(colnames(testds))]
trainds <- trainds[, !duplicated(colnames(trainds))]
testds$subject <- test_subjects[[1]]
testds$activity <- test_labels$activity
trainds$subject <- train_subjects[[1]]
trainds$activity <- train_labels$activity

merged <- rbind(testds, trainds)
merged <- merged[, grepl("MEAN|STDDEV|subject|activity", names(merged))]
merged <- data.table(merged)
cleaned_dataset <- merged[, lapply(.SD, mean), by=list(subject,activity)]