# Bundesliga 2023/2024 SQL Analysis

This document contains the complete SQL analysis of the Bundesliga 2023/2024 season.  

All SQL screenshots are stored in `img_sql/` folder and python visualization are stored in  `graphs_python/`

---

## 1️⃣ Show All Home/Away Data
This query displays all teams' home and away performance metrics including points, wins, draws, losses, goals scored, and goal difference.

![1_show_all_home_away](img_sql/1_Home_Away.png)

---

## 2️⃣ Show All Statistics Data
This query displays all team statistics including goals, shots, possession, passing accuracy, duels, and distance metrics.

![2_show_all_statistics](img_sql/2_All_Statistics_Data.png)

*Analysis:*  


---

## 3️⃣ Goal Efficiency: Shots vs Goals & Correlation
Calculates average shots per goal for each team and shows correlation between goals, shots, and league position.

![3_goal_efficiency](img_sql/3_Goal_Efficiency-Shots_vs_Goals_&_Correlation.png)

*Analysis:*  


---

## 4️⃣ Possession vs Successful Passes & Goals Correlation
Analyzes the relationship between possession, passing accuracy, goals scored, and league position.

![4_possession_passes](img_sql/4_Possession_vs_Successful_Passes_&_Goals_Correlation.png)

*Analysis:*  


---

## 5️⃣ Distance Covered, Sprints & Intensive Runs
Shows physical performance metrics: total distance, sprints, and intensive runs per team.


<p float="left">
  <img src="img_sql/5_Distance_Covered,_Sprints_&_Intensive_Runs.png" width="48%" />
  <img src="graphs_python/Correlation_Physical_Metrics_vs_League_Position.png" width="48%" />
</p>


*Analysis:*  


---

## 6️⃣ Work Rate & Wins/Goals Correlation
Correlation analysis between work rate metrics (distance, sprints, intensive runs) and wins/goals.

![6_workrate_corr](img_sql/6_Work_Rate_&_Wins-Goals_Correlation.png)

*Analysis:*  


---

## 7️⃣ Top Teams by Goal Efficiency (Shots per Goal & Z-Score)
Highlights top performers in terms of shots per goal and computes Z-score for goals.

![7_top_goal_efficiency](img_sql/7_Top_Teams_by_Goal_Efficiency_(Shots_per_Goal_&_Z-Score).png)

*Analysis:*  


---

## 8️⃣ Possession & Passes Efficiency vs Goals
Calculates passes per possession and goals per possession along with correlations.

![8_possession_goals](img_sql/8_Possession_&_Passes_Efficiency_vs_Goals.png)

*Analysis:*  


---

## 9️⃣ Home vs Away Analysis
Compares home vs away points and goal differences for each team.

![9_home_away_analysis](img_sql/9_Home_vs_Away_Analysis.png)

*Analysis:*  


---

## 1️⃣0️⃣ Discipline / Aggression Analysis
Shows cards, fouls, duels won, and calculates Z-scores for yellow cards and duels.

![10_discipline](img_sql/10_Discipline_-_Aggression_Analysis.png)

*Analysis:*  


---

## 1️⃣1️⃣ Team Strength Profiling: Defense, Attack, Work Rate
Combines defensive, attacking, and work rate metrics into indexes for each team.

![11_team_strength](img_sql/11_Team_Strength_Profiling-Defense,_Attack,_Work_Rate.png)

*Analysis:*  


---

## 1️⃣2️⃣ Home vs Away Games Consistency
Examines wins, draws, and goal difference home vs away for consistency analysis.

![12_home_away_consistency](img_sql/12_Home_vs_Away_Games_Consistency.png)

*Analysis:*  


---

### Notes
- All screenshots are in `img_sql/` folder.  
- All Python graphs are in `graphs_python` folder.
 
---

