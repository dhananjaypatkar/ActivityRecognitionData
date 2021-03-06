This project demonstrate the typical steps to make raw data into tidy data, which can be easily analyzed.

#### Dataset used 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### Steps to reproduce 
- Open and run script data-prep.R (this will download required dependencies and data set)
- Open the R script run_analysis.R
- Run the R script run_analysis.R


#### Outputs 

- Tidy dataset file HumanActivityRecongtnData.txt (tab-delimited text)
- Refer Code Book.pdf for understanding tidy data 

#### Note
- Script & analysis was done on windows platform , hence data-prep.R is windows specific and will vary as per OS.