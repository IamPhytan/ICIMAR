clear('all');
clc

% PARAMETRES PAR DEFAUT



% ================================ EXEMPLES ================================

%
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


%
% a) Planner_PosOnly
%

% ICIMAR Planner_PosOnly Exemple1
ICIMAR('Planner_PosOnly', 'Exemple1', axisLimits)


%
% b) Planner_Critere_mid_Prismatic
%

% ICIMAR Planner_Critere_mid_Prismatic Exemple1
ICIMAR('Planner_Critere_mid_Prismatic', 'Exemple1', axisLimits)



%
% Exemple 2 - Atteindre un point avec un robot R x n
%   Passage dans les obstacles
%

% Architecture : ['R'] * n
% Longueurs : [1.5 * pi / n] * n
% Angles : [-90] + [pi / n] * 19
% Vitesse cartésiennes maximales de l'organe terminal : [0.05, 0.05, 3]
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
    [-1, 3];
    [-2, 3]
];


%
% a) Planner_PosOnly
%

% ICIMAR Planner_PosOnly Exemple2a
ICIMAR('Planner_PosOnly', 'Exemple2a', axisLimits)


%
% b) Planner_Critere_Mem_Dist
%

% ICIMAR Planner_Critere_Mem_Dist Exemple2b
ICIMAR('Planner_Critere_Mem_Dist', 'Exemple2b', axisLimits)











