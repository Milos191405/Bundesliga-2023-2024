# Bundesliga 2023/2024 Season Analysis

## 1. Ranking Efficiency

### -  **Goal Efficiency**: Shots on Goal, Goals and correlation between them

``` SQL
WITH avg_shots_to_score AS (
    SELECT
        position,
        team,
        goals,
        shots,
        CASE
            WHEN goals = 0 THEN NULL  
            ELSE ROUND(CAST(shots AS DECIMAL) / goals, 2)        
        END AS avg_shots_to_score
    FROM
        bundesliga_statistics
)

SELECT 
    position,
    team,
    goals,
    shots,
    avg_shots_to_score,
    (SELECT CORR(goals, shots) FROM bundesliga_statistics) AS correlation_shots_goals,
    (SELECT CORR(position, goals) FROM bundesliga_statistics) AS goals_position_correlation
FROM avg_shots_to_score
ORDER BY position;
```

From here we can see that team from the top of table have significantly more shots on goal and scored more goals. 
Best teams needed in average around 7 shots to score the goal. 
Like we expected here is really high correlation between goals and position on the table. 

| Position | Team                        | Goals | Shots | Avg Shots |
|----------|-----------------------------|-------|-------|-----------|
| 1        | Bayer 04 Leverkusen          | 89    | 616   | 6.92      |
| 2        | VfB Stuttgart                | 78    | 527   | 6.76      |
| 3        | FC Bayern München            | 94    | 628   | 6.68      |
| 4        | RB Leipzig                   | 77    | 534   | 6.94      |
| 5        | Borussia Dortmund            | 68    | 497   | 7.31      |
| 6        | Eintracht Frankfurt          | 51    | 393   | 7.71      |
| 7        | TSG Hoffenheim               | 66    | 462   | 7.00      |
| 8        | 1. FC Heidenheim 1846        | 50    | 393   | 7.86      |
| 9        | SV Werder Bremen             | 48    | 398   | 8.29      |
| 10       | Sport-Club Freiburg          | 45    | 396   | 8.80      |
| 11       | FC Augsburg                  | 50    | 437   | 8.74      |
| 12       | VfL Wolfsburg                | 41    | 406   | 9.90      |
| 13       | 1. FSV Mainz 05              | 39    | 471   | 12.08     |
| 14       | Borussia Mönchengladbach     | 56    | 446   | 7.96      |
| 15       | 1. FC Union Berlin           | 33    | 403   | 12.21     |
| 16       | VfL Bochum 1848              | 42    | 509   | 12.12     |
| 17       | 1. FC Köln                   | 28    | 430   | 15.36     |
| 18       | SV Darmstadt 98              | 30    | 402   | 13.40     |


| Correlation Type                           | Value         |
|--------------------------------------------|---------------|
| **Correlation (Shots to Goals)**           | 0.8299        |
| **Goals-Position Correlation**             | -0.9003       |



*Correlation (Shots to Goals): The strong positive correlation of 0.8299 between shots and goals suggests that teams that take more shots tend to score more goals.*

*Goals-Position Correlation: The -0.9003 negative correlation between goals and position indicates that teams higher in the table tend to score more goals, while teams lower in the table score fewer goals.*

*Explanation of Negative Correlation: The negative correlation between goals and position occurs because the team in the first position (highest rank) has a negative correlation value, while the best teams typically occupy lower-numbered positions. A negative correlation confirms that higher-ranked teams (lower position numbers) score more goals, which aligns with expectations*




### - **Does higher possession lead to more successful passes?**  Correlation between "Possession (%)", "Successful passes from open play (%) a" and scored goals.
```sql
SELECT
    position,
    team,
    possession_percent,
    successful_passes_percent,
    CORR(possession_percent, successful_passes_percent) AS correlation_possession_passes,
    CORR(possession_percent, position) AS possession_position_correlation,
    CORR(successful_passes_percent, position) AS successful_passes_position_correlation
FROM
    bundesliga_statistics
ORDER BY
    position ASC;
```
Here is visible that the top team's have slightly higher Possession  and more successful Passes.




| Position | Team                     | Possession % | Successful Passes % |
|----------|--------------------------|--------------|---------------------|
| 1        | Bayer 04 Leverkusen       | 58.00        | 89.80               |
| 2        | VfB Stuttgart             | 57.00        | 88.40               |
| 3        | FC Bayern München         | 59.00        | 89.80               |
| 4        | RB Leipzig                | 54.00        | 86.50               |
| 5        | Borussia Dortmund         | 57.00        | 87.10               |
| 6        | Eintracht Frankfurt       | 50.00        | 83.60               |
| 7        | TSG Hoffenheim            | 49.00        | 83.50               |
| 8        | 1. FC Heidenheim 1846     | 43.00        | 77.30               |
| 9        | SV Werder Bremen          | 47.00        | 82.70               |
| 10       | Sport-Club Freiburg       | 46.00        | 81.40               |
| 11       | FC Augsburg               | 47.00        | 80.40               |
| 12       | VfL Wolfsburg             | 47.00        | 82.80               |
| 13       | 1. FSV Mainz 05           | 46.00        | 78.50               |
| 14       | Borussia Mönchengladbach  | 47.00        | 83.70               |
| 15       | 1. FC Union Berlin        | 44.00        | 79.90               |
| 16       | VfL Bochum 1848           | 47.00        | 81.40               |
| 17       | 1. FC Köln                | 47.00        | 80.80               |
| 18       | SV Darmstadt 98           | 45.00        | 81.40               |

## Correlations

| Correlation Type                          | Value         |
|-------------------------------------------|---------------|
| **Correlation (Possession to Successful Passes)** | 0.8738        |
| **Possession-Position Correlation**       | -0.8014       |
| **Successful Passes-Position Correlation**| -0.7686       |
| **Possession-Goals Correlation**          | 0.8820      |

*correlation Possession -Successful Passes is really hight*
*Other two are also hight and shows that this team are playing more offensive and attacking more*