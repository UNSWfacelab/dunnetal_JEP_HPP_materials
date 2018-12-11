            
            %%catch trial

            experimentTrial = experimentTrial+1;
            whichImage = [];
            targetIdentity = {};
            endTrial = 0; whichClick = 0;
            if endExperiment == 1; break; end

            gridAssignment = randperm(gridColumnCount*gridRowCount);
            unfamiliarTargetImageIndices = Shuffle(1:numel(groupedUnfamiliarList));
            familiarTargetImageIndices = Shuffle(1:numel(groupedFamiliarList));
            
            if trialCondition(trial) > 2
                testTask = identityTask;
                testType = trialCondition(trial) - 2;
                instruction = identityText;
            else
                testTask = imageTask;
                testType = trialCondition(trial);
                instruction = imageText;
            end
            
            if mod(block,2) == 1
                    trialType = unfamiliar; %%unfamiliar
                for n = 1:numberOfTargetIdentity{block}+1
                        if unfamiliarImageIndex == numel(groupedUnfamiliarList)
                            unfamiliarImageIndex = 1;                            
                        end
                        whichImage(n) = unfamiliarTargetImageIndices(unfamiliarImageIndex);
                        unfamiliarImageIndex = unfamiliarImageIndex+1;
                end
            elseif mod(block,2) == 0
                    trialType = familiar; %%familiar
                for n = 1:numberOfTargetIdentity{block}+1
                        if familiarImageIndex == numel(groupedFamiliarList)
                            familiarImageIndex = 1;
                        end
                        whichImage(n) = familiarTargetImageIndices(familiarImageIndex);
                        familiarImageIndex = familiarImageIndex+1;
                end
            end                     
                
            targetImages = {};
            allTargetImages = {};
            whichFoilImage = [];
            imageSelection = [];
            targetImageNumber = zeros(1,4);
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
                    targetNumber = unfamiliarIdentityNumList(whichImage(1))';
                    for n = 1:numberOfTargetIdentity{block}
                        for i = 1:targetsPerIdentity
                            if id > identityCap
                                id = 1;
                            end
                            targetImages{n,i} = imread(strcat(groupedUnfamiliarPathList{whichImage(n)}{imageSelection(id)}, '/', groupedUnfamiliarList{whichImage(n)}{imageSelection(id)}));
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                        targetImageNumber(n) = whichImage(n);
                        id = id+1;

                    end
                            if id > identityCap
                                id = 1;
                            end
                        testImage{sameSame} = targetImages{testNumber(trial)};
                        testImage{diffSame} = imread(strcat(groupedUnfamiliarPathList{whichImage(testNumber(trial))}{imageSelection(id)}, '/', groupedUnfamiliarList{whichImage(testNumber(trial))}{imageSelection(id)}));
                        testImage{diffDiff} = imread(strcat(groupedUnfamiliarPathList{whichImage(n+1)}{imageSelection(id)},'/', groupedUnfamiliarList{whichImage(n+1)}{imageSelection(id)}));
                        id = id+1;
            elseif trialType == 2
                    targetNumber = familiarIdentityNumList(whichImage(1))';
                    for n = 1:numberOfTargetIdentity{block}
                        for i = 1:targetsPerIdentity
                            if id > identityCap
                                id = 1;
                            end
                            targetImages{n,i} = imread(strcat(groupedFamiliarPathList{whichImage(n)}{imageSelection(id)}, '/', groupedFamiliarList{whichImage(n)}{imageSelection(id)}));
                            allTargetImages{end+1} = targetImages{n,i};
                        end
                        targetImageNumber(n) = whichImage(n);
                        id = id+1;
                    end
                            if id > identityCap
                                id = 1;
                            end
                        testImage{sameSame} = targetImages{testNumber(trial)};
                        testImage{diffSame} = imread(strcat(groupedFamiliarPathList{whichImage(testNumber(trial))}{imageSelection(id)}, '/', groupedFamiliarList{whichImage(testNumber(trial))}{imageSelection(id)}));
                        testImage{diffDiff} = imread(strcat(groupedFamiliarPathList{whichImage(n+1)}{imageSelection(id)},'/', groupedFamiliarList{whichImage(n+1)}{imageSelection(id)}));                        id = id+1;
            end
        maskImage = imread(strcat('twirled/u05tp.jpg'));          
            
            %% -------------------- Make textures -----------------------------
        allTextures = [];
        targetTexture = [];
        Screen('FillRect',window, grey);
        Screen('TextFont',window, 'Arial');
        Screen('TextSize',window, 32);
        
        maskTexture = Screen('MakeTexture', window, maskImage);
        
        for n = 1:trialTargets
            targetTexture(end+1) = Screen('MakeTexture', window, targetImages{n});
        end
        if testTask == imageTask
            if testType == 1
                allTextures = Screen('MakeTexture', window, testImage{sameSame});
            elseif testType == 2
                allTextures = Screen('MakeTexture', window, testImage{diffSame});
            end
        elseif testTask == identityTask
            if testType == 1
                allTextures = Screen('MakeTexture', window, testImage{diffSame});
            elseif testType == 2
                allTextures = Screen('MakeTexture', window, testImage{diffDiff});
            end
        end
                %% -------------- Blank screen ---------------------------
        Screen('FillRect', window ,grey);
        Screen('Flip',window);

        if instructionType ==1
            DrawFormattedText(window, instruction, 'center', 'center', white, wrapat, [], [], vSpacing);
        else
            DrawFormattedText(window, blankText, 'center', 'center', white, wrapat, [], [], vSpacing);
        end
        Screen('Flip',window); 
        WaitSecs(2);

        Screen('DrawLine', window, black, X0-widthOfFix/2, Y0, X0+widthOfFix/2, Y0,lineWidth);
        Screen('DrawLine', window, black, X0, Y0-heightOfFix/2, X0, Y0+heightOfFix/2,lineWidth);
        Screen('Flip',window);
        WaitSecs(0.5);
        
        %% -------------- Target Screen ---------------------------
        if trialTargets == 1
            DrawFormattedText(window, targetText1, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        else
            DrawFormattedText(window, targetText2, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
        end
        
        Screen('DrawTextures', window, targetTexture, [], targetArrayPosition{trialTargets});
        Screen('Flip',window);
        WaitSecs(targetDisplayTime{block});
        
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
        Screen('Flip',window);
        WaitSecs(targetDelay{block});
        
        
        %% ----------------- Present the images ---------------------------
        Screen('DrawTextures', window, allTextures, [], targetPosition);
        DrawFormattedText(window, instruction, XposHeading, YposHeading, white, wrapat, [], [], vSpacing);
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

        if feedback{block} == 1%if feedback is on
            DrawFormattedText(window, feedbackText, XposFeedbackText, YposFeedbackText, feedbackTextColour, wrapat, [], [], vSpacing);
            %Re-display images after feedback
            Screen('Flip',window);
        else
            DrawFormattedText(window, nextText, XposFeedbackText, YposFeedbackText, white, wrapat, [], [], vSpacing);
            Screen('Flip',window);
        end
        
        while KbCheck; end; KbWait;


        
        %% ----------------- Data Saving ---------------------------

                                pos = 0; heading = {};
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = pptNo;                                        heading{pos} = 'Ppt no.';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = G;                                            heading{pos} = 'Gender (1=F,2=M,3=T,4=O)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = age;                                          heading{pos} = 'Age';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = blockOrder;                                   heading{pos} = 'Block order (the order blocks were presented)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = block;                                        heading{pos} = 'Block (specific block presented)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = experimentTrial;                              heading{pos} = 'Experiment Trial';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = trial;                                        heading{pos} = 'Trial';                            
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = trialType;                                    heading{pos} = 'Image Type (1=Unfamiliar, 2=Familiar)';                                 
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = instructionType;                              heading{pos} = 'Image Type (1=Before, 2=After)';                                 
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = trialCondition(trial);                        heading{pos} = 'Trial Type (1-4)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = testTask;                                     heading{pos} = 'Trial Type (1 = Image, 2 = Identity)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = testType;                                     heading{pos} = 'Trial Type (1 = Same, 2 = Different)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = trialTargets;                                 heading{pos} = 'Number of Targets';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = numberOfTargetIdentity{block};                heading{pos} = 'Number of Target Identities';                               
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = targetImageNumber(1);                         heading{pos} = 'Target 1';                                
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = targetImageNumber(2);                         heading{pos} = 'Target 2';                                
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = targetImageNumber(3);                         heading{pos} = 'Target 3';                                
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = targetImageNumber(4);                         heading{pos} = 'Target 4';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = testNumber(trial);                            heading{pos} = 'Target Number';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = response;                                     heading{pos} = 'Response (0=said absent, 1=said present)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = correct;                                      heading{pos} = 'Correct';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = correctType;                                  heading{pos} = 'Response Type (1=CR,2=FA,3=Hit,4=Miss)';
                                pos=pos+1;  DATAmatrix(experimentTrial,pos) = RT;                                           heading{pos} = 'Response Latency';


%         end%while
        
                    %Save the headings to a .mat file
                    headingsFilename = 'headings.mat';
                    save(headingsFilename,'heading');
                    %Save the data as you go
                    variablesFilename = strcat('saveVariables/',num2str(pptNo),'_saveVariables','.mat');
                    save(variablesFilename);
                    trialDATAmatrix = DATAmatrix(experimentTrial,:);
                    trialDATAfilename = strcat('Raw_Data/exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
                    save(trialDATAfilename,'trialDATAmatrix','-ascii', '-tabs','-append');