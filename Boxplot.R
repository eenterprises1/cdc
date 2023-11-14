library(gridExtra)

df_rank_suicide <- df %>% select(-Age)|> filter(Year %in% c(1999, 2017), Cause == "Suicide")
# Calculate the percentual difference change from 2000 to 2017 for each state
df_rank_suicide <- df_rank_suicide %>%
  pivot_wider(names_from = Year, values_from = Deaths) |>
  mutate(PercentChange = `2017`/`1999`-1) |>
  arrange(desc(PercentChange))
# df_rank_suicide


df_rank_alz <- df %>% select(-Age)|> filter(Year %in% c(1999, 2017), Cause == "Alzheimer's disease")
# Calculate the percentual difference change from 2000 to 2017 for each state
df_rank_alz <- df_rank_alz %>%
  pivot_wider(names_from = Year, values_from = Deaths) |>
  mutate(PercentChange = `2017`/`1999`-1) |>
  arrange(desc(PercentChange))
#df_rank_alz


df_rank_unintentional <- df %>% select(-Age)|> filter(Year %in% c(1999, 2017), Cause == "Unintentional injuries")
# Calculate the percentual difference change from 2000 to 2017 for each state
df_rank_unintentional <- df_rank_unintentional %>%
  pivot_wider(names_from = Year, values_from = Deaths) |>
  mutate(PercentChange = `2017`/`1999`-1) |>
  arrange(desc(PercentChange))
#df_rank_unintentional

df_alz_sui_unt = rbind(df_rank_alz,df_rank_suicide,df_rank_unintentional)
#df_alz_sui_unt

# DO THE PLOT
ggplot(df_alz_sui_unt, aes(x=PercentChange, y=Cause)) + geom_boxplot()

ggplot(df_alz_sui_unt, aes(x=PercentChange)) + geom_boxplot()

df_alz_sui_unt %>% filter(PercentChange >= 2.5)

Q1 <- quantile(df_alz_sui_unt$PercentChange, 0.25)
Q3 <- quantile(df_alz_sui_unt$PercentChange, 0.75)
IQR <- Q3 - Q1

# Define the outlier boundaries
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Extract outliers
outliers <- subset(df_alz_sui_unt, PercentChange < lower_bound | PercentChange > upper_bound)

# View outliers
outliers
