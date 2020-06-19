function [ data ] = mlBr()
%   Produced by Julio Lima.
%   Query date ranges from Globo Esporte.
%   Machine Learning added by David Coelho.
    
    % MANDATORY
	%{
        Model to Tables:
            1: Nome
            2: Posicao
            3: Bonus (corresponds to the next championchip that the team will play)
            4: Pontos
            5: Jogos
            6: Vitorias
            7: Empates
            8: Derrotas
            9: Gols Pro
            10: Gols Contra
            11: Saldo Gols
            12: Percentual
            13: Ultimos Jogos (corresponds the points accumulated in the 5 past games)
        
        Model to Turns:
            1: Mandante
            2: Placar Mandante
            3: Visitante
            4: Placar Visitante
                
        To read table:
            Ex: Serie A call getTable('a',day).
            The variable day, corresponds to the day of year:
            day = day(datetime('now'),'dayofyear');
            table = getTable('a',day(datetime('now'),'dayofyear'))
            To read table of Serie A call getTable('a',day).
            But you could read getTable('a',260)
    
        To read turn:
            Ex: Turn 1 of Serie A call:
            turn =  getTurns('a',1)
    
        To access name at table of team 1:
        nameATableA = tableA{1,1}(1)
    
        To access position at table A  of team 1:
        posATableA = tableA{1,2}(1)
    
        To access name at table of team 2:
        nameATableA = tableA{1,1}(2)
    
        To access position at table A  of team 2:
        posATableA = tableA{1,2}(2)
    
        To access principal name at serie A turn 1 game 1:
        nameATableA = turnsA1{1,1}(1)
    
        To access principal goals at serie A turn 1:
        posATableA = turnsA1{1,2}(1)
    
        To access guest name at serie A turn 1 game 1:
        nameATableA = turnsA1{1,3}(1)
    
        To access guest goals at serie A turn 1:
        posATableA = turnsA1{1,4}(1)
    
	%}
    
    clc
    
    %Verify if is updated
    isUpdated();
    
    %Read table of Serie A at day 263 of year.
    tableA = getTable('a',263);
    
    %Read table of Serie B at day 263 of year.
    tableB = getTable('b',263);
    
    %Read game 1 of turn 1 at Serie A.
    turnsA1 = getTurns('a',1);
    
    %Read game 1 of turn 1 at Serie B.
    turnsB1 = getTurns('b',1);
        
end

function [data] = getTable(serie,day)
    nameFile = "table" + upper(serie) + ' - ' + day;
    root = "database/" + nameFile + ".csv";
    disp("Get file at: " + root);
    fileID = fopen(root);
    data = textscan(fileID,"%s %d %d %d %d %d %d %d %d %d %d %f %d","Delimiter",',',"TreatAsEmpty",' ');
end

function [data] = getTurns(serie,turns)
    nameFile = "turns" + upper(serie) + ' - ' + turns;
    root = "database/" + nameFile + ".csv";
    disp('Get file at: ' + root);
    fileID = fopen(root);
    data = textscan(fileID,"%s %d %s %d","Delimiter",',',"TreatAsEmpty",' ');
end

function [data] = getBases(day,firstTurn,lastTurn)
    
end

function isUpdated()
    try
        root = "database/tableA - " + day(datetime('now'),'dayofyear') + ".csv";
        textscan(fopen(root),"%s %d %d %d %d %d %d %d %d %d %d %f %d");
    catch
        getBr();
    end
end