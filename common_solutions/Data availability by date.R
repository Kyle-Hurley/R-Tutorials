# Load library
library(tidyverse)

# Create dataframe for TU data
dates <- sample(seq(as.Date("1990-01-01"), as.Date("2023-01-01"), by = "day"), 100)
conductivity <- sample(c(NA, sample(20:1000, 50, replace = TRUE)), 100, replace = TRUE)
chloride <- sample(c(NA, sample(10:500, 50, replace = TRUE)), 100, replace = TRUE)
data_source <- rep("TU", 100)
TU_df <- data.frame(dates, data_source, conductivity, chloride)

# Create dataframe for DPW data
dates <- sample(seq(as.Date("1990-01-01"), as.Date("2023-01-01"), by = "day"), 100)
conductivity <- sample(c(NA, sample(20:1000, 50, replace = TRUE)), 100, replace = TRUE)
chloride <- sample(c(NA, sample(10:500, 50, replace = TRUE)), 100, replace = TRUE)
data_source <- rep("DPW", 100)
DPW_df <- data.frame(dates, data_source, conductivity, chloride)

# Bind TU and DPW dataframes by rows
df <- rbind(DPW_df, TU_df)

# Pivot dataframe longer
df_long <- df %>% 
  pivot_longer(cols = c(chloride, conductivity), names_to = "measurement", values_to = "value")

# Plot!
ggplot(df_long, aes(x = measurement, group = data_source)) + 
  geom_point(aes(y = dates, shape = data_source, color = data_source), 
             position = position_dodge(w = 0.5)) + 
  coord_flip() + 
  theme_minimal()
