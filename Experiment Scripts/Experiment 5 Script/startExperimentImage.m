function startExperiment(windowPtr,windowWidth,windowHeight,v_where,spaceKey)

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
startExperimentText = 'At the start of each trial you will be shown between FOUR targer images on screen.';
startExperimentText2 = 'You will need to memorise all these images. Your task with the test image depends on the text above the image.';
startExperimentText3 = 'IMAGE: Is the test image the exact same as one of the four targets?';
startExperimentText4 = 'IDENTITY: Is the test image of the same person as one of the four targets?';
startExperimentText5 = 'Press the UP Arrow KEY if it is a MATCH. Press the DOWN Arrow KEY if it is a NONMATCH.';
startExperimentText6 = 'Press the SPACE key to start the experiment.';

DrawFormattedText(windowPtr, startExperimentText, 'center', v_where-200, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText2, 'center', v_where-100, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText3, 'center', v_where, textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText4, 'center', v_where+100', textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText5, 'center', v_where+200', textcolour, wrapat2, [], [], vSpacing2);
DrawFormattedText(windowPtr, startExperimentText6, 'center', v_where+300', textcolour, wrapat2, [], [], vSpacing2);

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