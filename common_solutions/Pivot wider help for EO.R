# Load libraries
library(dataRetrieval)
library(tidyverse)
library(ggplot2)
library(flextable)

# Download data
df <- readWQPdata(
  siteid = c( 
  # New Jersey Sites
  "USGS-01391500", # Saddle River at Lodi, NJ
  "USGS-01394500", # Rahway River near Springfield
  "USGS-01395000", # Rahway River near Rahway
  
  # Pennsylvania Sites
  "USGS-01464907", # Little Neshaminy Cr at Valley Rd
  "USGS-01473900", # Wissahickon Creek at Fort Washington
  
  # Virginia sites
  "USGS-01646000", # Difficult Run (DifR)
  "USGS-01645704", # Difficult Run above Fox Lake, VA
  "USGS-01654000", # Accotink Creek near Annandale, vA
  
  # North Carolina Sites
  "USGS-02087580",  # Swift Creek near Apex, NC
  "USGS-02085000", # Eno River at Hillsborough, NC
  "USGS-0209782609", # White Oak Cr at moth near Green Level, NC
  
  # South Carolina
  "USGS-02172300", # McTier Creek near Monetta, SC
  "USGS-02169570", # Gills Creek at Columbia, SC
  
  # Georgia Sites
  "USGS-02336728", # Utoy Creek at Great SW Pkwy near Atlanta
  "USGS-02203700", # Intrenchment Cr at Constitution Rd nr Atlanta
  "USGS-02336313", # Woodall Cr at Defoors Ferry Rd, Atlanta
  "USGS-02338523", # Hillibahatchee Creek
  "USGS-02335870" # Sope Creek near Marietta
    ), 
  CharacteristicName = c(
    "Calcium", "Sodium", "Specific conductance", 
    "Alkalinity","Nitrate", "Chloride", "Sulfate",
    "Magnesium", "Nitrogen", "pH", "Temperature, water",
    "Total dissolved solids", "Bicarbonate", "Carbonate", "Sodium plus potassium", "Nitrite"
    )
  )

# Convert to tibble (probably not necessary)
df <- df %>% 
  as_tibble()

# Select columns and filter
# THIS IS WHERE THE "PROBLEM" STARTS
# There are columns selected that are likely not needed
# The pivot_wider function has trouble pivoting the data because its trying to
#     place the `vaues_from` data with respect to too many unique "keys"
# E.g., Values are easily associated to unique dateTime and stream IDs; but
#     associating each value to `ResultSampleFractionText` as well is difficult
#     because there are "total", "dissolved", "suspended", and "recoverable" values; 
#     associating values to too many keys will create loads of NA values after pivoting
df_long <- df %>% 
  select(ActivityStartDate, MonitoringLocationIdentifier,
         CharacteristicName, ResultMeasureValue,
         ActivityStartDateTime, ResultSampleFractionText, 
         ResultMeasure.MeasureUnitCode, ActivityStartTime.TimeZoneCode, 
         ResultDetectionConditionText, ResultStatusIdentifier,
         ResultValueTypeName, USGSPCode, timeZoneStart) %>% 
  filter(ResultSampleFractionText != "Bed Sediment")

# Note that pivoting this df wider, the values would have to associate to everything that *isn't*
#     in the `names_from` arguement
unique(df_long$ResultSampleFractionText)

# Note that pivoting the df wider didn't shorten it much (but certainly made it wider)
df_wide <- df_long %>% 
  pivot_wider(names_from = CharacteristicName,
              values_from = ResultMeasureValue,
              values_fn = first)
nrow(df_long)
nrow(df_wide)

# I went through and deselected columns that I assumed weren't necessary, one at a time, and tested
df_long_test <- df_long %>% 
  select(!c(ResultMeasure.MeasureUnitCode, ResultValueTypeName, 
            ResultStatusIdentifier, ResultDetectionConditionText, 
            USGSPCode))

df_wide_test <- df_long_test %>% 
  pivot_wider(names_from = c(CharacteristicName, ResultSampleFractionText), # names from 2 columns!
              values_from = ResultMeasureValue,
              values_fn = first)

# Some dateTimes are still duplicated
# The result is far better though
any(duplicated(df_wide_test$ActivityStartDateTime))

nrow(df_wide_test)

# Example plotting

df_plotting <- df_long %>% 
  filter(CharacteristicName == "Calcium", 
         ResultSampleFractionText == "Dissolved", 
         ActivityStartDate >= as.Date("2022-01-01"))

ggplot(data = df_plotting, 
       aes(x = ActivityStartDate, y = ResultMeasureValue, 
           col = MonitoringLocationIdentifier)) + 
  geom_point() + 
  facet_wrap(~MonitoringLocationIdentifier)


# Example statistics with long format df

# wrong

df_long %>% 
  summarise(ex_mean = mean(ResultMeasureValue, na.rm = TRUE))

# right

df_long %>% 
  filter(CharacteristicName == "Nitrogen" | CharacteristicName == "Nitrate") %>% 
  group_by(MonitoringLocationIdentifier, ResultSampleFractionText) %>% 
  summarise(ex_mean = mean(ResultMeasureValue, na.rm = TRUE)) %>% 
  flextable()

# Suggest dlookr package for Exploratory Data Analysis