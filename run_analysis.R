library(data.table)

## apply some renaming rules to features vector to make feature names
## more human readable
renamefeatures <- function(features){
  features <- gsub("-", "_", features)
  features <- gsub("mean()", "MEAN", features, fixed=TRUE)
  features <- gsub("std()","STDDEV", features, fixed=TRUE)
  features <- gsub("()", "", features, fixed=TRUE)
  features <- gsub("Acc", "Acceleration", features, fixed=TRUE) 
  return(features)
}

## takes in a vector of labels and merges it with activity labels
mergelabels <- function(labels){
  names(activity_labels) <- c("activity_id", "activity")
  names(labels) <- c("activity_id")
  
  return(merge(labels, activity_labels, by.x = 'activity_id', by.y = 'activity_id'))
}

## load all necessary datasets
features <- read.table("UCI HAR Dataset/features.txt")[[2]]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
testds <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainds <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")  

# rename the feature names to be more human readable
# merge the test and train labels with corresponding activities
renamed <- renamefeatures(features)
test_labels <- mergelabels(test_labels)
train_labels <- mergelabels(train_labels)

colnames(testds) <- renamed
colnames(trainds) <- renamed

# clean datasets by getting rid of duplicated columns
testds <- testds[, !duplicated(colnames(testds))]
trainds <- trainds[, !duplicated(colnames(trainds))]

# add subject and activity columns to cleaned datasets
testds$subject <- test_subjects[[1]]
testds$activity <- test_labels$activity
trainds$subject <- train_subjects[[1]]
trainds$activity <- train_labels$activity

# combine test and train datasets into single dataframe
# extract only MEAN and STDDEV variables
merged <- rbind(testds, trainds)
merged <- merged[, grepl("MEAN|STDDEV|subject|activity", names(merged))]
merged <- data.table(merged)

# find mean of every variable grouped by subject and activity
tidy_dataset <- merged[, lapply(.SD, mean), by=list(subject,activity)]

# append Average to each column name to better describe results
cleaned_names <- names(tidy_dataset)
names(tidy_dataset) <- append(cleaned_names[c(1,2)], paste("Average", cleaned_names[-c(1, 2)], sep = "_"))

tidy_dataset <- tidy_dataset[with(tidy_dataset, order(subject, activity)), ]
return(tidy_dataset)