# Getting and Cleaning Data
## CourseProject

<strong>Objective:</strong>  Combining, extracting and producing a clean, tidy data set from data collected from the accelerometers from the Samsung Galaxy S smartphone.

<strong>Approach:</strong>
<ul>
  <li>Using dplyr package to mutate, to group and to summerise data</li>
  <li>
    Two functions to handle identical repeated tasks
    <ul>
      <li>function doJoinTables(), has one input parameter, folder with two possbile values are "train", "test"; and the function joins data from y_{folder}, X_{folder} and subject_{folder} to produce a dataframe which contain data from either "test" or "train" set. </li>
      <li>function doCleanNames() takes a list of variable names as the only input parameter; makes those names free of unvalid characters; and transforms them into  more meaningful names</li>
    </ul>
  </li>
</ul>



