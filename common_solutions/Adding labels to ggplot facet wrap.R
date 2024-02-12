# Load necessary library
library(tidyverse)

# Define the number of samples and sample names
n_samples <- 15
samples <- c("DRLC01a", "DRCC01", "NWBB2")

# Create an empty dataframe
df <- data.frame()

# Generate data for each sample
for (sample in samples) {
  df_sample <- data.frame(
    Sample = factor(rep(sample, n_samples), levels = samples),
    Depth = seq(0, 20, length.out = n_samples),
    Na2O = sort(rnorm(n_samples, 
                      mean = mean(runif(50, min = 0.5, max = 3)), 
                      sd = mean(runif(30, min = 0.1, max = 1.5)))),
    MgO = sort(rnorm(n_samples, 
                     mean = mean(runif(50, min = 3.5, max = 7)), 
                     sd = mean(runif(30, min = 0.1, max = 1.5)))),
    K2O = sort(rnorm(n_samples, 
                     mean = mean(runif(50, min = 7.5, max = 11)), 
                     sd = mean(runif(30, min = 0.1, max = 1.5)))),
    CaO = sort(rnorm(n_samples, 
                     mean = mean(runif(50, min = 11.5, max = 15)), 
                     sd = mean(runif(30, min = 0.1, max = 1.5))))
  )
  
  df <- rbind(df, df_sample)
}

# View the first few rows of the dataframe
head(df)

# Reshape the dataframe to long format
df_long <- df %>%
  pivot_longer(cols = c(Na2O, MgO, K2O, CaO), names_to = "Analyte", values_to = "Concentration")

# View the first few rows of the long dataframe
head(df_long)

# Create the line graph
ggplot(df_long, aes(x = Concentration, y = Depth, color = Analyte, group = Analyte)) +
  geom_line() +
  scale_y_reverse(breaks = seq(0, 100, by = 10)) +  # Invert y-axis
  labs(y = "Depth (m)", x = "Concentration (mg/L)", title = "Concentration of Elements vs. Depth") +
  facet_wrap(~ Sample) + 
  theme_minimal()

# Line graph does not have annotations
# ggplot2 doesn't directly support adding annotations to individual facet
# Need to create a dataframe that contains the labels and their positions

labels <- data.frame(Sample = c("DRLC01a", "DRCC01", "NWBB2"), 
                     Label = c("A", "B", "C"), 
                     right = rep(15, 3), 
                     bottom = rep(20, 3), 
                     Analyte = rep(NA, 3))

# Create the line graph
ggplot(df_long, aes(x = Concentration, y = Depth, color = Analyte, group = Analyte)) +
  geom_line() +
  scale_y_reverse(breaks = seq(0, 20, by = 5)) +  # Invert y-axis
  labs(y = "Depth (m)", x = "Concentration (mg/L)", title = "Concentration of Elements vs. Depth") +
  facet_wrap(~ Sample) + 
  geom_text(data = labels, aes(label = Label, x = right, y = bottom), 
            hjust = 1, vjust = 0, color = "black", 
            size = 18/.pt, family = "serif", fontface = "bold") +  # Add labels
  theme_minimal()


# Another Solution --------------------------------------------------------

# Load library
library(grid)
library(gridExtra)

# Subset data by Sample

drl <- subset(df_long, Sample == "DRLC01a")

drc <- subset(df_long, Sample == "DRCC01")

nwb <- subset(df_long, Sample == "NWBB2")

# Define theme for removing y and x axis titles

p <- theme(axis.title = element_blank(), 
           axis.text = element_text(family = "serif"))

# Create plot of each sample

drl_plot <- ggplot(drl, aes(x = Concentration, y = Depth, color = Analyte, group = Analyte)) + 
  geom_line(show.legend = FALSE) + 
  scale_y_reverse(breaks = seq(0, 20, by = 5)) + 
  annotate(geom = "text", x = 15, y = 20, label = "A", 
           family = "serif", fontface = "bold", size = 16/.pt) + 
  theme_minimal() + 
  p

drc_plot <- ggplot(drc, aes(x = Concentration, y = Depth, color = Analyte, group = Analyte)) + 
  geom_line(show.legend = FALSE) + 
  scale_y_reverse(breaks = seq(0, 20, by = 5)) + 
  annotate(geom = "text", x = 15, y = 20, label = "B", 
           family = "serif", fontface = "bold", size = 16/.pt) + 
  theme_minimal() + 
  p

nwb_plot <- ggplot(nwb, aes(x = Concentration, y = Depth, color = Analyte, group = Analyte)) + 
  geom_line() + 
  scale_y_reverse(breaks = seq(0, 20, by = 5)) + 
  annotate(geom = "text", x = 15, y = 20, label = "C", 
           family = "serif", fontface = "bold", size = 16/.pt) + 
  theme_minimal() + 
  p

# Define y and x axis titles

y.grob <- textGrob("Depth (m)", gp = gpar(fontsize = 12, fontfamily = "serif"), 
                   rot = 90)
x.grob <- textGrob("Concentration (mg/L)", gp = gpar(fontsize = 12, fontfamily = "serif"))

# Arrange labels and plots
hold <- grid.arrange(arrangeGrob(drl_plot, drc_plot, nwb_plot, 
                                 left = y.grob, 
                                 bottom = x.grob, 
                                 ncol = 3))
