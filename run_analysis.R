## Cleans and summarizes wearable computing data collected from the 
## accelerometers from the Samsung Galaxy S smartphone. 

## A full description is available at the site where the data was obtained: 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

loadFeatures <- function( featurefile ) {
    ## Loads features file and determines if the feature should be included
    ## when the feature result data is loaded later.  In this case only mean
    ## and standard deviation features are to be included. 
    
    ## Returs a list containing a function to
    ##   get a features dataframe for loading of the feature data
    
    features <- read.table(featurefile, header=FALSE, sep=" ", 
                           col.names=c("id", "feature") )

    # Rename time and frequency features to be more readable
    features$feature <- gsub("^f", "Freq_", features$feature)    
    features$feature <- gsub("^t", "Time_", features$feature)

    # Rename mean and standard deviation features to avoid R reserved symbols
    features$feature <- gsub("\\-(m|M)ean\\()", "_Mean", features$feature)
    features$feature <- gsub("\\-(s|S)td\\()", "_Std", features$feature)
    
    # Remove and replace other R reserved symbols
    features$feature <- gsub("\\-", "_", features$feature)
    features$feature <- gsub("(\\(|\\)|\\,)", "", features$feature)

    # Identify the columns that include mean and standard deviation measures
    # using a new column featureType which is "NULL" if we're not interested in
    # the feature
    includeCol <- grepl("(_Mean|_Std)", features$feature) 
    features$featureType <- ifelse( includeCol, "numeric", "NULL")

    features
}

loadData <- function( subjectfile, activityfile, resultfile, features ){
    ## Loads features data from a test or train file
    ## the column ordering is assumed to be the same as specified in the
    ## features dataframe.  The features datafram will also determine which
    ## columns should be loaded.
    
    ## Returs a data frame that includes 
    ##   the subject of the feature reading
    ##   the actvity associated with the feature reading
    ##   the feature readings

    subject <- read.table( subjectfile, col.names="Subject_ID")
    activity <- read.table( activityfile, col.names="Activity_ID")
    results <- read.table( resultfile, 
                           colClasses=features$featureType, 
                           col.names=features$feature)

    # the subject, activity, and feature readings tables are all ordered
    # so that can be joined by simply binding the data together
    cbind(subject, activity, results)

}

# load feature and actity information
features <- loadFeatures( "./features.txt")
activities <- read.table ( "./activity_labels.txt", 
                           col.names=c("Activity_ID", "Activity"))

#unify (join) test and training data sets
unifieddata <- rbind( loadData( "./test/subject_test.txt","./test/y_test.txt",
                                "./test/X_test.txt", features ),
                        loadData( "./train/subject_train.txt","./train/y_train.txt",
                                  "./train/X_train.txt", features ))

#merge the unified dataframe with the activities dataframe to get activity text
unifieddata <- merge( x=activities, y=unifieddata, 
                     by.x="Activity_ID", by.y="Activity_ID", all=FALSE )

#summarize data by activity and subject
cleandata <- aggregate(unifieddata[,4:69], 
                       by=list( unifieddata$Activity, unifieddata$Subject_ID ), 
                       FUN=mean)

#rename the sumarized groups for readability
names(cleandata)[1:2] <- c("Activity", "Subject")

#write the summarized results to the file cleandata.csv
write.table( cleandata, file="cleandata.csv", sep=",", 
             row.names=FALSE, col.names=TRUE)