function [out,Done] = PlannerRRRRRRR_1(CurrentJointAngles,J,Obstacles,xyThetaDot)
% PlannerRRRRRRR_1 Fonction de planification du manipulateur sériel
%   L'implémentation de base du planificateur est la suivante :
%       `out=CurrentJointAngles+pinv(J)*xyThetaDot;`

% Fonction Objective
out=CurrentJointAngles+pinv(J)*xyThetaDot;

%out=CurrentJointAngles;
end

