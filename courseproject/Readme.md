# Readme

## Running the Script

__You run the run_analysis.R script. For instance with the call: resultsOfAnalysis <- run_analysis()__

## Instructions:
First, clone this Git repository.
In RStudio set your working directory to datasciencecoursera/courseproject:
Open the script run_analysis.R.
select all the code lines and click run.
 
## Results:
 
The results will be print on your screen. (Depending on your option setting for __max.print__ you will see more or less lines.)
The results of analysis is an R object named __resultsOfAnalysis__.
 
 __resultsOfAnalysis__ is a data set with the average of each variable for each activity and each subject. 
 
 __resultsOfAnalysis__  is computed as described in the following lines:
  
Let us call __part1__  a data set resulting from merging the training and the test data sets.
In __part1__ only the measurements on the mean and the standard deviation for each measurement are taken into account and
the columns and the activities have been given descriptive labels. 
__resultsOfAnalysis__ is produced by first reshaping __part1__:

    resultsOfAnalysis <- melt(part1,id=c(Subject_Id,Activity),measure.vars=c(names(part1)[3:68])) 
 and then aggregating the desired variables:

    resultsOfAnalysis <- sqldf(select  Activity,Subject_Id , variable, avg(value)  as averages from part1 group by Activity,Subject_Id ,variable)
where __Activity__ and __Subject_Id__ are the labels for the columns identifying the activity and the subject respectively. 

