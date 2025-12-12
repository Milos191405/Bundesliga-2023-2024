SELECT * FROM home_Away_23_24 LIMIT 10;
SELECT * FROM bundesliga_statistics ORDER BY position ASC LIMIT 10;


CREATE TABLE home_Away_23_24 (
    position INT,
    team VARCHAR(100),
    matches INT,
    wins_total INT,
    draws_total INT,
    lost_total INT,
    goals_scored INT,
    goals_received INT,
    goals_difference INT,
    wins_home INT,
    draws_home INT,
    losses_home INT,
    goals_scored_home INT,
    goals_received_home INT,
    goal_difference_home INT,
    wins_away INT,
    draws_away INT,
    losses_away INT,
    goals_scored_away INT,
    goals_received_away INT,
    goal_difference_away INT,
    total_goals_scored INT,
    total_goals_received INT,
    total_goal_difference INT,
    points_home INT,
    points_away INT,
    total_points INT
);

\copy liga_tabela FROM 'C:/Users/milos/Desktop/Projects/Bundesliga 2023-2024/files/home_away_23_24.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS bundesliga_statistics;

CREATE TABLE bundesliga_statistics (
    position INTEGER,
    team TEXT,
    goals INTEGER,
    shots INTEGER,
    shots_against_post_bar INTEGER,
    own_goals INTEGER,
    penalties INTEGER,
    penalties_scored INTEGER,
    successful_passes_percent NUMERIC(5,2),
    possession_percent NUMERIC(5,2),
    duels_won INTEGER,
    aerial_duels_won INTEGER,
    crosses_from_open_play INTEGER,
    yellow_cards INTEGER,
    red_cards INTEGER,
    cards INTEGER,
    fouls_committed INTEGER,
    distance_covered_km NUMERIC(10,1),
    sprints INTEGER,
    intensive_runs INTEGER
);

INSERT INTO bundesliga_statistics (
    position, team, goals, shots, shots_against_post_bar, own_goals, penalties, 
    penalties_scored, successful_passes_percent, possession_percent, duels_won, 
    aerial_duels_won, crosses_from_open_play, yellow_cards, red_cards, cards, 
    fouls_committed, distance_covered_km, sprints, intensive_runs
) VALUES
(12,'VfL Wolfsburg',41,406,8,3,3,2,82.8,47,3149,567,299,82,5,87,393,4000.4,8369,26779),
(6,'Eintracht Frankfurt',51,393,3,0,3,2,83.6,50,3346,566,263,61,5,66,347,4011.2,8128,25611),
(13,'1. FSV Mainz 05',39,471,11,1,5,1,78.5,46,3530,806,318,97,3,100,455,4008.1,8320,25155),
(17,'1. FC Köln',28,430,8,0,6,5,80.8,47,3199,672,455,65,4,69,402,4017.0,7811,24676),
(16,'VfL Bochum 1848',42,509,4,4,4,4,74.2,47,3615,993,311,97,2,99,417,3936.2,8028,24337),
(7,'TSG Hoffenheim',66,462,9,1,6,6,83.5,49,3094,659,342,78,5,83,327,4079.9,7512,24198),
(1,'Bayer 04 Leverkusen',89,616,17,0,8,8,89.8,58,2962,455,293,59,0,59,289,4020.1,8011,24071),
(9,'SV Werder Bremen',48,398,9,1,6,5,82.7,47,3096,629,308,73,2,75,374,3974.5,7244,23739),
(15,'FC Union Berlin',33,403,9,1,6,3,79.9,44,3298,687,359,61,7,68,383,3987.5,7170,23425),
(11,'FC Augsburg',50,437,8,2,7,5,80.4,45,3098,749,363,69,3,72,435,3886.2,7765,23193),
(8,'1. FC Heidenheim 1846',50,393,8,3,3,2,77.3,43,3172,767,326,54,1,55,424,3720.3,7685,23105),
(10,'Sport-Club Freiburg',45,396,10,1,9,7,81.4,46,3036,696,322,62,4,66,351,3998.5,7225,23033),
(14,'Borussia Mönchengladbach',56,446,9,0,6,5,83.7,47,3248,600,308,64,2,66,323,3980.6,6857,22596),
(2,'VfB Stuttgart',78,527,13,3,8,5,88.4,57,3278,535,303,54,1,55,314,3617.2,6923,21581),
(5,'Borussia Dortmund',68,497,9,2,6,6,87.1,57,3171,472,258,55,4,59,298,3596.0,7304,21565),
(4,'RB Leipzig',77,534,9,1,7,4,86.5,54,3282,498,298,59,1,60,329,3484.6,6964,20704),
(3,'FC Bayern München',94,628,16,0,5,5,89.8,59,3310,469,321,45,2,47,294,3471.7,6990,20391),
(18,'SV Darmstadt 98',30,402,9,2,3,3,81.4,45,2926,623,264,83,4,87,404,3567.1,5927,20006);


select * FROM bundesliga_statistics
ORDER BY position ASC;

CREATE TABLE Home_Away_23_24 (
    position INT,
    team VARCHAR(100),
    matches INT,
    wins_total INT,
    draws_total INT,
    lost_total INT,
    goals_scored INT,
    goals_received INT,
    goals_difference INT,
    wins_home INT,
    draws_home INT,
    losses_home INT,
    goals_scored_home INT,
    goals_received_home INT,
    goal_difference_home INT,
    wins_away INT,
    draws_away INT,
    losses_away INT,
    goals_scored_away INT,
    goals_received_away INT,
    goal_difference_away INT,
    total_goals_scored INT,
    total_goals_received INT,
    total_goal_difference INT,
    points_home INT,
    points_away INT,
    total_points INT
);
