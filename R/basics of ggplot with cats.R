# Load necessary libraries
library(ggplot2)
library(gganimate)
library(tidyverse)
# install.packages("remotes")
# remotes::install_github("R-CoderDotCom/ggcats@main")
library(ggcats)

# Load the Economics dataset
data("economics")

# Wrangle the dataset
econ_long <- economics %>% 
  pivot_longer(cols = 2:6, 
               names_to = "variable", 
               values_to = "value") %>% 
  # Add cat names to dataset
  mutate(cat = case_when(
    variable == "uempmed" ~ "nyancat", 
    variable == "psavert" ~ if_else(row_number() %% 2 == 0, "pop_close", "pop")
  )) %>% 
  # Select variables of interest
  filter(variable %in% c("uempmed", "psavert"))

# Plot the animated cats
p <- ggplot(econ_long, aes(x = date, y = value, color = variable, group = variable)) + 
  geom_line() + 
  geom_cat(aes(cat = cat), size = 5) + 
  labs(title = "Whiskering Insights: Meow-velous Visualizations",
       x = "Date",
       y = "") + 
  transition_reveal(date) + # Transition between frames by date column
  theme(legend.position = "none",  # Remove legend
        axis.title = element_text(size = 14),  # Adjust text size
        plot.title = element_text(size = 20),  
        axis.text = element_text(size = 12)) + 
  ease_aes("linear")

# Animate the plot
animate(p, nframes = 100)

# Save it!
anim_save(filename = "animated_plot.gif", 
          animation = animate(p, nframes = 100), 
          path = getwd())
