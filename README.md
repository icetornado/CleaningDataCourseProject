# Getting and Cleaning Data
## CourseProject

<p><strong>Objective:</strong>  Combining, extracting and producing a clean, tidy data set from data collected from the accelerometers from the Samsung Galaxy S smartphone.</p>

<p><strong>Approach:</strong></p>
<ul>
  <li>Use dplyr package to mutate, to group and to summerise data</li>
  <li>
    There are two sub-functions in the script
    <ul>
      <li><i>function doJoinTables()</i> combines data from three files for each dataset into one single dataframe (as output).  It takes one input parameter, folder with two possbile values are "train", "test"; and it joins data from y_{folder}, X_{folder} and subject_{folder} to produce a dataframe which contain data from either "test" or "train" set. </li>
      <li><i>function doCleanNames()</i> scans through the list of variable names for any invalid characters and any obsucred abbreviation; then perform either stripping those invalid characters out or replace those abbreviations with more descriptive names.  The function takes a list of variable names as the only input parameter; and return a list of "clean" names</li>
    </ul>
  </li>
  <li>
    Code execution - Step by step:
    <ul>
      <li>Read "activities" from the file "activity_labels.txt"</li>
      <li>Read original variable names from "features.txt".  Pick variables with names contain either "-mean()" or "-std()" string. Then call doCleanNames function to get a dataframe called measureNames which contains clean variable names</li>
      <li>Get train data set by calling doJoinTables() function with input parameter as "train"</li>
      <li>Get test data set by calling doJoinTables() function with input parameter as "test"</li>
      <li>Combine train and test data into bigData dataframe</li>
      <li>Group bigData by subjectID and activity</li>
      <li>Run summarise_each to get mean values of each variables of each activity of each subject</li>
      <li>Write output of summarise_each to a text file</li>
    </ul>
  </li>
</ul>

<p><strong>Results:</strong> The script generates a data set of 180 observations (30 voluteers x 6 activities) and 68 variables. Within the data set, each measurement (variable) is in one column; and each different observation of that variable is in a different row.  Therefore the data set is tidy. </p>

