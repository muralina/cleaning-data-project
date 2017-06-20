##download file from url
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="C:/Users/nithya/Desktop/DataSc/R Working Directory/c3proj")

##unzip into the working directory
unzip("dataset.zip")

##reading data of activities 
path1 <- "./c3proj/c3proj/UCI HAR Dataset/activity_labels.txt"
activities <- read.table(path1)

##convert 2nd column factors to character
activities[,2] <- as.character(activities[,2])

##reading data of features
path2 <- "./c3proj/c3proj/UCI HAR Dataset/features.txt"
features <- read.table(path2)

##convert 2nd column factors to character
features[,2] <- as.character(features[,2])

##extract wanted features - "mean" & "std"
extract <- grep(".*mean.*|.*std.*",features[,2])
extract_names <- features[extract,2]

##modify the name with regular expression by removing the '-'
extract_names <- gsub("-mean", "MEAN",extract_names)
extract_names <- gsub("-std","STD",extract_names)

##modify the name with regular expression by removing the '()'
extract_names <- gsub("[()]","",extract_names)

##read the train data and bind them in separate columns to a data frame
train <- read.table("./c3proj/c3proj/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./c3proj/c3proj/UCI HAR Dataset/train/Y_train.txt")
train_sub <- read.table("./c3proj/c3proj/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_sub,train_y,train)

##read the test data and bind them in separate columns to a data frame
test <- read.table("./c3proj/c3proj/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./c3proj/c3proj/UCI HAR Dataset/test/Y_test.txt")
test_sub <- read.table("./c3proj/c3proj/UCI HAR Dataset/test/subject_test.txt")
test<- cbind(test_sub,test_y,test)


##bind by row the train and test data sets
allData <- rbind(train,test)

##after binding renaming the columns
colnames(allData) <- c("subject","activity",extract_names)

##turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activities[,1], labels = activities[,2])
allData$subject <- as.factor(allData$subject)

##the data is melted and determined by variable and mean
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

##write it on to a text file
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
