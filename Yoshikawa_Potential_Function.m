function out = Yoshikawa_Potential_Function(Architecture, LengthsMemory, thetaOutMemory)
% Yoshikawa_Potential_Function
%   Optimisation d'un critère

    % CONSTANTES LIÉES À L'ARCHITECTURE
    n=length(Architecture);
    jointsR = (Architecture == 'R');
    jointsP = ~jointsR;
    thetadot = double(jointsR');

    % Séries de données
    phi = cumsum(thetaOutMemory);
    x = cumsum(LengthsMemory .* cos(phi))';
    y = cumsum(LengthsMemory .* sin(phi))';

    % Vitesses
    % Calculs de vitesses (JACOBIENNE)
    xdot = zeros(1, n);
    ydot = zeros(1, n);

    for jj=1:n
        currentR = jointsR(jj);
        currentP = ~currentR;
        if jj == 1
            xdot(1,jj) = currentR * (0 - y(n)) + currentP * cos(phi(jj));
            ydot(1,jj) = currentR * (x(n) - 0) + currentP * sin(phi(jj));
        else
            xdot(1,jj) = currentR * (y(jj-1) - y(n)) + currentP * cos(phi(jj));
            ydot(1,jj) = currentR * (x(n) - x(jj-1)) + currentP * sin(phi(jj));
        end
    end

    % Construction de la jacobienne
    J=[xdot; ydot; thetadot];

    % Mesure de la manipulabilité
    manipulabilite = - sqrt(abs(det(J * J')));

    % Position envoyée au robot
    out = manipulabilite;
end

