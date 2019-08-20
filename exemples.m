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

