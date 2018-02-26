#Imports Test & Train datasets.

testX <- read.table("./test/X_test.txt")
trainX <- read.table("./train/X_train.txt")
testY <- read.table("./test/Y_test.txt")
trainY <- read.table("./train/Y_train.txt")
test_subject <- read.table("./test/subject_test.txt")
train_subject <- read.table("./train/subject_train.txt")

#Appropriately labels the data set with descriptive variable names. 

features <- read.table("features.txt")
colnames(trainX) <- features$V2
colnames(testX) <- features$V2

#Merges the training and the test sets to create one data set.

testX$id <- test_subject$V1
trainX$id <- train_subject$V1
trainX$activity <- trainY$V1
testX$activity <- testY$V1
Set <- rbind(testX,trainX)

#Extracts only the measurements on the mean and standard deviation for each measurement. 

mean_std <- grep("mean|std",names(Set))
Set_meanstd <- subset(Set, select = mean_std)
Set_meanstd$id <- Set$id
Set_meanstd$activity <- Set$activity

#Uses descriptive activity names to name the activities in the data set.

activity <- readLines("activity_labels.txt")
Set_meanstd$activity_labels <- activity[Set_meanstd$activity]

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Set_tidy <- group_by(Set_meanstd, id, activity_labels)
Set_tidy$activity <- NULL
Tidy_data <- summarize_all(Set_tidy,mean)