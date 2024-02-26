library(ggplot2)
library(dplyr)

# Load the mtcars dataset
data("mtcars")

# Convert cylinders to a factor for faceting
mtcars$cyl <- as.factor(mtcars$cyl)

# Create annotations for each facet
labels <- data.frame(
  cyl = sort(unique(mtcars$cyl)), 
  label = paste0(sort(unique(mtcars$cyl)), " Cylinders"), 
  disp = 0, 
  mpg = rep(max(mtcars$mpg), 3)*1.05
)

# Plot with labels
ggplot(mtcars, aes(x = disp, y = mpg)) +
  geom_point() + 
  geom_text(data = labels, 
            aes(x = disp, y = mpg, label = label), 
            vjust = 0, hjust = 0, 
            fontface = "bold", size = 14/.pt) + 
  facet_wrap(~ cyl, scales = "free") + 
  ylim(0, max(mtcars$mpg)*1.05) + 
  xlim(0, max(mtcars$disp)) + 
  labs(x = "Displacement (cu. inches)", 
       y = "Miles per Gallon") + 
  theme_minimal() + 
  theme(strip.background = element_blank(), 
        strip.text.x = element_blank(), 
        axis.title = element_text(size = 16))

ggsave(filename = paste0(getwd(), "/facets_w_labels.png"), plot = last_plot())
