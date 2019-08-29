function out = Planner_Critere_Mem_Dist(Architecture,Lengths,Angles,CurrentJointValues,J,Obstacles,xyThetaDot)
% Planner_Critere_Mem_Dist
%   Optimisation d'un critère

    % Incrément infinitésimal
    h=0.00001;

    % Distances incrémentée et décrémentée
    distIncrem = zeros(size(Lengths));
    distDecrem = zeros(size(Lengths));

    for idx = 1:length(Architecture)
        tempValues = [Lengths, Angles];

        incLength = tempValues(idx, 1) + h * (Architecture(idx) == 'P');
        incAngle = tempValues(idx, 2) + h * (Architecture(idx) == 'R');
        tempValues(idx, :) = [incLength, incAngle];

        distIncrem(idx, :) = DistToJointCalculator(Obstacles, tempValues(:, 1), tempValues(:, 2));

        tempValues = [Lengths, Angles];

        decLength = tempValues(idx, 1) - h * (Architecture(idx) == 'P');
        decAngle = tempValues(idx, 2) - h * (Architecture(idx) == 'R');
        tempValues(idx, :) = [decLength, decAngle];

        distDecrem(idx, :) = DistToJointCalculator(Obstacles, tempValues(:, 1), tempValues(:, 2));
    end


    discriminator = double(distIncrem ~= 0 & distDecrem ~= 0);
    distIncrem = distIncrem .* discriminator;
    distDecrem = distDecrem .* discriminator;

    distDot=(distIncrem-distDecrem)/(2*h);

    % Pseudo Inverse
    Jinv = J' / (J * J');

    % Projection dans le Noyau
    Jnoy = (eye(size(Jinv * J)) - Jinv*J);

    % Position envoyée au robot

    K = 0.35; % Gain de la projection

    out = CurrentJointValues + Jinv * xyThetaDot + K * Jnoy * distDot;

    %out=CurrentJointAngles;
end

