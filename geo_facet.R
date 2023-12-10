library(dplyr)

# Assuming cdc_dataset is your DataFrame
geofac <- cdc_dataset %>%
  group_by(State, Cause) %>%
  arrange(Year) %>%
  mutate(Earliest_Age_Adj_Rate = first(Age_Adj_Rate),
         Age_Adj_Growth = (Age_Adj_Rate / Earliest_Age_Adj_Rate) - 1) %>%
  select(Year, State, Cause, Age_Adj_Growth)






##Mapping
state_abbreviations <- c(
  'Alabama' = 'AL', 'Alaska' = 'AK', 'Arizona' = 'AZ', 'Arkansas' = 'AR', 'California' = 'CA',
  'Colorado' = 'CO', 'Connecticut' = 'CT', 'Delaware' = 'DE', 'Florida' = 'FL', 'Georgia' = 'GA',
  'Hawaii' = 'HI', 'Idaho' = 'ID', 'Illinois' = 'IL', 'Indiana' = 'IN', 'Iowa' = 'IA',
  'Kansas' = 'KS', 'Kentucky' = 'KY', 'Louisiana' = 'LA', 'Maine' = 'ME', 'Maryland' = 'MD',
  'Massachusetts' = 'MA', 'Michigan' = 'MI', 'Minnesota' = 'MN', 'Mississippi' = 'MS',
  'Missouri' = 'MO', 'Montana' = 'MT', 'Nebraska' = 'NE', 'Nevada' = 'NV', 'New Hampshire' = 'NH',
  'New Jersey' = 'NJ', 'New Mexico' = 'NM', 'New York' = 'NY', 'North Carolina' = 'NC',
  'North Dakota' = 'ND', 'Ohio' = 'OH', 'Oklahoma' = 'OK', 'Oregon' = 'OR', 'Pennsylvania' = 'PA',
  'Rhode Island' = 'RI', 'South Carolina' = 'SC', 'South Dakota' = 'SD', 'Tennessee' = 'TN',
  'Texas' = 'TX', 'Utah' = 'UT', 'Vermont' = 'VT', 'Virginia' = 'VA', 'Washington' = 'WA',
  'West Virginia' = 'WV', 'Wisconsin' = 'WI', 'Wyoming' = 'WY', "District of Columbia" = "DC"
)
geofac$State <- sapply(geofac$State, function(x) state_abbreviations[x])
geofac <- na.omit(geofac)

geofac <- geofac |> filter(Cause %in% c("Alzheimer's disease"))




#Doing geofacet
ggplot(geofac, aes(Year, Age_Adj_Growth)) +
  geom_line(size = 1.2, color = "#F78C6C") +
  facet_geo(~ State, grid = "us_state_grid2") +
  scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
  ggtitle("Growth in Alzheimer's Disease by State Since 1999") + # Add title
  theme_bw() + # Use black and white theme as base
  theme(
    strip.text = element_text(color = "white"), # Change facet strip text color
    strip.background = element_rect(fill = "#6D4C41", color = "black") # Change facet strip background color to brown

  )



