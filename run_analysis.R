## Setting needed libraries
library(dplyr)

## Bringing the given data into proper datasets
activityL <- read.table("activity_labels.txt",col.names = c("tag","name"))
features <- read.table("features.txt",col.names = c("tag","feature"))

#Files direct from "test" info
subT <- read.table("test/subject_test.txt",col.names = c("subject"))
xT <- read.table("test/X_test.txt",col.names = features$feature)
yT <- read.table("test/y_test.txt",col.names = "value")

#Files direct from "train" info
subP <- read.table("train/subject_train.txt",col.names = c("subject"))
xP <- read.table("train/X_train.txt",col.names = features$feature)
yP <- read.table("train/y_train.txt",col.names = "value" )

## Merging of training and test sets to create a dataset
#Merging of x_train and x_test
carl<-rbind(xP,xT)
#Merging of y_train and y_test
sagan<-rbind(yP,yT)
##Merging subjects
sube<-rbind(subP,subT)
#One list
merged <- cbind(sube,carl,sagan)

## Extracting only measurements from std or mean
theOnes<-select(merged,value,subject,contains("std"),contains("mean"))

##Naming the activities from info in dataset
theOnes$value<-activityL[theOnes$value,2]

##Proper labels
names(theOnes)[1] <- "Activity"
names(theOnes) <- gsub("Acc","Acceleration",names(theOnes))
names(theOnes) <- gsub("Gyro","Gyroscope",names(theOnes))
names(theOnes) <- gsub("Gyro","Gyroscope",names(theOnes))
names(theOnes) <- gsub("BodyBody","Body",names(theOnes))
names(theOnes) <- gsub("angle","Angle",names(theOnes))
names(theOnes) <- gsub("mean","Mean",names(theOnes))
names(theOnes) <- gsub("Freq","Frequency",names(theOnes))
names(theOnes) <- gsub("gravity","Gravity",names(theOnes))
names(theOnes) <- gsub("Mag","Magnitude",names(theOnes))

## New dataset and mean for each column
new <- group_by(theOnes,subject,Activity)
summarise_all(new,funs(mean))
write.table(new,"tidyData.txt",row.name = FALSE)

