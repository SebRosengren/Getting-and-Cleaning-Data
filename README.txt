This file describes how the run_analysis.R script works.

- Firstly, download and unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and rename the folder "data".
    Make sure the folder "data" and the run_analysis.R script are both in the your current working directory.

- Second, use source("run_analysis.R") command in RStudio.
    
- Third, you will find two output files are generated in the current working directory:
        merged_data.txt, containing a data frame called cleanedData with 10299*68 dimension.
        tidy_dataset.txt, containing a data frame called result with 180*68 dimension.

- Finally, use data <- read.table("tidy_dataset.txt") command in RStudio to read the file.