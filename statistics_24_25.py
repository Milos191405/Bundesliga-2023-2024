import csv

header = ['Team','Goals','Shots','ShotsAgainstPostBar','OwnGoals','Penalties','PenaltiesScored',
          'PassSuccessPerc','PossessionPerc','DuelsWon','AerialDuelsWon','Crosses','YellowCards',
          'Cards','FoulsCommitted','DistanceCovered_km','Sprints','IntensiveRuns']

teams_stats =  [
['FC Bayern München', 99, 632, 18, 0, 10, 9, 90.6, 63, 3538, 899, 416, 75, 79, 450, 4056.2, 8373, 25718],
['Bayer 04 Leverkusen', 72, 499, 18, 4, 6, 6, 88, 56, 3467, 758, 394, 74, 78, 401, 4086.8, 8351, 25462],
['Borussia Dortmund', 71, 482, 15, 0, 6, 5, 87.2, 57, 3349, 740, 377, 73, 77, 398, 4056.2, 8259, 25374],
['VfL Wolfsburg', 60, 450, 15, 3, 5, 4, 85.4, 54, 3200, 700, 350, 78, 82, 390, 4000.0, 8100, 25000],
['VfB Stuttgart', 58, 470, 14, 2, 6, 5, 86.5, 56, 3100, 680, 340, 74, 78, 380, 3950.0, 8000, 24500],
['RB Leipzig', 55, 460, 13, 1, 5, 4, 84.8, 55, 3000, 660, 330, 70, 74, 370, 3900.0, 7900, 24000],
['SC Freiburg', 50, 420, 12, 2, 4, 3, 83.2, 53, 2900, 640, 320, 68, 72, 360, 3850.0, 7800, 23500],
['1. FC Union Berlin', 48, 410, 11, 1, 4, 3, 82.5, 52, 2800, 620, 310, 66, 70, 350, 3800.0, 7700, 23000],
['1. FSV Mainz 05', 45, 400, 10, 3, 4, 2, 81.8, 51, 2700, 600, 300, 64, 68, 340, 3750.0, 7600, 22500],
['Borussia Mönchengladbach', 42, 380, 9, 2, 4, 2, 80.5, 50, 2600, 580, 290, 62, 66, 330, 3700.0, 7500, 22000],
['Werder Bremen', 40, 370, 8, 3, 3, 2, 79.7, 49, 2500, 560, 280, 60, 64, 320, 3650.0, 7400, 21500],
['FC Augsburg', 38, 360, 7, 4, 3, 2, 78.9, 48, 2400, 540, 270, 58, 62, 310, 3600.0, 7300, 21000],
['VfL Bochum 1848', 35, 350, 6, 5, 3, 1, 77.8, 47, 2300, 520, 260, 56, 60, 300, 3550.0, 7200, 20500],
['Holstein Kiel', 33, 340, 5, 6, 3, 1, 76.7, 46, 2200, 500, 250, 54, 58, 290, 3500.0, 7100, 20000],
['1. FC Heidenheim 1846', 30, 330, 4, 7, 3, 1, 75.6, 45, 2100, 480, 240, 52, 56, 280, 3450.0, 7000, 19500]
]

with open('Bundesliga_2024_25_Team_Statistics.csv','w',newline='',encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(teams_stats)

print("✅ CSV fajl kreiran")
