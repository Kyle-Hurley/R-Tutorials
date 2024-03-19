library(ggplot2)

# Creating a "wavy" plot

# Sample data
set.seed(123)
x <- 1:20
y <- sin(x/10) + rnorm(20, 0, 0.2)
df <- data.frame(x, y)

# Generate spline interpolated data
spline_data <- data.frame(spline(df$x, df$y, n = 100))

# Plot the original data points and the smoothed line
ggplot() +
  geom_point(data = df, aes(x, y), color = "blue") +  # Plot original data points
  geom_line(data = spline_data, aes(x, y), color = "red") +  # Plot smoothed line
  labs(title = "Visually Smoothed Line Plot", x = "X", y = "Y") +   # Add titles
  theme_minimal()



# A more linear plot
set.seed(123)
x <- 1:20
y <- 1:20 + rnorm(20, 0, 1)
df <- data.frame(x, y)

spline_data <- data.frame(spline(df$x, df$y, n = 100))

ggplot() +
  geom_point(data = df, aes(x, y), color = "blue") + 
  geom_line(data = spline_data, aes(x, y), color = "red") + 
  labs(title = "Visually Smoothed Line Plot", x = "X", y = "Y") + 
  theme_minimal()