clear('all');
clc

% ================================ EXEMPLES ================================

%%
% Exemple 1 - Atteindre un point avec un robot PPPR
%   Il est à noter qu'un des joints prismatiques aura une longueur négative.
%

% Architecture : ['P', 'P', 'P', 'R']
% Longueurs : [1, 1, 1, 1]
% Angles : [0, 90, 90, 90]
% Vitesse cartésiennes maximales de l'organe terminal : [0.03, 0.03, 3]
% Cibles à atteindre : [
%     {
%         x : 1,
%         y : 1,
%         angle : 270
%     },
%     {
%         x : 1.5,
%         y : 1.5,
%         angle : 180
%     }
% ]

axisLimits = [
    [-1, 4];
    [-1, 3]
];


%%
% a) Planner_PosOnly
%

% ICIMAR Planner_PosOnly Exemple1
ICIMAR('Planner_PosOnly', 'Exemple1', axisLimits);


%%
% b) Planner_Critere_mid_Prismatic
%

% ICIMAR Planner_Critere_mid_Prismatic Exemple1
ICIMAR('Planner_Critere_mid_Prismatic', 'Exemple1', axisLimits);




%%
% Exemple 2 - Atteindre un point avec un robot R x n
%   Passage dans et entre les obstacles
%

% Architecture : ['R'] * n
% Longueurs : [2.5 * pi / n] * n
% Angles : [180] + [360 / n] * (n - 1)
% Vitesse cartésiennes maximales de l'organe terminal : [0.02, 0.03, 3]
% Cibles à atteindre : [
%     {
%         x : 1,
%         y : 0,
%         angle : 90
%     },
%     {
%         x :   1,
%         y : 3.5,
%         angle : 90
%     },
%     {
%         x :   1,
%         y : 3.5,
%         angle : 180
%     },
%     {
%         x :  -2,
%         y : 3.5,
%         angle : 180
%     },
%     {
%         x : -0.5,
%         y :    2,
%         angle : 270
%     }
% ]
%
% Obstacles à éviter : [
%     {
%         x : 1.25,
%         y :    0,
%         rayon : 0.1
%     },
%     {
%         x : 0.75,
%         y :    1,
%         rayon : 0.1
%     },
%     {
%         x : 1.25,
%         y :    2,
%         rayon : 0.1
%     },
%     {
%         x : 0.75,
%         y :    3,
%         rayon : 0.1
%     }
% ]

axisLimits = [
    [-3, 3];
    [-2, 4]
];


%%
% a) Planner_PosOnly
%

% ICIMAR Planner_PosOnly Exemple2
ICIMAR('Planner_PosOnly', 'Exemple2', axisLimits);


%%
% b) Planner_Critere_Mem_Dist
%

% ICIMAR Planner_Critere_Mem_Dist Exemple2
ICIMAR('Planner_Critere_Mem_Dist', 'Exemple2', axisLimits);




%%
% Exemple 3 - Exemple de Yoshikawa
%   Exemple du livre "Advanced Robotics: Redundancy and Optimization" de Yoshihiko Nakamura
%

% Architecture : ['R'] * 3
% Longueurs : [10, 16.07980, 4.01995]
% Angles : [180, 5.71059, 5.71059]
% Vitesse cartésiennes maximales de l'organe terminal : [0.02, 0.03, 3]
% Cibles à atteindre : [
%     {
%         x :   10,
%         y :  1.8,
%         angle : 320
%     },
%     {
%         x :   10,
%         y :  1.6,
%         angle : 290
%     },
%     {
%         x :   10,
%         y :  1.4,
%         angle : 260
%     },
%     {
%         x :   10,
%         y :  1.2,
%         angle : 240
%     },
%     {
%         x :   10,
%         y :    1,
%         angle : 230
%     },
%     {
%         x :   10,
%         y :  0.8,
%         angle : 220
%     },
%     {
%         x :   10,
%         y :  0.6,
%         angle : 215
%     },
%     {
%         x :   10,
%         y :  0.4,
%         angle : 210
%     },
%     {
%         x :   10,
%         y :  0.2,
%         angle : 210
%     },
%     {
%         x :   10,
%         y :    0,
%         angle : 210
%     }
% ]


%%
% a) Planner_PosOnly
%

axisLimits = [
    [-12, 15];
    [-5, 15]
];

ICIMAR('Planner_PosOnly', 'Exemple3', axisLimits);


%%
% b) Planner_Critere_Mem_Dist_Yoshikawa
%

axisLimits = [
    [-12, 15];
    [-5, 35]
];

ICIMAR('Planner_Critere_Mem_Dist_Yoshikawa', 'Exemple3', axisLimits);
