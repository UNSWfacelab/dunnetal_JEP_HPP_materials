
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

familiarityInstructions(window,windowWidth,windowHeight,Y0,nextKey);

familiarText = 'Is this name familiar to you?';
familiarityResponse = [];
endExperiment = 0;
familiarIdentityNumList = [];
unfamiliarIdentityNumList = [];
identityList = Shuffle(1:80);

for n = 1:80
    identityText = C1{1}{identityList(n)};
    DrawFormattedText(window, familiarText, 'center', Y0-200, white, wrapat, [], [], vSpacing);
    DrawFormattedText(window, identityText, 'center', 'center', white, wrapat, [], [], vSpacing);
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
                        if identityList(n) <= 40                     
                            familiarIdentityNumList(end+1) = identityList(n);
                        end
                    end
                    if keyCode(unfamiliarKey); familiarityResponse(identityList(n)) = 0;                         
                        if identityList(n) <= 80 && identityList(n) > 40
                            unfamiliarIdentityNumList(end+1) = identityList(n)-40;
                        end
                    end
                    Screen('Flip',window);
                    break;
                end
                
                while KbCheck; end %Once a key has been pressed we wait until all keys have been released before going through the loop again
                
            end%if keyIsDown
        end%while 1
    
end

familiarIdentityNumList = sort(familiarIdentityNumList);
unfamiliarIdentityNumList = sort(unfamiliarIdentityNumList);

Screen('Flip',window);

if length(familiarIdentityNumList) < minFaces  
    Screen('Close',window);
    ShowCursor; ListenChar(1); 
    'Not enough familiar faces'
end
if length(unfamiliarIdentityNumList) < minFaces      
    Screen('Close',window);
    ShowCursor; ListenChar(1);
    'Not enough unfamiliar faces'
end

