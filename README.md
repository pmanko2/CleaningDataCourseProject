run_analysis.R
============================
This script uses downloaded cell phone motion data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to create a tidy dataset with the AVERAGE of all variables grouped by experiment subject and activity. 

renamefeatures(): 

takes in a character vector of feature names and performs some renaming operations to make the vectors more human readable

"-" was changed to "_"
"mean()" was changed to "MEAN"
"std()" was changed to "STDDEV"
"()" were removed

Only needed to rename MEAN and STDDEV since these were the only variables we were interested in.

mergelabels():

takes in a vector of either test or train labels and  merges these labels with their corresponding activity names. This is used to assign activities to each observation.
======

The script assumes that the top level data directory is named "UCI HAR Dataset". It then extracts the necessary data frames from the data. 

Feature names are made more human readable and assigned to the train and test datasets

Any duplicate features from these datasets are removed

Subject and activity columns are added to train and test.

Train and test is merged into one dataset called merged.

We extract only MEAN and STDDEV variables (in addition to subject and activity columns)

We then use data.table to find the mean of every remaining variable grouped by subject and activity. The resulting dataset becomes our tidy dataset.

Lastly we append Average_ to each column name in our tidy dataset and then sort by subject and then activity.