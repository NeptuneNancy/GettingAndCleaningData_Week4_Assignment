## assumes the following files are in working directory

## "activity_labels.txt" 
## "features.txt" 

## "subject_test.txt"    
## "y_test.txt"
## "X_test.txt" 

## "subject_train.txt"  
## "y_train.txt"       
## "X_train.txt"         



## Install libraries to be used , download if needed
## Install dplyr, reshape2 library

if(!is.element('dplyr', installed.packages()[,1]))
{install.packages('dplyr')
}else {print("dplyr library already installed")}

if(!is.element('reshape2', installed.packages()[,1]))
{install.packages('reshape2')
}else {print("reshape2 library already installed")}

## load libraries
library(dplyr)
library(reshape2)


## read files into RStudio
activity_labels <- read.table("activity_labels.txt" )
features <- read.table("features.txt" )

subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")


## Rename variables in subject_test and y_test, as they're both V1
names(subject_test) <- "subjectid"
names(y_test) <- "activityid"

## combine subject_test, y_test 
subj_activity_test <- cbind(subject_test, y_test) ## combine subject ids with activity ids

## add column to preserve the fact data was test data
subj_activity_test <- subj_activity_test %>% mutate(datatype = "test") 

## Take X_test data and features data and combine these.  
## Use values in features as variable labels for X_test data
## features$V2 becomes labels for columns on X_test
## features$V2 are factors; turn into character vector first

names(X_test) <- as.character(features$V2)

## Combine all the test data into a single data frame

testdata <- cbind(subj_activity_test, X_test)


        
## Rename variables in subject_train and y_train, as they're both V1
names(subject_train) <- "subjectid"
names(y_train) <- "activityid"

## combine subject_train, y_train 
subj_activity_train <- cbind(subject_train, y_train) ## combine subject ids with activity ids

## add column to preserve the fact data was training data
subj_activity_train <- subj_activity_train %>% mutate(datatype = "train") ## preserve data type, test or train

## Take X_train data and features data and combine these.  
## features$V2 becomes labels for variable on X_train

names(X_train) <- as.character(features$V2) ## features$V2 are factors; turn into character vector first

## Combine all the training data into a single data frame

traindata <- cbind(subj_activity_train, X_train)

## Combine test data and training data into one big data frame

bigdata <- rbind(testdata, traindata)

## Activities are currently identified by integers.  Replace these with words to more easily identify the activity

## convert integers into character factors (currently integers) 
bigdata$activityid <- as.factor(bigdata$activityid)

## replace number factors with corrsponding word factors
levels(bigdata$activityid) <- levels(activity_labels$V2)

## rename activityid to activity
names(bigdata)[2] <- "activity"

## Extract only those columns with mean and std in their names

## get names of all comuns (564 of them)
bigdata_names <- names(bigdata)

## from these pull out column indexes for features whose names contain at least one "mean"  or standard of deviation, "std"
## (knew what to look for after reading feature_info.txt file)

mean_std_cols <- grep("[Mm]ean+|std", bigdata_names, value=FALSE)

## use this info to take subset of columns
## have 3 columns that are not features (subject, activity, datatype) and 86 features for mean and std
## add those column numbers to those for mean and std

desired_cols <- c(1:3, mean_std_cols)

## subset bigdata to include just columns for mean and std
big_data_subset_meanstd <- bigdata[ , desired_cols] 

## data frame currently has a row for each activity performed by each subject, and 561 different measurements taken for that combo of subject/activity
## to create tidy data, each measurement should have it's own row
## can use melt to go from "wide" data frame to narrow, "tidy" dataframe

## melt all feature variables

melted_big_data_subset_meanstd <- melt(big_data_subset_meanstd, id=c("subjectid", "activity", "datatype"), variable.name = "feature", value.name="measurement")

## create a new data frame where take the mean of each feature variable for each combination of subjectid and activity

big_data_summary <- melted_big_data_subset_meanstd %>% group_by(subjectid, activity, feature) %>% summarise(mean(measurement))

## write the data frame out to disk
write.table(big_data_summary, file="SamsungSummaryData.txt", sep = " ", row.name=FALSE)

