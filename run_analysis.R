# DS - Getting Clean Data - Programming Assignment

# Load Requred packages
library(plyr);

# Remove global variables
rm(list=ls())

# Clear the console
clc <- function() cat(rep("\n",50));clc()

# Establish the R Working Directory 
setwd("L:/Coursera/DataScience/CleanData")

# ------ OBJECTIVE 1: Merges the training and the test sets to create one data set (TIDY DATASET) --------------

if(!file.exists("./SourceData")){dir.create("./SourceData")}

# Data source via a URL
URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download the source data (Variable: URL) to the working directory and source data folder
download.file(URL,destfile="./SourceData/Dataset.zip")

# Unzip the source data (UCI HAR Dataset) to the (zipfile=) source data folder and place the 
# contents of the zip into a subdirectory (exdir=), in this case the SourceData.
unzip(zipfile="./SourceData/Dataset.zip",exdir="./SourceData")

# An objective of the assignment is to merge the training and the test sets to create one data set,
# therefore the files (UCI HAR Dataset) in the ZIP (Dataset.zip) in the SourceData sub directory of 
# the working directory need to be read into R.  R needs to know where to locate: 
File_Path <- file.path("./SourceData" , "UCI HAR Dataset")

# The UCI HAR Dataset is broken down into Subjects, Features and Activities.
# Reference the Code Book for greater details.
# Note: none of the columns have headers, thus header = FALSE argument will be used. 

# The Subject train(ing) and test files need to be read into R:
SourceDataSubjectTrain <- read.table(file.path(File_Path, "train", "subject_train.txt"),header = FALSE)
SourceDataSubjectTest  <- read.table(file.path(File_Path, "test" , "subject_test.txt"),header = FALSE)

# The Features train(ing) and test files need to be read into R:
SourceDataFeaturesTrain <- read.table(file.path(File_Path, "train", "X_train.txt"),header = FALSE)
SourceDataFeaturesTest  <- read.table(file.path(File_Path, "test" , "X_test.txt" ),header = FALSE)

# The Activity train(ing) and test files need to be read into R:
SourceDataActivityTrain <- read.table(file.path(File_Path, "train", "Y_train.txt"),header = FALSE)
SourceDataActivityTest  <- read.table(file.path(File_Path, "test" , "Y_test.txt" ),header = FALSE)

# The Features are the range of measurements, see Code Book for greater detail.  
# Note: none of the columns have headers, thus header = FALSE argument will be used. 
SourceDataFeaturesNames <- read.table(file.path(File_Path, "features.txt"),head=FALSE)


# At this point, the distinct data (train and test) need to be bounded by descriptive varable names 
#       (Subject: train and test, Features: train and test, and Activity: train and test). 
#       The test and train data, given the respective descriptive variable will be bound by 
#       rbind, which mean the bounded data will be appended, i.e. 
#                                 ROWS
#       SourceDataActivityTrain =  7,352 
#       SourceDataActivityTest  =  2,947
#       SourceDataActivity      = 10,299
#
#       (column names are taken from the first argument with an apropriate names: 
#       colnames for a matrix, or names for a vector of length the number of columns of the result.)
# After the Train and Test have been rbound together, the respective source data will be removed.

SourceDataSubject <- rbind(SourceDataSubjectTrain, SourceDataSubjectTest)
rm("SourceDataSubjectTrain", "SourceDataSubjectTest")
SourceDataFeatures<- rbind(SourceDataFeaturesTrain, SourceDataFeaturesTest)
rm("SourceDataFeaturesTrain", "SourceDataFeaturesTest")
SourceDataActivity<- rbind(SourceDataActivityTrain, SourceDataActivityTest)
rm("SourceDataActivityTrain", "SourceDataActivityTest")

# As was highlighted in the read.table section, the raw data was imported into R with the header = FALSE 
# argument will be used, which means the source data was without headers, this step will create the header name

names(SourceDataSubject)<-c("subject")
names(SourceDataFeatures)<- SourceDataFeaturesNames$V2
names(SourceDataActivity)<- c("activity")

# At this point, all source data (train, test, and activity) will be incorporated via the CBIND function
# After the source data (train, test, and activity) have been rbound together, the respective 
# source data will be removed from RAM.

SourceDataCbind <- cbind(SourceDataSubject, SourceDataActivity)
rm("SourceDataSubject","SourceDataActivity")
SourceData <- cbind(SourceDataFeatures, SourceDataCbind)
rm("SourceDataFeatures", "SourceDataCbind")

# ------ OBJECTIVE 2: Extracts only the measurements on the mean and standard deviation for each measurement -----------

# The objective is to search through the scond column in the SourceDataFeaturesNames for instances of 
# mean OR standard, then take those measurments and put them into a new table which represents the subset of values.
# The grep funtion, within the base package will accomplish this goal.

FeatureNameMatches<-c("mean\\(\\)","std\\(\\)")
SubSetSourceDataFeaturesNames<-unique(grep(paste(FeatureNameMatches,collapse="|"),SourceDataFeaturesNames$V2, value=TRUE))
#write.csv(SubSetSourceDataFeaturesNames, file = "SubSetSourceDataFeaturesNames.csv")
rm("FeatureNameMatches")
rm("SourceDataFeaturesNames")

# Combine Values from SubSetSourceDataFeaturesNames, along with subject and activuty into  List
SourceDataSelectedNames<-c(as.character(SubSetSourceDataFeaturesNames), "subject", "activity" )
#write.csv(SourceDataFeaturesNames, file = "SourceDataFeaturesNames.csv")
rm("SubSetSourceDataFeaturesNames")

# Subset the SourceData based upon the values in SourceDataSelectedNames and assign the result into SourceData
SourceData <-subset(SourceData,select=SourceDataSelectedNames)
rm("SourceDataSelectedNames")

# -------- OBJECTIVE 3: Uses descriptive activity names to name the activities in the data set --------------------------

# At this point, obtaining the Activity Labels and assigning them to a data.frame
SourceDataActivities <- read.table(file.path(File_Path, "activity_labels.txt"),header = FALSE)

DataAsActivity<-factor(SourceData$activity);
DataAsActivity<- factor(SourceData$activity,labels=as.character(SourceDataActivities$V2))
rm("SourceDataActivities")
# ------- OBJECTIVE 4: Appropriately labels the data set with descriptive variable names -----------------------

# The objective in this section is to update the labels with descriptive names, which are needed to interact with the final step.
# The update table: Begins with t = time, Begins with f = frequency, Acc = Accelerometer, Gyro = Gyroscope, Mag = Magnitude, BodyBody = Body

names(SourceData)<-gsub("^t", "time", names(SourceData))
names(SourceData)<-gsub("^f", "frequency", names(SourceData))
names(SourceData)<-gsub("Acc", "Accelerometer", names(SourceData))
names(SourceData)<-gsub("Gyro", "Gyroscope", names(SourceData))
names(SourceData)<-gsub("Mag", "Magnitude", names(SourceData))
names(SourceData)<-gsub("BodyBody", "Body", names(SourceData))

# -- OBJECTIVE 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject ---

SourceDataAgg<-aggregate(. ~subject + activity, SourceData, mean)
SourceDataAgg<-SourceDataAgg[order(SourceDataAgg$subject,SourceDataAgg$activity),]
write.csv(SourceDataAgg, file = "SourceDataAgg.csv")
