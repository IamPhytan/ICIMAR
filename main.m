
% FIXME: uSE VINCENT AND CONTEXT -> FILEHANDLERS

architectureConfig = Context.importConfig('architecture.txt');
architectureConfig = architectureConfig{1};

targetsConfig = Context.importConfig('cibles.txt');
plannerFileName = string(targetsConfig{2});
targetsConfig = targetsConfig{1};

obstaclesConfig = Context.importConfig('obstacles.txt');
obstaclesConfig = obstaclesConfig{1};


% Nombre de membres
n = length(robotArchitecture{1});

% Create Arm
arm = Arm(n, 0, 0);

kindsOfJoints = ['R', 'P'];

for memberIndex = 1:n
    % TODO: MOVE CODE ELSEWHERE
    jointKind = robotArchitecture{1}{memberIndex};
    if ~any(kindsOfJoints == jointKind)
        ME = MException('MATLAB:wrongData', ...
        'Le type de joint %s défini pour le membre %d est incorrect.', jointKind, memberIndex);
        throw(ME)
    end
    long = robotArchitecture{2}(memberIndex);
    larg = robotArchitecture{3}(memberIndex);
    ang = robotArchitecture{4}(memberIndex);
    arm.addMember(jointKind, long, larg, ang);
end


arm.moveMember(2, 90);
arm.moveMember(3, 5);
arm.moveMember(1, -50);
arm.moveMember(5, -2);
arm.moveMember(4, -75);
arm.moveMember(2, 135);
arm.moveMember(5, 6);
arm.moveMember(2, 270);
arm.moveMember(1, 180);
arm.moveMember(8, 7);
arm.moveMember(6, 60);
arm.moveMember(10, 9);
arm.moveMember(4, -50);
arm.moveMember(10, -6);
arm.moveMember(9, 350);
arm.moveMember(5, -2);
arm.moveMember(11, 6);
arm.moveMember(7, 5);
arm.moveMember(8, 20);
% arm.rotateMember(5, 800);
% arm.rotateMember(1, 90);
% arm.getValues("relAngle")
% arm.getValues("absAngle")

eEffector = arm.getEndEffector();

% OUTPUT des valeurs
fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', eEffector(1), eEffector(2))

