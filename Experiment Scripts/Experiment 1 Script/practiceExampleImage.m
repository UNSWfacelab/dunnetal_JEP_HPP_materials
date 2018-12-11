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

hitText = 'You were CORRECT, these images were DUPLICATES';
missText = 'You were INCORRECT, these images were DUPLICATES';
correctRejectionText = 'You were CORRECT, all images were DIFFERENT';
falseAlarmText = 'You were INCORRECT, all images were DIFFERENT';

targetText = 'ARE THERE ANY DUPLICATES IN THIS GALLERY?';
XposHeading = 'center';
YposHeading = 50;

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
            numberOfTargetIdentity = [4 9];
            whichImage = [2 1];
            trialTargets = [4 9];
            targetType = trial-1;
            targetImages = {};
            endExperiment = 0;
            targetTested = 3;
            feedback = 1;
                       
            
            targetsPerIdentity(trial) = trialTargets(trial) /numberOfTargetIdentity(trial) ;
            id = 1;
            
            
                    for n = 1:numberOfTargetIdentity(trial) 
                        for i = 1:targetsPerIdentity(trial)
                            targetImages{n,i} = imread(strcat(groupedExamplePathList{whichImage(trial)}{n}, '/', groupedExampleList{whichImage(trial)}{n}));
                        end
                    end
                    
                    foilImage = imread(strcat(groupedExamplePathList{whichImage(trial)}{targetTested},'/', groupedExampleList{whichImage(trial)}{targetTested}));
                        
                        
                        
           
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        Screen('FillRect',window, grey);
        Screen('TextFont',window, 'Arial');
        Screen('TextSize',window, 32);
        
        if targetType == 1
            for n = 1:trialTargets(trial)
                if n == 7
                    allTextures(end+1) = Screen('MakeTexture', window, foilImage);
                else
                    allTextures(end+1) = Screen('MakeTexture', window, targetImages{n});
                end
            end
        elseif targetType  == 0
            for n = 1:trialTargets(trial)
                allTextures(end+1) = Screen('MakeTexture', window, targetImages{n});
            end
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
        DrawFormattedText(window, targetText, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        Screen('DrawTextures', window, allTextures, [], targetArrayPosition{trialTargets(trial)});
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
            Screen('DrawTextures', window, allTextures, [], targetArrayPosition{trialTargets(trial)});
             if targetType == 1
                 Screen('FrameRect', window, feedbackTextColour, targetArrayPosition{trialTargets(trial)}(:,targetTested), framePenWidth);
                 Screen('FrameRect', window, feedbackTextColour, targetArrayPosition{trialTargets(trial)}(:,7), framePenWidth);
             end
            Screen('Flip',window);
        else
            DrawFormattedText(window, nextText, XposFeedbackText, YposFeedbackText, white, wrapat, [], [], vSpacing);
            Screen('Flip',window);
        end
        
        while KbCheck; end; KbWait;
        
   end%for trial
end