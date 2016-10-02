# Read subject training and test data
subjectTrainData <- fread(file.path(pathIn, "train", "subject_train.txt"))
subjectTestData  <- fread(file.path(pathIn, "test" , "subject_test.txt" ))

# Read the activity files."Y_train.txt","Y_test.txt"

activityTrainData <- fread(file.path(pathIn, "train", "Y_train.txt"))
activityTestData  <- fread(file.path(pathIn, "test" , "Y_test.txt" ))


# Read the data files "X_train.txt","X_test.txt" 

trainingData <- fread(file.path(pathIn, "train", "X_train.txt"))
testData  <- fread(file.path(pathIn, "test" , "X_test.txt" ))


# Merge subject data.
subjectData <- rbind(subjectTrainData, subjectTestData)
# Rename colum V1 to subject
setnames(subjectData, "V1", "subject")

# Merge activity data
activityData <- rbind(activityTrainData, activityTestData)
# Rename colum V1 to activityNum
setnames(activityData, "V1", "activityNum")

# Merge data files
data <- rbind(trainingData, testData)

# Merge columns  from subjectData, activity data and test data
subjectData <- cbind(subjectData, activityData)
data <- cbind(subjectData, data)

# set Key to as subject and activityNum
setkey(data, subject, activityNum)

# Read the features.txt file, which variables in data are measurements for the mean and standard deviation.
featuresData <- fread(file.path(pathIn, "features.txt"))
# Set meaningful column names
setnames(featuresData, names(featuresData), c("featureNum", "featureName"))


# Subset only measurements for the mean and standard deviation, using grepl() function
featuresData <- featuresData[grepl("mean\\(\\)|std\\(\\)", featureName)]

# Convert the column numbers to a vector of variable names matching columns in data.
featuresData$featureCode <- featuresData[, paste0("V", featureNum)]

# Create a vector of column names using variable names.
select <- c(key(data), featuresData$featureCode)
data <- data[, select, with=FALSE]


# Read activity_labels.txt file. This will be used to add descriptive names to the activities.
activityNamesData <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(activityNamesData, names(activityNamesData), c("activityNum", "activityName"))



# Merge activity labels with data using activityNum column
data <- merge(data, activityNamesData, by="activityNum", all.x=TRUE)

# Add activityName as a key, so key now is subject activity num and activity name
setkey(data, subject, activityNum, activityName)

# Melt the data table to reshape it from a short and wide format to a tall and narrow format.
data <- data.table(melt(data, key(data), variable.name="featureCode"))


# Merge data with features by featureCode.
data <- merge(data, featuresData[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)

# Create a variable, activity that is equivalent to activityName as a factor class in data
data$activity <- factor(data$activityName)

# Create a variable, feature that is equivalent to featureName as a factor class in data
data$feature <- factor(data$featureName)


#Seperate features from featureName using grepl on feature column

## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("^t", data$feature), grepl("^f", data$feature)), ncol=nrow(y))
data$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(grepl("Acc",data$feature), grepl("Gyro",data$feature)), ncol=nrow(y))
data$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepl("BodyAcc", data$feature), grepl("GravityAcc", data$feature)), ncol=nrow(y))
data$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(grepl("mean()", data$feature), grepl("std()", data$feature)), ncol=nrow(y))
data$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))
## Features with 1 category
data$featJerk <- factor(grepl("Jerk", data$feature), labels=c(NA, "Jerk"))
data$featMagnitude <- factor(grepl("Mag", data$feature), labels=c(NA, "Magnitude"))
## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("-X", data$feature), grepl("-Y", data$feature), grepl("-Z", data$feature)), ncol=nrow(y))
data$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))




# Create a data set with the average of each variable for each activity and each subject.

setkey(data, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
tidyData <- data[, list(count = .N, average = mean(value)), by=key(data)]

# Make a compact format
tidyData$variable <- paste(tidyData$featDomain, tidyData$featAcceleration, 
                      tidyData$featInstrument, tidyData$featJerk,
                      tidyData$featMagnitude, tidyData$featAxis,tidyData$featVariable,sep = "_" )
tidyData$variable <- gsub("NA","",tidyData$variable)

tidyData <- subset(tidyData, select = -c(featDomain,featAcceleration,featInstrument
                                         ,featJerk,featMagnitude,featAxis,featVariable,count))
# Write to the file
write.table(tidyData,row.names = F,file = "HumanActivityRecongtnData.txt") 