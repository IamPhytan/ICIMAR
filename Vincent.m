classdef Vincent < handle
    % Vincent  Calculs de matrices et Jacobiennes
    %
    % Propriétés de Vincent:
    %    thetaOutMemory    - Stored Output Theta
    %
    %
    % Arm Setters and Getters:
    %    setThetaOutMemory       - Set stored output theta of Vincent
    %    getThetaOutMemory       - Get stored output theta of Vincent
    %
    %
    % Méthodes de Vincent:
    %    robotGenerique       - Calcule les valeurs d'angle et de x/y pour déplacer le robot

    % Robot Generique
    methods (Access = private)
        function robotGenerique(~, manipulator, architecture, xyThetaRequest, xyThetaDotMax, obstacles, Planner)
            % robotGenerique  Calcule les valeurs d'angle et de x/y pour déplacer le robot
            %   Prend l'architecture, les cibles, les vitesses maximales, les obstacles et le planificateur.
            %
            % :param manipulator: bras à bouger
            % :param architecture: architecture du robot (char array)
            % :param xyThetaRequest: cible du robot (struct array)
            % :param xyThetaDotMax: vitesses maximales de l'organe terminal
            % :param obstacles: obstacles sur le parcours du robot
            % :param Planner: fonctions de planification à implémenter dans le cadre du cours Éléments de Robotique GMC-3351 / GMC-7046
            % :returns xyPins: joint coordinates


            % CONSTANTES LIÉES À L'ARCHITECTURE
            n=length(architecture);
            thetadot = double(architecture' == 'R');

            % Condition initiale
            div = 50;

            relAngles = (deg2rad(manipulator.getMemberValues("relangle")))'';

            while div > 1

                manipulator.render();

                % SÉRIES DE DONNÉES
                % Position
                x = manipulator.getMemberValues("endx");
                y = manipulator.getMemberValues("endy");

                absoluteAngles = deg2rad(manipulator.getMemberValues("absangle"));
                currentPos = [(manipulator.getEndEffector())'; absoluteAngles(end)];

                % Vitesses
                xdot = zeros(1, n);
                ydot = zeros(1, n);

                xdot(1,1)=0-y(n);
                ydot(1,1)=x(n)-0;

                % Itération pour toute l'architecture
                if n > 1
                    for jj=2:n
                        % Calculs de vitesses (JACOBIENNE)
                        xdot(1,jj)=y(jj-1)-y(n);
                        ydot(1,jj)=x(n)-x(jj-1);
                    end
                end

                % Construction de la jacobienne
                J=[xdot; ydot; thetadot];

                % Limiteur de vitesses
                xyThetaDot=xyThetaRequest-currentPos;
                div=max(abs(xyThetaDot)./xyThetaDotMax);
                xyThetaDot = xyThetaDot / (div^(div > 1));
                size(xyThetaDot);

                % Calculs du prochain état par fonction de planification avec projection dans le noyeau
                relAngles = Planner(relAngles, J, obstacles, xyThetaDot);


                % Convert angles in XY Pins
                memberLengths = manipulator.getMemberValues("totalLength");
                newAbsAngles = cumsum(relAngles);

                xyPins = ones(1, n);
                xyPins = [manipulator.getX(); manipulator.getY()] * xyPins;
                for iMember=2:n
                    xyPins(:, iMember) = [memberLengths(iMember) * cos(newAbsAngles(iMember));
                                        memberLengths(iMember) * sin(newAbsAngles(iMember))];
                end

                xValues = cumsum(xyPins(1, :));
                yValues = cumsum(xyPins(2, :));

                manipulator.setParamsFromXandY(xValues, yValues);
            end
            manipulator.render()
        end
    end

    methods
        function reachTargets(thisVincent, reachingArm)
            % reachTargets  Reach predefined targets
            %   Call robotGenerique with proper arguments

            % Constantes
            architecture = (reachingArm.getMemberValues("architecture"))';
            maximalEndSpeeds = (reachingArm.getMaxEndSpeeds())';
            plannerHandle = reachingArm.getPlannerFunc();

            % Get target list
            armTargets = reachingArm.getTargets();
            nTargets = length(armTargets);
            targetsList = zeros(3, nTargets);
            for iTarget=1:nTargets
                target = armTargets(iTarget);
                targetsList(:, iTarget) = [target.x ; target.y; deg2rad(target.theta)];
            end

            % Get obstacles list
            armObstacles = reachingArm.getObstacles();
            nObstacles = length(armObstacles);
            obstaclesList = zeros(3, nObstacles);
            for iObstacle=1:nObstacles
                obstacle = armObstacles(iObstacle);
                obstaclesList(:, iObstacle) = [obstacle.x ; obstacle.y; obstacle.radius];
            end


            for iRequest=1:nTargets
                % Requête
                request = targetsList(:, iRequest);

                thisVincent.robotGenerique(reachingArm, architecture, request, maximalEndSpeeds, obstaclesList, plannerHandle);
            end









            % :returns thetaOut: final relative angles
            % :returns xyPins: joint coordinates
            % :returns Done: flag to indicate that the point was reached






        end
    end
end
