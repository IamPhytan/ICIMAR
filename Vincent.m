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
        function [thetaOut,xyPins,Done] = robotGenerique(thisVincent, architecture,initialStates,lengths,xyThetaDotMax,xyThetaRequest,Planner,obstacles)
            % robotGenerique  Calcule les valeurs d'angle et de x/y pour déplacer le robot
            %   Prend l'architecture, les angles, les longueurs de membres, les vitesses maximales, les cibles, le planificateur et les obstacles
            %
            % :param thisVincent: cette instance de Vincent
            % :param architecture: architecture du robot (char array)
            % :param initialStates: angles initials du robot (array)
            % :param lengths: longueurs initales des membres du robot
            % :param xyThetaDotMax: vitesses maximales de l'organe terminal
            % :param xyThetaRequest: cibles du robot (struct array)
            % :param Planner: fonctions de planification à implémenter dans le cadre du cours Éléments de Robotique GMC-3351 / GMC-7046
            % :param obstacles: obstacles sur le parcours du robot
            % :returns thetaOut: final angles
            % :returns xyPins: joint coordinates
            % :returns Done: flag to indicate that the point was reached
            %

            if isempty(thisVincent.getThetaOutMemory())
                thisVincent.setThetaOutMemory(initialStates);
            end

            n=length(architecture);



            % SÉRIES DE DONNÉES

            % Position
            x = zeros(1, n);
            y = zeros(1, n);
            phi = zeros(1, n);

            % Vitesses
            xdot = zeros(1, n);
            ydot = zeros(1, n);
            thetadot = ones(1, n);


            % CONDITONS INITIALES
            phi(1)=thisVincent.thetaOutMemory(1);
            x(1,1)=lengths(1)*cos(phi(1));
            y(1,1)=lengths(1)*sin(phi(1));

            xdot(1,1)=0-y(n);
            ydot(1,1)=x(n)-0;

            % Itération pour toute l'architecture
            if n > 1
                for jj=2:n
                    % Calculs de positions
                    phi(jj)=phi(jj-1)+thisVincent.thetaOutMemory(jj);
                    x(1,jj)=x(jj-1)+lengths(jj)*cos(phi(jj));
                    y(1,jj)=y(jj-1)+lengths(jj)*sin(phi(jj));

                    % Calculs de vitesses (JACOBIENNE)
                    xdot(1,jj)=y(jj-1)-y(n);
                    ydot(1,jj)=x(n)-x(jj-1);
                end
            end

            % Construction de la jacobienne
            J=[xdot, ydot, thetadot];

            thetaOut=thisVincent.getThetaOutMemory();

            xyPins=[x;y];


            % TODO: Reimplement with a while loop

            % WTF is going on here

            % Limiteur de vitesses (Créer Lignes droites en meme temps)
            xyThetaDot=xyThetaRequest-[xyPins(:,n);phi(n)];
            div=max(abs(xyThetaDot)./xyThetaDotMax);
            if(div > 1)
                xyThetaDot=xyThetaDot/div;
                Done=0;
            else
                Done=1;
                %xyThetaDot=xyThetaRequest;
            end
            % Calculs prochain pas de temps et fonction de plnaification avec
            % projection dans le noyeau
            [thetaOutMemory]=Planner(thetaOutMemory,J,obstacles,xyThetaDot);
        end
    end





    methods
        function reachTargets(thisVincent, reachingArm)
            % reachTargets  Reach predefined targets
            %   Call robotGenerique with proper arguments

            architecture = (reachingArm.getMemberValues("architecture"))';




        end
    end
end
