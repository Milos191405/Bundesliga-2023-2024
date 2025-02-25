# Bundesliga 2023/2024 Season Analysis

## ### 1️⃣ Correlation Analysis

###    ⚽ **Shots vs. Goals:** Do more shots lead to more goals? Rank teams by **Goal Efficiency** (shots per goal) and analyze the strength of the correlation.

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

#### 🔍 **Key Insights: Goal Efficiency**  
- **Top Scorers, Top Positions:** The top three teams—**Bayer Leverkusen**, **Bayern München**, and **VfB Stuttgart**—lead in both total goals and efficiency, needing fewer than 7 shots per goal on average.  
- **Finishing Efficiency Gap:** Teams at the bottom of the table, such as **1. FC Köln** and **SV Darmstadt 98**, require nearly double the shots per goal (13+), highlighting major finishing issues.  
- **Interesting Outlier:** **Borussia Mönchengladbach** shows good efficiency (7.96 shots/goal) despite a lower rank, indicating potential defensive weaknesses rather than attacking inefficiency.  



### ⚽ **Goal Efficiency Correlations**  
*Correlation between Shots, Goals, and League Position*  

| **Correlation Type**                     | **Correlation Value** | **Interpretation**                                                    |
|-------------------------------------------|----------------------:|------------------------------------------------------------------------|
| **Shots to Goals**                        | 0.8299               | ✅ **Strong positive correlation:** More shots → more goals.            |
| **Goals-Position Correlation**            | -0.9003              | 🔥 **Strong negative correlation:** Better-ranked teams score more goals. |



#### **Interpretation** 
*Correlation (Shots to Goals): The strong positive correlation of 0.8299 between shots and goals suggests that teams that take more shots tend to score more goals.*

*Goals-Position Correlation: The -0.9003 negative correlation between goals and position indicates that teams higher in the table tend to score more goals, while teams lower in the table score fewer goals.*

*Explanation of Negative Correlation: The negative correlation between goals and position occurs because the team in the first position (highest rank) has a negative correlation value, while the best teams typically occupy lower-numbered positions. A negative correlation confirms that higher-ranked teams (lower position numbers) score more goals, which aligns with expectations*

---


###  📈 **Possession (%) vs. Successful Passes:** Does higher possession lead to more successful passes and goals? Rank teams by **Passing Efficiency** (successful passes % per possession %) and assess the impact on league position. 
*Correlation between "Possession (%)", "Successful Passes from Open Play (%)", and Scored Goals.*
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

#### 🔍 **Key Insights: Possession & Passing**  
- **Possession Equals Performance:** Top teams (**Bayer Leverkusen**, **Bayern München**) dominate possession (58–59%) and have the highest successful pass percentages (89.8%), reflecting control-driven playstyles.  
- **Passing Accuracy Advantage:** The strong positive correlation (0.8738) shows that more possession significantly boosts passing accuracy.  
- **Exceptions to the Rule:** Teams like **Eintracht Frankfurt** and **TSG Hoffenheim** achieve mid-table results with lower possession, suggesting alternative tactics like counter-attacking play.  


### 🎯 **Possession & Passing Correlations**  
*Relation between Possession, Passing Accuracy, and Performance*  

| **Correlation Type**                           | **Correlation Value** | **Interpretation**                                                      |
|------------------------------------------------|----------------------:|--------------------------------------------------------------------------|
| **Possession to Successful Passes**             | 0.8738               | ✅ **Strong positive correlation:** More possession → higher passing accuracy. |
| **Possession-Position Correlation**             | -0.8014              | 🔥 **Negative correlation:** Higher-ranked teams dominate possession.    |
| **Successful Passes-Position Correlation**      | -0.7686              | 🔑 **Negative correlation:** Top teams pass more successfully.           |
| **Possession-Goals Correlation**                | 0.8820               | 💯 **Very strong positive correlation:** More possession → more goals.   |

**Interpretation:**
*Possession is strongly linked to successful passes (0.8738), indicating that controlling the ball results in better passing accuracy.*

*The negative correlations (-0.8014 and -0.7686) show that top teams tend to have more possession and better passing.*

 *Additionally, the 0.8820 correlation between possession and goals suggests that possession is a key factor in offensive success.*

---

### 🏃 **Distance Covered & Sprints:** Do teams that run more perform better? Examine correlations between physical performance metrics (distance, sprints, intensive runs) and key outcomes (goals scored, wins, and league position). 
*Assessing the Impact of Physical Performance on Success*  

