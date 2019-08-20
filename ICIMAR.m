function ICIMAR(nomDuPlanificateur, nomDuDossierDeConfiguration, varargin)
    % ICIMAR - Code principal d'ICIMAR
    %
    % Syntaxe: ICIMAR(nomDuPlanificateur, nomDuDossierDeConfiguration, axisLimits='auto')
    %
    % Code à exécuter
    %
    %
    % Exemples d'appels:
    %
    % ICIMAR Planner_Critere_Mem_Dist Exemple1                                                 % <-- Fournit seulement le nomDuPlanificateur et le nomDuDossierDeConfiguration (axisLimits = 'auto')
    %
    % ICIMAR('MonPlanificateur', 'MaConfiguration', 'auto');                                   % <-- Utilise explicitement le mode automatique des limites d'axe
    % ICIMAR('MonPlanificateur', 'MaConfiguration', [mesLimitesEnX; mesLimitesEnY]);           % <-- Fournit le nomDuPlanificateur et les limites d'axe
    %
    % ICIMAR('MonPlanificateur', 'MaConfiguration', 'auto', true);                             % <-- Génère des vidéos avec un axe défini automatiquement
    % ICIMAR('MonPlanificateur', 'MaConfiguration', [mesLimitesEnX; mesLimitesEnY], true);     % <-- Génère des vidéos avec des limites d'axes prédéfinies
    %
    %
    %
    % Paramètres obligatoires:
    %
    % param nomDuPlanificateur              : Nom de la fonction de planification utilisée
    % param nomDuDossierDeConfiguration     : Nom du dossier de configuration avec l'architecture du bras, les cibles à atteindre et les obstacles à éviter
    %
    %
    % Paramètres optionnels:
    %
    % param axisLimits                      : Limites d'axes (string pour signifier des valeurs automatiques, array pour des valeurs de configuration)
    %       * Valeur par défaut : 'auto'
    %       * Valeur attendue   : [[x_min, x_max]; [y_min, y_max]]
    %
    % param videoGeneration                 : Booléen indiquant si une vidéo sera générée avec l'exécution (La génération ralentit l'exécution)
    %       * Valeur par défaut : false
    %       * Valeur attendue   : true ou false
    %
    %
    % Paramètres à changer dans le fichier:
    %
    % param automaticChangingAxis           : Booléen pour zoomer sur le bras lorsqu'il se trouve dans le premier quadrant. Ne fonctionne que si `axisLimits` est en mode automatique
    %       * Valeur par défaut : false (Zoom automatique)
    %       * Valeur attendue   : true ou false
    %
    %
    % param verbose                         : Mode bavard / Affiche des messages de progrès ("Architecture importée", "Création du bras", ...)
    %       * Valeur par défaut : true (Affiche l'état de l'exécution)
    %       * Valeur attendue   : true ou false
    %
    %

    % PARAMETRES À CHANGER
    automaticChangingAxis = false; % Axes changeants, selon la préférence (Vincent = true / Clément = false)
    verbose = true; % Mode bavard




    % Vérifie que le nomduPlanificateur et le nomDuDossierDeConfiguration sont donnés dans l'appel
    narginchk(2, 4)

    % PARAMETRES PAR DEFAUT
    axisLimits = 'auto';
    videoGeneration = false;

    try
        axisLimits = varargin{1};
        videoGeneration = varargin{2};
    end

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
    arm = Arm(nArchitecture, 0, 0, maximalSpeeds, plannerHandle, axisLimits, automaticChangingAxis, videoGeneration);

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

    % OUTPUT des valeurs
    if verbose
        eEffector = arm.getEndEffector();
        fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', eEffector(1), eEffector(2))
    end


    % Video Generation
    if videoGeneration
        videoExtension = 'mp4'; % mp4 or avi
        videoFileName = sprintf('%s-%s-%s.%s', char(nomDuDossierDeConfiguration), char(nomDuPlanificateur), char(architectureConfig{1})', videoExtension);
        videoOutputPath = [pwd filesep 'videos' filesep videoFileName];

        switch videoExtension
        case 'mp4'
            genType = 'MPEG-4';
        case 'avi'
            genType = 'Uncompressed AVI';
        end

        videoGenerator = VideoWriter(videoOutputPath, genType);
        open(videoGenerator);
        writeVideo(videoGenerator, arm.getFrames());
        close(videoGenerator);

        if verbose
            disp('Video generee')
        end
    end

end



