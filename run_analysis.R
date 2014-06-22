# install plyr
install.packages("plyr")
install.packages("stringr")
install.packages("reshape2")

# Download data.
if(!file.exists("project")) {
dir.create("project")
}
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./project/Dataset.zip", method="auto")

# Extract data.
if (!file.exists("UCI HAR Dataset")){
        unzip("./project/Dataset.zip")      
}

# Upload labels and features,
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])


# Create the data

## Load the test and train set X_test.txt
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
## Name the colnames from features
colnames(test_data) <- features[,2]
colnames(train_data) <- features [,2]
## Delete features table to save ram
rm ("features")
## Unify test and train data
data <- rbind (train_data, test_data)
rm("train_data","test_data")

## Keep only columns required for the mean and std.
mean <- grep("mean",colnames(data))
std <- grep("std",colnames(data))
data <- data[,c(std,mean)]
rm("mean","std")

## Load the test and train labels set from y_test.txt and y_train.txt (which activity was performed).
training_labels <- read.table ("./UCI HAR Dataset/train/y_train.txt")
colnames(training_labels) <- "activity"
test_labels <- read.table ("./UCI HAR Dataset/test/y_test.txt")
colnames(test_labels) <- "activity"
labels<-rbind(training_labels,test_labels)
rm("training_labels","test_labels")
labels[,1]<- as.factor(labels[,1])
data <- cbind(labels,data)
rm("labels")
library(plyr)
levels(data[,1]<-revalue(data[,1], c("1"=activity_labels[1,2],"2"=activity_labels[2,2],"3"=activity_labels[3,2],
"4"=activity_labels[4,2],"5"=activity_labels[5,2],"6"=activity_labels[6,2])))


## Load the test and train subject (subject performing the test or training).
subject_train <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "subject_number"
subject_test <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "subject_number"
subject <- rbind(subject_train,subject_test)
rm("subject_train","subject_test")
## Append to first table and delete subject to free memory.
data <- cbind (subject,data)
rm ("subject")

## Add another column specifying whether the reading belongs to a train or test set.
group <- rep(c("train","test"), c(7352,2947))
group <- as.factor(group)
data <- cbind(group,data)
rm("group")

## Meaningful colnames.
a<-colnames(data)
library(stringr)
a<-gsub("[[:punct:]]","_",a)
a<-gsub("__","",a)
a<-gsub("Acc","Acceleration",a)
a<-gsub("Gyro","AngVelocity",a)
a<-gsub("tBody","TimeBody",a)
a<-gsub("fBody","FrequencyBody",a)
a<-gsub("BodyBody","Body",a)
a<-gsub("tGravity","timeGravity",a)
a<-gsub("std","StDev",a)
a<-gsub("mean","Mean",a)
a<-gsub("Mag","Magnitude",a)
colnames(data)<-a


# New table with average of each variable for each activity and subject
library(reshape2)
data <- cbind(data, data$group)
data <- data[,-1]
colnames(data)[82] <- "group"
variables <- colnames(data)[3:81]
mdata <- melt(data, id=c("activity","subject_number"), measure.vars=variables)
ddata <- dcast(mdata, activity+subject_number~variable, mean)

