classdef Member < handle
    % Member   Robotic Arm Member to be used with Arm class
    % Defines the functions to describe an arm member.
    %
    % Member Properties:
    %    index                - Index of arm member
    %    jointType            - Type of the preceding joint
    %    x                    - X Coordinate of starting point
    %    y                    - Y Coordinate of starting point
    %    initLength           - Initial length of arm member
    %    diffLength           - Differential length of arm member
    %    largeur              - Width of arm member
    %    orientation          - Angle of arm member (in degrees)
    %    relativeAngle        - Relative angle of arm member (in degrees), about the parentMember
    %    absoluteAngle        - Absolute angle of arm member (in degrees), about the x axis
    %    parentMember         - Parent of arm member
    %
    %
    % Member Setters and Getters:
    %    getIndex             - Get the index of the member
    %    setX                 - Set the X coordinate of starting point of the member
    %    getX                 - Get the X coordinate of starting point of the member
    %    setY                 - Set the Y coordinate of starting point of the member
    %    getY                 - Get the Y coordinate of starting point of the member
    %    setInitLength        - Set the initial length of the member
    %    getInitLength        - Get the initial length of the member
    %    setDiffLength        - Set the differential length of the member
    %    getDiffLength        - Get the differential length of the member
    %    setWidth             - Set the width of the member
    %    getWidth             - Get the width of the member
    %    setRelAngle          - Set the relative angle (in degrees) of the member
    %    getRelAngle          - Get the relative angle (in degrees) of the member
    %    setAbsAngle          - Set the absolute angle (in degrees) of the member
    %    getAbsAngle          - Get the absolute angle (in degrees) of the member
    %    setParent            - Set the parent member of the member
    %    getParent            - Get the parent member of the member
    %
    %
    % Member Methods:
    %    logical              - Return the existence of arm member
    %    getEndX              - Compute ending X coordinate
    %    getEndY              - Compute ending Y coordinate
    %    render               - Plot the member in a figure


    properties (SetAccess=private, GetAccess=public)
        index            =  -1;
        jointType         =  'R';
        x                =   0;
        y                =   0;
        initLength       = 100;
        diffLength       =   0;
        largeur          =   5;
        relativeAngle    =   0;
        absoluteAngle    =   0;
        parentMember   = false;
    end

    properties (Constant)
        colors = containers.Map({'yellow', 'blue', 'turquoise', 'green', 'pink', 'red', 'black', 'white'}, ...
         { ...
            [255, 255, 20] / 255, ...
            [1, 101, 252] / 255, ...
            [28, 247, 253] / 255, ...
            [8, 255, 8] / 255, ...
            [255, 2, 141] / 255, ...
            [229, 0, 0] / 255, ...
            [0, 0, 0], ...
            [255, 255, 255] / 255 ...
        });
    end

    % Constructor
    methods
        function this = Member(idx, jointKind, orig_x, orig_y, long, larg, relAng, parentmember)
            % Construct an instance of member
            if (nargin > 0)
                this.index = idx;
                this.jointType = jointKind;
                this.x = orig_x;
                this.y = orig_y;
                this.initLength = long;
                this.largeur = larg;
                this.relativeAngle = relAng;
                this.parentMember = parentmember;
            end
        end
    end

    % Getters and setters
    methods (Access = public)
        function out = getIndex(this)
            % getIndex  Get the index of the member
            %   Return the value of index
            out = this.index;
        end

        function setJointType(this, value)
            % setJointType  Set the type of the preceding joint
            %   Set jointType with a value
            this.jointType = value;
        end
        function out = getJointType(this)
            % getJointType  Get the type of the preceding joint
            %   Return the value of jointType
            out = this.jointType;
        end

        function setX(this, value)
            % setX  Set the X coordinate of starting point of the member
            %   Set x with a value
            this.x = value;
        end
        function out = getX(this)
            % getX  Get the X coordinate of starting point of the member
            %   Return the value of x
            out = this.x;
        end

        function setY(this, value)
            % setY  Set the Y coordinate of starting point of the member
            %   Set y with a value
            this.y = value;
        end
        function out = getY(this)
            % getY  Get the Y coordinate of starting point of the member
            %   Return the value of y
            out = this.y;
        end

        function setInitLength(this, value)
            % setInitLength  Set the initial length of the member
            %   Set initLength with a value
            this.initLength = value;
        end
        function out = getInitLength(this)
            % getInitLength  Get the initial length of the member
            %   Return the value of initLength
            out = this.initLength;
        end

        function setDiffLength(this, value)
            % setDiffLength  Set the differential length of the member
            %   Set diffLength with a value
            this.diffLength = value;
        end
        function out = getDiffLength(this)
            % getDiffLength  Get the differential length of the member
            %   Return the value of diffLength
            out = this.diffLength;
        end

        function setWidth(this, value)
            % setWidth  Set the width of the member
            %   Set largeur with a value
            this.largeur = value;
        end
        function out = getWidth(this)
            % getWidth  Get the width of the member
            %   Return the value of largeur
            out = this.largeur;
        end

        function setRelAngle(this, value)
            % setRelAngle  Set the relative angle (in degrees) of the member
            %   Set relativeAngle with a value
            this.relativeAngle = value;
        end
        function out = getRelAngle(this)
            % getRelAngle  Get the relative angle (in degrees) of the member
            %   Return the value of relativeAngle
            out = this.relativeAngle;
        end

        function setAbsAngle(this, value)
            % setAbsAngle  Set the absolute angle (in degrees) of the member
            %   Set absoluteAngle with a value
            this.absoluteAngle = value;
        end
        function out = getAbsAngle(this)
            % getAbsAngle  Get the absolute angle (in degrees) of the member
            %   Return the value of absoluteAngle
            out = this.absoluteAngle;
        end

        function setParent(this, value)
            % setParent  Set the parent member of the member
            %   Set parentMember iwth a value
            this.parentMember = value;
        end
        function out = getParent(this)
            % getParent  Get the parent member of the member
            %   Return the value of parentMember
            out = this.parentMember;
        end
    end

    methods
        function result = logical(~)
            % logical  Return the existence of arm member
            %   Helps to determine if an arm member or his parent was defined or not.
            result = true;
        end

        function render(this, ax)
            % render  Plot the member in a figure
            %   Plot the member with a length, an origin, a width and an angle.

            % RECTANGLE EN PATCH
            x_min = this.x;
            x_max = this.x + this.initLength + this.diffLength;

            y_min = this.y - this.largeur / 2;
            y_max = this.y + this.largeur / 2;

            xs = [x_min, x_max, x_max, x_min];
            ys = [y_min, y_min, y_max, y_max];

            switch this.getJointType()
                case 'R'
                    patchEdgeColor = this.colors('blue');
                case 'P'
                    patchEdgeColor = this.colors('green');
            end

            p = patch(ax, xs, ys, 'w', 'EdgeColor', patchEdgeColor);

            % ROTATION
            direction = [0, 0, 1]; % En z, vu le plan
            pnt_rotation = [this.x, this.y, 0];
            rotate(p, direction, this.absoluteAngle, pnt_rotation);
        end
    end


    methods (Access = public)
        function finX = getEndX(this)
            % getEndX  Compute ending X coordinate
            %   Calculates X coordinate through angle calculation and applying cosine to it.
            %
            %   See also getEndY.
            finX = this.x + cos(deg2rad(this.absoluteAngle())) * (this.initLength + this.diffLength);
        end
        function finY = getEndY(this)
            % getEndY  Compute ending Y coordinate
            %   Calculates Y coordinate through angle calculation and applying sine to it.
            %
            %   See also getEndX.
            finY = this.y + sin(deg2rad(this.absoluteAngle())) * (this.initLength + this.diffLength);
        end
    end

end
