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
        function robotGenerique(~, manipulator, targetIdx, architecture, xyThetaRequest, maxEndSpeeds, obstacles, Planner)
            % robotGenerique  Calcule les valeurs d'angle et de x/y pour déplacer le robot
            %   Prend l'architecture, les cibles, les vitesses maximales, les obstacles et le planificateur.
            %
            % :param manipulator: bras à bouger
            % :param targetIdx: indice de la cible
            % :param architecture: architecture du robot (char array)
            % :param xyThetaRequest: cible du robot (struct array)
            % :param maxEndSpeeds: vitesses maximales de l'organe terminal
            % :param obstacles: obstacles sur le parcours du robot
            % :param Planner: fonctions de planification à implémenter dans le cadre du cours Éléments de Robotique GMC-3351 / GMC-7046


            % CONSTANTES LIÉES À L'ARCHITECTURE
            n=length(architecture);
            jointsR = (architecture == 'R');
            jointsP = ~jointsR;
            thetadot = double(jointsR');

            % Condition initiale
            div = 50;
            mvmt_idx = 0;

            % TODO: Chaotic
            % Variables évolutives
            relAngles = (deg2rad(manipulator.getMemberValues("relangle")))';
            totLengths = (manipulator.getMemberValues("totalLength"))';

            while div > 1

                % SÉRIES DE DONNÉES
                % Position
                % FIXME: Possibilité de devoir changer le calcul de ces valeurs
                x = manipulator.getMemberValues("endx");
                y = manipulator.getMemberValues("endy");
                absoluteAngles = deg2rad(manipulator.getMemberValues("absangle"));
                currentPos = [(manipulator.getEndEffector())'; absoluteAngles(end)];

                % Vitesses
                % Calculs de vitesses (JACOBIENNE)
                xdot = zeros(1, n);
                ydot = zeros(1, n);

                for jj=1:n
                    currentR = jointsR(jj);
                    currentP = ~currentR;
                    if jj == 1
                        xdot(1,jj) = currentR * (0 - y(n)) + currentP * cos(absoluteAngles(jj));
                        ydot(1,jj) = currentR * (x(n) - 0) + currentP * sin(absoluteAngles(jj));
                    else
                        xdot(1,jj) = currentR * (y(jj-1) - y(n)) + currentP * cos(absoluteAngles(jj));
                        ydot(1,jj) = currentR * (x(n) - x(jj-1)) + currentP * sin(absoluteAngles(jj));
                    end
                end

                % Construction de la jacobienne
                J=[xdot; ydot; thetadot];

                % Limiteur de vitesses
                xyThetaDot=xyThetaRequest-currentPos;

                div=max(abs(xyThetaDot)./maxEndSpeeds);
                xyThetaDot = xyThetaDot / (div^(div > 1));

                % Calculs du prochain état par fonction de planification avec projection dans le noyau
                variableData = jointsR .* relAngles + jointsP .* totLengths;
                resData = Planner(variableData, J, obstacles, xyThetaDot);

                relAngles = jointsR .* resData + jointsP .* relAngles;
                totLengths = jointsP .* resData + jointsR .* totLengths;

                % % Set Params from Lengths and Angles
                manipulator.setFromTotLenRelAng(totLengths, relAngles);



                % % % Convert angles in XY Pins
                % memberLengths = totLengths;
                % newAbsAngles = cumsum(relAngles);

                % xyPins = ones(1, n + 1);
                % xyPins = [manipulator.getX(); manipulator.getY()] * xyPins;
                % for iMember=1:n
                %     xyPins(:, iMember + 1) = [memberLengths(iMember) * cos(newAbsAngles(iMember));
                %                         memberLengths(iMember) * sin(newAbsAngles(iMember))];
                % end

                % xValues = cumsum(xyPins(1, :));
                % yValues = cumsum(xyPins(2, :));

                % manipulator.setParamsFromXandY(xValues, yValues);

                % Show result
                manipulator.render();

                % Stop at 500 movements
                mvmt_idx = mvmt_idx + 1;

                if mvmt_idx == 500
                    % Affiche que la cible fut manquée
                    missedTargetStatus = sprintf("Cible %d manquee !", targetIdx);
                    disp(missedTargetStatus)
                    manipulator.displayInformation(1, missedTargetStatus)
                    break
                end

            end

            if mvmt_idx < 500
                % Affiche que la cible fut atteinte en moins de 500 coups
                reachedTargetStatus = sprintf("Cible %d atteinte !", targetIdx);
                disp(reachedTargetStatus)
                manipulator.displayInformation(1, reachedTargetStatus)
            end

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

            % Show arm
            reachingArm.render();

            for iRequest=1:nTargets

                % Requête
                request = targetsList(:, iRequest);

                reachingArm.setCurrentTarget(request(1:2));

                % Print la cible dans la console
                fprintf('\n\nCible %d : \n===============\nx: %f, y: %f, theta: %f%c\n', iRequest, request(1), request(2), rad2deg(request(3)), char(0176))

                % Affiche la cible dans le titre de la figure
                targetInfo = sprintf("Cible %d : x: %g, y: %g, theta: %g%c", iRequest, request(1) , request(2), rad2deg(request(3)), char(0176));
                reachingArm.displayInformation(2, targetInfo)

                thisVincent.robotGenerique(reachingArm, iRequest, architecture, request, maximalEndSpeeds, obstaclesList, plannerHandle);

            end
        end
    end
end
