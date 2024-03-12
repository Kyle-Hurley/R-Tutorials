# Load library
library(tidyverse)

# Both pipes work similarly
mtcars |> 
  head()

mtcars %>% 
  head()

# Native pipe cannot use placeholder `.`
mtcars %>% 
  mutate(wt_per_mpg = .[["wt"]]/.[["mpg"]]) %>% 
  select(wt_per_mpg) %>% 
  head()

# Native pipe works well in functional programming style
# `\(x)` is shorthand for an anonymous function
# `()` calls the function
mtcars |> 
  (\(df) df[1:6, ])() |> 
  summary()