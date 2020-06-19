function [ data ] = getBr()
%   Produced by Julio Lima (Universidade Federal do Ceará).
%   Query date ranges from Globo Esporte.

    % MANDATORY
    %Just open this to update the database.

    clc
    
    for i = ['a' 'b']
        %Get table of serie i;
        getTable(i);

        %Get turns of serie i;
        getTurns(i);
    end
    
     disp('DONE!');

end

function store(nameFile,data)
    if ( extractBefore(nameFile,6) == 'table')
        nameFile = nameFile + ' - ' + day(datetime('now'),'dayofyear');
    end
    root = "database/" + nameFile + ".csv";
    cell2csv(root,data);
    disp('Stored at: ' + root);
end

function getTable(serie)
    %Define roots of querys.
    tableURL = strcat('https://us-central1-brother-bet.cloudfunctions.net/tabela?serie=' , serie);
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
    store("table" +  upper(serie),table);
end

function getTurns(serie)
    for turns = 1:38
        %Define roots of querys.
        tableURL = strcat('https://us-central1-brother-bet.cloudfunctions.net/rodada?serieRodada=', serie,'-',  num2str(turns));
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
        store("turns" + upper(serie) + ' - ' + num2str(turns),table);
    end
end


