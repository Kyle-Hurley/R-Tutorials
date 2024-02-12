# Pivoting wide data to long
# Load libraries
library(dplyr)
library(tidyr)

# Create repex data frame
set.seed(123)
dates <- seq(
  as.Date("2020/01/01"), 
  as.Date("2020/12/31"), 
  by = "day"
)

n_size <- length(dates) # Reference for size of data

set.seed(123)
site_name <- sample(
  c("Big River", "Little River", 
    "Suess Stream", "Towson Run"), 
  size = n_size, 
  replace = TRUE
)

set.seed(123)
collector <- sample(
  c("Kyle", "Emily", "Joel", "Amanda"), 
  size = n_size, 
  replace = TRUE
)

set.seed(123)
temp_deg_c <- sample(
  round(
    runif(n_size, min = -5, max = 38), 
    digits = 2
  ), 
  size = n_size, 
  replace = TRUE
)

variable <- rep(
  c("silica", "calcium", "iron"), 
  times = n_size
)

set.seed(123)
value <- sample(
  round(
    runif(length(variable), min = 0.02, max = 5.5), 
    digits = 2
  ), 
  size = length(variable), 
  replace = TRUE
)

set.seed(123)
value <- sample(
  round(
    runif(n_size * 3,     # Values 3x longer bc there are 3 variables
          min = 0.02, 
          max = 5.5), 
    digits = 2), 
  size = n_size * 3, 
  replace = TRUE
  )


# Create wide data frame
df_wide <- data.frame(
  date = dates,
  site = site_name,
  collector = collector,
  temp_deg_c = temp_deg_c,
  calcium = value[1:n_size],                    # 1st third of value vector
  silica = value[(n_size + 1):(2 * n_size)],    # 2nd third
  iron = value[(2 * n_size + 1):(3 * n_size)]   # Last third
)

# Can pivot to long format on constituents only
df_long <- df_wide %>% 
  pivot_longer(
    cols = calcium:iron, 
    names_to = "variable", 
    values_to = "value"
  )

# Or can pivot to long format including temperature
df_longer <- df_wide %>% 
  pivot_longer(
    cols = temp_deg_c:iron, 
    names_to = "variable", 
    values_to = "value"
  )

# When pivoting, data must adhere to "tidy" principles
# For example, `value` column must all be same class

class(df$collector)      # Character class
class(df$temp_deg_c)     # Numeric class

# Pivoting longer to include different data classes throws error
df_wide %>% 
  pivot_longer(
    cols = collector:iron, 
    names_to = "variable", 
    values_to = "value"
  )
