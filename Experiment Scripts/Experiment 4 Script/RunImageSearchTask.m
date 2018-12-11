clear all
close all

%function memoryTask
rand('twister',sum(100*clock));%sorts out matlab randomisation problem

%% ------------------------------------------------------------------------
%Get studentNumber, age, and gender by asking for input
[studentNumber, age, G, gender] = getPptInfo;%User-defined function
pptNo = studentNumber;%Define participant number
time = getTime; %Get the current time in the format 'DD-MM_HH-MM' (user-defined function)

%% ------------------- Opening the screen ---------------------------------

Screen('Preference', 'SkipSyncTests', 1);
%PsychJavaTrouble;%UNCOMMENT WHEN GET BACK TO WORK

% Opening a new window to display stimuli
screens=Screen('Screens'); screenNumber=max(screens);
window=Screen('OpenWindow',screenNumber, [], [], [], [], [], []);

%Get the width and height of the window, the X centre and Y centre of the screen
[windowWidth, windowHeight, X0, Y0] = getInfoAboutScreen(window);%user-defined function

%Set up some things to do with the keyboard
KbName('UnifyKeyNames');
ListenChar(2);%turn on character listening but suppress output of keypresses to Matlab windows
escapeKey = KbName('ESCAPE');
nextKey = KbName('space');
%HideCursor %Don't hide the cursor in this experiment

%% THESE ARE THE EXPERIMENTAL VARIABLES THAT YOU CAN CHANGE
experimentNo = 2;

% --- COLOUR LOOKUP ---
grey = 128;
black = 0;
white = 255;

red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
yellow = red + green;
purple = red + blue;
cyan = blue + green;

% --- VARIABLES TO DO WITH FEEDBACK ---
frameColour = black;
correctFrameColour = green;
incorrectFrameColour = red;
framePenWidth = 6;
vSpacing = 2;%vertical spacing of characters
wrapat = 100;%wrap text after 100 characters

% --- VARIABLES TO DO WITH TEXT ---
textSize = 30;

%% ---------------- DEFINING VARIABLES ------------------------------------
%Put the identity numbers into this list. Must be numbers only (paste list between brackets).
%Just use numbers from the "Comparisons" folder

% --- BLOCKS ---
howManyBlocks = 4;  %including practice block
shuffleBlocks = 1; %0 = in order; 1 = shuffled
identityCap = 20; %min number of images in each identity folder
incorrectTimePenalty = 4; %Time penalty for incorrect responses
ITI = 0; %Inter-trial Interval in seconds
demoDisplay = 0;

%% ------------------------ EDIT BLOCKS -----------------------------------

% --- VARIABLES ---
%You can allocate just one number to variables (*FOR EACH BLOCK*)
%
%                       *** NB ***
%I have changed this bit of allocating variables to blocks to save space.
%The first number corresponds to the value for Block 1, the second number
%corresponds to the value for Block 2 etc. If you need to add another block
%then just add a number to the end of each list.

%For the memory task, number of trials = number of games
numberOfTrials = {5 5 5 5}; %enter the number of trials (games) you want for each block
numberOfTargets = {8 8 8 8}; %enter the number of targets per trial you want for each block
numberOfTargetIdentity = {2 2 2 2}; %enter the number of different target images for each trial. Must be a factor of the number of targets
numberOfFoils = {40 40 40 40}; %enter the number of foils per trial you want for each block
targetDisplayTime = {8 8 8 8}; %how long the target image is shown for in seconds
randomiseNumberOfTargets = {0 0 0 0}; %0 = no, 1 = yes
selfTerminate = {0 0 0 0}; % 0 = Auto, 1 = Self
feedback = {1 1 1 1}; %incorrect selection feedback, 0 = no, 1 = yes
incorrectStreakTerminate = {6 6 6 6}; %number of consecutive incorrect choices made before termination


% --- LISTS ---
%You can allocate multiple numbers to lists
%e.g. list = [0 0 1] means that 1/3 of trials will have a value of 1
%NB: To add another block, copy+paste a new list under each list and change
%the number in curly brackets to the block number

%There are currently no lists

block = 1;

%% ------------------------------------------------------------------------

%Make a list of blocks
if shuffleBlocks == 1
    blockList = Shuffle(1:howManyBlocks);
else
    blockList = 1:howManyBlocks;
end

familiarityCheck

%Where to look for the images
parentDirectory = 'Images';
unfamiliarDirectory = '/UK';
unfamiliarImage = '/UK*.jpg';
familiarDirectory = '/AU';
familiarImage = '/AU*.jpg';

