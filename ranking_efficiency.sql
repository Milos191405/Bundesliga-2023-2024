SELECT *
FROM bundesliga_statistics
ORDER BY position ASC

-- -  Goal Efficiency: Shots on Goal, Goals and correlation between them

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


--**Does higher possession lead to more successful passes?** (Correlation between "Possession (%)" and "Successful passes from open play (%)")

SELECT
    position,   
    team,
    possession_percent,
    goals,
    shots,
    successful_passes_percent,
    (SELECT CORR(possession_percent, successful_passes_percent) 
     FROM bundesliga_statistics) AS correlation_possession_passes,
    (SELECT CORR(possession_percent, position) 
     FROM bundesliga_statistics) AS possession_position_correlation,
    (SELECT CORR(successful_passes_percent, position) 
     FROM bundesliga_statistics) AS successful_passes_position_correlation,
     (SELECT CORR(possession_percent, goals) AS possession_goals_correlation
     FROM bundesliga_statistics) AS possession_goals_correlation
FROM
    bundesliga_statistics
ORDER BY
    position ASC;


-- Distance covered, sprints, and intensive runs corelation with goals and position on the table 

SELECT
    position,
    team,
    distance_covered_km,
    sprints,
    intensive_runs
FROM
    bundesliga_statistics
ORDER BY    
    position ASC

SELECT
    position,
    team,
    distance_covered_km,
    sprints,
    intensive_runs,
    (SELECT CORR(distance_covered_km, possession_percent) 
     FROM bundesliga_statistics) AS distance_position_correlation,
    (SELECT CORR(sprints, position) 
     FROM bundesliga_statistics) AS sprints_position_correlation,
    (SELECT CORR(intensive_runs, position) 
     FROM bundesliga_statistics) AS intensive_runs_position_correlation,
    (SELECT CORR(distance_covered_km, goals) 
     FROM bundesliga_statistics) AS distance_goals_correlation
FROM
    bundesliga_statistics
ORDER BY    
    position ASC;

-- Running Position Corelation






