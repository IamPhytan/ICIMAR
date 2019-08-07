classdef Context < handle
    % Context  Base of the execution of the code
    % All the functions to use in the code
    %
    %
    % Context Properties:
    %    configFolderName  - Configuration foldername
    %
    %
    %
    % Context Setters and Getters:
    %    setConfigFolderName  - Set the configuration folder name
    %    getConfigFolderName  - Get the configuration folder name
    %
    %
    %
    % Context Methods:
    %    importConfig               - Decide whether the config file should be created or opened
    %    createConfigFile           - Generate a config file
    %    readConfig                 - Open the config file and return the contents
    %    validateContents           - Verify that the data is there and well formatted
    %    generateArchitectureConfig - Gemerate an architecture config file
    %    generateTargetsConfig      - Gemerate a target config file
    %    generateObstaclesConfig    - Gemerate an obstacle config file
    %    handlizePlannerFilename    - Creates a function handle from string "funcname.m"

    properties (SetAccess = private, GetAccess = public)
        configFolderName;
    end

    % Constructor
    methods
        function thisContext = Context(config_foldername)
            % Construct an instance of context
            folderPath = [pwd filesep 'configurations' filesep char(config_foldername)];
            if ~isfolder(folderPath)
                mkdir(folderPath)
            end
            thisContext.configFolderName = char(config_foldername);
        end
    end

    % Getters and setters
    methods
        function setConfigFolderName(thisContext, value)
            % setConfigFolderName  Set the configuration folder name
            %   Set configFolderName with a value
            thisContext.configFolderName = value;
        end
        function out = getConfigFolderName(thisContext)
            % getConfigFolderName  Get the configuration folder name
            %   Return the value of configFolderName
            out = thisContext.configFolderName;
        end
    end

    % Create or import from configuration file
    methods
        function out = importConfig(thisContext, configFilename)
            % importConfig  Decide whether the config file should be created or opened
            %   Feature implemented for those who delete the config file
            %   Checks if the config file is in the folder
            configFilePath = [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep configFilename];
            if ~isfile(configFilePath)
                thisContext.createConfigFile(configFilename);
            end
            configContents = thisContext.readConfig(configFilePath);
            if configFilename == "cibles.txt"
                thisContext.validateContents(configContents{1}, configFilePath);
            else
                thisContext.validateContents(configContents, configFilePath);
            end
            out = configContents;
        end
    end

    methods (Static)
        function plannerHandle = handlizePlannerFilename(plannerFileName)
            % handlizePlannerFilename  Creates a function handle from string "funcname.m"
            %   Feature implemented so that we can add function name in targets configuration files
            if isfile([pwd filesep plannerFileName '.m'])
                plannerHandle = eval(['@' plannerFileName]);
            else
                ME = MException('MATLAB:wrongFilename', ...
                'La fonction de planification ''%s'' est inexistante.', [plannerFileName '.m']);
                throw(ME)
            end
        end
    end

    methods (Access=private)
        function createConfigFile(thisContext, configFilename)
            % createConfigFile  Gemerate a config file
            %   Feature implemented for those who delete the config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot
            switch configFilename
                case "architecture.txt"
                    thisContext.generateArchitectureConfig();
                case "cibles.txt"
                    thisContext.generateTargetsConfig();
                case "obstacles.txt"
                    thisContext.generateObstaclesConfig();
            end

        end

        function out = readConfig(thisContext, configFilePath)
            % readConfig  Open the config file and return the contents
            %   Return the data inside the configuration file
            %   Looks for float or for what would be floats if this code was written in C.

            % Get strFormat and numHeaderLines from configFilePath
            switch configFilePath
                case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'architecture.txt']
                    strFormat = '%s %f %f %f\r\n';
                    numHeaderLines = 12;
                case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'cibles.txt']
                    strFormat = '%f %f %f\r\n';
                    numHeaderLines = 19;
                case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'obstacles.txt']
                    strFormat = '%f %f %f\r\n';
                    numHeaderLines = 11;
            end

            % Lecture du fichier de configuration
            fileID = fopen(configFilePath, 'r');
            configContents = textscan(fileID, strFormat, 'HeaderLines', numHeaderLines);
            fclose(fileID);

            % Récupération des maximalSpeeds
            if configFilePath == string([pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'cibles.txt'])
                fid = fopen(configFilePath);
                maximalSpeeds = textscan(fid,'%f %f %f',1,'delimiter','\n', 'HeaderLines',7);
                fclose(fid);
                out = {configContents, maximalSpeeds};
            else
                out = configContents;
            end
        end

        function validateContents(thisContext, configContents, configFilePath)
            % validateContents  Verify that the data is there and well formatted
            %   As the data is user input, it is important to validate it using data validation techniques.
            %   Since MATLAB can't handle strings conveniently, the code for this part is long

            % Vérifie la présence de données dans le fichier
            if numel(configContents{1}) == 0
                ME = MException('MATLAB:missingData', ...
                'Il manque des donnees dans le fichier de configuration (<a href="matlab: open(''%s'')">%s</a>)', configFilePath, configFilePath);
                throw(ME)
            end

            % Verifie si toutes les colonnes ont le même nombre de valeurs
            num_colonnes = numel(configContents);
            switch configFilePath
                case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'architecture.txt']
                    desiredNumColumns = 4;
                otherwise
                    desiredNumColumns = 3;
            end

            if num_colonnes ~= desiredNumColumns
                ME = MException('MATLAB:tooMuchData', ...
                'Une ligne du fichier de configuration a trop de donnees');
                throw(ME)
            end

            % Récupère le nombre de valeurs réelles dans chaque colonne
            num_elems = zeros(1, num_colonnes);
            for ii=1:numel(configContents)
                if iscellstr(configContents{ii})
                    configContents{ii} = double(char(configContents{ii}));
                end
                num_elems(ii) = sum(~isnan(configContents{ii}));
            end

            % Si le nombre de valeurs non réelles dans une colonne est différent du restant
            if ~(range(num_elems) == 0)
                [~, I] = min(num_elems);
                switch configFilePath
                    case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'architecture.txt']
                        noms_colus = {"de type de joint", "de longueur", "de largeur", "d'angle"};
                    case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'cibles.txt']
                        noms_colus = {"de x", "de y", "d'angle"};
                    case [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'obstacles.txt']
                        noms_colus = {"de x", "de y", "de rayon"};
                end
                nom_colu = noms_colus{I};
                ME = MException('MATLAB:missingValue', ...
                    'Il manque des valeurs %s dans le fichier de configuration', nom_colu);
                throw(ME)
            end
        end
    end

    % Create configuration files
    methods (Access=private)
        function generateArchitectureConfig(thisContext)
            % generateArchitectureConfig  Gemerate an architecture config file
            %   Feature implemented for those who delete the architecture config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            architectureConfigFilePath = [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'architecture.txt'];

            architectureConfigFileContents = "Configuration de l'architecture et des membres du manipulateur seriel" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "==============================================" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "Entrez vos parametres a partir de la ligne 13, apres la ligne de '*'" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "Utilisez la syntaxe suivante avec 'R' pour symboliser un joint rotorique et 'P' pour un joint prismatique :" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "<type-de-joint> <longueur> <largeur> <angle>" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "Par exemple, pour un membre long de 5 unites, large de 2 unites, avec un angle de 60 degres" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "par rapport au membre precedent et relie a celui-ci par un joint rotorique  :" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "R 5 2 60" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "" + newline;
            architectureConfigFileContents = architectureConfigFileContents + "******************************************" + newline;
            architectureConfigFileContents = architectureConfigFileContents + newline + newline + newline + newline + newline + newline;

            fid = fopen(architectureConfigFilePath, 'wt');
            fprintf(fid, architectureConfigFileContents);
            fclose(fid);

            ME = MException('MATLAB:missingData', ...
            ['Fichier de configuration manquant', newline, ...
            'Veuillez ajouter vos valeurs au fichier de configuration qui fut cree au chemin suivant: <a href="matlab: open(''%s'')">%s</a>'], architectureConfigFilePath, architectureConfigFilePath);
            throw(ME)
        end

        function generateTargetsConfig(thisContext)
            % generateTargetsConfig  Gemerate a target config file
            %   Feature implemented for those who delete the target config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            targetConfigFilePath = [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'cibles.txt'];

            targetConfigFileContents = "Configuration des cibles a atteindre avec le manipulateur seriel" + newline;
            targetConfigFileContents = targetConfigFileContents + "==============================================" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "Entrez les vitesses cartesiennes maximales de l'organe terminal, apres la ligne de '+'" + newline;
            targetConfigFileContents = targetConfigFileContents + "Utilisez la syntaxe suivante :" + newline;
            targetConfigFileContents = targetConfigFileContents + "<vitesse-maximale-en-x> <vitesse-maximale-en-y> <vitesse-angulaire-maximale-en-degres>" + newline;
            targetConfigFileContents = targetConfigFileContents + "++++++++++++++++++++++++++++++++" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "==============================================" + newline;
            targetConfigFileContents = targetConfigFileContents + "Entrez vos parametres a partir de la ligne 20, apres la ligne de '*'" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "Utilisez la syntaxe suivante :" + newline;
            targetConfigFileContents = targetConfigFileContents + "<x> <y> <angle-en-degres>" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "Par exemple, pour une cible au point (4, 7) a atteindre avec un angle de 35 degres :" + newline;
            targetConfigFileContents = targetConfigFileContents + "4 7 35" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "******************************************" + newline;
            targetConfigFileContents = targetConfigFileContents + newline + newline + newline + newline + newline + newline;

            fid = fopen(targetConfigFilePath, 'wt');
            fprintf(fid, targetConfigFileContents);
            fclose(fid);

            ME = MException('MATLAB:missingData', ...
            ['Fichier de configuration manquant', newline, ...
            'Veuillez ajouter vos valeurs au fichier de configuration qui fut cree au chemin suivant: <a href="matlab: open(''%s'')">%s</a>'], targetConfigFilePath, targetConfigFilePath);
            throw(ME)
        end

        function generateObstaclesConfig(thisContext)
            % generateObstaclesConfig  Gemerate an obstacle config file
            %   Feature implemented for those who delete the obstacle config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            obstacleConfigFilePath = [pwd filesep 'configurations' filesep thisContext.getConfigFolderName() filesep 'obstacles.txt'];

            obstacleConfigFileContents = "Configuration des obstacles a eviter avec le manipulateur seriel" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "==============================================" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Entrez vos parametres a partir de la ligne 12, apres la ligne de '*'" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Utilisez la syntaxe suivante :" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "<x> <y> <rayon>" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Par exemple, pour un obstacle de rayon 3 centre au point (2, 4) :" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "2 4 3" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "******************************************" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + newline + newline + newline + newline + newline + newline;

            fid = fopen(obstacleConfigFilePath, 'wt');
            fprintf(fid, obstacleConfigFileContents);
            fclose(fid);

            ME = MException('MATLAB:missingData', ...
            ['Fichier de configuration manquant', newline, ...
            'Veuillez ajouter vos valeurs au fichier de configuration qui fut cree au chemin suivant: <a href="matlab: open(''%s'')">%s</a>'], obstacleConfigFilePath, obstacleConfigFilePath);
            throw(ME)
        end
    end
end


