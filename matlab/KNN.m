classdef KNN
%   Produced by Julio Lima (Universidade Federal do Ceará).
%   K - Nearest Neighbors.

    properties

    end
    methods(Static)
        
        function classify = KNN()
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
    end
end
