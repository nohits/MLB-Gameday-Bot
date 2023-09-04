# MLB-Gameday-Bot

Generates a report of todays MLB games, giving detailed information about each matchup.

Lots of relevant stats are provided about the teams/ players to better predict outcomes.

This data is gathered from different stats APIs. 

Download, then right-click and run with powershell to execute.

More stats and functionality will be added.

</br>

PREVIEW OF OUTPUT:


<pre>
-- MATCHUP --

MATCHUP   : New York Yankees (68-69) @ Houston Astros (77-61)
GAME TIME : 9/3/2023 6:10:00 PM
PROBABLES : Michael King vs Cristian Javier
WEATHER   : Roof Closed, 73F, 0 mph, No Direction
MONEYLINE : 

Away SP
RHP MICHAEL KING            : 4-5
IP                          : 78.0
ERA                         : 2.88
QS                          : 0
K/9                         : 10.50
H/9                         : 7.38
BB/9                        : 2.88
AVG                         : .221
SLG                         : .336
BARREL%                     : 0.19
WIFF%                       : 0.30
ERA--                       : 70.45
LAST 5 STARTS               :  
1 Home vs Baltimore Orioles : 1.0 IP, 0 ER, 2 K, 0 BB, 1 H
2 Home vs Miami Marlins     : 2.2 IP, 0 ER, 5 K, 0 BB, 2 H
3 Away vs Boston Red Sox    : 2.0 IP, 2 ER, 3 K, 0 BB, 4 H
4 Home vs Boston Red Sox    : 3.2 IP, 0 ER, 3 K, BB, 1 H
Career                      : 221.0 IP, 3.50 ERA, WL 13-14
Career+                     : AVG .221, SLG .351
vs Houston Astros           : 44 PA, 3 R, 12 K, .275 AVG,  HR

Home SP
RHP CRISTIAN JAVIER         : 9-3
IP                          : 137.1
ERA                         : 4.65
QS                          : 10
K/9                         : 8.32
H/9                         : 8.19
BB/9                        : 3.34
AVG                         : .239
SLG                         : .437
BARREL%                     : 0.21
WIFF%                       : 0.26
ERA--                       : 109.33
LAST 5 STARTS               :  
1 Home vs Baltimore Orioles : 5.0 IP, 2 ER, 3 K, 3 BB, 4 H
2 Home vs Miami Marlins     : 4.2 IP, 4 ER, 2 K, BB, 6 H
3 Away vs Boston Red Sox    : 5.0 IP, 3 ER, 3 K, 3 BB, 7 H
4 Home vs Boston Red Sox    : 4.0 IP, 4 ER, 4 K, 6 BB, 6 H
Career                      : 441.2 IP, 3.55 ERA, WL 29-15
Career+                     : AVG .239, SLG .370
vs New York Yankees         : 98 PA, 7 R, 33 K, .125 AVG, 4 HR


