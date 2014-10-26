# Getting and Cleaning Data Course Project
# Assume that the relevant data file are present in ./Data/train and
# ./Data/test.

# Per project FAQ, we do not need to include the intertial data

# The requirement that this be a single scipt makes it difficult to use
# functions and keep the code readable so there will be some repetition

# Description of data files:
# ./Data/(test/train)/x_(test/train).txt:
# The actual data sets, sizes [2947,561], [7352,561] repectively.

# /Data/(test/train)/y_(test/train).txt: An integer vector corresponding to the
# rows of the respective data set. Range 1-6 mapping each row to an activity.
# Sizes [2947], [7352]

# /Data/(test/train)/subject_(test/train).txt: An integer vector corresponding
# to the rows of the respective data set. Mapping each row to a 
# subject (person) ID #. Sizes [2947], [7352]

# /Data/activity_lables.txt: maps integers in subject_(test/train).txt to an
# activity description e.g. 'walking'. Size [6]

# /Data/features.txt: Column/variable names of the data set, x_(test/train).txt.
# [561,2]

# Set some useful variables
dirTrain <- "./Data/train"
dirTest <- "./Data/test"
outputFile <-"./TidyDataSet.txt"

# Merge the test and training data
# I am going to row bind the different components (training on top) then put
# the resultng components together into one large data frame.

trnSubject <- read.table(paste(dirTrain, "subject_train.txt", sep = "/" ))
tstSubject <- read.table(paste(dirTest, "subject_test.txt", sep = "/" ))
subject <- rbind(trnSubject, tstSubject)
rm(trnSubject, tstSubject)

trnY <- read.table(paste(dirTrain, "y_train.txt", sep = "/" ))
tstY <- read.table(paste(dirTest, "y_test.txt", sep = "/" ))
y <- rbind(trnY, tstY)
rm(trnY, tstY)

trnX <- read.table(paste(dirTrain, "x_train.txt", sep = "/" ))
tstX <- read.table(paste(dirTest, "x_test.txt", sep = "/" ))
x <- rbind(trnX, tstX)
rm(trnX, tstX)

features <- read.table("./Data/features.txt")

# Add column/variable names to the data set
names(x) <- features[ , 2]
#clean up the names by getting rid of"()" and turning "-" to "_"
names(x) <- gsub("[()]", "", names(x))
names(x) <- gsub("-", "_", names(x))

# Find the measurements that have to do with mean and standard deviation
# and keep only those columns.
x <- x[ ,grepl("mean|std", names(x))]

# make a big data frame with all of the data components
bigData <- data.frame(subject, y)
names(bigData) = c("Subject_ID", "Activity")
bigData <- cbind(bigData, x)
rm(x, y, subject, features)

# Replace Activity number with descriptive name from activity_labels.txt.
# We are going to do this by making it a factor with descriptive labels.
actList <- read.table("data/activity_labels.txt")
bigData$Activity <- factor(bigData$Activity, levels = actList[,1],
                           labels = actList[,2])
rm(actList)

# So now we have the big data set with decriptive activity and variable names
# with only variables that have to do with the mean or standard deviation.

# Extract tidy data set containing the average value for each variable by 
# Subject_ID and Activity.
# This is perfect for plyr (ddply)
library(plyr)
tidyData <- ddply(bigData, c("Subject_ID", "Activity"),
                  function(x) colMeans(x[,3:ncol(x)]))

#rename data columns to reflect that the values were averaged
names(tidyData)[3:ncol(tidyData)] <- 
  paste("Avg", names(tidyData)[3:ncol(tidyData)], sep = "_")

# Write out the tidy data frame to a file.
write.table(tidyData, file = outputFile, row.names = FALSE)

# Sanity check to make sure the output file is what we want. Read the output
# file back into a new data frame and inspect it.
dataIn <- read.table(outputFile, header = TRUE)
