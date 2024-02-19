# Load dplyr package
library(dplyr)

# Example datasets
df1 <- data.frame(ID = c(1, 2, 3, 4),
                  Value = c("A", "B", "C", "D"))
df2 <- data.frame(ID = c(1, 2, 5),
                  OtherValue = c("X", "Y", "Z"))

# Semi join: Keep only rows from df1 that have a match in df2
semi_join(df1, df2, by = "ID")

# Whereas left join keeps ALL rows from df1
left_join(df1, df2, by = "ID")

# Anti join: Keep only rows from df1 that do not have a match in df2
anti_join(df1, df2, by = "ID")

# Whereas inner join keeps rows matching between df1 and df2
inner_join(df1, df2, by = "ID")

# How to join data that may have spelling errors?
# Install and load necessary libraries
install.packages("fuzzyjoin")
library(fuzzyjoin)

# Example datasets
df3 <- data.frame(ID = c(1, 2, 3, 4),
                  Value = c("Apple", "Banana", "Cherry", "Date"))
df4 <- data.frame(ID = c(1, 2, 5),
                  OtherValue = c("Aple", "Banan", "Zebra"))

# Perform fuzzy join based on approximate matching
stringdist_inner_join(df3, df4, by = c("Value" = "OtherValue"), max_dist = 1)


