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

-- 13 League-Wide Team-Level Analysis: Bayer Leverkusen vs Rest of League


WITH rest_stats AS (
    SELECT
        AVG(distance_covered_km) AS avg_distance,
        STDDEV(distance_covered_km) AS std_distance,
        AVG(sprints) AS avg_sprints,
        STDDEV(sprints) AS std_sprints,
        AVG(intensive_runs) AS avg_intensive,
        STDDEV(intensive_runs) AS std_intensive,
        AVG(goals) AS avg_goals,
        STDDEV(goals) AS std_goals,
        AVG(possession_percent) AS avg_possession,
        STDDEV(possession_percent) AS std_possession,
        AVG(successful_passes_percent) AS avg_passes,
        STDDEV(successful_passes_percent) AS std_passes
    FROM statistics_23_24
    WHERE team != 'Bayer 04 Leverkusen'
),
leverkusen AS (
    SELECT *
    FROM statistics_23_24
    WHERE team = 'Bayer 04 Leverkusen'
)

SELECT 'distance_covered_km' AS metric,
       l.distance_covered_km AS leverkusen_value,
       ROUND(r.avg_distance,2) AS league_avg,
       ROUND((l.distance_covered_km - r.avg_distance) / r.std_distance,2) AS z_score
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL

SELECT 'sprints',
       l.sprints,
       ROUND(r.avg_sprints,2),
       ROUND((l.sprints - r.avg_sprints) / r.std_sprints,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL

SELECT 'intensive_runs',
       l.intensive_runs,
       ROUND(r.avg_intensive,2),
       ROUND((l.intensive_runs - r.avg_intensive) / r.std_intensive,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL

SELECT 'goals',
       l.goals,
       ROUND(r.avg_goals,2),
       ROUND((l.goals - r.avg_goals) / r.std_goals,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL

SELECT 'possession_percent',
       l.possession_percent,
       ROUND(r.avg_possession,2),
       ROUND((l.possession_percent - r.avg_possession) / r.std_possession,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL

SELECT 'successful_passes_percent',
       l.successful_passes_percent,
       ROUND(r.avg_passes,2),
       ROUND((l.successful_passes_percent - r.avg_passes) / r.std_passes,2)
FROM leverkusen l CROSS JOIN rest_stats r;



-- 14 League-Wide Team-Level Analysis (Home/Away Metrics): Bayer Leverkusen vs Rest of League

WITH rest_stats AS (
    SELECT
        AVG(total_points) AS avg_points,
        STDDEV(total_points) AS std_points,
        AVG(wins_total) AS avg_wins,
        STDDEV(wins_total) AS std_wins,
        AVG(lost_total) AS avg_lost,
        STDDEV(lost_total) AS std_lost,
        AVG(goals_scored_home) AS avg_goals_home,
        STDDEV(goals_scored_home) AS std_goals_home,
        AVG(goals_scored_away) AS avg_goals_away,
        STDDEV(goals_scored_away) AS std_goals_away,
        AVG(goals_received_home) AS avg_goals_received_home,
        STDDEV(goals_received_home) AS std_goals_received_home,
        AVG(goals_received_away) AS avg_goals_received_away,
        STDDEV(goals_received_away) AS std_goals_received_away
    FROM home_away_23_24
    WHERE team != 'Bayer 04 Leverkusen'
),
leverkusen AS (
    SELECT *
    FROM home_away_23_24
    WHERE team = 'Bayer 04 Leverkusen'
)

SELECT 'total_points' AS metric,
       l.total_points AS leverkusen_value,
       ROUND(r.avg_points,2) AS league_avg,
       ROUND((l.total_points - r.avg_points)/r.std_points,2) AS z_score
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'wins_total',
       l.wins_total,
       ROUND(r.avg_wins,2),
       ROUND((l.wins_total - r.avg_wins)/r.std_wins,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'lost_total',
       l.lost_total,
       ROUND(r.avg_lost,2),
       ROUND((l.lost_total - r.avg_lost)/r.std_lost,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'goals_scored_home',
       l.goals_scored_home,
       ROUND(r.avg_goals_home,2),
       ROUND((l.goals_scored_home - r.avg_goals_home)/r.std_goals_home,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'goals_scored_away',
       l.goals_scored_away,
       ROUND(r.avg_goals_away,2),
       ROUND((l.goals_scored_away - r.avg_goals_away)/r.std_goals_away,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'goals_received_home',
       l.goals_received_home,
       ROUND(r.avg_goals_received_home,2),
       ROUND((l.goals_received_home - r.avg_goals_received_home)/r.std_goals_received_home,2)
FROM leverkusen l CROSS JOIN rest_stats r

UNION ALL
SELECT 'goals_received_away',
       l.goals_received_away,
       ROUND(r.avg_goals_received_away,2),
       ROUND((l.goals_received_away - r.avg_goals_received_away)/r.std_goals_received_away,2)
FROM leverkusen l CROSS JOIN rest_stats r;

-- League-Wide Correlations: All Key Metrics
SELECT 
    'Goals vs Shots' AS metric,
    ROUND(CORR(goals, shots), 2) AS correlation
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'League Position vs Goals',
    ROUND(CORR(ha.position, s.goals), 2)
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Possession vs Successful Passes',
    ROUND(CORR(possession_percent, successful_passes_percent), 2)
FROM statistics_23_24

UNION ALL

SELECT 
    'Possession vs Goals',
    ROUND(CORR(possession_percent, goals), 2)
FROM statistics_23_24

UNION ALL

SELECT 
    'Distance Covered vs Wins',
    ROUND(CORR(distance_covered_km, wins_total), 2)
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Sprints vs Wins',
    ROUND(CORR(sprints, wins_total), 2)
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Intensive Runs vs Wins',
    ROUND(CORR(intensive_runs, wins_total), 2)
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Distance Covered vs Goals',
    ROUND(CORR(distance_covered_km, goals), 2)
FROM statistics_23_24;


-- League-wide Correlations Summary
SELECT
    CORR(goals, shots) AS corr_goals_shots,
    CORR(possession_percent, successful_passes_percent) AS corr_possession_passes,
    CORR(distance_covered_km, wins_total) AS corr_distance_wins,
    CORR(sprints, wins_total) AS corr_sprints_wins,
    CORR(distance_covered_km, goals) AS corr_distance_goals
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team;



-- 15 League-Wide Correlations + Leverkusen vs League Average

WITH league_corr AS (
    SELECT
        CORR(goals, shots) AS corr_goals_shots,
        CORR(possession_percent, successful_passes_percent) AS corr_possession_passes,
        CORR(distance_covered_km, wins_total) AS corr_distance_wins,
        CORR(sprints, wins_total) AS corr_sprints_wins,
        CORR(distance_covered_km, goals) AS corr_distance_goals
    FROM statistics_23_24 s
    JOIN home_away_23_24 ha ON s.team = ha.team
),
rest_stats AS (
    SELECT
        AVG(distance_covered_km) AS avg_distance,
        STDDEV(distance_covered_km) AS std_distance,
        AVG(sprints) AS avg_sprints,
        STDDEV(sprints) AS std_sprints,
        AVG(goals) AS avg_goals,
        STDDEV(goals) AS std_goals,
        AVG(possession_percent) AS avg_possession,
        STDDEV(possession_percent) AS std_possession,
        AVG(successful_passes_percent) AS avg_passes,
        STDDEV(successful_passes_percent) AS std_passes
    FROM statistics_23_24
    WHERE team != 'Bayer 04 Leverkusen'
),
leverkusen AS (
    SELECT *
    FROM statistics_23_24
    WHERE team = 'Bayer 04 Leverkusen'
)

SELECT 
    'League-Wide' AS type,
    corr_goals_shots,
    corr_possession_passes,
    corr_distance_wins,
    corr_sprints_wins,
    corr_distance_goals,
    NULL AS leverkusen_distance_z,
    NULL AS leverkusen_sprints_z,
    NULL AS leverkusen_goals_z,
    NULL AS leverkusen_possession_z,
    NULL AS leverkusen_passes_z
FROM league_corr

UNION ALL

SELECT
    'Leverkusen vs League' AS type,
    NULL, NULL, NULL, NULL, NULL,
    ROUND((l.distance_covered_km - r.avg_distance) / r.std_distance, 2) AS leverkusen_distance_z,
    ROUND((l.sprints - r.avg_sprints) / r.std_sprints, 2) AS leverkusen_sprints_z,
    ROUND((l.goals - r.avg_goals) / r.std_goals, 2) AS leverkusen_goals_z,
    ROUND((l.possession_percent - r.avg_possession) / r.std_possession, 2) AS leverkusen_possession_z,
    ROUND((l.successful_passes_percent - r.avg_passes) / r.std_passes, 2) AS leverkusen_passes_z
FROM leverkusen l
CROSS JOIN rest_stats r;




