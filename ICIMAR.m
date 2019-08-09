function ICIMAR(nomDuPlanificateur, nomDuDossierDeConfiguration, varargin)
    % ICIMAR - Code principal d'ICIMAR
    %
    % Syntaxe: ICIMAR(nomDuPlanificateur, nomDuDossierDeConfiguration, axisLimits='auto')
    %
    % Code à exécuter

    % Vérifie que le nomduPlanificateur et le nomDuDossierDeConfiguration sont donnés dans l'appel
    narginchk(2, 3)



    % PARAMETRES PAR DEFAUT
    axisLimits = 'auto';

    automaticChangingAxis = true; % Axes changeants, selon la préférence (Vincent = true / Clément = false)

    verbose = true; % Mode bavard

    try
        axisLimits = varargin{1};
    end


    % TODO: Examples
    % TODO: VideoGen dans une nouvelle branch


    % Créé contexte
    roboticsContext = Context(nomDuDossierDeConfiguration);

    % Import architecture configuration
    architectureConfig = roboticsContext.importConfig('architecture.txt');

    if verbose
        disp('Architecture importee')
    end

    % Import targets configuration
    targetsConfig = roboticsContext.importConfig('cibles.txt');
    maximalSpeeds = cell2mat(targetsConfig{2});
    targetsConfig = targetsConfig{1};

    if verbose
        disp('Requetes importes')
    end

    % Import obstacles configuration
    obstaclesConfig = roboticsContext.importConfig('obstacles.txt');

    if verbose
        disp('Obstacles importes')
    end

    % Handlize planner function
    plannerHandle = Context.handlizePlannerFilename(nomDuPlanificateur);

    if verbose
        fprintf('Importation completee des donnees de configuration\nCreation du bras\n')
    end


    % ARCHITECTURE

    % Nombre de membres
    nArchitecture = length(architectureConfig{1});

    % Create Arm
    arm = Arm(nArchitecture, 0, 0, maximalSpeeds, plannerHandle, axisLimits, automaticChangingAxis);

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
    if verbose
        fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', eEffector(1), eEffector(2))
    end

end



