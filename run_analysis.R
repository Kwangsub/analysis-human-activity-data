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
  colnames(activity) <- c("index", "name")
  # Convert underscore & upper case to camel case
  activity$name = sub("_([a-z])", "\\U\\1", tolower(activity$name), perl=TRUE)
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
	colnames(data) <- c(features, c("subject", "activity"))
	data
}

features <- getFeatures()
activity <- getActivity()
data <- getExperimentData(features)

# Extract the mean and standard deviation measurements
selectedFeatures <- features[grep("(mean|std)\\(\\)", features)]
reducedData <- subset(data, select=c("subject", "activity", selectedFeatures))
