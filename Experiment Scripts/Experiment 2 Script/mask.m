% Clear the workspace
close all;
clear all;
sca;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Contrast for our contrast modulation mask: 0 = mask has no effect,
% 1 = mask
% will at its strongest part be completely opaque i.e. 0 and 100% contrast
% respectively
contrast = 1;

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Define a simple spiral texture by defining X and Y coordinates with the
% meshgrid command, converting these to polar coordinates and finally
% defining the spiral. This time we create a two layer texture fill
% the first layer with the background color and then place the spiral
% texure in the second 'alpha' layer
% Experiment with the variables rd and td to see their effects
[x, y] = meshgrid(-250:1:250, -250:1:250);
[th, r] = cart2pol(x, y);
rd = 5;
td = 5;
spiral = (white .* (1 - cos(r / rd + th * td))) ./ 2;

[s1, s2] = size(x);
mask = ones(s1, s2, 2) .* grey;
mask(:, :, 2)= spiral .* contrast;

% Make our sprial  into a screen texture for drawing
maskTexture = Screen('MakeTexture', window, mask);

% Make ablack and white noise texture, we make this half the size of the
% destination rectangle we are putting it in so that it is scaled up,
% giving us a more chunky noise pattern. This will be viewed through the
% spiral mask
noise = round(rand(s1 / 3, s2 / 3));
noiseTexture = Screen('MakeTexture', window, noise);

% We are going to draw three textures to show how a black and white texture
% can be color modulated upon drawing.
yPos = yCenter;
xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 3);

% Define the destination rectangles for our spiral textures. For this demo
% these will be the same size as out actualy texture, but this doesn't have
% to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
baseRect = [0 0 s1 s2];
dstRects = nan(4, 3);
for i = 1:3
    dstRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos);
end

% Color Modulation
colorMod = [1 0 0; 0 1 0; 0 0 1]';

% Batch Draw all of the texures to screen
Screen('DrawTextures', window, noiseTexture, [], dstRects,...
    [], [], [], colorMod);
Screen('DrawTextures', window, maskTexture, [], dstRects, [], [], [], []);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;