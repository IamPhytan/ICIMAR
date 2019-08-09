function out = Planner_Critere_mid_Prismatic(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% Planner_Critere_mid_Prismatic
%   Pour éloigner les joints prismatiques d'une longueur définie

LongueurCentree = 0.5;
Critere = (CurrentJointValues - LongueurCentree);
Critere = (Critere<0) .* Critere;
Critere = -Critere .* (Architecture == 'P');

% Pseudo Inverse
Jinv = J' / (J*J');
% Projection dans le Noyau
Jnoy = (eye(size(Jinv * J)) - Jinv * J);

% Position Envoyée au Robot
K = 0.05; % Gain de la projection
out = CurrentJointValues + Jinv * xyThetaDot + K * Jnoy * Critere;

% out = CurrentJointAngles;
end

