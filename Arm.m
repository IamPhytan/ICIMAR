classdef Arm < handle
    % Member   Robotic Arm Member to be used with Arm class
    % Defines the functions to describe .
    %
    % Arm Properties:
    %    members           - Array of arm members
    %    lastMember        - Last member in arm members
    %    x                 - X Coordinate of the base of the arm
    %    y                 - Y Coordinate of the base of the arm
    %    totalLength       - (Private) Total Length of the arm
    %    armSize           - (Private) Requested arm size / nMembers
    %    renderAxes        - Axes to plot the arm in
    %    smallWindowRange  - Small window range
    %    largeWindowRange  - Large window range
    %    largeAxis         - Large window range
    %    maxEndSpeeds      - Maximal end effector speeds
    %    plannerFunc       - Planner function handle
    %    evolutiveAxis     - Enable axis mode (Vincent = true / Clément = false)
    %
    % Arm Target Properties:
    %    targets           - Array of arm targets
    %
    % Arm Obstacle Properties:
    %    obstacles         - Array of arm obstacles
    %
    %
    %
    % Arm Setters and Getters:
    %    getX                 - Get X coordinate of the base of the arm
    %    getY                 - Get Y coordinate of the base of the arm
    %    setTotalLength       - Set total length of the arm
    %    getTotalLength       - Get total length of the arm
    %    setMembers           - Set members of the arm
    %    getMembers           - Get members of the arm
    %    setSmallWindowRange  - Set small window range of the arm
    %    getSmallWindowRange  - Get small window range of the arm
    %    setLargeWindowRange  - Set large window range of the arm
    %    getLargeWindowRange  - Get large window range of the arm
    %    setMaxEndSpeeds      - Set max end effector speeds
    %    getMaxEndSpeeds      - Get max end effector speeds
    %    setPlannerFunc       - Set planner function handle
    %    getPlannerFunc       - Get planner function handle
    %
    % Arm Target Setter and Getters:
    %    setTargets           - Set targets
    %    getTargets           - Get targets
    %
    % Arm Target Setter and Getters:
    %    setObstacles         - Set obstacles
    %    getObstacles         - Get obstacles
    %
    %
    %
    % Arm Methods:
    %    logical              - Return the existence of arm member
    %    computeAbsoluteAngle - Compute absolute angle about the x axis before the i-th member of the arm
    %    getEndX              - Compute ending X coordinate
    %    getEndY              - Compute ending Y coordinate
    %    addMember            - Add new member of defined length to the arm
    %    render               - Plot the arm in a figure
    %    getMemberValues      - Return the values of valueType for all arm members
    %    checkJointType       - Checks that the feedded joint kind is rotoric or prismatic
    %
    % Arm Target Methods:
    %    addTarget            - Add new target for the arm
    %    setParamsFromXandY   - Set members parameters from x and y arrays
    %
    % Arm Obstacles Methods:
    %    addObstacle          - Add new obstacle for the arm
    %
    %
    %


    properties (SetAccess = private, GetAccess = public)
        members;
        lastMember;
        x                = 0;
        y                = 0;
        armSize          = 0;
        renderAxes;
        smallWindowRange;
        largeWindowRange;
        largeAxis        = 0;
        maxEndSpeeds;
        plannerFunc;
        targets;
        obstacles;
        evolutiveAxis;
    end

    properties (constant)
        colors = containers.Map({'yellow', 'blue', 'turquoise', 'green', 'pink', 'red'}, ...
         [[255, 255, 20] / 255, [1, 101, 252] / 255, [28, 247, 253] / 255, [8, 255, 8] / 255, [255, 2, 141] / 255, [229, 0, 0] / 255]);
    end

    properties (Access = private)
        totalLength
    end

    % Constructor
    methods
        function thisArm = Arm(armsize, base_x, base_y, max_speeds, planner_func, change_axis)
            % Construct an instance of member
            if nargin == 0
                thisArm.x = 0;
                thisArm.y = 0;
                thisArm.armSize  = 0;
            else
                thisArm.x = base_x;
                thisArm.y = base_y;
                thisArm.armSize = armsize;
            end
            thisArm.members = Member.empty;
            thisArm.lastMember = false;
            thisArm.totalLength = 0;
            thisArm.maxEndSpeeds = max_speeds;
            thisArm.plannerFunc = planner_func;
            thisArm.targets = struct('x',{},'y',{}, 'theta', {});
            thisArm.obstacles = struct('x',{},'y',{}, 'radius', {});
            thisArm.evolutiveAxis = change_axis;
        end
    end

    % Getters and setters
    methods
        function out = getX(thisArm)
            % getX  Get the X coordinate of the base of the arm
            %   Return the value of x
            out = thisArm.x;
        end
        function out = getY(thisArm)
            % getY  Get the Y coordinate of the base of the arm
            %   Return the value of y
            out = thisArm.y;
        end

        function setTotalLength(thisArm, value)
            % setTotalLength  Set the total length of the arm
            %   Set totalLength with a value
            thisArm.totalLength = value;
        end
        function out = getTotalLength(thisArm)
            % getTotalLength  Get the total length of the arm
            %   Return the value of totalLength
            out = thisArm.totalLength;
        end

        function setMembers(thisArm, value)
            % setMembers  Set the members of the arm
            %   Set members with a value
            thisArm.members = value;
        end
        function out = getMembers(thisArm)
            % getMembers  Get the members of the arm
            %   Return the value of members
            out = thisArm.members;
        end

        function setAxes(thisArm, value)
            % setAxes  Set the axes of the arm
            %   Set renderAxes with a value
            thisArm.renderAxes = value;
        end
        function out = getAxes(thisArm)
            % getAxes  Get the axes of the arm
            %   Return the value of renderAxes
            out = thisArm.renderAxes;
        end

        function setSmallWindowRange(thisArm, value)
            % setSmallWindowRange  Set the small window range of the arm
            %   Set smallWindowRange with a value
            thisArm.smallWindowRange = value;
        end
        function out = getSmallWindowRange(thisArm)
            % getSmallWindowRange  Get the small window range of the arm
            %   Return the value of smallWindowRange
            out = thisArm.smallWindowRange;
        end

        function setLargeWindowRange(thisArm, value)
            % setLargeWindowRange  Set the large window range of the arm
            %   Set largeWindowRange with a value
            thisArm.largeWindowRange = value;
        end
        function out = getLargeWindowRange(thisArm)
            % getLargeWindowRange  Get the large window range of the arm
            %   Return the value of largeWindowRange
            out = thisArm.largeWindowRange;
        end

        function setMaxEndSpeeds(thisArm, value)
            % setMaxEndSpeeds  Set the max arm's end effector speeds
            %   Set maxEndSpeeds with a value
            thisArm.maxEndSpeeds = value;
        end
        function out = getMaxEndSpeeds(thisArm)
            % getMaxEndSpeeds  Get the max arm's end effector speeds
            %   Return the value of maxEndSpeeds
            out = thisArm.maxEndSpeeds;
        end

        function setPlannerFunc(thisArm, value)
            % setPlannerFunc  Set the planner function handle
            %   Set plannerFunc with a value
            thisArm.plannerFunc = value;
        end
        function out = getPlannerFunc(thisArm)
            % getPlannerFunc  Get the planner function handle
            %   Return the value of plannerFunc
            out = thisArm.plannerFunc;
        end

        function setTargets(thisArm, value)
            % setTargets  Set the targets of the arm
            %   Set targets with a value
            thisArm.targets = value;
        end
        function out = getTargets(thisArm)
            % getTargets  Get the targets of the arm
            %   Return the value of targets
            out = thisArm.targets;
        end

        function setObstacles(thisArm, value)
            % setObstacles  Set the obstacles of the arm
            %   Set obstacles with a value
            thisArm.obstacles = value;
        end
        function out = getObstacles(thisArm)
            % getObstacles  Get the obstacles of the arm
            %   Return the value of obstacles
            out = thisArm.obstacles;
        end
    end

    methods
        function addMember(thisArm, jointType, long, larg, initAngle)
            % addMember  Add new member of length long to the arm
            %   Add a member to the arm and define if it is the last one.
            newMemberIndex = length(thisArm.members) + 1;
            if thisArm.checkJointType(jointType, newMemberIndex)
                newMember = Member(newMemberIndex, jointType, 0, 0, long, larg, initAngle, false);
                thisArm.members(newMemberIndex) = newMember;
                if logical(thisArm.lastMember)
                    thisArm.members(newMemberIndex).setParent(thisArm.lastMember);
                else
                    % Don't want to start by a prismatic joint
                    thisArm.members(newMemberIndex).setJointType('R');
                end
                thisArm.lastMember = thisArm.members(end);
                thisArm.totalLength = thisArm.totalLength + long;
                thisArm.update();
            end
        end

        function update(thisArm)
            % update  Update members coordinates with neighbouring members
            %   Update coordinate values.
            for ii=1:length(thisArm.members)
                if logical(thisArm.members(ii).getParent())
                    % Prismatics have a relative angle of 0
                    % if thisArm.members(ii).getJointType() == 'P'
                    %     thisArm.members(ii).setRelAngle(0);
                    %     thisArm.members(ii).setWidth(thisArm.members(ii - 1).getWidth());
                    % end
                    if thisArm.members(ii).getJointType() == 'R'
                        thisArm.members(ii).setDiffLength(0);
                    end

                    % Ensure that the absolute angles are set according to parent members
                    thisArm.members(ii).setAbsAngle(thisArm.members(ii - 1).getAbsAngle() + thisArm.members(ii).getRelAngle());

                    % Ensure that the arm is joined
                    thisArm.members(ii).setX(thisArm.members(ii-1).getEndX());
                    thisArm.members(ii).setY(thisArm.members(ii-1).getEndY());
                else
                    % First member
                    thisArm.members(ii).setAbsAngle(thisArm.members(ii).getRelAngle());
                    thisArm.members(ii).setX(thisArm.x);
                    thisArm.members(ii).setY(thisArm.y);
                end
            end
        end

        function createFigureAndAxes(thisArm)
            % createFigureAndAxes  Generate a figure and axes from an arm
            %   Use arm features to get the right parameters to display the arm
            %   Set axes of arm

            % Close all already opened figures
            if ~isempty(get(groot,'CurrentFigure'))
                close(gcf);
            end

            figure('NumberTitle', 'off', 'Name', 'ICDMAR');
            ax = gca;
            hold(ax, 'on');
            grid(ax, 'on');
            axis(ax, 'equal');

            % AXES
            % Window size
            thisArm.setSmallWindowRange(round(0.25 * thisArm.getTotalLength(), -1) + 10);
            thisArm.setLargeWindowRange(round(1.25 * thisArm.getTotalLength(), -1) + 10);

            % Axis limits
            if thisArm.evolutiveAxis
                xlim(ax, [-thisArm.getSmallWindowRange(), thisArm.getLargeWindowRange()]);
                ylim(ax, [-thisArm.getSmallWindowRange(), thisArm.getLargeWindowRange()]);
            else
                xlim(ax, [-thisArm.getLargeWindowRange(), thisArm.getLargeWindowRange()]);
                ylim(ax, [-thisArm.getLargeWindowRange(), thisArm.getLargeWindowRange()]);
            end

            % Function to draw arrows
            drawArrow = @(plotAxes, x,y, varargin) quiver(plotAxes, x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );

            % Draw axis arrows
            drawArrow(ax, [0, thisArm.getLargeWindowRange()], [0, 0], 'linewidth',3,'color','k');
            drawArrow(ax, [0, 0], [0, thisArm.getLargeWindowRange()], 'linewidth',3,'color','k');

            % Render Obstacles
            for iObstacle=1:length(thisArm.obstacles)
                thisArm.drawCircle(ax, thisArm.obstacles(iObstacle).x, thisArm.obstacles(iObstacle).y, 2 * thisArm.obstacles(iObstacle).radius, thisArm.colors('red'), 'obstacle');
            end

            thisArm.setAxes(ax);
        end

        function render(thisArm)
            % render  Plot the arm in a figure
            %   Create a figure and plot the arm members and the joints in it.

            if isempty(get(groot,'CurrentFigure')) || isempty(thisArm.renderAxes)
                thisArm.createFigureAndAxes();
            end

            % TODO: RENDER TARGET WITH COLORS('pink')

            numStableGraphics = length(thisArm.obstacles) + 2;

            if ~(length(thisArm.renderAxes.Children) == numStableGraphics)
                delete(thisArm.renderAxes.Children(1:length(thisArm.renderAxes.Children)-numStableGraphics))
            end

            % Plot members
            for ii=1:length(thisArm.members)
                thisArm.members(ii).render(thisArm.getAxes());
            end

            % Lines
            plot(thisArm.renderAxes, [thisArm.getMemberValues("x"), thisArm.members(end).getEndX()], [thisArm.getMemberValues("y"), thisArm.members(end).getEndY()], '--b')

            % Plot joints
            thisArm.renderJoints('R');
            thisArm.renderJoints('P');

            eEffector = thisArm.getEndEffector();
            thisArm.drawCircle(thisArm.renderAxes, eEffector(1), eEffector(2), thisArm.members(end).getWidth(), thisArm.colors('green'), 'joint');

            if thisArm.evolutiveAxis && ~thisArm.largeAxis && any(eEffector < -thisArm.getSmallWindowRange())
                thisArm.largeAxis = 1;
                xlim(thisArm.renderAxes, [-thisArm.getLargeWindowRange(), thisArm.getLargeWindowRange()]);
                ylim(thisArm.renderAxes, [-thisArm.getLargeWindowRange(), thisArm.getLargeWindowRange()]);
            elseif thisArm.evolutiveAxis && thisArm.largeAxis && all(eEffector > -thisArm.getSmallWindowRange())
                thisArm.largeAxis = 0;
                xlim(thisArm.renderAxes, [-thisArm.getSmallWindowRange(), thisArm.getLargeWindowRange()]);
                ylim(thisArm.renderAxes, [-thisArm.getSmallWindowRange(), thisArm.getLargeWindowRange()]);
            end

            % drawnow;
            drawnow limitrate;
        end

        function endEffector = getEndEffector(thisArm)
            % getEndEffector  Get coordinates of the end effector of the arm
            %   Return the end coordinate of the last member.
            if logical(thisArm.lastMember)
                endEffector = [thisArm.members(end).getEndX() thisArm.members(end).getEndY()];
            else
                endEffector = [thisArm.x, thisArm.y];
            end
        end

        function values = getMemberValues(thisArm, valueType)
            % getMemberValues  Get the values of valueType for all members
            %   Return an array of values of valueType for all arm members
            numMembers = length(thisArm.members);
            values = cell([1, numMembers]);
            switch lower(valueType)
                case "index"
                    values = arrayfun(@getIndex, thisArm.members);
                case "architecture"
                    values = arrayfun(@getJointType, thisArm.members);
                case "x"
                    values = arrayfun(@getX, thisArm.members);
                case "y"
                    values = arrayfun(@getY, thisArm.members);
                case "rmembers"
                    values = thisArm.members(arrayfun(@getJointType, thisArm.members) == 'R');
                case "pmembers"
                    values = thisArm.members(arrayfun(@getJointType, thisArm.members) == 'P');
                case "initlength"
                    values = arrayfun(@getInitLength, thisArm.members);
                case "difflength"
                    values = arrayfun(@getDiffLength, thisArm.members);
                case "totallength"
                    values = arrayfun(@getDiffLength, thisArm.members) + arrayfun(@getInitLength, thisArm.members);
                case "width"
                    values = arrayfun(@getWidth, thisArm.members);
                case "relangle"
                    values = arrayfun(@getRelAngle, thisArm.members);
                case "absangle"
                    values = arrayfun(@getAbsAngle, thisArm.members);
                case "radrelangle"
                    values = arrayfun(@deg2rad, thisArm.getMemberValues("relangle"));
                case "radabsangle"
                    values = arrayfun(@deg2rad, thisArm.getMemberValues("absangle"));
                case "endx"
                    values = arrayfun(@getEndX, thisArm.members);
                case "endy"
                    values = arrayfun(@getEndY, thisArm.members);
                case "parent"
                    values = arrayfun(@getParent, thisArm.members, 'UniformOutput', false);
                otherwise
                    fprintf('\nPas d''attributs "%s" dans les membres\n', valueType)
            end
        end
    end

    % Targets & Obstacles (ICIMAR)
    methods
        function addTarget(thisArm, tar_x, tar_y, tar_ang)
            % addTarget  Add new target for the arm
            %   Add a target to arm's targets
            newTargetIndex = length(thisArm.targets) + 1;
            target = struct;
            target.x = tar_x;
            target.y = tar_y;
            target.theta = tar_ang;
            thisArm.targets(newTargetIndex) = target;
        end

        function addObstacle(thisArm, obst_x, obst_y, obst_rad)
            % addObstacle  Add new obstacle for the arm
            %   Add a obstacle to arm's obstacles
            newObstacleIndex = length(thisArm.obstacles) + 1;
            obstacle = struct;
            obstacle.x = obst_x;
            obstacle.y = obst_y;
            obstacle.radius = obst_rad;
            thisArm.obstacles(newObstacleIndex) = obstacle;
        end

        % TODO: Verify that the xs and ys are good for Ps and Rs
        function setParamsFromXandY(thisArm, xs, ys)
            % setParamsFromXandY  Set members parameters from x and y arrays
            %   Convert x and y arrays to members params for Vincent's Code
            for iPoint=1:length(xs)-1
                dx = xs(iPoint + 1) - xs(iPoint);
                dy = ys(iPoint + 1) - ys(iPoint);

                % Angles
                effectiveAbsAngle = rad2deg(atan2(dy, dx));
                if iPoint == 1
                    effRelAngle = effectiveAbsAngle;
                else
                    effRelAngle = effectiveAbsAngle - thisArm.members(iPoint - 1).getAbsAngle();
                end

                % Lengths
                effTotalLength = hypot(dx, dy);
                effDiffLength = effTotalLength - thisArm.members(iPoint).getInitLength();

                switch thisArm.members(iPoint).getJointType()
                    case "R"
                        thisArm.members(iPoint).setRelAngle(effRelAngle);
                    case "P"
                        thisArm.members(iPoint).setDiffLength(effDiffLength);
                end

                % Update other values
                thisArm.update();
            end
        end
    end

    % Movement (ICDMAR)
    methods
        function moveMember(thisArm, iMember, value)
            % moveMember  Move an arm member
            %   Move the iMember-th member by value, depending on jointType
            if iMember > length(thisArm.members)
                ME = MException('MATLAB:indexOutOfRange', ...
                ['Member index out of range', newline, ...
                'L''indice %f ne peut etre contenu dans une liste de membres de taille %f'], iMember, length(thisArm.members));
                throw(ME)
            elseif thisArm.members(iMember).getJointType() == 'R'
                % Rotorique
                thisArm.rotateMember(iMember, value);
            else
                % Prismatique
                thisArm.slideMember(iMember, value);
            end
        end

        function rotateMember(thisArm, iMember, rotationAngle)
            % rotateMember  Rotate an arm member
            %   Rotate the iMember-th member by rotationAngle
            for ii_angle = 1:abs(rotationAngle)
                    thisArm.members(iMember).setRelAngle(thisArm.members(iMember).getRelAngle() + sign(rotationAngle));
                    thisArm.update();
                    thisArm.render();
            end
        end

        function slideMember(thisArm, iMember, slideLength)
            % slideMember  Slide an arm member
            %   Slide the iMember-th member by slideLength
            for ii_length = 1:abs(slideLength)
                    thisArm.members(iMember).setDiffLength(thisArm.members(iMember).getDiffLength() + sign(slideLength));
                    thisArm.update();
                    thisArm.render();
            end
        end
    end

    % JOINTS METHODS
    methods (Access = private)
        function checkResult = checkJointType(~, jointKind, memberIndex)
            % checkJointType  Checks that the feedded joint kind is rotoric or prismatic
            %   Return an error if not
            kindsOfJoints = ['R', 'P'];

            if ~any(kindsOfJoints == jointKind)
                ME = MException('MATLAB:wrongData', ...
                'Le type de joint %s défini pour le membre %d est incorrect.', jointKind, memberIndex);
                throw(ME)
            else
                checkResult = true;
            end
        end

        function renderJoints(thisArm, jointKind)
            % renderJoints  Plot the joints of a jointKind in the figure
            %   Plot the joints in it.

            switch lower(jointKind)
                case "r"
                    col = thisArm.colors('turquoise');
                case "p"
                    col = thisArm.colors('yellow');
                otherwise
                    ME = MException('MATLAB:wrongData', ...
                    'Le type de joint %s défini pour le membre est incorrect.', jointKind);
                    throw(ME)
            end

            jointMembersIndexes = arrayfun(@getIndex, thisArm.getMemberValues(jointKind + "Members"));

            for jii=1:length(jointMembersIndexes)
                memberIndex = jointMembersIndexes(jii);
                if memberIndex == 1
                    taille = thisArm.members(1).getWidth();
                else
                    taille = max(thisArm.members(memberIndex - 1).getWidth(), thisArm.members(memberIndex).getWidth());
                end
                thisArm.drawCircle(thisArm.renderAxes, thisArm.members(memberIndex).getX(), thisArm.members(memberIndex).getY(), taille, col, 'joint');
            end
        end

        function drawCircle(~, drawingAxes, centerX, centerY, diameter, colour, circleType)
            % drawCircle  Plot circle at center coordinate, with specified diameter
            %   Draw a circle centered on `(centerX, center Y)` with a radius `diameter` and a color `colour`
            r = diameter/2;
            px = centerX-r;
            py = centerY-r;

            switch circleType
                case "joint"
                    edgeColour = 'b';
                otherwise
                    edgeColour = 'k';
            end

            rectangle(drawingAxes, 'Position',[px py diameter diameter],'Curvature',[1,1], 'EdgeColor', edgeColour, 'FaceColor', colour);
        end
    end
end