NEW YORK YANKEES       : BATTING
R                      : #23 582
AVG                    : #29 .228
HR                     : #05 197
SLG                    : #19 .404
OBP                    : #26 .303
GLEYBER TORRES         : AB 507, AVG .272, HR 22, SLG .445, OBP .365
G.Torres LAST 10       : AB 042, AVG .381, HR 02, SLG .821, OBP .432, K 07
G.Torres VS SP         : AB 012, AVG .250, HR 00, SLG .250, OBP .250, K 02
ANTHONY VOLPE          : AB 454, AVG .218, HR 20, SLG .407, OBP .296
A.Volpe LAST 10        : AB 037, AVG .243, HR 03, SLG .568, OBP .333, K 10
A.Volpe VS SP          : AB 003, AVG .000, HR 00, SLG .000, OBP .250, K 00
DJ LEMAHIEU            : AB 415, AVG .241, HR 14, SLG .398, OBP .321
D.LeMahieu LAST 10     : AB 039, AVG .256, HR 05, SLG .667, OBP .341, K 08
D.LeMahieu VS SP       : AB 005, AVG .400, HR 01, SLG 1.200, OBP .571, K 01
ANTHONY RIZZO          : AB 373, AVG .244, HR 12, SLG .378, OBP .328
A.Rizzo LAST 10        : AB 041, AVG .220, HR 01, SLG .317, OBP .256, K 12
A.Rizzo VS SP          : AB 006, AVG .167, HR 00, SLG .167, OBP .167, K 01
GIANCARLO STANTON      : AB 313, AVG .204, HR 21, SLG .441, OBP .282
G.Stanton LAST 10      : AB 043, AVG .256, HR 03, SLG .512, OBP .289, K 16
G.Stanton VS SP        : AB 006, AVG .167, HR 01, SLG .667, OBP .167, K 05
ISIAH KINER-FALEFA     : AB 295, AVG .247, HR 06, SLG .353, OBP .312
I.Kiner-Falefa LAST 10 : AB 034, AVG .147, HR 00, SLG .206, OBP .194, K 11
I.Kiner-Falefa VS SP   : AB 014, AVG .214, HR 01, SLG .429, OBP .313, K 03
AARON JUDGE            : AB 291, AVG .261, HR 31, SLG .619, OBP .388
A.Judge LAST 10        : AB 036, AVG .139, HR 03, SLG .389, OBP .244, K 19
A.Judge VS SP          : AB 010, AVG .000, HR 00, SLG .000, OBP .231, K 06
Last 5 Scores          : NEW 6 @ HOU 2, NEW 3 @ DET 4, NEW 6 @ DET 2, NEW 4 @ DET 2


HOUSTON ASTROS      : BATTING
R                   : #06 690
AVG                 : #08 .257
HR                  : #09 180
SLG                 : #08 .426
OBP                 : #08 .329
ALEX BREGMAN        : AB 530, AVG .266, HR 22, SLG .445, OBP .365
A.Bregman LAST 10   : AB 042, AVG .381, HR 02, SLG .619, OBP .458, K 05
A.Bregman VS SP     : AB 003, AVG 1.000, HR 00, SLG 1.000, OBP 1.000, K 00
KYLE TUCKER         : AB 491, AVG .289, HR 26, SLG .511, OBP .371
K.Tucker LAST 10    : AB 037, AVG .243, HR 01, SLG .378, OBP .356, K 06
K.Tucker VS SP      : AB 002, AVG .000, HR 00, SLG .000, OBP .000, K 00
JEREMY PENA         : AB 483, AVG .259, HR 10, SLG .389, OBP .323
J.Pena LAST 10      : AB 037, AVG .378, HR 00, SLG .622, OBP .439, K 03
J.Pena VS SP        : AB 003, AVG .333, HR 00, SLG .333, OBP .333, K 00
JOSE ABREU          : AB 453, AVG .234, HR 12, SLG .351, OBP .293
J.Abreu LAST 10     : AB 039, AVG .205, HR 02, SLG .385, OBP .295, K 04
J.Abreu VS SP       : AB 004, AVG .000, HR 00, SLG .000, OBP .000, K 02
MAURICIO DUBON      : AB 411, AVG .273, HR 07, SLG .389, OBP .303
M.Dubon LAST 10     : AB 024, AVG .375, HR 01, SLG .625, OBP .375, K 02
M.Dubon VS SP       : AB 003, AVG .333, HR 00, SLG .333, OBP .333, K 00
CHAS MCCORMICK      : AB 327, AVG .281, HR 19, SLG .511, OBP .363
C.McCormick LAST 10 : AB 045, AVG .267, HR 02, SLG .422, OBP .292, K 10
C.McCormick VS SP   : AB 002, AVG .000, HR 00, SLG .000, OBP .000, K 01
YORDAN ALVAREZ      : AB 326, AVG .291, HR 23, SLG .564, OBP .400
Y.Alvarez LAST 10   : AB 038, AVG .395, HR 02, SLG .632, OBP .521, K 03
Y.Alvarez VS SP     : AB 003, AVG .333, HR 00, SLG .333, OBP .500, K 00
Last 5 Scores       : NEW 5 @ HOU 4, NEW 6 @ HOU 2, HOU 7 @ BOS 4, HOU 6 @ BOS 2


</pre>
