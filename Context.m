classdef Context < handle
    % Context  Base of the execution of the code
    % All the functions to use in the code
    %
    %
    % Member Methods:
    %    importConfig               - Decide whether the config file should be created or opened
    %    createConfigFile           - Generate a config file
    %    readConfig                 - Open the config file and return the contents
    %    validateContents           - Verify that the data is there and well formatted
    %    generateArchitectureConfig - Gemerate an architecture config file
    %    generateTargetsConfig      - Gemerate a target config file
    %    generateObstaclesConfig    - Gemerate an obstacle config file
    %    handlizePlannerFilename    - Creates a function handle from string "funcname.m"

    % Create or import from configuration file
    methods (Static)
        function out = importConfig(configFilename)
            % importConfig  Decide whether the config file should be created or opened
            %   Feature implemented for those who delete the config file
            %   Checks if the config file is in the folder
            configFilePath = [pwd filesep configFilename];
            if ~isfile(configFilePath)
                Context().createConfigFile(configFilename);
            end
            configContents = Context().readConfig(configFilePath);
            if configFilename == "cibles.txt"
                Context().validateContents(configContents{1}, configFilePath);
            else
                Context().validateContents(configContents, configFilePath);
            end
            out = configContents;
        end

        function plannerHandle = handlizePlannerFilename(plannerFileName)
            % handlizePlannerFilename  Creates a function handle from string "funcname.m"
            %   Feature implemented so that we can add function name in targets configuration files
            if isfile([pwd filesep plannerFileName])
                plannerHandle = eval(['@' plannerFileName(1:end-2)]);
            else
                cibleFilename = [pwd filesep 'cibles.txt'];
                ME = MException('MATLAB:wrongFilename', ...
                'La fonction de planification definie dans le fichier <a href="matlab: open(''%s'')">%s</a> est inexistante.', cibleFilename, cibleFilename);
                throw(ME)
            end
        end
    end

    methods (Access=private)
        function createConfigFile(~, configFilename)
            % createConfigFile  Gemerate a config file
            %   Feature implemented for those who delete the config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot
            switch configFilename
                case "architecture.txt"
                    Context().generateArchitectureConfig();
                case "cibles.txt"
                    Context().generateTargetsConfig();
                case "obstacles.txt"
                    Context().generateObstaclesConfig();
            end

        end

        function out = readConfig(~, configFilePath)
            % readConfig  Open the config file and return the contents
            %   Return the data inside the configuration file
            %   Looks for float or for what would be floats if this code was written in C.

            % Get strFormat and numHeaderLines from configFilePath
            switch configFilePath
                case [pwd filesep 'architecture.txt']
                    strFormat = '%s %f %f %f\r\n';
                    numHeaderLines = 12;
                case [pwd filesep 'cibles.txt']
                    strFormat = '%f %f %f\r\n';
                    numHeaderLines = 25;
                case [pwd filesep 'obstacles.txt']
                    strFormat = '%f %f %f\r\n';
                    numHeaderLines = 11;
            end

            % Lecture du fichier de configuration
            fileID = fopen(configFilePath, 'r');
            configContents = textscan(fileID, strFormat, 'HeaderLines', numHeaderLines);
            fclose(fileID);

            % Récupération du Planner Filename
            if configFilePath == string([pwd filesep 'cibles.txt'])
                fid = fopen(configFilePath);
                plannerFileName = textscan(fid,'%s',1,'delimiter','\n', 'HeaderLines',5);
                frewind(fileID);
                maximalSpeeds = textscan(fid,'%f %f %f',1,'delimiter','\n', 'HeaderLines',13);
                fclose(fid);
                out = {configContents, plannerFileName, maximalSpeeds};
            else
                out = configContents;
            end
        end

        function validateContents(~, configContents, configFilePath)
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
                case [pwd filesep 'architecture.txt']
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
                    case [pwd filesep 'architecture.txt']
                        noms_colus = {"de type de joint", "de longueur", "de largeur", "d'angle"};
                    case [pwd filesep 'cibles.txt']
                        noms_colus = {"de x", "de y", "d'angle"};
                    case [pwd filesep 'obstacles.txt']
                        noms_colus = {"de x", "de y", "de rayon"};
                end
                nom_colu = noms_colus{I};
                ME = MException('MATLAB:missingValue', ...
                    'Il manque des valeurs %s dans le fichier de configuration', nom_colu);
                throw(ME)
            end
        end
    end

    % TODO: UPDATE CONFIG FILES
    % Create configuration files
    methods (Access=private)
        function generateArchitectureConfig(~)
            % generateArchitectureConfig  Gemerate an architecture config file
            %   Feature implemented for those who delete the architecture config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            architectureConfigFilePath = [pwd filesep 'architecture.txt'];

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

        function generateTargetsConfig(~)
            % generateTargetsConfig  Gemerate a target config file
            %   Feature implemented for those who delete the target config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            targetConfigFilePath = [pwd filesep 'cibles.txt'];

            targetConfigFileContents = "Configuration des cibles a atteindre avec le manipulateur seriel" + newline;
            targetConfigFileContents = targetConfigFileContents + "==============================================" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "Nom du fichier de planification apres la ligne de '-' (Ex: Planner.m)" + newline;
            targetConfigFileContents = targetConfigFileContents + "--------------------------------" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "==============================================" + newline;
            targetConfigFileContents = targetConfigFileContents + "Entrez vos parametres a partir de la ligne 18, apres la ligne de '*'" + newline;
            targetConfigFileContents = targetConfigFileContents + "" + newline;
            targetConfigFileContents = targetConfigFileContents + "Utilisez la syntaxe suivante :" + newline;
            targetConfigFileContents = targetConfigFileContents + "<x> <y> <angle>" + newline;
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

        function generateObstaclesConfig(~)
            % generateObstaclesConfig  Gemerate an obstacle config file
            %   Feature implemented for those who delete the obstacle config file
            %   If you are one of those, the program will create a new config file in the folder
            %   The program will then prompt you to fulfill it with the data of the robot

            obstacleConfigFilePath = [pwd filesep 'obstacles.txt'];

            obstacleConfigFileContents = "Configuration des obstacles a eviter avec le manipulateur seriel" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "==============================================" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Entrez vos parametres a partir de la ligne 12, apres la ligne de '*'" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Utilisez la syntaxe suivante :" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "<x> <y> <rayon>" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "" + newline;
            obstacleConfigFileContents = obstacleConfigFileContents + "Par exemple, pour un obstacle de rayon 3 centré au point (2, 4) :" + newline;
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