%Make a list of all the image files in the Comparisons and Foils folders
%[Makes a list of files (fileList) and a list with their corresponding paths (pathList)]
[unfamiliarImagesPathList, unfamiliarImagesFileList] = folderSearch(strcat(parentDirectory,unfamiliarDirectory),unfamiliarImage);%User-defined function
[familiarImagesPathList, familiarImagesFileList] = folderSearch(strcat(parentDirectory,familiarDirectory),familiarImage);%User-defined function

%Make a list of just the prefixes of all the images, so we can compare these to the targetNumList
for i = 1:numel(unfamiliarImagesFileList)%For each image
    unfamiliarImagesPrefixList(i) = str2num(unfamiliarImagesFileList{i}(3:4));%Convert from strings to numbers
end
 for i = 1:numel(familiarImagesFileList)%For each image
    familiarImagesPrefixList(i) = str2num(familiarImagesFileList{i}(3:4));%Convert from strings to numbers
end

%Group the images into identities
groupedUnfamiliarImagesPrefixList = {}; groupedUnfamiliarList = {}; groupedFamiliarImagesPrefixList = {}; groupedFamiliarList = {}; groupedUnfamiliarPathList = {}; groupedFamiliarPathList = {};
for i = 1:numel(familiarIdentityNumList)%for each target
    groupedFamiliarImagesPrefixList{i} = familiarImagesPrefixList(familiarImagesPrefixList == familiarIdentityNumList(i));
    groupedFamiliarList{i} = familiarImagesFileList(familiarImagesPrefixList == familiarIdentityNumList(i));%remember foils aren't in the identity list
    groupedFamiliarPathList{i} = familiarImagesPathList(familiarImagesPrefixList == familiarIdentityNumList(i));
end

for i = 1:numel(unfamiliarIdentityNumList)%for each target
    groupedUnfamiliarImagesPrefixList{i} = unfamiliarImagesPrefixList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
    groupedUnfamiliarList{i} = unfamiliarImagesFileList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
    groupedUnfamiliarPathList{i} = unfamiliarImagesPathList(unfamiliarImagesPrefixList == unfamiliarIdentityNumList(i));
end

%%
TargetPositions
gridAssignment = randperm(gridColumnCount*gridRowCount);

%%
unfamiliarTargetImageIndices = Shuffle(1:numel(groupedUnfamiliarList));
familiarTargetImageIndices = Shuffle(1:numel(groupedFamiliarList));


experimentTrial = 0; endExperiment = 0; blockOrder = 0; endTrial = 0; experimentClick = 0; imageSelected = 0; distanceTraveledClicks = 0; lastClickPosition = [];
unfamiliarImageIndex = 1; familiarImageIndex = 1;

DATAmatrix = []; heading = {};

Screen('FillRect',window ,grey);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 32);


