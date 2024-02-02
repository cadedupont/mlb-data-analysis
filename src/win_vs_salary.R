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

# Get team salaries and wins for the latest year
# left_join() is used to combine the two datasets based on the teamID column
latest_year <- max(Lahman::Salaries$yearID)
team_salaries <- Lahman::Salaries %>%
  filter(yearID == latest_year) %>%
  group_by(lgID, teamID, yearID) %>%
  summarise(Salary = sum(as.numeric(salary))) %>%
  group_by(yearID, lgID) %>%
  arrange(desc(Salary))
wins <- Lahman::Teams %>%
  filter(yearID == latest_year) %>%
  select(teamID, name, W, L) %>%
  mutate(WinPct = W / (W + L)) %>%
  arrange(desc(WinPct))
team_salaries_wins <- left_join(team_salaries, wins, by = "teamID")

# Create a scatter plot of team salary vs. win percentage and save to PNG file
ggplot(team_salaries_wins, aes(x = Salary, y = WinPct)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_text_repel(
    aes(label = name),
    size = 1.75,
    segment.size = 0
  ) +
  labs(
    title = sprintf("Win Percentage vs. Team Salary in %d", latest_year),
    x = "Team Salary",
    y = "Win Percentage"
  ) +
  scale_x_continuous(labels = function(x) paste0(x / 1e6, "M")) +
  theme_bw()
ggsave("../plots/win_vs_salary.png")