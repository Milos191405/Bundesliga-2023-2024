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
    sprints DESC

SELECT
    (SELECT CORR(distance_covered_km, possession_percent) 
     FROM bundesliga_statistics) AS distance_position_correlation,
    (SELECT CORR(sprints, position) 
     FROM bundesliga_statistics) AS sprints_position_correlation,
    (SELECT CORR(intensive_runs, position) 
     FROM bundesliga_statistics) AS intensive_runs_position_correlation,
    (SELECT CORR(distance_covered_km, goals) 
     FROM bundesliga_statistics) AS distance_goals_correlation,
    (SELECT CORR(sprints, goals)
     FROM bundesliga_statistics) AS sprints_goals_correlation,
    (SELECT CORR(intensive_runs, goals)
     FROM bundesliga_statistics) AS intensive_runs_goals_correlation,
    (SELECT CORR(distance_covered_km, wins)
     FROM bundesliga_statistics) AS distance_wins_correlation,
    (SELECT CORR(sprints, goals * 1.0 / shots) 
     FROM bundesliga_statistics) AS sprint_goal_efficiency_correlation

FROM
    bundesliga_statistics
ORDER BY    
    position ASC;

-- Running Position Corelation

SELECT *
FROM home_away_23_24
ORDER BY position ASC

SELECT 
    column_name,
    ordinal_position
FROM 
    information_schema.columns
WHERE 
    table_name = 'home_away_23_24'
ORDER by
    ordinal_position

ALTER TABLE home_away_23_24
ADD COLUMN wins_total INTEGER,
ADD COLUMN draws_total INTEGER,
ADD COLUMN lost_total INTEGER,
ADD COLUMN goals_scored INTEGER,
ADD COLUMN goals_received INTEGER,
ADD COLUMN goals_difference INTEGER;

CREATE TABLE home_away_23_24_reordered AS
SELECT
    position,
    team,
    matches,
    wins_total,
    draws_total,
    lost_total,
    goals_scored,
    goals_received,
    goals_difference,
    wins_home,
    draws_home,
    losses_home,
    goals_scored_home,
    goals_received_home,
    goal_difference_home,
    wins_away,
    draws_away,
    losses_away,
    goals_scored_away,
    goals_received_away,
    goal_difference_away,
    total_goals_scored,
    total_goals_received,
    total_goal_difference,
    points_home,
    points_away,
    total_points
FROM
    home_away_23_24;

DROP TABLE home_away_23_24;

ALTER TABLE home_away_23_24_reordered
RENAME TO home_away_23_24;

UPDATE home_away_23_24
SET
    wins_total = wins_home + wins_away,
    draws_total = draws_home + draws_away,
    lost_total = losses_home + losses_away,
    goals_scored = goals_scored_home + goals_scored_away,
    goals_received = goals_received_home + goals_received_away,
    goals_difference = goals_scored - goals_received;


SELECT 
    team,
    goals_scored,
    goals_received
FROM 
    home_away_23_24
WHERE 
    goals_scored IS NULL OR goals_received IS NULL;

UPDATE home_away_23_24
SET
    goals_difference = COALESCE(goals_scored, 0) - COALESCE(goals_received, 0);
