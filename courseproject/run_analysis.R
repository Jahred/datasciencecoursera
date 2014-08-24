
run_analysis <-function(){
  x_training_set <- read.table("./X_train.txt",sep="")
  correspondingActivity_set <- read.table("./Y_train.txt",sep="")
  correspondingSubject  <- read.table("./Subject_train.txt",sep="")
  activities<-read.table("./activity_labels.txt",sep="")
  # read test data
  x_test_set <- read.table("./X_test.txt",sep="")
  correspondingActivity_test_set <- read.table("./Y_test.txt",sep="")
  correspondingSubject_test  <- read.table("./Subject_test.txt",sep="")
  features  <- read.table("./features.txt",sep="")
  
   
  regExpMeanAndStd <- "((.*?)mean\\(\\))|(.*?)std\\(\\)"
  meanAndDevCols <- grep(regExpMeanAndStd,ignore.case = "true",features$V2)
  theNames <- sapply(meanAndDevCols,function(e) paste("V",e,sep = ""))
   myTestDataset <- x_test_set[,names(x_test_set) %in% theNames]
  myTtrainDataset <- x_training_set[,names(x_training_set) %in% theNames]
  #library(Hmisc);
  library(plyr)
  library(reshape2)
 
mergedSet <- rbind(myTtrainDataset,myTestDataset)

  activities_test <- merge(correspondingActivity_test_set,activities,by.x = names(correspondingActivity_test_set)[1], by.y =names(activities)[1],all="true")
  activities_train <- merge(correspondingActivity_set,activities,by.x = names(correspondingActivity_set)[1], by.y =names(activities)[1],all="true")
  mergedAtivities <- rbind(activities_train,activities_test)
  mergedAtivities <- mutate(mergedAtivities,id=seq(along.with = mergedAtivities$V1))
  mergedSubjects <- rbind(correspondingSubject,correspondingSubject_test)
  mergedSubjects <- mutate(mergedSubjects,id=seq(along.with = mergedSubjects$V1))
  mergedSubjectWithActivity <-  merge(mergedSubjects,mergedAtivities,by.x="id",by.y="id")
  mergedSet <- mutate(mergedSet,id=seq(along.with = mergedSet$V1))
  
  mergedDataWithActivity <-  merge(mergedSubjectWithActivity,mergedSet,by.x="id",by.y="id")
  mergedDataWithActivity <-  mergedDataWithActivity[,!colnames(mergedDataWithActivity) %in% c("V1.y")] 
  colnames(mergedDataWithActivity)[2] <-"Subject_Id"
  colnames(mergedDataWithActivity)[3] <-"Activity"
  colnames(mergedDataWithActivity)[5] <-"V2"
  #change the columns name
  colIndex =1
    for(i in meanAndDevCols){
      colnames(mergedDataWithActivity)[colIndex+3]  <- as.character(features$V2[i])
      colIndex = colIndex+1
   }
 
 result <- mergedDataWithActivity[,2:69]
   
 print("==================================    Part 1: Tidy Dataset   =======================")

  print(result)
print("=====================================================================================")

  tidy <- melt(result,id=c("Subject_Id","Activity"),measure.vars=c(names(result)[3:68])) 
 library(sqldf)
 agg2 <- sqldf("select  Activity,Subject_Id , variable, avg(value)  as averages from tidy group by Activity,Subject_Id ,variable")
 
#output <- list(part1=result,tidydataset2  = agg2)

print("==================================    Part 2: Averages   =======================")
  print(agg2)
print("================================================================================")
agg2
} 



resultsOfAnalysis <- run_analysis()
