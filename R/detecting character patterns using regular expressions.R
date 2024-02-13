# Ever try to find a complex pattern of characters in text and think to yourself
# str_detect(THAT_four_letter_word, "^F[a-z]{3}") !??? Well, I have something
# for you!!
#
# Finding a specific pattern of characters in text can be brutal. Funny enough,
# the code we write to find those patterns is called "regex" or "regular
# expression".
#
# Let's face it, there is nothing regular about regex. But with just a few tips
# you too can regularly express yourself!! 
#
# To give you a taste of the magic (and madness) of regex, here are some basics
# to help get you started:
#
# 1. A simple example first. Use `str_count()` to count the number of times a
# pattern occurs. You can then filter for rows based on how many times that
# pattern occurs.
#
# 2. Square brackets"[]" match character classes. `[abc]` matches any one
# character of "a", "b", or "c"; and `[A-Za-z]` matches any upper or lower case
# character.
#
# 3. Quantifiers match a specific quantity of characters. Use `*` to match
# any number of occurrences of an element, `+` matches at least 1, `?` makes the
# element optional, and `{n,m}` matches at least `n` and at most `m` occurrences
# of an element. (e.g., "a+" matches one or more consecutive "a"s in a string)
#
# 4. Anchors! The `^` and `$` symbols match a pattern to the start and end of
# text respectively. (e.g., "^[A-Z]" matches any string starting with an upper
# case letter)
#
# Let's see these examples in practice!

# Regex for regulars

library(tidyverse)

# Homeworlds with two or more words
starwars %>% 
  filter(str_count(homeworld, " ") >= 1)

# Names with a number
starwars %>% 
  filter(str_detect(name, "[0-9]$"))


# Filter for names beginning with at least two neighboring vowels
starwars %>% 
  filter(
    str_detect(tolower(name), "^[aeiou]{2}")
  )
