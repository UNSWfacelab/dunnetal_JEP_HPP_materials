
famFile = strcat('Identities.csv');

minFaces = 10;
folder = 'Familiarity';
fileLocation = [];
familiarKey = KbName('y');
unfamiliarKey = KbName('n');

fid = fopen(strcat(folder,'/',famFile));

C1 = textscan(fid, '%s', 'Delimiter', ',');%C = textscan(FID,'FORMAT','PARAM',VALUE)
fclose(fid);
Screen('FillRect',window, grey);
Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 32);

imageFolder = 'Example/';
unfamiliarImageName = 'UK';
familiarImageName = 'FAM';
fileType = '.jpg';

familiarityInstructions(window,windowWidth,windowHeight,Y0,nextKey);

familiarText = 'Was this person''s face familiar to you before this experiment?';
responseText = 'Y for Yes, N for No';
familiarityResponse = [];
endExperiment = 0;
familiarIdentityNumList = [];
unfamiliarIdentityNumList = [];
identityList = Shuffle(1:64);
familiarityResponses = zeros(64,1);
for n = 1:64
    if identityList(n) <=32
        imageNum = identityList(n);
        fam = 1;
    else
        imageNum = identityList(n)-32;
        fam = 0;
    end
    
    if imageNum < 10
        correctFileName = strcat('0',num2str(imageNum));
    else
        correctFileName = num2str(imageNum);
    end
    
    if fam == 1
        imageName = strcat(imageFolder,familiarImageName,correctFileName,fileType);
    elseif fam == 0
        imageName = strcat(imageFolder,unfamiliarImageName,correctFileName,fileType);
    end
    
    famImage = imread(imageName);
    imageTexture = Screen('MakeTexture', window, famImage);
    Screen('DrawTextures', window, imageTexture, [], targetPosition);
    
    nameText = C1{1}{identityList(n)};
    DrawFormattedText(window, familiarText, 'center', Y0-200, white, wrapat, [], [], vSpacing);
    DrawFormattedText(window, nameText, 'center', Y0+200, white, wrapat, [], [], vSpacing);
    DrawFormattedText(window, responseText, 'center', Y0+300, white, wrapat, [], [], vSpacing);
    Screen('Flip',window);

    while KbCheck; end %Wait until all keys have been released
    while 1 %while 1 is always true, so this loop will continue indefinitely.
        if endExperiment == 1; Screen('Close',window); ShowCursor; ListenChar(1); quitexperiment; end
        [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
            
        if keyIsDown
            find(keyCode);
            KbName(keyCode);
            whichKey = find(keyCode);
                %If a meaningful key was pressed
                if keyCode(escapeKey); endExperiment = 1; break; end
                if keyCode(familiarKey) || keyCode(unfamiliarKey)
                    %this records the number of the image that was selected (1 or 2), NOT the side that was chosen
                    if keyCode(familiarKey); familiarityResponse(identityList(n)) = 1;
                        familiarityResponses(identityList(n)) = 1;
                        if identityList(n) <= 32                     
                            familiarIdentityNumList(end+1) = imageNum;
                        end
                    end
                    if keyCode(unfamiliarKey); familiarityResponse(identityList(n)) = 0;                         
                        if identityList(n) <= 64 && identityList(n) > 32
                            unfamiliarIdentityNumList(end+1) = imageNum;
                        end
                    end
                    Screen('Flip',window);
                    break;
                end
                
                while KbCheck; end %Once a key has been pressed we wait until all keys have been released before going through the loop again
                
            end%if keyIsDown
        end%while 1
    
end

Screen('Flip',window);

% if length(familiarIdentityNumList) < minFaces  
%     Screen('Close',window);
%     ShowCursor; ListenChar(1); 
%     'Not enough familiar faces'
% end
% if length(unfamiliarIdentityNumList) < minFaces      
%     Screen('Close',window);
%     ShowCursor; ListenChar(1);
%     'Not enough unfamiliar faces'
% end

familiarityDATAfilename = strcat('Raw_Data/familiarity_exp',num2str(experimentNo),' ppt',num2str(pptNo),' gender [', gender,'] age [', num2str(age),'] time [',time,'].m');
save(familiarityDATAfilename,'familiarityResponses','-ascii', '-tabs','-append');