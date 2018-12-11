function practiceExampleImage(window,windowWidth,windowHeight,nextKey,targetPosition,targetArrayPosition,targetPositionList,gridAssignment)
grey = 128;
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
yellow = red + green;
purple = red + blue;
cyan = blue + green;

% --- VARIABLES TO DO WITH FEEDBACK ---
framePenWidth = 6;

% Select specific text font, style and size:
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 16);
%Screen('TextStyle', window, 1+2);

escapeKey = KbName('ESCAPE');


Screen('FillRect', window, grey, [0, 0, windowWidth, windowHeight]);%clear the screen
Screen(window, 'Flip');

parentDirectory = 'Example';
exampleImage = '/EX*.jpg';

exampleIdentityNumList = [1:12];

[exampleImagesPathList, exampleImagesFileList] = folderSearch(parentDirectory,exampleImage);%User-defined function


for i = 1:numel(exampleImagesFileList)%For each image
    exampleImagesPrefixList(i) = str2num(exampleImagesFileList{i}(3:4));%Convert from strings to numbers
end

%Group the images into identities
groupedExampleImagesPrefixList = {}; groupedExampleList = {}; groupedFamiliarImagesPrefixList = {}; groupedFamiliarList = {}; groupedExamplePathList = {}; groupedFamiliarPathList = {};

for i = 1:numel(exampleIdentityNumList)%for each target
    groupedExampleImagesPrefixList{i} = exampleImagesPrefixList(exampleImagesPrefixList == exampleIdentityNumList(i));
    groupedExampleList{i} = exampleImagesFileList(exampleImagesPrefixList == exampleIdentityNumList(i));
    groupedExamplePathList{i} = exampleImagesPathList(exampleImagesPrefixList == exampleIdentityNumList(i));
end
X1 = 1;
Y1 = 2;
incorrectTimePenalty = 4;

