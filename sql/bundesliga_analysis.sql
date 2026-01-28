-- Bundesliga 2023/2024 Analysis
-- Complete SQL queries ready for visualization


-- 1 Show All Home/Away Data  
SELECT *
FROM home_away_23_24
ORDER BY position ASC;



-- 2 Show All Statistics Data

SELECT *
FROM statistics_23_24
ORDER BY position ASC;

-- 3 Goal Efficiency: Shots vs Goals & Correlation
WITH avg_shots_to_score AS (
    SELECT
        position AS league_position,
        team,
        goals,
        shots,
        CASE WHEN goals = 0 THEN NULL
             ELSE ROUND(CAST(shots AS DECIMAL)/goals,2)
        END AS avg_shots_to_score
    FROM statistics_23_24
),
corr_values AS (
    SELECT
        CORR(goals, shots) AS correlation_shots_goals,
        CORR(position, goals) AS correlation_goals_position
    FROM statistics_23_24
)
SELECT 
    a.league_position,
    a.team,
    a.goals,
    a.shots,
    a.avg_shots_to_score,
    c.correlation_shots_goals,
    c.correlation_goals_position
FROM avg_shots_to_score a
CROSS JOIN corr_values c
ORDER BY league_position;

-- 4 Possession vs Successful Passes & Goals Correlation
WITH corr_stats AS (
    SELECT
        CORR(possession_percent, successful_passes_percent) AS correlation_passes_possession,
        CORR(possession_percent, position) AS correlation_possession_position,
        CORR(successful_passes_percent, position) AS correlation_passes_position,
        CORR(possession_percent, goals) AS correlation_possession_goals
    FROM statistics_23_24
)
SELECT
    s.position AS league_position,
    s.team,
    s.possession_percent,
    s.successful_passes_percent,
    s.goals,
    c.correlation_passes_possession,
    c.correlation_possession_position,
    c.correlation_passes_position,
    c.correlation_possession_goals
FROM statistics_23_24 s
CROSS JOIN corr_stats c
ORDER BY league_position;

-- 5 Distance Covered, Sprints & Intensive Runs
SELECT
    position AS league_position,
    team,
    distance_covered_km,
    sprints,
    intensive_runs
FROM statistics_23_24
ORDER BY sprints DESC;

-- 6 Work Rate & Wins/Goals Correlation
WITH combined_stats AS (
    SELECT 
        ha.position AS league_position,
        s.team,
        s.distance_covered_km,
        s.sprints,
        s.intensive_runs,
        ha.wins_total,
        s.goals AS goals_scored
    FROM statistics_23_24 s
    JOIN home_away_23_24 ha ON s.team = ha.team
),
correlations AS (
    SELECT
        CORR(distance_covered_km, sprints)      AS distance_sprints_corr,
        CORR(sprints, intensive_runs)           AS sprints_intensive_corr,
        CORR(distance_covered_km, wins_total)   AS distance_wins_corr,
        CORR(sprints, wins_total)               AS sprints_wins_corr,
        CORR(intensive_runs, wins_total)        AS intensive_runs_wins_corr,
        CORR(distance_covered_km, goals_scored) AS distance_goals_corr,
        CORR(sprints, goals_scored)             AS sprints_goals_corr,
        CORR(intensive_runs, goals_scored)      AS intensive_runs_goals_corr
    FROM combined_stats
)
SELECT
    cs.league_position,
    cs.team,
    cs.distance_covered_km,
    cs.sprints,
    cs.intensive_runs,
    cs.wins_total,
    cs.goals_scored,
    c.*
FROM combined_stats cs
CROSS JOIN correlations c
ORDER BY cs.league_position ASC;

-- 7 Top Teams by Goal Efficiency (Shots per Goal & Z-Score)
WITH avg_shots AS (
    SELECT
        ha.position AS league_position,
        s.team,
        s.goals,
        s.shots,
        CASE WHEN s.goals = 0 THEN NULL
             ELSE ROUND(CAST(s.shots AS DECIMAL)/s.goals,2)
        END AS avg_shots_to_score
    FROM statistics_23_24 s
    JOIN home_away_23_24 ha ON s.team = ha.team
)
SELECT
    league_position,
    team,
    goals,
    ROUND(AVG(goals) OVER (),2) AS league_avg_goals,
    ROUND((goals - AVG(goals) OVER()) / STDDEV(goals) OVER(),2) AS z_score_goals,
    avg_shots_to_score
FROM avg_shots
ORDER BY league_position ASC;

-- 8 Possession & Passes Efficiency vs Goals
SELECT
    ha.position AS league_position,
    s.team,
    s.possession_percent,
    s.successful_passes_percent,
    s.goals AS goals_scored,
    ROUND(s.successful_passes_percent / s.possession_percent, 3) AS passes_per_possession,
    ROUND(s.goals::DECIMAL / s.possession_percent, 3) AS goals_per_possession,  
    -- Correlation: possession vs successful passes
    (SELECT CORR(possession_percent, successful_passes_percent) 
     FROM statistics_23_24) AS correlation_passes_possession,
    -- Correlation: possession vs goals
    (SELECT CORR(stat.possession_percent, stat.goals)
     FROM statistics_23_24 stat
    ) AS correlation_possession_goals
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team
ORDER BY league_position ASC;



-- 9 Home vs Away Analysis
SELECT
    position AS league_position,
    team,
    points_home,
    points_away,
    points_home - points_away AS diff_points,
    goals_scored_home,
    goals_scored_away,
    goals_scored_home - goals_scored_away AS diff_goals
FROM home_away_23_24
ORDER BY league_position ASC;

-- 10 Discipline / Aggression Analysis
SELECT
    position AS league_position,
    team,
    yellow_cards,
    red_cards,
    fouls_committed,
    duels_won,
    aerial_duels_won,
    (yellow_cards + red_cards) AS total_cards,
    ROUND((yellow_cards - AVG(yellow_cards) OVER()) / STDDEV(yellow_cards) OVER(),2) AS z_yellow_cards,
    ROUND((duels_won - AVG(duels_won) OVER()) / STDDEV(duels_won) OVER(),2) AS z_duels_won
FROM statistics_23_24
ORDER BY total_cards DESC;

-- 11 Team Strength Profiling: Defense, Attack, Work Rate
SELECT
    ha.position AS league_position,
    s.team,
    (s.duels_won + s.aerial_duels_won - s.fouls_committed) AS defensive_index,
    (s.goals + s.shots + s.crosses_from_open_play) AS attacking_index,  -- ha.goals → s.goals
    (s.distance_covered_km + s.sprints + s.intensive_runs) AS workrate_index
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team
ORDER BY league_position ASC;


-- 12 Home vs Away Games Consistency
SELECT 
    position AS league_position,
    team,
    wins_home,
    wins_away,
    draws_home,
    draws_away,
    goal_difference_home,
    goal_difference_away
FROM home_away_23_24
ORDER BY league_position DESC;