# time of data 
as.character(Sys.time()) 
# R version 
R.version$version.string

require(reshape2)


# Set path as the workign directory
path <- getwd()
path

# Download the file. Put it in the Data folder. 

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))


# Unzip the file

executable <- file.path("C:", "Program Files (x86)", "7-Zip", "7z.exe")
parameters <- "x"
cmd <- paste(paste0("\"", executable, "\""), parameters, paste0("\"", file.path(path, f), "\""))
system(cmd)

# The archive put the files in a folder named UCI HAR Dataset. Set this folder as the input path. List the files here.
pathIn <- file.path(path, "UCI HAR Dataset")
list.files(pathIn, recursive=TRUE)
