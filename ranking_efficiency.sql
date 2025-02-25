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

--separate table for distance,sprints and intensive runs
SELECT
    position,
    team,
    distance_covered_km,
    sprints,
    intensive_runs
FROM
    bundesliga_statistics
ORDER BY    
    sprints DESC;

-- check if team names are same in both tables

SELECT 
    bs.position AS bundesliga_position,
    bs.team AS bundesliga_team,
    ha.position AS home_away_position,
    ha.team AS home_away_team
FROM 
    bundesliga_statistics bs
LEFT JOIN 
    home_away_23_24 ha
ON 
    bs.team = ha.team
WHERE 
    ha.team IS NULL OR bs.position <> ha.position;

--Cte for correlation calculations

WITH combined_stats AS (
    SELECT 
        bs.position,
        bs.team,
        bs.distance_covered_km,
        bs.sprints,
        bs.intensive_runs,
        ha.wins_total,
        bs.goals
    FROM 
        bundesliga_statistics bs
    LEFT JOIN 
        home_away_23_24 ha
    ON 
        bs.team = ha.team
)
SELECT
    cs.*,
    -- Correlation calculations (full coverage)
    (SELECT CORR(distance_covered_km, sprints) FROM combined_stats) AS distance_sprints_correlation,
    (SELECT CORR(sprints, intensive_runs) FROM combined_stats) AS sprints_intensive_runs_correlation,
    (SELECT CORR(distance_covered_km, wins_total) FROM combined_stats) AS distance_wins_correlation,
    (SELECT CORR(sprints, wins_total) FROM combined_stats) AS sprints_wins_correlation,
    (SELECT CORR(intensive_runs, wins_total) FROM combined_stats) AS intensive_runs_wins_correlation,
    (SELECT CORR(distance_covered_km, goals) FROM combined_stats) AS distance_goals_correlation,
    (SELECT CORR(sprints, goals) FROM combined_stats) AS sprints_goals_correlation,
    (SELECT CORR(intensive_runs, goals) FROM combined_stats) AS intensive_runs_goals_correlation
FROM
    combined_stats AS cs
ORDER BY    
    cs.position ASC;


-- Running Position Corelation


