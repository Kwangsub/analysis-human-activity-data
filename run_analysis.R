## Course Project: analysis of human activity data by Galaxy S II
## It should be run as long as the data is in your working directory.

runAnalysis <- function() {
	# Read features and activity labels
	features <- read.delim("./features.txt", sep="", header=FALSE, stringsAsFactors=FALSE)
	colnames(features) <- c("feature_num", "feature_name")
	activity <- read.delim("./activity_labels.txt", sep="", header=FALSE)
	colnames(activity) <- c("activity_num", "activity_name")

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
	colnames(data) <- c(features$feature_name, c("subject", "activity"))
	data
}