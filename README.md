---
title: "README"
output: html_document
---
Description of run_analysis.R
The script does the following:

1) Reads subject_train.txt and subject_test.txt into data frames.

2) Row binds the subject_test data frame to the subject_train data frame reulting in the 'subject' data frame.

3) Reads y_train.txt and y_test.txt into data frames.

4) Row binds the y_test data frame to the y_train data frame.  Resulting in the 'y' data frame.

5) Reads x_train.txt and x_test.txt into data frames.

6) Row binds the x_test data frame to the x_train data frame.  Resulting in the 'x' data frame.

7) Reads features.txt into a data frame 'features'.

8) Use the gsub funtion to clean up the text in 'features[,2]' by removing the  characters '(' and ')' as well as replacing '-' (dash) with '_' (underline).  

9) Sets the column names of data frame x to be equal to column 2 of
   data frame 'features'.  
   
10) Uses the grepl function to search column names of data frame x to find and keep only columns of x where the column name contains "mean" or "std".

11) Create data frame 'bigData' by with 1st column = data frame 'subject' and 2nd column = data frame  'y'.  Name the columns 'Subject_ID' and 'Activity'.

12) Column bind data frame 'x' to data frame 'bigData'.

13) Read activity_labels.txt int a data frame named 'actList'.

14) convert 'Activity' column of bigData to a factor Using data frame
      'actList' to assign levels and labels to the factor.
      
15) Load the 'plyr' package and use the ddply funtion to split the 'bigData' data frame by the 'Subject_ID' and 'Activity' variables, execute the colMeans function on each piece and then unsplit the results back into the data frame 'tidyData'.

16) Rename all columns of data frame tidyData, except for columns 'Subject_ID' and 'Activty', by prepending 'Avg_' to the name in order to indicate that the results have been averaged.

17) Write data frame 'tidyData' to a file named 'TidyDataSet.txt'.

18) Read 'TidyData.txt' into data frame 'dataIn' in order to ensure that TidyData.txt contains the resluts we expect.
 
