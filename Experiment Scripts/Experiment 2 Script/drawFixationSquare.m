function drawFixationSquare(windowPtr,height,width,where,colour)

position = CenterRect([0 0 height width],where);

Screen('FillRect',windowPtr,colour,position);
%Screen('Flip',windowptr);

%WaitSecs(secs);

%Screen('Flip',windowptr);

end