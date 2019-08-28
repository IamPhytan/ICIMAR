function out = Planner_Yoshikawa(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% Planner_Yoshikawa
%   Optimisation d'un critère

    % Mesure de la manipulabilité
    manipulabilite = - sqrt(abs(det(J * J')));

    % Position envoyée au robot
    out = CurrentJointValues + manipulabilite * xyThetaDot;
end

