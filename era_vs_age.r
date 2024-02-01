# Install required packages
install.packages("dplyr")
install.packages("ggplot2")
install.packages("Lahman")
install.packages("ggrepel")

# Load required packages
library(dplyr)
library(ggplot2)
library(Lahman)
library(ggrepel)

# Define minimum number of innings pitched
# Used to filter out position players that have pitched
minInnings <- 50
latestYear <- max(Lahman::Pitching$yearID)

# Get ERA and age of active pitchers in the latest year
# Filter out players with less than 50 innings pitched
pitchers <- Lahman::Pitching %>%
  filter(yearID == latestYear) %>%
  group_by(playerID) %>%
  summarise(
    IP = sum(IPouts) / 3, 
    ERA = mean(ERA, na.rm = TRUE)
  ) %>%
  filter(IP >= minInnings) %>%
  left_join(Lahman::People, by = "playerID") %>%
  mutate(age = latestYear - birthYear) %>%
  select(playerID, nameFirst, nameLast, age, ERA)

# Plot ERA vs. age, label points with player names if they're standing out
ggplot(pitchers, aes(x = age, y = ERA)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text_repel(
    aes(label = paste(nameFirst, nameLast)), 
    size = 1.75, 
    segment.size = 0, 
    max.overlaps = 5
  ) +
  labs(
    title = sprintf("ERA vs. Age of Active Pitchers in %d", latestYear),
    x = "Age",
    y = "ERA"
  ) +
  theme_bw()

# Save the plot as a PNG file
ggsave("era_vs_age.png")