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

# Minimum innings pitched and games played to be considered an active pitcher
min_innings <- 100
min_games <- 20

# Get the latest year in the Lahman database
latest_year <- max(Lahman::Pitching$yearID)

# Get the data for active pitchers in the latest year
pitchers <- Lahman::Pitching %>%
  filter(yearID == latest_year) %>%
  left_join(Lahman::People, by = "playerID") %>%
  mutate(age = yearID - birthYear) %>%
  select(playerID, nameFirst, nameLast, yearID, age, ERA, ER, IPouts, G) %>%
  group_by(playerID, yearID, nameFirst, nameLast, age, G) %>%
  summarise(
    IP = sum(IPouts) / 3,
    ER = sum(ER),
    ERA = (ER / IP) * 9
  ) %>%
  filter(IP >= min_innings & G >= min_games)

# Create a scatter plot of ERA vs. age for active pitchers
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
    title = sprintf("ERA vs. Age of Active Pitchers in %d", latest_year),
    x = "Age",
    y = "ERA"
  ) +
  theme_bw()

# Save the plot as a PNG file
ggsave("era_vs_age.png")