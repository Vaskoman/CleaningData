This script performs the following tasks:
1. Installs the required packages
2. Downloads the .zip file required in a directory called <project>
3. Extracts the data.
4. Uploads the labels (denoting activity) and features data (denoting the types of measurements performed).
5. Uploads the test and train measurement data.
6. Gives names to each measurement by changing the column names to be as names provided in the features file.
7. Combines the test and train measurements.
8. Selects only for measurements of Standard Deviation and Mean.
9. Adds labels to this new dataset representing type of activity associated with each entry.
10. Changes the names of the variabes measured (column names) so that they are easily readable.
11. Rearranges the data so that the final table gives the mean measurement for each variable per subject and per activity.
