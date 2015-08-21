library("dplyr")

doCleanNames <- function(x) {
    #cleanNames <- gsub("\\(\\)", "", x)
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

## get activity names from activity_labels
rawActivities <- read.table("./UCI HAR Dataset/activity_labels.txt")

## get column names from features.txt
## cleanup names up to compliance with make.names()
rawNames <- read.table("./UCI HAR Dataset/features.txt")
measureNames <- rawNames[grep("-mean\\(\\)|-std\\(\\)", rawNames$V2),]
measureNames <- transform(measureNames, measureName = doCleanNames(measureNames$V2))

trainData <- doJoinTables('train')
testData <- doJoinTables('test')
bigData <- rbind(trainData, testData)

bigData <- group_by(bigData, subjectID, activity)
tidyData <- summarise_each(bigData, funs(mean))
write.table(tidyData, file = "tidydata.txt", row.names = FALSE)