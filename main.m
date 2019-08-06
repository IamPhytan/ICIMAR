function main(nomDuPlanificateur)
    % main - Code principal d'ICIMAR
    %
    % Syntaxe: main(nomDuPlanificateur)
    %
    % Code à exécuter

    % PARAMETRES
    % Axes changeants, selon la préférence
    % Vincent = true / Clément = false
    changeAxis = false;

    % Mode bavard
    verbose = true;


    % TODO: VideoGen dans le bon branch


    % Vérifie que le nomduPlanificateur est donné dans l'appel
    narginchk(1, 1)

    % Import architecture configuration
    architectureConfig = Context.importConfig('architecture.txt');

    if verbose
        disp('Architecture importee')
    end

    % Import targets configuration
    targetsConfig = Context.importConfig('cibles.txt');
    maximalSpeeds = cell2mat(targetsConfig{2});
    targetsConfig = targetsConfig{1};

    if verbose
        disp('Requetes importes')
    end

    % Import obstacles configuration
    obstaclesConfig = Context.importConfig('obstacles.txt');

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
    if verbose
        fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', eEffector(1), eEffector(2))
    end

end