for block = blockList
    blockOrder = blockOrder+1;
    if endExperiment == 1; break; end

    if blockOrder == 1 %% PracticeTrials
        startExperimentImage(window,windowWidth,windowHeight,Y0,nextKey);
        startPracticeTrials(window,windowWidth,windowHeight,Y0,nextKey);
        practiceExampleImage(window,windowWidth,windowHeight,nextKey,targetPosition,targetArrayPosition,targetPositionList,gridAssignment);
        endPracticeTrials(window,windowWidth,windowHeight,Y0,nextKey);
    end
    
    imageNumberDisplay = [];
    shuffledImageNumberDisplay = [];
    
    for trial = 1:numberOfTrials{block}
            experimentTrial = experimentTrial+1;
            whichImage = [];
            targetIdentity = {};
            endTrial = 0; whichClick = 0;
            if endExperiment == 1; break; end

            gridAssignment = randperm(gridColumnCount*gridRowCount);
            
            if mod(block,2) == 1
                    trialType = 1; %%unfamiliar
                        if unfamiliarImageIndex == numel(groupedUnfamiliarList)
                            unfamiliarImageIndex = 1;                            
                        end
                        whichImage(1:numberOfTargetIdentity{block}) = unfamiliarTargetImageIndices(unfamiliarImageIndex);
                        unfamiliarImageIndex = unfamiliarImageIndex+1;
            elseif mod(block,2) == 0
                    trialType = 2; %%familiar
                        if familiarImageIndex == numel(groupedFamiliarList)
                            familiarImageIndex = 1;
                        end
                        whichImage(1:numberOfTargetIdentity{block}) = familiarTargetImageIndices(familiarImageIndex);
                        familiarImageIndex = familiarImageIndex+1;
            end
                  
            targetImages = {};
            allTargetImages = {};
            whichFoilImage = [];
            imageSelection = [];
            targetImageNumber = [];
            foilImageNumber = [];
            
           
            if randomiseNumberOfTargets{block} ==1
                trialTargets = ceil(rand*numberOfTargets{block});
            else
                trialTargets = numberOfTargets{block};
            end
            
            targetsPerIdentity = trialTargets/numberOfTargetIdentity{block};

            imageSelection = randperm(identityCap);            
            id = 1;
            
            if trialType == 1
                    targetNumber = unfamiliarIdentityNumList(whichImage)';
                    for n = 1:numberOfTargetIdentity{block}
                        for i = 1:targetsPerIdentity
                            targetImages{n,i} = imread(strcat(groupedUnfamiliarPathList{whichImage(n)}{imageSelection(id)}, '/', groupedUnfamiliarList{whichImage(n)}{imageSelection(id)}));
                            imageNumberDisplay = [imageNumberDisplay imageSelection(id)];
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                        targetImageNumber(n) = imageSelection(id);
                        id = id+1;

                    end
                    
                    for i = 1:numberOfFoils{block}
                        if id > identityCap
                            id = 1+numberOfTargetIdentity{block};
                        end
                        foilImages{i} = imread(strcat(groupedUnfamiliarPathList{whichImage(n)}{imageSelection(id)},'/', groupedUnfamiliarList{whichImage(n)}{imageSelection(id)}));
                        foilImageNumber(i) = imageSelection(id);
                        imageNumberDisplay = [imageNumberDisplay imageSelection(id)];
                        if i >= targetsPerIdentity*(id-numberOfTargetIdentity{block})
                            id = id+1;
                        end
                    end
            elseif trialType == 2
                    targetNumber = familiarIdentityNumList(whichImage)';
                    for n = 1:numberOfTargetIdentity{block}
                        for i = 1:targetsPerIdentity
                            targetImages{n,i} = imread(strcat(groupedFamiliarPathList{whichImage(n)}{imageSelection(id)}, '/', groupedFamiliarList{whichImage(n)}{imageSelection(id)}));
                            imageNumberDisplay = [imageNumberDisplay imageSelection(id)];
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                        targetImageNumber(n) = imageSelection(id);
                        id = id+1;
                    end
                    for i = 1:numberOfFoils{block}
                        if id > identityCap
                            id = 1+numberOfTargetIdentity{block};
                        end
                        foilImages{i} = imread(strcat(groupedFamiliarPathList{whichImage(n)}{imageSelection(id)},'/', groupedFamiliarList{whichImage(n)}{imageSelection(id)}));
                        foilImageNumber(i) = imageSelection(id);
                        imageNumberDisplay = [imageNumberDisplay imageSelection(id)];
                        if i >= targetsPerIdentity*(id-numberOfTargetIdentity{block})
                            id = id+1;
                        end
                    end
            end
            
            targetIdentity = targetImages(:,1);
            
            combinedImages = {allTargetImages{1:trialTargets},foilImages{1:numberOfFoils{block}}};
            imagePositionIndex = Shuffle(1:numel(combinedImages));

            for i = 1:numel(combinedImages)
                shuffledCombinedImages{i} = combinedImages{imagePositionIndex(i)};
                positionList(:,i) = targetPositionList(:,gridAssignment(i));
                shuffledImageNumberDisplay(i) = imageNumberDisplay(imagePositionIndex(i));
            end
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        
        for n = 1:numberOfTargetIdentity{block}
            targetTexture(end+1) = Screen('MakeTexture', window, targetIdentity{n});
        end
        
        for i = 1:numel(combinedImages)       
            allTextures(end+1) = Screen('MakeTexture', window, shuffledCombinedImages{i});
        end
        
                %% -------------- Blank screen (500 ms) ---------------------------
        Screen('FillRect', window ,grey);
        Screen('Flip',window);        
        
        %% -------------- Blank screen (500 ms) ---------------------------
        
        if numberOfTargetIdentity{block} > 1
            Screen('DrawTextures', window, targetTexture, [], targetArrayPosition);
            if demoDisplay == 1
                for i = 1:numberOfTargetIdentity{block}
                    DrawFormattedText(window, num2str(targetImageNumber(i)), targetArrayPosition(1,i), targetArrayPosition(2,i), black);
                end
            end
        else
            Screen('DrawTextures', window, targetTexture, [], targetPosition);
            if demoDisplay == 1
                DrawFormattedText(window, num2str(targetImageNumber(1)), targetPosition(1), targetPosition(2), black);
            end
        end
        Screen('Flip',window);
        WaitSecs(targetDisplayTime{block});
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], positionList);
        
        %Image number for demo        
        
        if demoDisplay == 1
            for m = 1:numel(shuffledImageNumberDisplay)
                DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
            end
        end

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
        targetsRemaining = numberOfTargets{block};
        incorrectStreak = 0;

        while  1
            if endTrial ==1;  break; end
            if endExperiment == 1; break; end
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
                    experimentClick = experimentClick+1;
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
                        targetImageSelected = ceil(imageSelected/(trialTargets/numberOfTargetIdentity{block}));
                        targetSelected = whichImage(ceil(imageSelected/(trialTargets/numberOfTargetIdentity{block})));
                        if trialType ==1
                            whichSelected = groupedUnfamiliarList{targetSelected}{targetImageNumber(targetImageSelected)};
                        elseif trialType == 2
                            whichSelected = groupedFamiliarList{targetSelected}{targetImageNumber(targetImageSelected)};
                        end
                        imagePositionIndex(clickedPositionIndex) = [];
                        allTextures(clickedPositionIndex) = [];%then delete those faces
                        positionList(:,clickedPositionIndex) = [];%and the positions of those faces
                        shuffledImageNumberDisplay(clickedPositionIndex) = [];
                        correct = 1;
                        incorrectStreak = 0;
                        targetsRemaining = targetsRemaining - 1;
                        
                        if demoDisplay == 1
                            for m = 1:numel(shuffledImageNumberDisplay)
                                DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
                            end
                        end
                    else %%if incorrect image selected
                        imageSelected = imagePositionIndex(clickedPositionIndex)-trialTargets;
                        correct = 0;
                        incorrectStreak = incorrectStreak+1;
                        if trialType ==1
                            whichSelected = groupedUnfamiliarList{whichImage(end)}{foilImageNumber(imageSelected)};
                        elseif trialType == 2
                            whichSelected = groupedFamiliarList{whichImage(end)}{foilImageNumber(imageSelected)};
                        end
                        if selfTerminate{block} == 0
