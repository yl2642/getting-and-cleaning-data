# Peer-graded assignment: getting and cleaning data course project

The run_analysis.R prepares the original data by performing the 5 steps required by the project:

**1. Merges the training and the test sets to create one data set.**
* original data is downloaded and unzipped into `UCI HAR Dataset`
* `featurestest` comes from the `x_test.txt`
* `featurestrain` comes from the `x_train.txt`
* `subjecttest` comes from the `subject_test.txt`
* `subjecttrain` comes from the `subject_train.txt`
* `activitytest` comes from the `y_test.txt`
* `activitytrain` comes from the `y_train.txt`
*`datasubject` is a list with the `subjecttest` and `subjecttrain` combined using rbind
*`dataactivity` is a list with the `activitytest` and `activitytrain` combined using rbind
* `datafeatures` is a dataframe  with the `featurestest` and `featurestrain` combined using 
rbind and the names of the features from `features.txt`
* `combinedata` is a dataframe that merges `datasubject` and `dataactivity` with cbind
* `mergedata` is a dataframe that merges `combinedata` and `datafeatures` to create one 
dataset

**2. Extracts only the measurements on the mean and standard deviation for each measurement.**
* `datafeaturesmeanstd` selects the names containing "mean" or "std" from the list of features
* `selectnames` is a character vector with the means and std names and subject and activity
* `meanstddata` is a data frame that contains only the measurements on the mean and standard 
deviation for each measurement

**3. Uses descriptive activity names to name the activities in the data set**
* `activitylabel` reads the activity number and name from the `activity_labels.txt`
* `meanstddata` merges `activitylabel` and `meanstddata` by `activity` and name the activities
in the dataset

**4. Appropriately labels the data set with descriptive variable names.**
* all names starts with "t" are replaced with "time"
* all names starts with "f" are replaced with "frequency"
* names containing "Acc" are replaced with "Accelerometer"
* names containing "Gyro" are replaced with "Gyroscope"
* names containing "Mag" are replaced with "Magnitude"
* names containing "BodyBody" are replaced with "Body"
* names containing "std()" are replaced with "SD"
* names containing "mean()" are replaced with "Mean"

**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**
* `finaldata` is created by loading the dplyr package, grouping `meanstddata` by `subject` and
`activityname`, and calculating the average of each variable for each activity and each subject
* `FinalData.txt` is the second, independent tidy set created using write.table

