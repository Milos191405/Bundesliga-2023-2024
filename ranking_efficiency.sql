-- Bundesliga 2023/2024 Analysis
-- Complete SQL queries ready for visualization


-- 1 Show all data
SELECT *
FROM statistics_23_24
ORDER BY position ASC;

-- 2 Goal Efficiency: Shots vs Goals & correlation
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
    FROM statistics_23_24
)
SELECT 
    position,
    team,
    goals,
    shots,
    avg_shots_to_score,
    (SELECT CORR(goals, shots) FROM statistics_23_24) AS correlation_shots_goals,
    (SELECT CORR(position, goals) FROM statistics_23_24) AS goals_position_correlation
FROM avg_shots_to_score
ORDER BY position;


-- 3 Possession vs Successful Passes & Goals correlation
SELECT
    position,   
    team,
    possession_percent,
    successful_passes_percent,
    goals,
    (SELECT CORR(possession_percent, successful_passes_percent) FROM statistics_23_24) AS correlation_possession_passes,
    (SELECT CORR(possession_percent, position) FROM statistics_23_24) AS possession_position_correlation,
    (SELECT CORR(successful_passes_percent, position) FROM statistics_23_24) AS successful_passes_position_correlation,
    (SELECT CORR(possession_percent, goals) FROM statistics_23_24) AS possession_goals_correlation
FROM statistics_23_24
ORDER BY position ASC;


-- 4 Distance Covered, Sprints & Intensive Runs
SELECT
    position,
    team,
    distance_covered_km,
    sprints,
    intensive_runs
FROM statistics_23_24
ORDER BY sprints DESC;


-- 5 Combined Correlation Analysis (Work Rate & Wins/Goals)
WITH combined_stats AS (
    SELECT 
        ha.position AS league_position,
        s.team,
        s.distance_covered_km,
        s.sprints,
        s.intensive_runs,
        ha.wins_total,
        ha.goals AS goals_scored
    FROM statistics_23_24 s
    JOIN home_away_23_24 ha
        ON s.team = ha.team
)
SELECT
    *,
    (SELECT CORR(distance_covered_km, sprints) FROM combined_stats) AS distance_sprints_corr,
    (SELECT CORR(sprints, intensive_runs) FROM combined_stats) AS sprints_intensive_corr,
    (SELECT CORR(distance_covered_km, wins_total) FROM combined_stats) AS distance_wins_corr,
    (SELECT CORR(sprints, wins_total) FROM combined_stats) AS sprints_wins_corr,
    (SELECT CORR(intensive_runs, wins_total) FROM combined_stats) AS intensive_runs_wins_corr,
    (SELECT CORR(distance_covered_km, goals_scored) FROM combined_stats) AS distance_goals_corr,
    (SELECT CORR(sprints, goals_scored) FROM combined_stats) AS sprints_goals_corr,
    (SELECT CORR(intensive_runs, goals_scored) FROM combined_stats) AS intensive_runs_goals_corr
FROM combined_stats
ORDER BY league_position ASC;


-- 6 Top Teams by Goal Efficiency (Average Shots per Goal)
WITH avg_shots_to_score_league AS (
    SELECT
        ha.position AS league_position,
        s.team,
        s.goals,
        s.shots,
        CASE
            WHEN s.goals = 0 THEN NULL
            ELSE ROUND(CAST(s.shots AS DECIMAL)/s.goals,2)
        END AS avg_shots_to_score
    FROM statistics_23_24 s
    JOIN home_away_23_24 ha
        ON s.team = ha.team
)
SELECT
    league_position,
    team,
    goals,
    ROUND(AVG(goals) OVER (), 2) AS league_avg_goals,
    ROUND((goals - AVG(goals) OVER ()) / STDDEV(goals) OVER(), 2) AS z_score_goals,
    avg_shots_to_score
FROM avg_shots_to_score_league
ORDER BY league_position ASC;

-- 7 Possession and Passes Efficiency with Goals
SELECT
    ha.position AS league_position,
    s.team,
    s.possession_percent,
    s.successful_passes_percent,
    ha.goals AS goals_scored,
    ROUND(s.successful_passes_percent / s.possession_percent, 3) AS passes_per_possession,
    ROUND(ha.goals::DECIMAL / s.possession_percent, 3) AS goals_per_possession,
    (SELECT CORR(possession_percent, successful_passes_percent) FROM statistics_23_24) AS correlation_passes_possession,
    (SELECT CORR(possession_percent, ha.goals) FROM statistics_23_24 s JOIN home_away_23_24 ha USING(team)) AS correlation_possession_goals
FROM statistics_23_24 s
JOIN home_away_23_24 ha
    ON s.team = ha.team
ORDER BY league_position ASC;


-- 8 Home vs Away Analysis
SELECT
    position,
    team,
    points_home,
    points_away,
    points_home - points_away AS diff_points,
    goals_scored_home,
    goals_scored_away,
    goals_scored_home - goals_scored_away AS diff_goals
FROM home_away_23_24
ORDER BY position ASC;


-- 9 Discipline / Aggression Analysis
SELECT
    position,
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


-- 10 Team Strength Profiling (Defense, Attack, Work Rate)
SELECT
    ha.position AS league_position,
    s.team,
    (s.duels_won + s.aerial_duels_won - s.fouls_committed) AS defensive_index,
    (ha.goals + s.shots + s.crosses_from_open_play) AS attacking_index,
    (s.distance_covered_km + s.sprints + s.intensive_runs) AS workrate_index
FROM statistics_23_24 s
JOIN home_away_23_24 ha
    ON s.team = ha.team
ORDER BY league_position ASC;

