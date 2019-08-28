function out = Yoshikawa_Potential_Function(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% Yoshikawa_Potential_Function
%   Optimisation d'un critère

    % Mesure de la manipulabilité
    manipulabilite = - sqrt(abs(det(J * J')));

    % Position envoyée au robot
    out = CurrentJointValues + manipulabilite * xyThetaDot;
end

