clear('all');
clc

% PARAMETRES PAR DEFAUT

% Mode bavard
verbose = true;

% Axes changeants, selon la préférence
% Vincent = true / Clément = false
changeAxis = true;


%
% Exemple 1
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


%
% a) Planner_PosOnly
%

ICIMAR Planner_PosOnly Exemple1


%
% b) Planner_Critere_mid_Prismatic
%

ICIMAR Planner_Critere_mid_Prismatic Exemple1











