function out = Planner_PosOnly(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% PlannerRRRRRRR_1 Fonction de planification du manipulateur sériel
%   L'implémentation de base du planificateur est la suivante :
%       `out=CurrentJointValues+(J'*inv(J*J'))*xyThetaDot;`

CritereNoyau=0;

%Pseudo Inverse
out=CurrentJointValues+(J'*inv(J*J'))*xyThetaDot;

%Pseudo Inverse Amortie

%out=CurrentJointAngles;

end

