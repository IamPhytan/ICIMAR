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


    properties (SetAccess = private, GetAccess = public)
        thetaOutMemory;
    end

    % Getters and setters
    methods
        function setThetaOutMemory(thisVincent, value)
            % setThetaOutMemory  Set stored output theta of Vincent
            %   Set thetaOutMemory with a value
            thisVincent.thetaOutMemory = value;
        end
        function out = getThetaOutMemory(thisVincent)
            % getThetaOutMemory  Get stored output theta of Vincent
            %   Return the value of thetaOutMemory
            out = thisVincent.thetaOutMemory;
        end
    end

    % Robot Generique
    methods (Access = private)
        function xyPins = robotGenerique(thisVincent, manipulator, architecture, initialStates, xyThetaDotMax,xyThetaRequest,Planner,obstacles)
            % robotGenerique  Calcule les valeurs d'angle et de x/y pour déplacer le robot
            %   Prend l'architecture, les angles, les longueurs de membres, les vitesses maximales, les cibles, le planificateur et les obstacles
            %
            % :param thisVincent: cette instance de Vincent
            % :param manipulator: bras à bouger
            % :param architecture: architecture du robot (char array)
            % :param initialStates: angles relatifs initiaux du robot (array)
            % :param xyThetaDotMax: vitesses maximales de l'organe terminal
            % :param xyThetaRequest: cibles du robot (struct array)
            % :param Planner: fonctions de planification à implémenter dans le cadre du cours Éléments de Robotique GMC-3351 / GMC-7046
            % :param obstacles: obstacles sur le parcours du robot
            % :returns thetaOut: final angles
            % :returns xyPins: joint coordinates
            % :returns Done: flag to indicate that the point was reached


            % CONSTANTES LIÉES À L'ARCHITECTURE
            n=length(architecture);
            thetadot = double(architecture' == 'R');

            % Condition initiale
            div = 50;
            phi = manipulator.getMemberValues("radabsangle");

            angles = manipulator.getMemberValues("radrelangle");

            while div > 1

                manipulator.render();

                % SÉRIES DE DONNÉES
                % Position
                x = manipulator.getMemberValues("endx");
                y = manipulator.getMemberValues("endy");

                % TODO: Unpseudocodize this line
                current = [eFFector'; manipulator.members(end).radabsangle];

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
                xyThetaDot=xyThetaRequest-current;
                div=max(abs(xyThetaDot)./xyThetaDotMax);
                xyThetaDot = xyThetaDot / (div^(div > 1));

                % Calculs prochain pas de temps et fonction de planification avec
                % projection dans le noyeau
                angles = Planner(angles, J, obstacles, xyThetaDot);


                % TODO: Unpseudocodize this part
                % FIXME: Broke it
                lengths = manipulator.getLengths

                xyPins = zeros(1, n);
                xyPins = [arm.getX(); arm.getY()] * xyPins;
                for num in 2:range(n):
                    xyPins(:, num) = [xyPins(1, num-1) + length(num) * cos(angles(num)); xyPins(1, num-1) + length(num) * cos(angles(num))];


                return xvPins into arm

                % TODO: Set Values inside arm
                % TODO: Set Angles == > xyPins
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
            maximalEndSpeeds = reachingArm.getMaxEndSpeeds();
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
                % Variables
                initialStates = (reachingArm.getMemberValues("relangle"))';

                request = targetsList(:, iRequest);

                xyCoords = robotGenerique();


            end









            % :returns thetaOut: final relative angles
            % :returns xyPins: joint coordinates
            % :returns Done: flag to indicate that the point was reached






        end
    end
end
