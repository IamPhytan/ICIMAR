
% FIXME: uSE VINCENT AND CONTEXT -> FILEHANDLERS

architectureConfig = Context.importConfig('architecture.txt');

targetsConfig = Context.importConfig('cibles.txt');
plannerFileName = char(targetsConfig{2}{1});
targetsConfig = targetsConfig{1};

obstaclesConfig = Context.importConfig('obstacles.txt');

plannerHandle = Context.handlizePlannerFilename(plannerFileName);


% ARCHITECTURE

% Nombre de membres
nArchitecture = length(architectureConfig{1});

% Create Arm
arm = Arm(nArchitecture, 0, 0, plannerHandle);

for memberIndex = 1:nArchitecture
    jointKind = architectureConfig{1}{memberIndex};
    long = architectureConfig{2}(memberIndex);
    larg = architectureConfig{3}(memberIndex);
    ang = architectureConfig{4}(memberIndex);
    arm.addMember(jointKind, long, larg, ang);
end

% Nombre de cibles
nTargets = length(targetsConfig{1});

for targetIndex = 1:nTargets
    tarX = targetsConfig{1}(targetIndex);
    tarY = targetsConfig{2}(targetIndex);
    tarAng = targetsConfig{3}(targetIndex);
    arm.addTarget(tarX, tarY, tarAng);
end


% Nombre d'obstacles
nObstacles = length(obstaclesConfig{1});

for obstacleIndex = 1:nObstacles
    obstX = obstaclesConfig{1}(obstacleIndex);
    obstY = obstaclesConfig{2}(obstacleIndex);
    obstRad = obstaclesConfig{3}(obstacleIndex);
    arm.addObstacle(obstX, obstY, obstRad);
end

arm.moveMember(12, 180);
arm.moveMember(13, 90);
arm.moveMember(6, 90);
arm.moveMember(3, 5);
arm.moveMember(8, -50);
arm.moveMember(5, -2);
arm.moveMember(12, -75);
arm.moveMember(9, 135);
arm.moveMember(5, 6);
arm.moveMember(8, 270);
arm.moveMember(12, 270);
arm.moveMember(4, 7);
arm.moveMember(6, 60);
arm.moveMember(10, 9);
arm.moveMember(10, -6);
arm.moveMember(9, 90);
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

