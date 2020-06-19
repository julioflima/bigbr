classdef GetBr
%   Produced by Julio Lima (Universidade Federal do Ceará).
%   Query date ranges from Globo Esporte.

    % MANDATORY
    %Just open this to update the database.
    properties

    end
    methods(Static)
        
        function brasileirao = GetBr()
        end
        
        function isUpdated()
            try
                root = "database/table/tableA - " + day(datetime('now'),'dayofyear') + ".csv";
                textscan(fopen(root),"%s %f %f %f %f %f %f %f %f %f %f %f %f");
            catch
                GetBr.getCloudBr();
            end
        end
        
        function getCloudBr()
            clc

            for i = ['a' 'b']
                %Get table of serie i;
                GetBr.getCloudTable(i);

                %Get turns of serie i;
                GetBr.getCloudTurns(i);
            end

             disp('DONE!');
        end

        function store(nameFile,data,dayRequired)
            if ( extractBefore(nameFile,6) == 'table' || extractBefore(nameFile,6) == 'previ')
                nameFile = nameFile + ' - ' + dayRequired;
            end
            root = "database/" + nameFile + ".csv";
            cell2csv(root,data);
            disp('Stored at: ' + root);
        end

        function getCloudTable(serie)
            %Define roots of querys.
            tableURL = strcat('https://us-central1-brother-bet.cloudfunctions.net/table?serie=' , serie);
            disp("The URL's to find table: " + tableURL);

            %Receive the file.
            disp("The received data: Table " + upper(serie));
            tableJSON = urlread(tableURL);
            disp(tableJSON);
            table = jsondecode(tableJSON);

            %Struct to cell
            table = struct2cell(table);

            %Transpose
            table = table';

            %Store table;
            GetBr.store("table/table" +  upper(serie),table,day(datetime('now'), 'dayofyear'));
        end
        
        function [data] = removeEquals(dataIn)
            sData = size(dataIn);
            for j=sData(2):-1:1
                equality = 1;
                for i=1:(sData(1)-1)
                    if(dataIn(i,j) ~= dataIn(i+1,j))
                        equality = 0;
                    end
                end
                if(equality)
                    dataIn(:,j) = [];
                end
            end
            data = dataIn;
        end

        function getCloudTurns(serie)
            for turns = 1:38
                %Define roots of querys.
                tableURL = strcat('https://us-central1-brother-bet.cloudfunctions.net/updateTurn?serieTurn=', serie,'-',  num2str(turns));
                disp("The URL's to find turns: " + tableURL);

                %Receive the file.
                disp("The received data: Serie " + upper(serie) + " - Turn " + num2str(turns));
                tableJSON = urlread(tableURL);
                disp(tableJSON);
                table = jsondecode(tableJSON);

                %Struct to cell
                table = struct2cell(table);

                %Transpose
                table = table';

                %Store table;
                GetBr.store("turns/turns" + upper(serie) + ' - ' + num2str(turns),table,day(datetime('now'), 'dayofyear'));
            end
        end
        
        function [data] = getTable(serie,day)
            nameFile = "table" + upper(serie) + ' - ' + day;
            root = "database/table/" + nameFile + ".csv";
            %disp("Get file at: " + root);
            fileID = fopen(root);
            data = textscan(fileID,"%s %f %f %f %f %f %f %f %f %f %f %f %f","Delimiter",',',"TreatAsEmpty",'');
        end

        function [data] = getTurns(serie,turns)
            nameFile = "turns" + upper(serie) + ' - ' + turns;
            root = "database/turns/" + nameFile + ".csv";
            %disp('Get file at: ' + root);
            fileID = fopen(root);
            data = textscan(fileID,"%s %f %s %f","Delimiter",',',"TreatAsEmpty",'');
        end

        function [data] = getBases(dayRequired,s)
            if(isstring(dayRequired))
             dayRequired = day(datetime('now'),'dayofyear');
            end
            
            tableNames = GetBr.getTable(s,dayRequired);
            tablePoints = cell2mat(tableNames(2:13));
            tableNames = tableNames{1};

            data.points = [,];
            data.result = [,];

            for j = 1:38
                turn = GetBr.getTurns(s,j);
                for k = 1:10
                    if(~(isnan(turn{2}(k)) || isnan(turn{4}(k))))
                        %Get result.
                        index = size(data.result,1) + 1;
                        resultGoals = turn{2}(k) - turn{4}(k);
                        if resultGoals > 0
                            data.result(index,:) = [1 0 0];
                        else
                            if resultGoals == 0
                                data.result(index,:) = [0 1 0];
                            else
                                data.result(index,:) = [0 0 1];
                            end
                        end
                        %Get points of result.
                        indexP = find(contains(tableNames,turn{1}(k)));
                        indexG = contains(tableNames,turn{3}(k));
                        pointsP = tablePoints(indexP,:);
                        pointsG = tablePoints(indexG,:);
                        data.points(index,:) = pointsP - pointsG;
                    end
                end
            end
        end
        
    end
end
