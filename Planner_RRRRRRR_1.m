function out = Planner_RRRRRRR_1(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% PlannerRRRRRRR_1 Fonction de planification du manipulateur sériel
%   L'implémentation de base du planificateur est la suivante :
%       `out=CurrentJointAngles+pinv(J)*xyThetaDot;`

% Fonction Objective
% out=CurrentJointAngles+pinv(J)*xyThetaDot;

% Pseudo Inverse
out=CurrentJointValues+(J'*inv(J*J'))*xyThetaDot;

%out=CurrentJointAngles;
end

