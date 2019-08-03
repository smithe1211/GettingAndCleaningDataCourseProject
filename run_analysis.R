## load required packages
library(dplyr)
library(reshape2)

##read in data and assign to dataframes

features <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\features.txt", col.names = c("n","functions"))
activities <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\test\\subject_test.txt", col.names = "subject")
x_test <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\test\\X_test.txt", col.names = features$functions)
y_test <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\test\\y_test.txt", col.names = "code")
subject_train <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\train\\subject_train.txt", col.names = "subject")
x_train <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\train\\X_train.txt", col.names = features$functions)
y_train <- read.table("C:\\Users\\smith\\OneDrive\\Documents\\UCI HAR Dataset\\train\\y_train.txt", col.names = "code")

##merge data into 1 data set
X_data <- rbind(x_train, x_test)
Y_data <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
M_Data <- cbind(Subject, Y_data, X_data)



##filter data for mean and std
fData <- M_Data %>% select(subject, code, contains("mean"), contains("std"))

##use descriptive activity names to name the dataset
fData$code <- activities[fData$code, 2]

##label dataset with descriptive variable names
names(fData)[2] = "activity"
names(fData)<-gsub("Acc", "Accelerometer", names(fData))
names(fData)<-gsub("Gyro", "Gyroscope", names(fData))
names(fData)<-gsub("BodyBody", "Body", names(fData))
names(fData)<-gsub("Mag", "Magnitude", names(fData))
names(fData)<-gsub("^t", "Time", names(fData))
names(fData)<-gsub("^f", "Frequency", names(fData))
names(fData)<-gsub("tBody", "TimeBody", names(fData))
names(fData)<-gsub("-mean()", "Mean", names(fData), ignore.case = TRUE)
names(fData)<-gsub("-std()", "STD", names(fData), ignore.case = TRUE)
names(fData)<-gsub("-freq()", "Frequency", names(fData), ignore.case = TRUE)
names(fData)<-gsub("angle", "Angle", names(fData))
names(fData)<-gsub("gravity", "Gravity", names(fData))

## create a 2nd tidy data set
n.Tidy <- fData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(n.Tidy, "C:\\Users\\smith\\OneDrive\\Documents\\FinalData.txt", row.name=FALSE)
