# Getting and Cleaning Data

This is the course project for Getting and Cleaning Data on Coursera. Its 
purpose is to take raw data and process it into a tidy dataset.

## Process

1. Check if data already exists, and if not, download it.
2. Read in the activity, feature, subject info and the training and test 
datasets
3. Merge the datasets, keeping only the subject, activity, and mean/std 
variables
4. Rename variables to be more descriptive
5. Convert the activity codes to their labels
6. Melt and cast into a tidy dataset that contains the mean for each variable
grouped by Activity and Subject
7. Output this tidy dataset to tidyData.txt