| Position | Team                      | Distance Covered (km) | Sprints | Intensive Runs | Wins Total | Goals |
|----------|----------------------------|-----------------------:|--------:|---------------:|------------:|------:|
| 1        | Bayer 04 Leverkusen        | 4020.1                | 8011    | 24071          | 28          | 89    |
| 2        | VfB Stuttgart              | 3617.2                | 6923    | 21581          | 23          | 78    |
| 3        | FC Bayern München          | 3471.7                | 6990    | 20391          | 23          | 94    |
| 4        | RB Leipzig                 | 3484.6                | 6964    | 20704          | 19          | 77    |
| 5        | Borussia Dortmund          | 3596.0                | 7304    | 21565          | 18          | 68    |
| 6        | Eintracht Frankfurt        | 4011.2                | 8128    | 25611          | 11          | 51    |
| 7        | TSG Hoffenheim             | 4079.9                | 7512    | 24198          | 13          | 66    |
| 8        | 1. FC Heidenheim 1846      | 3720.3                | 7685    | 23105          | 10          | 50    |
| 9        | SV Werder Bremen           | 3974.5                | 7244    | 23739          | 11          | 48    |
| 10       | Sport-Club Freiburg        | 3998.5                | 7225    | 23033          | 11          | 45    |
| 11       | FC Augsburg                | 3886.2                | 7765    | 23193          | 10          | 50    |
| 12       | VfL Wolfsburg              | 4000.4                | 8369    | 26779          | 10          | 41    |
| 13       | 1. FSV Mainz 05            | 4008.1                | 8320    | 25155          | 7           | 39    |
| 14       | Borussia Mönchengladbach   | 3980.6                | 6857    | 22596          | 7           | 56    |
| 15       | FC Union Berlin            | 3987.5                | 7170    | 23425          | 9           | 33    |
| 16       | VfL Bochum 1848            | 3936.2                | 8028    | 24337          | 7           | 42    |
| 17       | 1. FC Köln                 | 4017.0                | 7811    | 24676          | 5           | 28    |
| 18       | SV Darmstadt 98            | 3567.1                | 5927    | 20006          | 3           | 30    |

#### 🔍 **Key Insights: Physical Performance**  
- **Physical Effort ≠ Success:** Surprisingly, top-performing teams like **FC Bayern München** cover fewer kilometers than lower-ranked teams, indicating that tactical efficiency matters more than sheer physical output.  
- **Sprint Correlation Insights:** While there’s a strong link between sprints and intensive runs (0.8707), this doesn’t translate into more wins or goals, showing that speed alone isn’t a decisive factor.  
- **Unexpected Standouts:** **VfL Wolfsburg** and **1. FSV Mainz 05** cover more distance and perform many sprints but lack corresponding success, hinting at inefficient gameplay strategies.  



### 🏃‍♂️ **Distance, Sprints & Performance Correlations**  
*Assessing the impact of physical performance on success*  

| **Correlation Type**                     | **Correlation Value** | **Interpretation**                                                      |
|-------------------------------------------|----------------------:|--------------------------------------------------------------------------|
| **Distance - Sprints**                    | 0.6055               | 🚀 **Moderate positive correlation:** More distance → more sprints.      |
| **Sprints - Intensive Runs**              | 0.8707               | ⚡ **Strong positive correlation:** Sprints often lead to intensive runs.|
| **Distance - Wins**                       | -0.3774              | ❌ **Moderate negative correlation:** Running more ≠ winning more.       |
| **Sprints - Wins**                        | -0.0220              | 😐 **Negligible correlation:** Sprints barely impact wins.              |
| **Intensive Runs - Wins**                 | -0.3037              | 📉 **Weak negative correlation:** More intensive runs ≠ more wins.      |
| **Distance - Goals**                      | -0.4471              | ⚽ **Moderate negative correlation:** More distance ≠ more goals.        |
| **Sprints - Goals**                       | -0.1196              | 💨 **Slight negative correlation:** Sprints have little impact on goals.|
| **Intensive Runs - Goals**                | -0.4107              | 🏃‍♂️ **Moderate negative correlation:** Intensive runs ≠ more goals.   |

**Interpretation:**
*The physical performance metrics show mixed results.*

*While there is a moderate correlation (0.6055) between distance covered and sprints, indicating that teams covering more distance tend to sprint more, running or sprinting more does not strongly correlate with winning matches or scoring goals.*

*The negative correlations suggest that simply running more or performing more intensive runs doesn't translate to better performance in terms of goals or victories.*

---

## 🏆 **Key Takeaways: Bundesliga 2023/2024 Season Analysis**  
### **1️⃣ Correlation Analysis**

- 🔥 **Efficiency is King:** Top teams convert shots into goals with fewer attempts, showing clinical finishing.  
- ⚡ **Possession Dominance Matters:** High possession and passing accuracy strongly correlate with league success.  
- 🏃 **Physical Performance ≠ Victories:** Running more doesn’t necessarily win matches; tactical efficiency trumps raw effort.  
- 🧐 **Tactical Flexibility:** Teams like **Eintracht Frankfurt** show that alternative styles like counter-attacks can still yield strong results despite lower possession stats.  

🎯 *Overall, the data suggests that while physical intensity contributes to play style, **possession control** and **efficient goal conversion** remain the most decisive factors in Bundesliga success.*  
