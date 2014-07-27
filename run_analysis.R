loadFeatures <- function( featurefile ) {
    features <- read.table(featurefile, header=FALSE, sep=" ", 
                           col.names=c("id", "feature") )

    features$feature <- gsub("^f", "Freq_", features$feature)    
    features$feature <- gsub("^t", "Time_", features$feature)
    features$feature <- gsub("\\-(m|M)ean\\()", "_Mean", features$feature)
    features$feature <- gsub("\\-(s|S)td\\()", "_Std", features$feature)
    features$feature <- gsub("\\-", "_", features$feature)
    features$feature <- gsub("(\\(|\\)|\\,)", "", features$feature)

    includeCol <- grepl("(_Mean|_Std)", features$feature) 
    features$featureType <- ifelse( includeCol, "numeric", "NULL")

    features
}

loadData <- function( subjectfile, activityfile, resultfile, features ){
    subject <- read.table( subjectfile, col.names="Subject_ID")
    activity <- read.table( activityfile, col.names="Activity_ID")
    results <- read.table( resultfile, 
                           colClasses=features$featureType, 
                           col.names=features$feature)
    cbind(subject, activity, results)

}

features <- loadFeatures( "./features.txt")
activities <- read.table ( "./activity_labels.txt", 
                           col.names=c("Activity_ID", "Activity"))

unifieddata <- rbind( loadData( "./test/subject_test.txt","./test/y_test.txt",
                                "./test/X_test.txt", features ),
                        loadData( "./train/subject_train.txt","./train/y_train.txt",
                                  "./train/X_train.txt", features ))
unifieddata <- merge( x=activities, y=unifieddata, 
                     by.x="Activity_ID", by.y="Activity_ID", all=FALSE )

cleandata <- aggregate(unifieddata[,4:69], 
                       by=list( unifieddata$Activity, unifieddata$Subject_ID ), 
                       FUN=mean)

names(cleandata)[1:2] <- c("Activity", "Subject")

write.table( cleandata, file="cleandata.csv", sep=",", 
             row.names=FALSE, col.names=TRUE)