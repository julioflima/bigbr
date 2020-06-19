%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%       Universidade Federal do Cear�                               %
%       Class: Intelig�ncia Computacional                           %
%       Student: Julio Cesar Ferreira Lima                          %
%       Professor: Jarbas Joaci de Mesquita S� Junior               %
%       Enrrollment: 393849                                         %
%       Homework: Least Squares Multiple and KNN Classificators     %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This structure was used to maintain the compatibility with all versions.
%In the main of file could be called not just the main but each function.
function Code_3()
    
    %Call the main function of simulation.
    main()

end

function main()
    %Defining variables, out of scope to test.
    tests = 1;
    
    while tests > .5
        %Cleaning IDE.
        close all;
        clc;

        %Loading the resource of data.
        load database_pap.dat
        base = database_pap';

        %Defining variables, out of scope to test.
        order = 255;

        %Create the matrix of Class Results.
        %Considering the firsts 242 belongings to the classe 1.
        %And the rest of them belongings to the class 2.
        classesResult= [ones(242,1) zeros(242,1);zeros(675,1) ones(675,1)]';

        %Receiving by user the question.
        while order < 1 || order > 2
            %Seting the question to test .
            disp('1 - Least Squares Multiple Classificator: ');
            disp('2 - KNN Classificator: ');
            order= input('Type the question: ');
            order = int8(order);
        end

        %Choicing the questions to avaluate.
        switch order ~=0
            case order == 1
                %Cleaning IDE.
                close all;
                clc;
                fprintf('Tax classification awards, Least Squares Multiple with Leave One Out: %.4f%%\n',MS_leave_one_out(base,classesResult))
                disp('...');
            case order == 2
                %Cleaning IDE.
                close all;
                clc;
                k = input('What K-Nearest Neighbourhood you will gonna use?: ');
                percentTraining = input('What percent you will gonna use for training?: ');
                loops = input('How many time do you wanna repeat this?: ');
                matches = 0;
                times = 0;
                awards = 0;
                for i=1:loops
                    clc;
                    %Show the percentage already executed.
                    fprintf('Wait for it: %d%%\n',100*i/loops)
                    fprintf('Tax classification awards, KNN with Hold Out: %G%%\n',awards)
                    %Receive the matches and calculate the awards.
                    [result1 result2 ]= knn(k,base, classesResult,percentTraining);
                    clc;
                    matches = matches + result1;
                    times = times + result2;
                    awards = (100*matches/times);
                end
                fprintf('Tax classification awards, KNN with Hold Out: %G%%\n',awards)
                disp('...');
        end
        
        %Requesting with the user wanna try one more time.
        request = input('Do you wanna try one more test? (y\\n): ','s');
        tests = strcmp(request,'y');
    end
end

function classificationTax = MS_leave_one_out(base, supervisedClass)    
    %Take the number of samples of base.
    widghtBase = size(base,2);
    
    %Defining match count variable, to count the awards.
    matchCount = 0;
    
    %Interact the number of base widht.
    for x=1:widghtBase
        %Leaving out the sample of base.
        trainingBase=base;
        trainingBase(:,x)=[];
        %Leaving out the sample of result.
        resultTraining=supervisedClass;
        resultTraining(:,x)=[];
        
        %Applying the Multiple Regression Method to obtain classificator matrix A.
        classificator=(resultTraining*trainingBase')*(trainingBase*trainingBase')^(-1);
        
        %Testing the leaved one.
        result=(classificator*base(:,x));
        
        %Create base of results base in test.
        filteredResult = [0;0];
        
        %The bigger one correspond to the result, if bigger put value 1.
        if result(1)>result(2)
            filteredResult(1)=1;
        else    
            filteredResult(2)=1;
        end
        %If result and test were equals add one to the match count.
        if filteredResult==supervisedClass(:,x); 
            matchCount=matchCount+1; 
        end
    end
    %Return the classification tax;
    classificationTax=100*matchCount/widghtBase; 
end
