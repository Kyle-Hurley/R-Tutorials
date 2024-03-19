# Define main function
main_func <- function(a, b) {
  x <- a + b
  # Calling function g
  nested_func()
}

# Define function g
nested_func <- function() {
  # Trying to use variable x from main_func
  print(x)
}

# Calling main_func does not work!
main_func(2, 3)

# Try assigning x to Global Env
x <- 2 + 3
nested_func() # Works! But negates main_func()

# Functions look for variables in this order:
# 1. Inside the function itself (it's own environment)
# 2. Environment which function is defined in
#    Note nested_func is defined in Global!

# So x is defined inside main_func()
# nested_func() can't find x inside it's own environment or the Global
# and so it returns an error! But when we define x in the Global, we get a return!

# Lets do this correctly...
rm(list = ls())



# Solution 1: Pass x as argument to nested_func
main_func <- function(a, b) {
  x <- a + b
  nested_func(x)
}

nested_func <- function(x) {
  print(x)
}

# Output 5
main_func(2, 3)

# Clear environment
rm(list = ls())



# Solution 2: Define nested_func() inside main_func()
main_func <- function(a, b) {
  x <- a + b
  
  nested_func <- function() {
    print(x)
  }
  
  nested_func()
}

# Output 3
main_func(1, 2)

# Clear environment
rm(list = ls())



# Solution 3: Get x from nested_func's parent frame
main_func <- function(a, b) {
  x <- a + b
  nested_func()
}

nested_func <- function() {
  # Look for x in environment which nested_func() was called from (e.g., parent frame)
  x <- get("x", envir = parent.frame())
  print(x + 1)
}

# Output 6
main_func(2, 3)


# For simple functions, solution 2 is fine
# However, solution 1 is always best practice
# Solution 3 is not recommended!!