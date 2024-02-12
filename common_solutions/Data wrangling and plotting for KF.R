library(readr)
library(ggplot2)
library(grid)
library(gridExtra)
library(dplyr)
library(tidyr)

# Read the CSV file
# KH - MAKE YOUR DATA FRAME NAME SHORTER, SUCH AS "DF"
NWBB2_5_19_23_XRF_and_DeadRun_fulldata <- read_csv("CSV files/NWBB2_5.19.23_XRF_and_DeadRun_fulldata.csv")

# KH - INCLUDE EMPTY LINES BETWEEN "SECTIONS" FOR EASIER READABILITY

# View the data
View(NWBB2_5_19_23_XRF_and_DeadRun_fulldata)

# KH - AFTER LOOKING AT IT, YOU NEED TO WRANGLE YOUR DATA
df_long <- NWBB2_5_19_23_XRF_and_DeadRun_fulldata %>% 
  # KH - FIRST, TRANSFORM TO LONG FORMAT
  pivot_longer(cols = Na2O:par, 
               names_to = "Analyte", 
               values_to = "value") %>% 
  # KH - WHEN PLOTTING YOU WANT TO GROUP BY SAMPLE ID. TO HELP WITH THIS YOU WILL NEED TO
  # KH - NOW YOU HAVE TO ARRANGE THE DATA BY INCREASING DEPTH
  # KH - GROUP DATA BY SITENAME, SAMPLE_NAME, AND ANALYTE
  group_by(SiteName, Analyte) %>% 
  # ARRANGE THE DATA IN INCREASING ORDER OF MID_POINT_M
  arrange(Mid_point_m, .by_group = TRUE)

df_long$SiteName <- factor(df_long$SiteName, 
                           levels = c("DRLC01a", "DRCC01", "NWBB2"))

# KH - FILTER FOR THE ANALYTES YOU WANT TO PLOT
big_four <- df_long %>% 
  filter(Analyte %in% c("Na2O", "MgO", "K2O", "CaO"))

# KH - CREATE YOUR THEME (THIS IS UNCHANGED)
p <- theme(axis.title = element_blank(),
           axis.text = element_text(family = "serif"))

# KH - PLOT
ggplot(data = big_four, 
       aes(x = value, y = Mid_point_m, 
           color = Analyte, 
           group = Analyte)) + 
  geom_path() + 
  geom_point() + 
  scale_y_reverse() + 
  facet_wrap(~SiteName) + 
  p

# Adding labels
# Create label dataframe
labels <- data.frame(
  SiteName = factor(c("DRLC01a", "DRCC01", "NWBB2"), 
                    levels = c("DRLC01a", "DRCC01", "NWBB2")), 
  label = c("A", "B", "C"), 
  x_val = rep(9.5, 3), 
  y_val = rep(0.0, 3), 
  Analyte = rep(NA, 3)
)

# Use Labels dataframe in ggplot!
t <- ggplot(data = big_four, 
            aes(x = value, y = Mid_point_m, 
                color = Analyte, 
                group = Analyte)) + 
  geom_path() + 
  geom_point() + 
  scale_y_reverse() + 
  geom_text(data = labels, 
            aes(label = label, x = x_val, y = y_val), 
            hjust = 0, vjust = 1, color = "black", 
            size = 18/.pt, family = "serif", fontface = "bold") +  # Add labels
  facet_wrap(~SiteName) + 
  p

# Save plot t as a 6.5 inch x 5 inch png
ggsave(filename = "C:/Users/kphur/Desktop/test.png", 
       plot = t, 
       width = 6.5, 
       height = 5, 
       units = "in")
