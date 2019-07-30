
% TODO: Call le main comme une fonction avec PlannerFuncName en args
% TODO: VideoGen dans le bon branch

changeAxis = false;

% Import architecture configuration
architectureConfig = Context.importConfig('architecture.txt');

disp('Architecture importee')

% Import targets configuration
targetsConfig = Context.importConfig('cibles.txt');
plannerFileName = char(targetsConfig{2}{1});
maximalSpeeds = cell2mat(targetsConfig{3});
targetsConfig = targetsConfig{1};

disp('Requetes importes')

% Import obstacles configuration
obstaclesConfig = Context.importConfig('obstacles.txt');

disp('Obstacles importes')

% Handlize planner function
plannerHandle = Context.handlizePlannerFilename(plannerFileName);

fprintf('Importation completee des donnees de configuration\nCreation du bras\n')


% ARCHITECTURE

% Nombre de membres
nArchitecture = length(architectureConfig{1});

% Create Arm
arm = Arm(nArchitecture, 0, 0, maximalSpeeds, plannerHandle, changeAxis);

for memberIndex = 1:nArchitecture
    jointKind = architectureConfig{1}{memberIndex};
    long = architectureConfig{2}(memberIndex);
    larg = architectureConfig{3}(memberIndex);
    ang = architectureConfig{4}(memberIndex);
    arm.addMember(jointKind, long, larg, ang);
end

% CIBLES

% Nombre de cibles
nTargets = length(targetsConfig{1});

for targetIndex = 1:nTargets
    tarX = targetsConfig{1}(targetIndex);
    tarY = targetsConfig{2}(targetIndex);
    tarAng = targetsConfig{3}(targetIndex);
    arm.addTarget(tarX, tarY, tarAng);
end

% OBSTACLES

% Nombre d'obstacles
nObstacles = length(obstaclesConfig{1});

for obstacleIndex = 1:nObstacles
    obstX = obstaclesConfig{1}(obstacleIndex);
    obstY = obstaclesConfig{2}(obstacleIndex);
    obstRad = obstaclesConfig{3}(obstacleIndex);
    arm.addObstacle(obstX, obstY, obstRad);
end

arm.render();

vinc = Vincent;
vinc.reachTargets(arm);

eEffector = arm.getEndEffector();

% OUTPUT des valeurs
fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', eEffector(1), eEffector(2))

