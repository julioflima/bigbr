%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%       Universidade Federal do Ceará                               %
%       Class: Inteligência Computacional                           %
%       Student: Julio Cesar Ferreira Lima                          %
%       Professor: Jarbas Joaci de Mesquita Sá Junior               %
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

function [matchCount widthTest ] = knn (k,base, supervisedClass,trainingPercent)    
    %Initialize match;
    matchCount = 0;
    
    %Get the height and the widht of base.
    height = size(base,1);
    width = size(base,2);
    %Make the calculo for training.
    widthTraining = cast( width*trainingPercent/100 , 'uint16');
    widthTest = width - widthTraining;
    %Receive the randomize bases and the before position for the awards.
    [baseTraining list_training baseTest list_test ] = getBases(height,width,widthTraining, base);

    
    %Create a empty list to add the k-nearest neighbourhood not used in training base.
    %And the best k-distances;
    k_nearest = ones(k,2,widthTest)*(-1);
    
    %Loop to compare all the test samples.
    for j = 1:widthTest
        %Loop to get the distance until to all training samples.
        for i = 1:widthTraining
            rightNowDist = sqrt(sum((minus(baseTest(:,j),baseTraining(:,i)).^2)));
            %Loop to verify if the actual distance is one of k-nearsts.
            for n = 1:k
                if(k_nearest(n,2,j) == -1)
                    k_nearest(n,2,j) = rightNowDist;
                    k_nearest(n,1,j) = list_training(i);
                else
                    if(rightNowDist < k_nearest(n,2,j))
                        k_nearest(n,2,j) = rightNowDist;
                        k_nearest(n,1,j) = list_training(i);
                        break;
                    end
                end
            end
            %Sort itens to update just in case of a least one.
            k_nearest(:,:,j) = sortrows(k_nearest(:,:,j),2);
        end
    
        %Result Test.
        %Create base of results base in test.
        filteredResultTest = [0;0];
        %The bigger one correspond to the result, if bigger put value 1.
        positionTest = list_test(j);
        %disp(base(positionTest));
        if supervisedClass(1,positionTest)>supervisedClass(2,positionTest)
            filteredResultTest(1)=1;
        else    
            filteredResultTest(2)=1;
        end

        %Result KNN.
        %The bigger one correspond to the result, if bigger put value 1.
        %Create base of results base in training.
        filteredResultKNN = zeros(k,2);
        for n = 1:k
           positionTraining = k_nearest(n,1,j);
           if supervisedClass(1,positionTraining)>supervisedClass(2,positionTraining)
                filteredResultKNN(n,1)= 1;
           else    
                filteredResultKNN(n,2)= 1;
           end
        end

        %If result and test were equals fo most frequency class in KNN, will add one to the match count.
        if filteredResultTest' == mode(filteredResultKNN,1); 
            matchCount = matchCount+1; 
        end
    end
end


function [baseTraining list_training baseTest list_test ] = getBases(height,width,widthTraining, base)
    %Create a empty list to add the position already used in training base.
    list_training = zeros(1,widthTraining);
    %Create a empty list to add the position not used in training base.
    list_test = zeros(1,width - widthTraining);;
    %Define training base and test base.
    baseTraining = zeros(height,widthTraining);
    baseTest =  zeros(height,width - widthTraining);
    %Interact the number of training widht.
    for i = 1:widthTraining
        %Randomize a position in base.
        randomPos = cast(1+rand()*(width-1),'uint16');
        %If the positions was not generated, insert them at training base.
        %And aloc the position.
        while(list_training(list_training==randomPos))
            randomPos = cast(1+rand()*(width-1),'uint16');
            %disp('repeated item');
        end
            %disp('inserted item');
            baseTraining(:,i) = base(:,i);
            list_training(i) = randomPos;
    end
    n = 0;
    %Interact the number of base widht.
    for i = 1:width
        %Put all positions that was not in training base to test base.
        if(list_training(list_training==i))
            %disp('inserted item');
        else
            n =n + 1;
            baseTest(:,n) = base(:,i);
            list_test(n) = i;
        end
    end
end