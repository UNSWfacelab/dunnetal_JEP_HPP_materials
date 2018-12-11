function familarityInstructions(windowPtr,windowWidth,windowHeight,v_where,spaceKey)

grey = 128;

% Select specific text font, style and size:
Screen('TextFont',windowPtr, 'Arial');
Screen('TextSize',windowPtr, 16);
%Screen('TextStyle', window, 1+2);

textcolour = 255;%white
wrapat = 60;%wrap at 60 characters
wrapat2 = 200;
vSpacing = 4;
vSpacing2 = 2;


Screen('FillRect', windowPtr, grey, [0, 0, windowWidth, windowHeight]);%clear the screen
startExperimentText = 'We will now be checking your familiarity with celebrities.';
startExperimentText2 = 'For each face you will need to decide whether they were familiar to you prior to completing this experiment.';
startExperimentText3 = 'Press the Y KEY for YES if they were FAMILIAR. Press the N KEY for NO if they were UNFAMILIAR.';
startExperimentText4 = 'Note: Only press YES if you were familiar with their face BEFORE to completing the experiment.';
startExperimentText5 = 'Press the SPACE key to start the experiment.';

DrawFormattedText(windowPtr, startExperimentText, 'center', v_where-200, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText2, 'center', v_where-100, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText3, 'center', v_where, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText4, 'center', v_where+100', textcolour, wrapat2, [], [], vSpacing2);

Screen(windowPtr, 'Flip');

while KbCheck;
end % Wait until all keys are released before continuing.
while 1 %while 1 is always true, so this loop will continue indefinitely.
    [ keyIsDown, seconds, keyCode ] = KbCheck; %Check the state of the keyboard. See if a key is currently pressed on the keyboard.
    if keyIsDown
        find(keyCode);
        KbName(keyCode);
        %if keyCode(spaceKey); break; end
        if keyCode(spaceKey);
            break;
        end
        while KbCheck;
        end %Once a key has been pressed we wait until all keys have been released before going through the loop again
    end%if keyIsDown
end%while

end