%                             Screen('DrawTextures', window, allTextures, [], positionList);
                            if feedback{block} == 1
%                                 Screen('FrameRect', window, red, positionList(:,clickedPositionIndex), framePenWidth);%Then draw a border around those faces
                                DrawFormattedText(window, 'Incorrect!', 'center', 'center', 255, 60, [], [], 2);
                            end
                            if demoDisplay == 1
                                for m = 1:numel(shuffledImageNumberDisplay)
                                    DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
                                end
                            end
                            
                            Screen('Flip',window);          
                            lastClickTime = tic;
%                             imagePositionIndex(clickedPositionIndex) = [];
%                             allTextures(clickedPositionIndex) = [];%then delete those faces
%                             positionList(:,clickedPositionIndex) = [];%and the positions of those faces
%                             shuffledImageNumberDisplay(clickedPositionIndex) = [];
                            
                            if demoDisplay == 1
                                for m = 1:numel(shuffledImageNumberDisplay)
                                    DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
                                end
                            end
                            if incorrectStreak >= incorrectStreakTerminate{block}
                                endTrial = 1;                        
                                DrawFormattedText(window, 'Incorrect Selection - End Trial', 'center', 'center', 255, 60, [], [], 2);
                                Screen('Flip',window);
                                WaitSecs(incorrectTimePenalty);
                            else
                                Screen('DrawTextures', window, allTextures, [], positionList);
                                WaitSecs(incorrectTimePenalty);
                                lastClickTime = tic;
                                Screen('Flip',window);
                            end
                                          
                        else
                            if feedback{block} == 1
                                Screen('FrameRect', window, red, positionList(:,clickedPositionIndex), framePenWidth);%Then draw a border around those faces
                            	DrawFormattedText(window, 'Incorrect!', 'center', 'center', 255, 60, [], [], 2);
                            end
                            if demoDisplay == 1
                                for m = 1:numel(shuffledImageNumberDisplay)
                                    DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
                                end
                            end
                            if incorrectStreak >= incorrectStreakTerminate{block}
                                endTrial = 1;                        
                                Screen('Flip',window);          
                                DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                                Screen('Flip',window);
                                WaitSecs(incorrectTimePenalty);
                            end
