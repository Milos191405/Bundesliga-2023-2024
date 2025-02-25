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
