##README

### PLEASE NOTE: 

The resulting data set that was uploaded for this assignment is in a "narrow" or "long" format, as it was decided that a narrow/long format, which contains only one measurement per row (as opposed to 86 measurements per row), better fit the description of a "tidy" data set as set forth in the paper ["Tidy Data"](http://vita.had.co.nz/papers/tidy-data.pdf) by Hadley Wickham. 

  ______

###Study Design


An experiment was conducted to determine if various forms of human activity could be detected by looking at signals obtained from sensors - the accelerometer and the gyroscope - available in today's smart phones.  Thirty subjects were recorded wearing a smart phone and performing six different activities: walking, walking upstairs, walking downstairs, sitting, standing and laying. 

The accelerometer provided a time-domain signal representing linear acceleration in 3 directions - sideways/horizontal, up/down, and forward/backward - designated by the X-, Y- and Z-axes respectively.  The gyroscope provided a time-domain signal representing angular velocity, again in three directions (X-, Y- and Z-).  

By sampling these signals at regular intervals, the experimenters were able to calculate 561 features from each sample.  The following table<sup>1</sup> describes the functions used to make these calculations, across both time and derived frequency domains.

|Function|Description|
|---|---|
|mean|Mean value|
|std|Standard deviation| 
|mad|Median absolute value|
|max|Largest values in array|
|min|Smallest value in array| 
|sma|Signal magnitude area| 
|energy|Average sum of the squares| 
|iqr|Interquartile range|
|entropy|Signal Entropy| 
|arCoeff|Autorregresion coefficients|
|correlation|Correlation coefficient| 
|maxFreqInd|Largest frequency component|
|meanFreq|Frequency signal weighted average| 
|skewness|Frequency signal Skewness| 
|kurtosis|Frequency signal Kurtosis| 
|energyBand|Energy of a frequency interval| 
|angle|Angle between two vectors|

(See also *features_info.txt* in the downloaded HCI Data Set for additional information)

______

### The Data
  

#### Human Activity Recognition Using Smartphones Data Set (HCI Data Set)

##### Retrieved from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


The file structure of the UCI HAR Dataset:

	- activity_labels.txt
	- features_info.txt
	- features.txt
	- README.txt
	- /test
		- /Inertial Signals
			- body_acc_x_test.txt  
			- body_acc_y_test.txt
			- body_acc_z_test.txt
			- body_gyro_x_test.txt  
			- body_gyro_y_test.txt
			- body_gyro_z_test.txt
			- total_acc_x_test.txt
			- total_acc_y_test.txt
			- total_acc_z_test.txt			
		- subject_test.txt
		- X_test.txt
		- y_test.txt
	- /train
		- /Inertial Signals
			- body_acc_x_train.txt  Raw accelerometer data for each axis X, Y and Z
			- body_acc_y_train.txt
			- body_acc_z_train.txt
			
			- body_gyro_x_train.txt
			- body_gyro_y_train.txt
			- body_gyro_z_train.txt
			- total_acc_x_train.txt
			- total_acc_y_train.txt
			- total_acc_z_train.txt			
		- subject_train.txt
		- X_train.txt
		- y_train.txt

The data was divided into test data and training data, with similarly structured files available for each category.  

Files found in the Inertial Signals sub directories contained raw sample data taken from both the accelerometer and gyroscope signals.  As we were interested in just the features involving mean and standard of deviation for this assignment, the raw data files found in these directories were not used.

The *README.txt* file downloaded with the data files described both the experiment and the content of the files containing the data (raw and calculated features) plus those files containing descriptive data.

*features_info.txt* described how the 561 features were obtained from the raw data.

The remaining files were used in the assignment: ```activity_labels.txt, features.txt, subject_test.txt, X_test.txt, y_test.txt, subject_train.txt, X_train.txt, y_train.txt```
		
		
	

###The Script

####run_analysis.R####

All files were assumed to be in the same directory as the script.  The text file produced by the script was also written to this directory.

The script works as follows:

&#49;.  Install, if necessary, and load the ```dplyr``` (v. 0.5.0) and ```reshape2``` (v. 1.4.2) packages.

&#50;.  Read files into R using ```read.table()``` resulting in the following data frames:



| Dimensions |Table|Description|
|----:|:----|-------------------------------------------------------------------|
|[6, 2]|```activity_labels```|describes of the six activities which were represented by numbers in y_test.txt and y_train.txt|
|[561, 2]|```features```|contains the descriptive names of the 561 features derived from the raw signals|
|[2947, 1]|```subject_test```|contains subject identifiers 2, 4, 9, 10, 12, 13, 18, 20, 24|
|[2947, 561]|```X_test```|contains the numeric feature calculations, normalized to range in value from -1 to 1|
|[2947, 1]|```y_test```|contains numeric representations of the 6 various activities performed by the subjects|
|[7352, 1]|```subject_train```|contains subject identifiers 1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30|
|[7352, 561]|```X_train```|contains the numeric feature calculations, normalized to range in value from -1 to 1|
|[7352, 1]|```y_train```|contains numeric representations of the 6 various activities performed by the subjects|

    
The data frames appeared to fit as follows to create one data set for training data and one for testing data:

![Training data files](images/train.png?raw=TRUE)
![Testing data files](images/test.png?raw=TRUE)
    

&#51;.  As the test data was a smaller set, the script worked with it first. 

Rename the variables in ```subject_test``` and ```y_test``` with more descriptive names - ```subjectid``` and ```activityid```, respectively

&#52;.  Combine ```subject_test``` and ```y_test``` to get a data frame that shows what activity was performed by which subject - ```subject_activity_test```

&#53;.  Add a column, ```datatype```, to preserve the fact this data is test data, as it is intended to eventually combine the test data and the training data into one data table

&#54;.  Use the data in the features data table as descriptive column names for the feature data contained in ```X_test```

&#55;.  Combine the data tables into a complete set of testing data, where each row in the data table shows the subject, the activity being performed in that row, the data type (test), and 561 numeric values representing the calculated features values.  

```[2947, 564] testdata```

Repeat steps 3 through 7 for the training-related data tables  (```subject_train```, ```y_train``` and ```X_train```), resulting in a set of training data.

```[7352, 564] traindata```


&#56;.  Combine the test data and training data into one data set

```[10299, 564] bigdata```

&#57;. Activities performed by the subjects are represented by numbers 1-6.  Replace these numbers with the descriptions in ```activity_labels```, and rename the column ```activity```

&#49;&#48;.  As the only interest is in columns representing mean and standard of deviation, select any columns containing "mean" or "std" in their variable names.  This includes all mean and standard of deviation calculations, meanFreq calculations, and angle measurements between features that contain mean or std in their names.  Of the 561 features, 86 meet the criteria.

```[10299, 89]  big_data_subset_meanstd```  (columns: ```subjectid```, ```activity```, ```datatype``` (test or train), 86 feature columns)
    
&#49;&#49;. To create a tidy data set, each measurement should have its own row.  Use ```melt``` to go from "wide" data frame to narrow, "tidy" dataframe    

```[885714, 5] melted_big_data_subset_meanstd```

    The first 5 rows of this "narrow" data set:
        
        
        subjectid            activity datatype            feature  measurement
                2  WALKING_DOWNSTAIRS     test  tBodyAcc-mean()-X   0.25717778
                2  WALKING_DOWNSTAIRS     test  tBodyAcc-mean()-X   0.28602671
                2  WALKING_DOWNSTAIRS     test  tBodyAcc-mean()-X   0.27548482
                2  WALKING_DOWNSTAIRS     test  tBodyAcc-mean()-X   0.27029822
                2  WALKING_DOWNSTAIRS     test  tBodyAcc-mean()-X   0.27483295


&#49;&#50;.  The final data set requested by the assignment contains a mean for each feature, organized by subject and activity, so the data is grouped first by subject, then for each subject, by activity, and for each activity, by feature.  For each combination of those three variable, calculate the mean.

Each of the 30 subjects has 6 activities, and for each activity there are 86 features for which the mean is calculated.

30 subjects \* 6 activities \* mean for each of the 86 features, with one feature measurement per row, results in 15,480 rows in the final data set

```[15480, 4]  big_data_summary```

First five rows of ```big_data_summary```:

        subjectid   activityid            feature  mean(measurement)
                1       LAYING	tBodyAcc-mean()-X       0.2773307587
                1       LAYING	tBodyAcc-mean()-Y      -0.0173838185
                1       LAYING	tBodyAcc-mean()-Z      -0.1111481035
                1       LAYING	 tBodyAcc-std()-X      -0.2837402588
                1       LAYING	 tBodyAcc-std()-Y       0.1144613367


&#49;&#51;.  Write this final data table out to disk as a text file, separating fields using spaces

    SamsungSummaryData.txt


______
Note: To read this file back into R (assuming file is in current working directory):


    data <- read.table("SamsungSummaryData.txt", header = TRUE)
    View(data)



###Bibliography
  --------

####1. Wu, Z., Zhang, S., Zhang, C. Human Activity Recognition using Wearable Devices Sensor Data.  

#####Retrieved from http://cs229.stanford.edu/proj2015/107_report.pdf


The authors used the HCI data for another look at the data.  This paper contains an explanation of how the HCI data was collected, and how the calculations on the raw data were made.  It identifies the measures used for computing the feature vectors.


####2. Bayat, A., Pomplun, M. & Tran, D. A Study on Human Activity Recognition Using Accelerometer Data from Smartphones.  

#####Retrieved from http://dx.doi.org/10.1016/j.procs.2014.07.009


This paper provides an explanation of what data can be captured using smartphone accelerometer.  It includes a good description of the signals that can be obtained from a smartphone accelerometer in such an experiment, including what the three axes - X, Y and Z - represent, what processing can be done to those signals, and how to sample the signals to calculate the features researches are interested in.



####3. Wickham, H. (2014). Tidy Data. *Journal of Statistical Software*, VV(II), pp. 24. 

#####Retrived from https://www.jstatsoft.org/article/view/v059i10
 

 