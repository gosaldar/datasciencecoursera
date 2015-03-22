# STEP 0: load packages

library(plyr)

# STEP 1: Merges the training and the test sets to create one data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")[,2]
extract_features <- grep("-(mean|std)\\(\\)", features)
x_data <- x_data[,extract_features]
names(x_data) <- features[extract_features]

# STEP 3: Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")[,2]
y_data[, 1] <- activities[y_data[, 1]]
names(y_data) <- "activity"

# Step 4: Appropriately labels the data set with descriptive activity names.

names(subject_data) <- "subject"

# Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

full_data <- cbind(x_data, y_data, subject_data)
average_data <- ddply(full_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(average_data, "result.txt", row.name=FALSE)