%                             imagePositionIndex(clickedPositionIndex) = [];
%                             allTextures(clickedPositionIndex) = [];%then delete those faces
%                             positionList(:,clickedPositionIndex) = [];%and the positions of those faces
%                             imagePositionIndex(clickedPositionIndex) = [];
                        end
                        

                    end

                end
                    if selfTerminate{block}~=0 && numel(allTextures) == 0
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'End Trial', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(ITI);
                        endTrial = 1;
                    elseif selfTerminate{block}==0 && targetsRemaining == 0;%if there are no faces left
                        Screen('Flip',window);          
                        DrawFormattedText(window, 'Complete!', 'center', 'center', 255, 60, [], [], 2);
                        Screen('Flip',window);          
                        WaitSecs(ITI);
                        endTrial = 1;
                    elseif endTrial == 0;                        
                        Screen('DrawTextures', window, allTextures, [], positionList);
                        if demoDisplay == 1
                            for m = 1:numel(shuffledImageNumberDisplay)
                                DrawFormattedText(window, num2str(shuffledImageNumberDisplay(m)), positionList(1,m), positionList(2,m), black);
                            end
                        end
                        Screen('Flip',window);
                        

                    end
                    
                    for n= 1:numberOfTargetIdentity{block}
                        targetCode = targetImageNumber(n)*10^((numberOfTargetIdentity{block}-n)*2)+targetCode;
                    end

                    
                    if clickedPositionIndex ~= 0;

                                pos = 0; heading = {};
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = pptNo;                                        heading{pos} = 'Ppt no.';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = G;                                            heading{pos} = 'Gender (1=F, 2=M)';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = age;                                          heading{pos} = 'Age';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = blockOrder;                                   heading{pos} = 'Block order (the order blocks were presented)';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = block;                                        heading{pos} = 'Block (specific block presented)';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = experimentTrial;                              heading{pos} = 'Experiment Trial';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = selfTerminate{block};                         heading{pos} = 'Termination Condition (0=Auto, 1=Self)';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = incorrectStreakTerminate{block};              heading{pos} = 'Incorrect Streak Limit';                                
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = trial;                                        heading{pos} = 'Trial';                            
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = trialType;                                    heading{pos} = 'Trial Type (1 = Unfamiliar, 2 = Familiar)';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = trialTargets;                                 heading{pos} = 'Number of Targets';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = numberOfFoils{block};                         heading{pos} = 'Number of Foils';                                
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = numberOfTargetIdentity{block};                heading{pos} = 'Number of Target Identities';                               
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = targetCode;                                   heading{pos} = 'Target Number';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = experimentClick;                              heading{pos} = 'How Many Clicks in Experiment?';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = whichClick;                                   heading{pos} = 'How Many Clicks in Trial?';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = str2num(whichSelected(3:4));                  heading{pos} = 'Which Identity Was Clicked';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = str2num(whichSelected(6:7));                  heading{pos} = 'Which Image Was Clicked';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = distanceTraveledClicks;                       heading{pos} = 'Distance Travelled between Images';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = distanceTraveled;                             heading{pos} = 'Mouse Distance Travelled';                            
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = correct;                                      heading{pos} = 'Correct';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = incorrectStreak;                              heading{pos} = 'Number of consecutive incorrect selections';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = RTstart;                                      heading{pos} = 'Time Since Start';
                                pos=pos+1;  DATAmatrix(experimentClick,pos) = RTlastClick;                                  heading{pos} = 'Time Since Last Click';


                    end

                 [theX,theY,buttons] = GetMouse(window); %Get the position of the mouse and call the coordinates [theX, theY]
                 clickedPositionIndex = [];
                 correct = -99;
                 imageSelected = [];
                 targetCode = 0;
                 distanceTraveled = 0;

        end%while
        
                    %Save the headings to a .mat file
                    headingsFilename = 'headings.mat';
                    save(headingsFilename,'heading');
                    %Save the data as you go
                    variablesFilename = strcat('saveVariables/',num2str(pptNo),'_saveVariables','.mat');
                    save(variablesFilename);

   end%for trial
        
    if endExperiment ~= 1 && block > 0 && block ~= blockList(end)
       takeBreak(window,windowWidth,windowHeight,Y0,nextKey);
    end
    
end%for block

                    trialDATAfilename = strcat('Raw_Data/exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
                    save(trialDATAfilename,'DATAmatrix','-ascii', '-tabs','-append');
                    
%% ---------------- End experiment ----------------------------------------
while KbCheck; end %Wait until all keys have been released

%ShowCursor;

finishExperiment(window,windowWidth,windowHeight,Y0);%Display finish experiment screen

ListenChar(1);%turn on character listening


Screen('Close',window);
