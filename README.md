DSCleaningDataProject
=====================

Coursera - Getting &amp; Cleaning Data | Course Project

An R script file for cleaning and summarizing wearable computing data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The script will automatically execute when sourced in using source(run_analysis.R). The clean summarized output file cleandata.csv will be written to the working directory.

The script requires a number of input files:
* features.txt            : list of features that matching the data in the test and train data sets
* activity_labels.txt     : space delimited table with activity ids and activiy descriptions
* test/subject_test.txt   : subjects (IDs) associated with each the test
* test/y_test.txt         : activity tested
* test/X_test.txt         : space delimited table of test data where the columns are ordered based on the features table
* train/subject_test.txt  : subjects (IDs) associated with each the training set
* train/y_test.txt        : activity tested in the training set
* train/X_test.txt        : space delimited table of training data where the columns are ordered based on the features table