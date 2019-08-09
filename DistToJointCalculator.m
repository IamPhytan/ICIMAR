function [out] = DistToJointCalculator(Obstacles,LengthsMemory,thetaOutMemory)
    dis = 0;

    phi = cumsum(thetaOutMemory);
    x = cumsum(LengthsMemory .* cos(phi));
    y = cumsum(LengthsMemory .* sin(phi));

    xyPins = [x;y];

    for iObstacle = 1:size(Obstacles,2)
        obstacleXY = Obstacles(1:2,iObstacle);
        tempDist = zeros(1, size(xyPins,2) - 1);

        for iMember = 1:size(xyPins,2)-1
            dXY = obstacleXY - xyPins(:,iMember);
            d = sqrt(dXY' * dXY);
            tempDist(iMember)=(0.6-d)^2*(d<0.6);
        end

        % Dist = min(DistTemp);
        dis = dis + tempDist' * tempDist;
    end

    out = -dis;

end
