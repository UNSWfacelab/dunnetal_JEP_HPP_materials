function practiceExampleImage(window,windowWidth,windowHeight,presentKey, absentKey, X0, Y0)
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
YposFeedbackText = windowHeight-80;%Y position of the feedback text

hitText = 'You were CORRECT, the images were the SAME';
missText = 'You were INCORRECT, the images were the SAME';
correctRejectionText = 'You were CORRECT, this image was DIFFERENT';
falseAlarmText = 'You were INCORRECT, this image was DIFFERENT';

targetText1 = 'STUDY THIS IMAGE';
targetText2 = 'STUDY THESE IMAGES';
trialText = 'DOES THIS IMAGE MATCH ONE THAT YOU STUDIED?';
XposHeading = 'center';
YposHeading = 200;

% Select specific text font, style and size:
Screen('FillRect',window, grey);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 32);

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

TargetPositions

for trial = 1:2
            numberOfTargetIdentity = 4*trial;
            whichImage = trial;
            trialTargets = 4*trial;
            targetDisplayTime = [4];
            targetType = trial-1;
            targetImages = {};
            endExperiment = 0;
            targetTested = 2*trial;
            targetDelay = 0.5;
            feedback = 1;
                       
            
            targetsPerIdentity = trialTargets/numberOfTargetIdentity;
            id = 1;
            
            
                    for n = 1:numberOfTargetIdentity
                        for i = 1:targetsPerIdentity
                            targetImages{n,i} = imread(strcat(groupedExamplePathList{whichImage}{n}, '/', groupedExampleList{whichImage}{n}));
                        end
                    end
                    
                    foilImage = imread(strcat(groupedExamplePathList{whichImage}{numberOfTargetIdentity+1},'/', groupedExampleList{whichImage}{numberOfTargetIdentity+1}));
                        
                        
                        
           
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        probTexture = [];
        Screen('FillRect',window, grey);
        Screen('TextFont',window, 'Arial');
        Screen('TextSize',window, 32);
                
        for n = 1:trialTargets
            targetTexture(end+1) = Screen('MakeTexture', window, targetImages{n});
        end
        
        if targetType == 0
            probTexture(end+1) = Screen('MakeTexture', window, foilImage);
        elseif targetType  == 1
            probTexture(end+1) = Screen('MakeTexture', window, targetImages{targetTested});
        end

        
                %% -------------- Blank screen ---------------------------
        Screen('FillRect', window ,grey);
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        %% -------------- Target Screen ---------------------------
%         if trialTargets == 1
%             DrawFormattedText(window, targetText1, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
%         else
%             DrawFormattedText(window, targetText2, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
%         end
        
        Screen('DrawTextures', window, targetTexture, [], targetArrayPosition{trialTargets});
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(targetDisplayTime);
        
                %% -------------- Blank screen (3000 ms) ---------------------------
%         drawFixationSquare(window,heightOfFix,widthOfFix,targetPosition',black);%drawFixationSquare(windowptr,height,width,where,colour)
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
%         WaitSecs(0.5);
%         Screen('FillRect', window ,grey);
%         Screen('DrawTextures', window, maskTexture, [], targetPosition);
%         Screen('Flip',window);
%         WaitSecs(1);
%         Screen('Flip',window);
        WaitSecs(targetDelay);
        
        
        %% ----------------- Present the images ---------------------------
%         DrawFormattedText(window, trialText, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('DrawTextures', window, probTexture, [], targetArrayPosition{trialTargets}(:,targetTested));
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
                if keyCode(escapeKey); endExperiment = 1; break; end
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
        
        if response==targetType
            correct = 1;
            feedbackTextColour = correctFrameColour;
            if targetType== 1
                feedbackText = hitText;
                correctType = 3;
            elseif targetType==0
                feedbackText = correctRejectionText;
                correctType = 1;
            end
        else
            correct = 0;
            feedbackTextColour = incorrectFrameColour;
            if targetType== 1
                feedbackText = missText;
                correctType = 4;
            elseif targetType==0
                feedbackText = falseAlarmText;
                correctType = 2;
            end
        end

        if feedback == 1%if feedback is on
            DrawFormattedText(window, feedbackText, XposFeedbackText, YposFeedbackText, feedbackTextColour, wrapat, [], [], vSpacing);
            %Re-display images after feedback
            Screen('DrawTextures', window, probTexture, [], targetArrayPosition{trialTargets}(:,targetTested));
            if targetType == 0 
                Screen('FrameRect', window, feedbackTextColour, targetArrayPosition{trialTargets}(:,targetTested), framePenWidth);
            end
            Screen('Flip',window);
        else
            DrawFormattedText(window, nextText, XposFeedbackText, YposFeedbackText, white, wrapat, [], [], vSpacing);
            Screen('Flip',window);
        end
        
        while KbCheck; end; KbWait;


   end%for trial
