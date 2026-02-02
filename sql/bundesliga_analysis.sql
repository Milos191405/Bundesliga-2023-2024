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
        CASE 
            WHEN goals = 0 THEN NULL
            ELSE ROUND(CAST(shots AS DECIMAL)/goals, 2)
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
    COALESCE(c.correlation_shots_goals, 0) AS correlation_shots_goals,
    COALESCE(c.correlation_goals_position, 0) AS correlation_goals_position
FROM avg_shots_to_score a
LEFT JOIN corr_values c ON 1 = 1   
ORDER BY a.league_position;

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
        s.team,
        s.distance_covered_km,
        s.sprints,
        s.intensive_runs,
        COALESCE(ha.position, 0) AS league_position,   -- LEFT JOIN vrednost, default 0
        COALESCE(ha.wins_total, 0) AS wins_total,     -- LEFT JOIN vrednost, default 0
        s.goals AS goals_scored
    FROM statistics_23_24 s
    LEFT JOIN home_away_23_24 ha ON s.team = ha.team
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
        CASE 
            WHEN s.goals = 0 THEN NULL
            ELSE ROUND(CAST(s.shots AS DECIMAL)/s.goals, 2)
        END AS avg_shots_to_score
    FROM statistics_23_24 s
    LEFT JOIN home_away_23_24 ha 
        ON s.team = ha.team
)
SELECT
    league_position,
    team,
    goals,
    ROUND(AVG(goals) OVER (), 2) AS league_avg_goals,
    ROUND((goals - AVG(goals) OVER()) / NULLIF(STDDEV(goals) OVER(), 0), 2) AS z_score_goals,
    avg_shots_to_score
FROM avg_shots
ORDER BY avg_shots_to_score ASC NULLS LAST; 

-- 8 Possession & Passes Efficiency vs Goals
WITH corr_stats AS (
    SELECT
        CORR(possession_percent, successful_passes_percent) AS correlation_passes_possession,
        CORR(possession_percent, goals) AS correlation_possession_goals
    FROM statistics_23_24
)
SELECT
    ha.position AS league_position,
    s.team,
    s.possession_percent,
    s.successful_passes_percent,
    s.goals AS goals_scored,
    ROUND(COALESCE(s.successful_passes_percent, 0) / NULLIF(s.possession_percent, 0), 3) AS passes_per_possession,
    ROUND(COALESCE(s.goals, 0) / NULLIF(s.possession_percent, 0), 3) AS goals_per_possession,
    COALESCE(c.correlation_passes_possession, 0) AS correlation_passes_possession,
    COALESCE(c.correlation_possession_goals, 0) AS correlation_possession_goals
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha 
    ON s.team = ha.team
CROSS JOIN corr_stats c
ORDER BY ha.position ASC;



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
    (
        COALESCE(s.duels_won, 0) 
        + COALESCE(s.aerial_duels_won, 0) 
        - COALESCE(s.fouls_committed, 0)
    ) AS defensive_index,
    (
        COALESCE(s.goals, 0) 
        + COALESCE(s.shots, 0) 
        + COALESCE(s.crosses_from_open_play, 0)
    ) AS attacking_index,
    (
        COALESCE(s.distance_covered_km, 0) 
        + COALESCE(s.sprints, 0) 
        + COALESCE(s.intensive_runs, 0)
    ) AS workrate_index
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha 
    ON s.team = ha.team
ORDER BY ha.position ASC;



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
ORDER BY league_position ASC;


-- 13 League-Wide Team-Level Analysis: Bayer Leverkusen vs Rest of League 


WITH rest_stats AS (
    SELECT
        ROUND(AVG(COALESCE(distance_covered_km,0)),2) AS avg_distance,
        ROUND(STDDEV(COALESCE(distance_covered_km,0)),2) AS std_distance,
        ROUND(AVG(COALESCE(sprints,0)),2) AS avg_sprints,
        ROUND(STDDEV(COALESCE(sprints,0)),2) AS std_sprints,
        ROUND(AVG(COALESCE(intensive_runs,0)),2) AS avg_intensive,
        ROUND(STDDEV(COALESCE(intensive_runs,0)),2) AS std_intensive,
        ROUND(AVG(COALESCE(goals,0)),2) AS avg_goals,
        ROUND(STDDEV(COALESCE(goals,0)),2) AS std_goals,
        ROUND(AVG(COALESCE(possession_percent,0)),2) AS avg_possession,
        ROUND(STDDEV(COALESCE(possession_percent,0)),2) AS std_possession,
        ROUND(AVG(COALESCE(successful_passes_percent,0)),2) AS avg_passes,
        ROUND(STDDEV(COALESCE(successful_passes_percent,0)),2) AS std_passes
    FROM statistics_23_24
    WHERE team <> 'Bayer 04 Leverkusen'
),
leverkusen AS (
    SELECT s.*, ha.*
    FROM statistics_23_24 s
    LEFT JOIN home_away_23_24 ha ON s.team = ha.team
    WHERE s.team = 'Bayer 04 Leverkusen'
)

SELECT 'distance_covered_km' AS metric,
       ROUND(COALESCE(l.distance_covered_km,0),2) AS leverkusen_value,
       r.avg_distance AS league_avg,
       ROUND((COALESCE(l.distance_covered_km,0) - r.avg_distance) / NULLIF(r.std_distance,0),2) AS z_score
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1

UNION ALL

SELECT 'sprints',
       ROUND(COALESCE(l.sprints,0),2),
       r.avg_sprints,
       ROUND((COALESCE(l.sprints,0) - r.avg_sprints) / NULLIF(r.std_sprints,0),2)
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1

UNION ALL

