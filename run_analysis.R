## download data
filename <- "Course4data.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}


## assign data to variables
featurestest <-read.table(file.path(fpath,"test","X_test.txt"),header=FALSE)
featurestrain <-read.table(file.path(fpath,"train","X_train.txt"),header=FALSE)

subjecttest <-read.table(file.path(fpath,"test","subject_test.txt"),header=FALSE)
subjecttrain <-read.table(file.path(fpath,"train","subject_train.txt"),header=FALSE)

activitytest <-read.table(file.path(fpath,"test","Y_test.txt"),header=FALSE)
activitytrain <-read.table(file.path(fpath,"train","Y_train.txt"),header=FALSE)

## merge training and test sets to create one set
datasubject <- rbind(subjecttest,subjecttrain)
names(datasubject) <- c("subject")

dataactivity <- rbind(activitytest,activitytrain)
names(dataactivity) <- c("activity")

datafeatures <- rbind(featurestest,featurestrain)
datafeaturesnames <- read.table(file.path(fpath,"features.txt"),header=FALSE)
names(datafeatures) <- datafeaturesnames$V2

combinedata <-cbind(datasubject,dataactivity)
mergeddata <- cbind(datafeatures,combinedata)

## extract only the measurements on the mean and standard deviation for each measurement
datafeaturesmeanstd <- datafeaturesnames$V2[grep("mean\\(\\)|std\\(\\)",datafeaturesnames$V2)]

selectnames <-c(as.character(datafeaturesmeanstd),"subject","activity")
meanstddata <- subset(mergeddata,select=selectnames)

## use descriptive activity names to name the activities in the data set
activitylabel <- read.table(file.path(fpath,"activity_labels.txt"),header=FALSE)
names(activitylabel) <- c("activity","activityname")

meanstddata <-merge(activitylabel,meanstddata,by="activity") [,-1]

## labels the data set with descriptive variable names
names(meanstddata) <- gsub("^t","time",names(meanstddata))
names(meanstddata) <- gsub("^f","frequency",names(meanstddata))
names(meanstddata) <- gsub("Acc","Accelerometer",names(meanstddata))
names(meanstddata) <- gsub("Gyro","Gyroscope",names(meanstddata))
names(meanstddata) <- gsub("Mag","Magnitude",names(meanstddata))
names(meanstddata) <- gsub("BodyBody","Body",names(meanstddata))
names(meanstddata) <- gsub("std()","SD",names(meanstddata))
names(meanstddata) <- gsub("mean()","Mean",names(meanstddata))

##  create a second, independent tidy data set with the average of each variable 
##  for each activity and each subject.
library(dplyr)
finaldata <- meanstddata %>% 
        group_by(subject,activityname) %>%
        summarize_all(list(mean))
write.table(finaldata,"FinalData.txt",row.names=FALSE)
