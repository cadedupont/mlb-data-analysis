# MLB Data Analysis

Project intended to familiarize myself with data analysis in R. The data used is from the [Lahman database](https://cran.r-project.org/web/packages/Lahman/Lahman.pdf), which contains a wide variety of statistics for Major League Baseball (MLB).

## [`era_vs_age.R`](src/era_vs_age.R)

Creates a scatter plot of the earned run average (ERA) of MLB pitchers against their age in the 2022 season. The data utilizes the `Pitching` table left-joined with the `People` table in the database to get the age of the pitchers.

To be qualified for the plot, a pitcher must have thrown at least 100 innings in the season and played in a minimum of 20 games. This is to ensure that the pitcher had a significant amount of playing time in the season (i.e. ignore position players that have pitched, pitchers that were injured, etc.).

<p align="center">
    <img src="/plots/era_vs_age.png" alt="ERA vs Age" width="65%"/>
</p>

## [`win_vs_salary.R`](src/win_vs_salary.R)

Creates a scatter plot of the win percentage of MLB teams in 2016 against their total expenditure on players salaries for that season.

<p align="center">
    <img src="/plots/win_vs_salary.png" alt="Win % vs Salary" width="65%"/>
</p>