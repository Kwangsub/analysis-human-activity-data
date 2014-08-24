## Course Project: analysis of human activity data by Galaxy S II
## It should be run as long as the data is in your working directory.

getFeatures <- function() {
	# Read features and return a vector of features
	features <- read.delim("./features.txt", sep="", header=FALSE, stringsAsFactors=FALSE)
	colnames(features) <- c("index", "name")
	features$name
}

getActivity <- function() {
  # Read activity and return a data frame of activity
  # Read activity labels
  activity <- read.delim("./activity_labels.txt", sep="", header=FALSE)
  colnames(activity) <- c("activityIndex", "activityName")
  # Convert underscore & upper case to camel case
  activity$activityName = sub("_([a-z])", "\\U\\1", tolower(activity$activityName), perl=TRUE)
  activity
}

getExperimentData <- function(features) {
	# Read train data
	train_x <- read.delim("./train/X_train.txt", sep="", header=FALSE)
	train_subject <- read.delim("./train/subject_train.txt", sep="", header=FALSE)
	train_y <- read.delim("./train/y_train.txt", sep="", header=FALSE)

	# Read test data
	test_x <- read.delim("./test/X_test.txt", sep="", header=FALSE)
	test_subject <- read.delim("./test/subject_test.txt", sep="", header=FALSE)
	test_y <- read.delim("./test/y_test.txt", sep="", header=FALSE)

	# Merge data
	x <- rbind(train_x, test_x)
	subject <- rbind(train_subject, test_subject)
	y <- rbind(train_y, test_y)

	# Construct table
	data <- cbind(x, subject, y)
	colnames(data) <- c(features, c("subject", "activityNum"))
	data
}

getAppropriateLabel <- function(x) {
  # Appropriate pattern: func-(mean|std)-(X|Y|Z) -> mean|std of func for X|Y|Z
  src <- strsplit(x, "-")[[1]]
  label <- ""
  if (length(src) > 1) {
    if (length(grep("mean", src[[2]])) > 0) {
      label <- "Mean of"
    } else if (length(grep("std", src[[2]])) > 0) {
      label <- "Standard deviation of"
    }
    label <- paste(label, src[[1]])
    if (length(src) > 2) {
      label <- paste(label, "for", src[[3]]);
    }
  } else {
    label <- x
  }
  label
}

features <- getFeatures()
activity <- getActivity()

# Step 1: Get data and merge the training and the test sets
#         and create one data set
data <- getExperimentData(features)

# Step 2: Extract the mean and standard deviation measurements
selectedFeatures <- features[grep("(mean|std)\\(\\)", features)]
reducedData <- subset(data, select=c("subject", "activityNum", selectedFeatures))

# Step 3: Use descriptive activity names to name the activities
descData <- merge(reducedData, activity, by.x = "activityNum", by.y = "activityIndex")

# Step 4: Appropriately labels the data set with descriptive variable names
descLabel <- sapply(selectedFeatures, getAppropriateLabel)
descData <- subset(descData, select=c("subject", "activityName", selectedFeatures))
colnames(descData) <- c("subject", "activity", descLabel)

# Step 5: Creates a second, independent tidy data set
#         with the average of each variable for each activity and each subject
secondData <- reducedData
secondData <- aggregate(secondData, by=list(secondData$subject, secondData$activityNum), mean)
secondData <- merge(secondData, activity, by.x = "activityNum", by.y = "activityIndex")

tidyData <- subset(secondData, select=c("subject", "activityName", selectedFeatures))
colnames(tidyData) <- c("subject", "activity", descLabel)

# A tidy data frame was stored into 'tidyData'.
# It can be exported to the file as below.
# > write.table(tidyData, file="tidy-data.txt", row.name=FALSE)