for trial = 1:2
            numberOfTargetIdentity = trial;
            whichImage = [1 1];
            trialTargets = 8;
            numberOfFoils = 10;
            
            targetIdentity = {};            
            targetImages = {};
            allTargetImages = {};
            whichFoilImage = [];
            imageSelection = [];
            targetImageNumber = [];
            foilImageNumber = [];
            shuffledCombinedImages = {};
            positionList = [];
            imagePositionIndex = [];
            combinedImages = [];
                       
            
            targetsPerIdentity = trialTargets/numberOfTargetIdentity;
            id = 1;
            
            
                    for n = 1:numberOfTargetIdentity
                        for i = 1:targetsPerIdentity
                            targetImages{n,i} = imread(strcat(groupedExamplePathList{whichImage(n)}{n}, '/', groupedExampleList{whichImage(n)}{n}));
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                    end
                    
                    
                    
                    for i = 3:12
                        foilImages{i-2} = imread(strcat(groupedExamplePathList{whichImage(n)}{i},'/', groupedExampleList{whichImage(n)}{i}));
                    end

            targetIdentity = targetImages(:,1);
            
            combinedImages = {allTargetImages{1:trialTargets},foilImages{1:numberOfFoils}};
            imagePositionIndex = Shuffle(1:numel(combinedImages));

            for i = 1:numel(combinedImages)
                shuffledCombinedImages{i} = combinedImages{imagePositionIndex(i)};
                positionList(:,i) = targetPositionList(:,gridAssignment(i));
            end
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        
        for n = 1:numberOfTargetIdentity
            targetTexture(end+1) = Screen('MakeTexture', window, targetIdentity{n});
        end
        
        for i = 1:numel(combinedImages)       
            allTextures(end+1) = Screen('MakeTexture', window, shuffledCombinedImages{i});
        end
        
                %% -------------- Blank screen (500 ms) ---------------------------
        Screen('FillRect', window ,grey);
        Screen('Flip',window);
        
        
        %% -------------- Blank screen (500 ms) ---------------------------
        
        if numberOfTargetIdentity > 1
            Screen('DrawTextures', window, targetTexture, [], targetArrayPosition);
        else
            Screen('DrawTextures', window, targetTexture, [], targetPosition);
        end
        Screen('Flip',window);
        waitTime = trial*4;    
            
        WaitSecs(waitTime);
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], positionList);
        
        %Image number for demo         

        Screen('Flip',window);
        ShowCursor(0);%Show the cursor on the screen
        [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
        clickedPositionIndex = [];
        tstart = tic;
        lastClickTime = tic;
        distanceTraveled = 0;
        targetCode = 0;
        lastX = theX;
        lastY = theY;
        targetsRemaining = trialTargets;
        incorrectStreak = 0;
        endTrial = 0;
        whichClick = 0;

        while  1
            if endTrial ==1;  break; end
            while ~any(buttons)
                [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
                
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end
                
                if keyIsDown
                    if keyCode(escapeKey); endExperiment = 1; break; end
                    if keyCode(nextKey); endTrial = 1;                        
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(ITI); 
                        break; 
                    end
                end
             end
        
            while any(buttons)
                [theX,theY,buttons] = GetMouse(window);
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end
                
            end

                %Get the position of the mouse and call the coordinates [theX, theY]
            [theX,theY,buttons] = GetMouse(window);
                
                if theX ~= lastX || theY ~= lastY
                    distanceTraveled = distanceTraveled+sqrt((lastX-theX)^2+(lastY-theY)^2);
                    lastX = theX;
                    lastY = theY;
                end

                clickedPositionIndex = find((positionList(1,:) < theX) & (positionList(3,:) > theX) & (positionList(2,:) < theY) & (positionList(4,:) > theY));
                if any(clickedPositionIndex)
                    whichClick = whichClick+1;
                    RTstart = toc(tstart);
                    RTlastClick = toc(lastClickTime);
                    lastClickTime = tic;
                    lastClickPosition(X1,whichClick) = theX;
                    lastClickPosition(Y1,whichClick) = theY;
                    if whichClick == 1
                       distanceTraveledClicks = 0;
                    else
                       distanceTraveledClicks = sqrt((lastClickPosition(X1,whichClick)-lastClickPosition(X1,whichClick-1))^2+(lastClickPosition(Y1,whichClick)-lastClickPosition(Y1,whichClick-1))^2);
                    end

                    if imagePositionIndex(clickedPositionIndex) <= trialTargets %%correct image selected
                        imageSelected = imagePositionIndex(clickedPositionIndex);
                        targetImageSelected = ceil(imageSelected/(trialTargets/numberOfTargetIdentity));
                        targetSelected = whichImage(ceil(imageSelected/(trialTargets/numberOfTargetIdentity)));
                        imagePositionIndex(clickedPositionIndex) = [];
                        allTextures(clickedPositionIndex) = [];%then delete those faces
                        positionList(:,clickedPositionIndex) = [];%and the positions of those faces
                        correct = 1;
                        incorrectStreak = 0;
                        targetsRemaining = targetsRemaining - 1;
                        
                    else %%if incorrect image selected
                        imageSelected = imagePositionIndex(clickedPositionIndex)-trialTargets;
                        correct = 0;
                        incorrectStreak = incorrectStreak+1;
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        Screen('FrameRect', window, red, positionList(:,clickedPositionIndex), framePenWidth);%Then draw a border around those faces
                        DrawFormattedText(window, 'Incorrect!', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);
                        WaitSecs(incorrectTimePenalty);
                        if incorrectStreak >= 6
                            endTrial = 1;
                            DrawFormattedText(window, 'Incorrect Selection - End Trial', 'center', 'center', 255, 60, [], [], 2);
                            Screen('Flip',window);
                        end
                    end
                end
                    if targetsRemaining == 0;%if there are no faces left
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'Complete!', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(0);
                        endTrial = 1;
                    elseif endTrial == 0;                        
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        Screen('Flip',window);
                    end
                                      

                 [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                 clickedPositionIndex = [];
                 correct = -99;
                 imageSelected = [];
                 targetCode = 0;
                 distanceTraveled = 0;

        end%while
        
   end%for trial
end