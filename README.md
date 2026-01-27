# Bundesliga 2023/2024 Season Analysis

## Project Overview
This project analyzes team statistics from the Bundesliga 2023/2024 season to identify trends, correlations, and performance patterns. The main goal is to understand which factors contribute to league standings and highlight differences between higher-ranked and lower-ranked teams. Special attention is given to exploring why Bayer Leverkusen performed so convincingly during the season.

## Objectives
- Collect and structure Bundesliga 2023/2024 team statistics.
- Create new analytical tables to support advanced analysis.
- Perform correlation analysis to identify relationships between key metrics.
- Cluster teams based on playing style, work rate, and defensive/attacking tendencies.
- Evaluate efficiency in goal scoring, passing, and sprinting.
- Identify standout teams and statistical outliers.
- Perform home vs away performance analysis to explore differences in results.
- Plan future predictive analysis when additional data becomes available.
- Develop Power BI dashboards to visualize insights.

## Data Sources
- Official Bundesliga statistics [Bundesliga Stats 2023/24](https://www.bundesliga.com/en/bundesliga/stats/overview/2023-2024).

- Data collected manually and structured into new tables for analysis.

## Data Files
The structured tables and datasets used for this analysis are available on [Google Drive](https://drive.google.com/drive/folders/1OpOBN63IkiADnRSjakmCm7Vw45wNWlDc?usp=drive_link).  
These include all combined tables, derived metrics, and calculated statistics used in SQL analyses and visualizations.

## Planned Analysis
### Correlation Analysis
Explore relationships between key performance metrics and league standings:
- Shots vs. Goals: Does a higher number of shots lead to more goals? Rank teams by goal efficiency (goals per shot).
- Possession vs. Successful Passes: Does higher possession result in more successful passes and goals? Calculate efficiency metrics (passes per possession, goals per possession).
- Distance Covered & Sprints: Investigate whether teams with higher work rate perform better in terms of wins and goals.

### Performance Clustering
Group teams using clustering methods based on:
- Playing Style: Possession-based vs counter-attacking teams.
- Work Rate: Distance covered, sprints, intensive runs.
- Defensive vs Attacking Tendencies: Duels won, aerial duels, fouls committed.

### Team Strength Profiling
Categorize teams based on core strengths:
- Defensive Strength: Fouls, duels won, aerial duels, yellow/red cards.
- Attacking Strength: Shots, goals, crosses.
- Work Rate: Distance covered, sprints, intensive runs.

### Outlier Detection & Insights
Identify teams that deviate significantly from league norms, for example:
- Teams with high aggression (yellow cards, duels won) versus league averages.
- Teams outperforming or underperforming relative to expected goal efficiency.

### Home vs Away Performance
Analyze differences in points, wins, and goals scored at home versus away to determine key factors influencing league position.

### Predictive Analysis
When more historical data is available:
- Predict future team performance based on key metrics.
- Analyze consistency in results for high work rate teams.

## Next Steps
1. Data Collection: Gather additional seasonal or historical data.
2. Statistical Analysis & Clustering: Perform correlation, efficiency analysis, and cluster teams.
3. Visualization: Develop dashboards and interactive charts in Power BI.
4. Predictive Modeling: Build and validate models to forecast future performance.

## Tools & Technologies
- SQL for data storage, querying, and analysis.
- Python (Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn) for advanced analysis.
- Jupyter Notebook for data exploration and visualization.
- Power BI for interactive dashboards.
- Machine Learning (K-Means, Hierarchical Clustering) for team grouping and predictive analysis.

## Visualization Ideas
- Heatmaps for correlation matrices.
- Scatter plots for relationships between key metrics.
- Radar charts for team strength profiles.
- Line charts for trend analysis and predictive insights.

## Contact
For questions or collaboration, please reach out via [milos.mirkovic7@gmail.com](mailto:milos.mirkovic7@gmail.com).
