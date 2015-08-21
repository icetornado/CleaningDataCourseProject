library("dplyr")

## ----------------
## - Functions ----
## ----------------

## This function takes a list of varibale names as an input
## cleaning and replacing variable names with better ones
doCleanNames <- function(x) {
    ## replacing non-standard characters, or obscured abbreviations in variable names 
    cleanNames <- gsub("mean\\(\\)", "Mean", x)
    cleanNames <- gsub("std\\(\\)", "Std", cleanNames)
    cleanNames <- gsub("Acc", "Accelerometer", cleanNames)
    cleanNames <- gsub("Gyro", "Gyroscope", cleanNames)
    cleanNames <- gsub("Mag", "Magnitude", cleanNames)
    cleanNames <- gsub("BodyBody", "Body", cleanNames)
    cleanNames <- gsub("-", "", cleanNames)
    cleanNames <- make.names(cleanNames)
    return(cleanNames)
}

## This function join data from three text files
##  "y_...", "X_..." and "subject_...".
## Input parameter folder takes either "train" or "set" value.
## depending on the input parameter, the function will look for the set of three text files in appropriate folder and join data together
doJoinTables <- function(folder) {
    ## replace activity number with activity name in y_"file"
    activities <- read.csv(paste("./UCI HAR Dataset", folder, paste("y_", folder, ".txt", sep = ""), sep = "/"), header = FALSE, sep = " ")
    activities <- mutate(activities, activity = rawActivities[V1, 2])
    colnames(activities) <- c("activityID", "activity")
    
    ## read data from X_"file"
    rawData <- read.table(paste("./UCI HAR Dataset", folder, paste("X_", folder, ".txt", sep = ""), sep = "/"), quote="\"", comment.char="")
    data <- rawData[,measureNames$V1]
    
    ## remove raw data to release memory
    rm("rawData")
    colnames(data) <- measureNames$measureName
    
    ## read data from subject_"file"
    subjects <- read.csv(paste("./UCI HAR Dataset", folder, paste("subject_", folder, ".txt", sep = ""), sep = "/"), header = FALSE, sep = " ")
    colnames(subjects) <- c("subjectID")
    
    ## merge horiziontally 
    subData <- cbind(subjects, activity = activities$activity)
    subData <- cbind(subData, data)
    
    return(subData)
}
## ----------------
## - Main ----
## ----------------

## get activity names from activity_labels
rawActivities <- read.table("./UCI HAR Dataset/activity_labels.txt")

## get column names from features.txt
rawNames <- read.table("./UCI HAR Dataset/features.txt")
## pickup names with "-mean()" or "-std()"
measureNames <- rawNames[grep("-mean\\(\\)|-std\\(\\)", rawNames$V2),]
## get a list of cleaned names and attach it to dataframe
measureNames <- transform(measureNames, measureName = doCleanNames(measureNames$V2))

## get train data 
trainData <- doJoinTables('train')
## get test data
testData <- doJoinTables('test')
## combine them together
bigData <- rbind(trainData, testData)

bigData <- group_by(bigData, subjectID, activity)
## register mean call back for summarise_each to call
funs(mean, "mean", mean(., na.rm = TRUE))
## perform mean calculation on each variables
tidyData <- summarise_each(bigData, funs(mean))

## output tidy data to a text file
write.table(tidyData, file = "tidydata.txt", row.names = FALSE)