# CleanData

# COURSERA - Getting Clean Data - Programming Assignment

## Review Criteria:

* The submitted data set is tidy.
* The Github repo contains the required scripts.
* GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the 
*   variables and summaries calculated, along with units, and any other relevant information.
* The README that explains the analysis files is clear and understandable.
* The work submitted for this project is the work of the student who submitted it.


## Getting and Cleaning Data Course Project:

* a tidy data set as described below, 	
* a link to a Github repository with your script for performing the analysis, and 
* a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

# Processing Steps

## Pre Steps
* Loads Requred packages
* Remove global variables
* Clears the console
* Establish the R Working Directory 

## ------ OBJECTIVE 1: Merges the training and the test sets to create one data set (TIDY DATASET) --------------

* Data source via a URL
* Download the source data (Variable: URL) to the working directory and source data folder
* Unzip the source data (UCI HAR Dataset) to the (zipfile=) source data folder and place the 
    contents of the zip into a subdirectory (exdir=), in this case the SourceData.
* An objective of the assignment is to merge the training and the test sets to create one data set,
    therefore the files (UCI HAR Dataset) in the ZIP (Dataset.zip) in the SourceData sub directory of 
    the working directory need to be read into R.  R needs to know where to locate: 
* The UCI HAR Dataset is broken down into Subjects, Features and Activities.
    Reference the Code Book for greater details.
    Note: none of the columns have headers, thus header = FALSE argument will be used. 
* The Subject train(ing) and test files need to be read into R:
* The Features train(ing) and test files need to be read into R:
* The Activity train(ing) and test files need to be read into R:
* The Features are the range of measurements, see Code Book for greater detail.  
    Note: none of the columns have headers, thus header = FALSE argument will be used. 
* At this point, the distinct data (train and test) need to be bounded by descriptive varable names 
       (Subject: train and test, Features: train and test, and Activity: train and test). 
       The test and train data, given the respective descriptive variable will be bound by 
       rbind, which mean the bounded data will be appended, i.e. 
                                 ROWS
       SourceDataActivityTrain =  7,352 
       SourceDataActivityTest  =  2,947
       SourceDataActivity      = 10,299

       (column names are taken from the first argument with an apropriate names: 
       colnames for a matrix, or names for a vector of length the number of columns of the result.)
    After the Train and Test have been rbound together, the respective source data will be removed.
* As was highlighted in the read.table section, the raw data was imported into R with the header = FALSE 
    argument will be used, which means the source data was without headers, this step will create the header name
* At this point, all source data (train, test, and activity) will be incorporated via the CBIND function
    After the source data (train, test, and activity) have been rbound together, the respective 
    source data will be removed from RAM.

## ------ OBJECTIVE 2: Extracts only the measurements on the mean and standard deviation for each measurement -----------

* The objective is to search through the scond column in the SourceDataFeaturesNames for instances of 
    mean OR standard, then take those measurments and put them into a new table which represents the subset of values.
    The grep funtion, within the base package will accomplish this goal.
* Combine Values from SubSetSourceDataFeaturesNames, along with subject and activuty into  List
* Subset the SourceData based upon the values in SourceDataSelectedNames and assign the result into SourceData

## -------- OBJECTIVE 3: Uses descriptive activity names to name the activities in the data set --------------------------
* At this point, obtaining the Activity Labels and assigning them to a data.frame 

## ------- OBJECTIVE 4: Appropriately labels the data set with descriptive variable names -----------------------

*  The objective in this section is to update the labels with descriptive names, which are needed to interact with the final step.
    The update table: Begins with t = time, Begins with f = frequency, Acc = Accelerometer, Gyro = Gyroscope, Mag = Magnitude, BodyBody = Body

# -- OBJECTIVE 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject ---    