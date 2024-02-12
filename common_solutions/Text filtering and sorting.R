library(readxl)
library(dplyr)
library(janitor)
library(stringr)

df <- read_xlsx(path = "")

df <- df %>% 
  janitor::clean_names()

check_match <- function(last_name_words, email) {
  any(
    sapply(last_name_words, 
           function(word) str_detect(email, 
                                     regex(word, ignore_case = TRUE)
                                     )
           )
    )
}

df <- df %>% 
  mutate(last_name_lower = tolower(last_name), 
         last_name_split_space = str_split(last_name, " "), 
         last_name_split_hyphen = str_split(last_name, "-"), 
         last_name_no_hyphen = str_replace_all(last_name_lower, "-", ""), 
         last_name_no_space = str_replace_all(last_name_no_hyphen, " ", ""))
  
last_name_mismatch <- df %>% 
  filter(str_detect(email, 
                    last_name_lower, 
                    negate = TRUE) & 
         !purrr::map2_lgl(last_name_split_space, 
                          email, 
                          check_match) & 
         !purrr::map2_lgl(last_name_split_hyphen, 
                          email, 
                          check_match) & 
         str_detect(email, 
                    last_name_no_hyphen, 
                    negate = TRUE) & 
         str_detect(email, 
                    last_name_no_space, 
                    negate = TRUE)) %>% 
  select(1:17)

last_name_match <- df %>% 
  filter(str_detect(email, 
                    last_name_lower) | 
         purrr::map2_lgl(last_name_split_space, 
                          email, 
                          check_match) | 
         purrr::map2_lgl(last_name_split_hyphen, 
                          email, 
                          check_match) | 
         str_detect(email, 
                    last_name_no_hyphen) | 
         str_detect(email, 
                    last_name_no_space)) %>% 
  select(1:17)

# Evaluates to FALSE
nrow(last_name_match) + nrow(last_name_mismatch) == nrow(df)

write.csv(last_name_match, file = "C:/Users/khurley/Downloads/last_names_matching.csv")
write.csv(last_name_mismatch, file = "C:/Users/khurley/Downloads/last_names_no_match.csv")
