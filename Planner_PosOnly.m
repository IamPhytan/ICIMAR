function out = Planner_PosOnly(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% Planner_PosOnly Fonction de planification du manipulateur sériel
%   L'implémentation de base du planificateur est la suivante :
%       `out = CurrentJointValues+(J'*inv(J*J'))*xyThetaDot;`

%Pseudo Inverse
out = CurrentJointValues + (J' * inv(J * J')) * xyThetaDot;

%Pseudo Inverse Amortie

%out=CurrentJointAngles;

end