SELECT 'intensive_runs',
       ROUND(COALESCE(l.intensive_runs,0),2),
       r.avg_intensive,
       ROUND((COALESCE(l.intensive_runs,0) - r.avg_intensive) / NULLIF(r.std_intensive,0),2)
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1

UNION ALL

SELECT 'goals',
       ROUND(COALESCE(l.goals,0),2),
       r.avg_goals,
       ROUND((COALESCE(l.goals,0) - r.avg_goals) / NULLIF(r.std_goals,0),2)
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1

UNION ALL

SELECT 'possession_percent',
       ROUND(COALESCE(l.possession_percent,0),2),
       r.avg_possession,
       ROUND((COALESCE(l.possession_percent,0) - r.avg_possession) / NULLIF(r.std_possession,0),2)
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1

UNION ALL

SELECT 'successful_passes_percent',
       ROUND(COALESCE(l.successful_passes_percent,0),2),
       r.avg_passes,
       ROUND((COALESCE(l.successful_passes_percent,0) - r.avg_passes) / NULLIF(r.std_passes,0),2)
FROM leverkusen l
LEFT JOIN rest_stats r ON 1=1;








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
    WHERE team <> 'Bayer 04 Leverkusen'
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

-- 15 League-Wide Correlations: All Key Metrics
SELECT 
    'Goals vs Shots' AS metric,
    ROUND(CORR(goals, shots)::numeric, 2) AS correlation
FROM statistics_23_24

UNION ALL

SELECT 
    'League Position vs Goals',
    ROUND(CORR(COALESCE(ha.position,0), s.goals)::numeric, 2)
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Possession vs Successful Passes',
    ROUND(CORR(possession_percent, successful_passes_percent)::numeric, 2)
FROM statistics_23_24

UNION ALL

SELECT 
    'Possession vs Goals',
    ROUND(CORR(possession_percent, goals)::numeric, 2)
FROM statistics_23_24

UNION ALL

SELECT 
    'Distance Covered vs Wins',
    ROUND(CORR(distance_covered_km, COALESCE(ha.wins_total,0))::numeric, 2)
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Sprints vs Wins',
    ROUND(CORR(sprints, COALESCE(ha.wins_total,0))::numeric, 2)
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Intensive Runs vs Wins',
    ROUND(CORR(intensive_runs, COALESCE(ha.wins_total,0))::numeric, 2)
FROM statistics_23_24 s
LEFT JOIN home_away_23_24 ha ON s.team = ha.team

UNION ALL

SELECT 
    'Distance Covered vs Goals',
    ROUND(CORR(distance_covered_km, goals)::numeric, 2)
FROM statistics_23_24;



-- 16.League-wide Correlations Summary
SELECT
    CORR(goals, shots) AS corr_goals_shots,
    CORR(possession_percent, successful_passes_percent) AS corr_possession_passes,
    CORR(distance_covered_km, wins_total) AS corr_distance_wins,
    CORR(sprints, wins_total) AS corr_sprints_wins,
    CORR(distance_covered_km, goals) AS corr_distance_goals
FROM statistics_23_24 s
JOIN home_away_23_24 ha ON s.team = ha.team;



-- 17 League-Wide Correlations + Leverkusen vs League Average

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




-- 17 League-Wide Correlations + Leverkusen vs League Average
WITH league_corr AS (
    SELECT
        CORR(goals, shots) AS goals_shots,
        CORR(possession_percent, successful_passes_percent) AS possession_passes,
        CORR(distance_covered_km, wins_total) AS distance_wins,
        CORR(sprints, wins_total) AS sprints_wins,
        CORR(distance_covered_km, goals) AS distance_goals
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
    WHERE team <> 'Bayer 04 Leverkusen'
),
leverkusen AS (
    SELECT *
    FROM statistics_23_24
    WHERE team = 'Bayer 04 Leverkusen'
)

SELECT type, league_value, leverkusen_value
FROM (
    -- 1. Goals vs Shots
    SELECT 
        'goals_shots' AS type,
        ROUND(c.goals_shots::numeric, 2) AS league_value,
        ROUND((l.goals - r.avg_goals) / r.std_goals, 2) AS leverkusen_value
    FROM league_corr c
    CROSS JOIN rest_stats r
    CROSS JOIN leverkusen l

    UNION ALL

    -- 2. Possession vs Successful Passes
    SELECT
        'possession_passes',
        ROUND(c.possession_passes::numeric, 2),
        ROUND((l.successful_passes_percent - r.avg_passes) / r.std_passes, 2)
    FROM league_corr c
    CROSS JOIN rest_stats r
    CROSS JOIN leverkusen l

    UNION ALL

    -- 3. Distance Covered vs Wins
    SELECT
        'distance_wins',
        ROUND(c.distance_wins::numeric, 2),
        ROUND((l.distance_covered_km - r.avg_distance) / r.std_distance, 2)
    FROM league_corr c
    CROSS JOIN rest_stats r
    CROSS JOIN leverkusen l

    UNION ALL

    -- 4. Sprints vs Wins
    SELECT
        'sprints_wins',
        ROUND(c.sprints_wins::numeric, 2),
        ROUND((l.sprints - r.avg_sprints) / r.std_sprints, 2)
    FROM league_corr c
    CROSS JOIN rest_stats r
    CROSS JOIN leverkusen l

    UNION ALL

    -- 5. Distance Covered vs Goals
    SELECT
        'distance_goals',
        ROUND(c.distance_goals::numeric, 2),
        ROUND((l.goals - r.avg_goals) / r.std_goals, 2)
    FROM league_corr c
    CROSS JOIN rest_stats r
    CROSS JOIN leverkusen l
) t
ORDER BY type;
