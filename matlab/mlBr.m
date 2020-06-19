%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   
%  Autor: Julio Lima                                                
%  Query date ranges from Globo Esporte.                            
%  Autor: David Coelho                                              
%  Machine Learning Improvement.                                    
%                                                                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Model to Tables:
%        1: Nome
%        2: Posicao
%        3: Bonus (corresponds to the next championchip that the team will play)
%        4: Pontos
%        5: Jogos
%        6: Vitorias
%        7: Empates
%        8: Derrotas
%        9: Gols Pro
%        10: Gols Contra
%        11: Saldo Gols
%        12: Percentual
%        13: Ultimos Jogos (corresponds the points accumulated in the 5 past games)
%
%    Model to Turns:
%        1: Mandante
%        2: Placar Mandante
%        3: Visitante
%        4: Placar Visitante
%
%    To read table of Serie A call :
%       tableA = getBr.getTable('a',day);
%
%    The variable day, corresponds to the day of year:
%       day = day(datetime('now'),'dayofyear');
%       table = getBr.getTable('a',day(datetime('now'),'dayofyear'))
%
%    To read table of Serie A call:
%       tableA = getBr.getTable('a',day).
%
%    You could read like this too:
%       tableA = getBr.getTable('a',264)
%
%    To read turn 1 of Serie A call:
%        turn =  getBr.getTurns('a',1);
%
%    To access name at table of team 1:
%       nameATableA = tableA{1,1}(1);
%
%    To access position at table A  of team 1:
%       posATableA = tableA{1,2}(1);
%
%    To access name at table of team 2:
%       nameATableA = tableA{1,1}(2);
%
%    To access position at table A  of team 2:
%       posATableA = tableA{1,2}(2);
%
%    To access principal name at serie A turn 1 game 1:
%       nameATableA = turnsA1{1,1}(1);
%
%    To access principal goals at serie A turn 1:
%       posATableA = turnsA1{1,2}(1);
%
%    To access guest name at serie A turn 1 game 1:
%       nameATableA = turnsA1{1,3}(1);
%
%    To access guest goals at serie A turn 1:
%       posATableA = turnsA1{1,4}(1);
%
%    To read a table of Serie A at day 264 of year.
%       tableA = getBr.getTable('a',264);
%
%    To read a table of Serie B at day 264 of year.
%       tableB = getBr.getTable('b',264);
%
%    To read To rgame 1 of turn 1 at Serie A.
%       turnsA1 = getBr.getTurns('a',38);
%
%    To read a game 1 of turn 1 at Serie B.
%       turnsB1 = getBr.getTurns('b',1);

% Init configurations.
function [ data ] = mlBr()   
    %Clean prompt.
    clc
    
    dayRequired = "today";
    
    %Supress warnings.
    warning('off','all');
    warning;
    
    %Create GetBr object.
    getBr = GetBr();
    
    %Verify if is updated.
    getBr.isUpdated();
    
    %Get bases points and results from today and Serie A.
    dataOn.A = getBr.getBases(dayRequired,'a');
    %Get bases points and results from today and Serie B.
    dataOn.B = getBr.getBases(dayRequired,'b');
    
    %Remove if all paremeters are equals.
    dataOn.A.points = getBr.removeEquals(dataOn.A.points);
    dataOn.B.points = getBr.removeEquals(dataOn.B.points);
    
    % Main of your ML.
    data = mainML(dataOn);
end

% Put your ML Code in below.
function [ data ] = mainML(dataIn)   

    dayRequired = "today";
    
    %Normalize by David Coelho.
    OPTION.norm = 3;
    %Serie A
    DATA.input = dataIn.A.points';
    normalized = normalize(DATA,OPTION);
    dataIn.A.points = normalized.input';
    %Serie B
    DATA.input = dataIn.B.points';
    normalized = normalize(DATA,OPTION);
    dataIn.B.points = normalized.input';
       
    %Test OLS prevision.
    %Create OLS object.
    ols = OLS();
    data.A = ols.gameTest(dataIn.A,'a',10,'s');
    %data.B = ols.gameTest(dataIn.B,'b'10,'s');

end