function practiceExampleImage(window,windowWidth,windowHeight,presentKey, absentKey,targetPosition,targetArrayPosition, X0, Y0)
grey = 128;
black = 0;
white = 255;
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
yellow = red + green;
purple = red + blue;
cyan = blue + green;
escapeKey = KbName('ESCAPE');

% --- VARIABLES TO DO WITH FEEDBACK ---
frameColour = black;
correctFrameColour = green;
incorrectFrameColour = red;
framePenWidth = 6;
vSpacing = 2;%vertical spacing of characters
wrapat = 100;%wrap text after 100 characters
XposFeedbackText = 'center';%X position of the feedback text. If you want it in the centre, type 'center'. Otherwise, put a numerical value.
YposFeedbackText = windowHeight-100;%Y position of the feedback text

hitText = 'You were CORRECT, they were a MATCH';
missText = 'You were INCORRECT, they were a MATCH';
correctRejectionText = 'You were CORRECT, they were a NONMATCH';
falseAlarmText = 'You were INCORRECT, they were a NONMATCH';

buttonText = 'Up Arrow for MATCH, Down Arrow for Nonmatch';

targetText1 = 'TARGET';
targetText2 = 'TARGETS';
imageText = 'IMAGE';
identityText = 'IDENTITY';
blankText = '?';
nextText = 'PRESS ANY KEY TO CONTINUE';
XposHeading = 'center';
YposHeading = 200;

% Select specific text font, style and size:
Screen('FillRect',window, grey);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 30);

% --- FIXATION POINT ---
heightOfFix = 20;
widthOfFix = 20;
lineWidth = 3;

Screen('FillRect', window, grey, [0, 0, windowWidth, windowHeight]);%clear the screen
Screen(window, 'Flip');

parentDirectory = 'Example';
exampleImage = '/EX*.jpg';

exampleIdentityNumList = [1:13];

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
endExperiment = 0;
            trialCondition = Shuffle([1:4]);

    for trial = 1:4
            if endExperiment == 1; break; end
            numberOfTargetIdentity = 4;
            targetDisplayTime = 6;
            targetImages = {};
            endExperiment = 0;
                                                         
                    for n = 1:numberOfTargetIdentity
                        targetImages{n} = imread(strcat(groupedExamplePathList{n}{1}, '/', groupedExampleList{n}{1}));
                    end
                    
                    testImage{1} = imread(strcat(groupedExamplePathList{1}{1},'/', groupedExampleList{1}{1}));
                    testImage{2} = imread(strcat(groupedExamplePathList{2}{2},'/', groupedExampleList{2}{2}));
                    testImage{3} = imread(strcat(groupedExamplePathList{3}{6},'/', groupedExampleList{3}{6}));
                    testImage{4} = imread(strcat(groupedExamplePathList{5}{1},'/', groupedExampleList{5}{1}));
           
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        maskImage = imread(strcat('twirled/u05tp.jpg'));  
        maskTexture = Screen('MakeTexture', window, maskImage);
       
        for n = 1:4
            targetTexture(end+1) = Screen('MakeTexture', window, targetImages{n});
        end
        
        allTextures(end+1) = Screen('MakeTexture', window, testImage{trialCondition(trial)});
  
                    %% -------------- Blank screen ---------------------------
        Screen('FillRect', window ,grey);
        Screen('Flip',window);

        if trialCondition(trial) > 2
            instruction = identityText;
        else
            instruction = imageText;
        end
        
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        DrawFormattedText(window, instruction, 'center', 'center', white, wrapat, [], [], vSpacing);
        Screen('Flip',window); 
        WaitSecs(3);

        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        %% -------------- Target Screen ---------------------------
        DrawFormattedText(window, targetText2, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        
        Screen('DrawTextures', window, targetTexture, [], targetArrayPosition{numberOfTargetIdentity});
        Screen('Flip',window);
        WaitSecs(targetDisplayTime);
        
                %% -------------- Blank screen (3000 ms) ---------------------------
%         drawFixationSquare(window,heightOfFix,widthOfFix,targetPosition',black);%drawFixationSquare(windowptr,height,width,where,colour)
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        Screen('FillRect', window ,grey);
        Screen('DrawTextures', window, maskTexture, [], targetPosition);
        Screen('Flip',window);
        WaitSecs(1);
        DrawFormattedText(window, instruction, 'center', 'center', white, wrapat, [], [], vSpacing);
        Screen('Flip',window);
        WaitSecs(3);
        
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], targetPosition);
        DrawFormattedText(window, instruction, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        DrawFormattedText(window, buttonText, XposFeedbackText, YposFeedbackText, white, wrapat, [], [], vSpacing);
        Screen('Flip',window); 
        tstart = tic;
        while KbCheck; end %Wait until all keys have been released
        while 1 %while 1 is always true, so this loop will continue indefinitely.
            if endExperiment == 1; break; end
            [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
            
            if keyIsDown
                find(keyCode);
                KbName(keyCode);
                whichKey = find(keyCode);
                %If a meaningful key was pressed
                if keyCode(escapeKey); response = 99; endExperiment = 1; break; end
                if keyCode(presentKey) || keyCode(absentKey)
                    %this records the number of the image that was selected (1 or 2), NOT the side that was chosen
                    if keyCode(presentKey); response = 1; end
                    if keyCode(absentKey); response = 0; end
                    RT = toc(tstart);
                    Screen('Flip',window);
                    break;
                end
                
                while KbCheck; end %Once a key has been pressed we wait until all keys have been released before going through the loop again
                
            end%if keyIsDown
        end%while 1
        
                %% ----------------- Check if Correct ---------------------------
        if trialCondition(trial) == 1 || trialCondition(trial) == 3
            if response == 1
                correct = 1;
                feedbackTextColour = correctFrameColour;
                feedbackText = hitText;
                correctType = 3;
            else
                correct = 0;
                feedbackTextColour = incorrectFrameColour;
                feedbackText = missText;
                correctType = 4;
            end
        elseif trialCondition(trial) == 2 || trialCondition(trial) == 4
            if response == 0
                correct = 1;
                feedbackTextColour = correctFrameColour;
                feedbackText = correctRejectionText;
                correctType = 1;
            else
                correct = 0;
                feedbackTextColour = incorrectFrameColour;
                feedbackText = falseAlarmText;
                correctType = 2;
            end
        end          

        DrawFormattedText(window, feedbackText, XposFeedbackText, YposFeedbackText, feedbackTextColour, wrapat, [], [], vSpacing);
        DrawFormattedText(window, nextText, XposFeedbackText, YposFeedbackText+75, white, wrapat, [], [], vSpacing);
        Screen('Flip',window);

        
        while KbCheck; end; KbWait;

        
   end%for trial
end