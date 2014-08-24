Analysis human activity data
============================

Course project of 'Getting and Cleaning Data' in Coursera

# How It Works
## Contents
* README.md: This file. It describes how can you obtain a tidy data set.
* CodeBook.md: It describe the variables of the output data set (tidyData).
* run_analysis.R: The code file to retrieve raw data and make a tidy data.

## How to obtain a tidy data set
*It assumes the root of raw data is located in the current working directory.*

1. Open run_analysis.R
2. Run the whole script of the opened file
3. A tidy data set was stored into the data frame named 'tidyData'

## Progress of making a tidy data set
1. Read raw data from the file.
2. Merge the training and test set.
3. Extract the certain features with mean or standard deviation in order to reduce excessive experimental data.
4. Rename the label with descriptive name.
5. Calculate the average of each variables for each activity and each subject.

