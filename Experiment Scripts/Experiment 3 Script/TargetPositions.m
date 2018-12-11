%% ----------------------- POSITIONS --------------------------------------
%This bit of code sets up where each image will be displayed

targetIm_height = 200; targetIm_width = 150; imageGap = 25;

Im_height = 200; Im_width = 150;

gridRowCount = floor(windowHeight/Im_height);

gridColumnCount = floor(windowWidth/Im_width);
emptyRows = windowHeight - gridRowCount*Im_height;

emptyColumns = windowWidth - gridColumnCount*Im_width;

jiggleSpaceRows = emptyRows/gridRowCount;

jiggleSpaceColumns = emptyColumns/gridColumnCount;
targetPositionList = [];
targetArrayPosition = {};



X1 = 1;
Y1 = 2;
X2 = 3;
Y2 = 4;

gridAssignment = [];


        targetArrayPosition{1}(:,1) = [X0-targetIm_width/2,Y0-targetIm_height/2,X0+targetIm_width/2,Y0+targetIm_height/2];
        
        targetArrayPosition{2}(:,1) = [X0-targetIm_width-imageGap,Y0-targetIm_height-imageGap,X0-imageGap,Y0-imageGap];
        targetArrayPosition{2}(:,2) = [X0+imageGap,Y0-targetIm_height-imageGap,X0+targetIm_width+imageGap,Y0-imageGap];
        
        targetArrayPosition{3}(:,1) = [X0-targetIm_width-imageGap,Y0-targetIm_height-imageGap,X0-imageGap,Y0-imageGap];
        targetArrayPosition{3}(:,2) = [X0+imageGap,Y0-targetIm_height-imageGap,X0+targetIm_width+imageGap,Y0-imageGap];
        targetArrayPosition{3}(:,3) = [X0-targetIm_width/2,Y0+imageGap,X0+targetIm_width/2,Y0+targetIm_height+imageGap];
        
        targetArrayPosition{4}(:,1) = [X0-targetIm_width-imageGap,Y0-targetIm_height-imageGap,X0-imageGap,Y0-imageGap];
        targetArrayPosition{4}(:,2) = [X0+imageGap,Y0-targetIm_height-imageGap,X0+targetIm_width+imageGap,Y0-imageGap];
        targetArrayPosition{4}(:,3) = [X0-targetIm_width-imageGap,Y0+imageGap,X0-imageGap,Y0+targetIm_height+imageGap];
        targetArrayPosition{4}(:,4) = [X0+imageGap,Y0+imageGap,X0+targetIm_width+imageGap,Y0+targetIm_height+imageGap];

        targetArrayPosition{8}(:,1) = [X0-targetIm_width*2-imageGap*2,Y0-targetIm_height-imageGap,X0-targetIm_width-imageGap*2,Y0-imageGap];
        targetArrayPosition{8}(:,2) = [X0-targetIm_width-imageGap,Y0-targetIm_height-imageGap,X0-imageGap,Y0-imageGap];
        targetArrayPosition{8}(:,3) = [X0+imageGap,Y0-targetIm_height-imageGap,X0+targetIm_width+imageGap,Y0-imageGap];
        targetArrayPosition{8}(:,4) = [X0+targetIm_width+imageGap*2,Y0-targetIm_height-imageGap,X0+targetIm_width*2+imageGap*2,Y0-imageGap];    
        targetArrayPosition{8}(:,5) = [X0-targetIm_width*2-imageGap*2,Y0+imageGap,X0-targetIm_width-imageGap*2,Y0+targetIm_height+imageGap];
        targetArrayPosition{8}(:,6) = [X0-targetIm_width-imageGap,Y0+imageGap,X0-imageGap,Y0+targetIm_height+imageGap];
        targetArrayPosition{8}(:,7) = [X0+imageGap,Y0+imageGap,X0+targetIm_width+imageGap,Y0+targetIm_height+imageGap];
        targetArrayPosition{8}(:,8) = [X0+targetIm_width+imageGap*2,Y0+imageGap,X0+targetIm_width*2+imageGap*2,Y0+targetIm_height+imageGap];

        targetArrayPosition{16}(:,1) = [X0-targetIm_width*2-imageGap*2,Y0-targetIm_height*2-imageGap*2,X0-targetIm_width-imageGap*2,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,2) = [X0-targetIm_width-imageGap,Y0-targetIm_height*2-imageGap*2,X0-imageGap,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,3) = [X0+imageGap,Y0-targetIm_height*2-imageGap*2,X0+targetIm_width+imageGap,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,4) = [X0+targetIm_width+imageGap*2,Y0-targetIm_height*2-imageGap*2,X0+targetIm_width*2+imageGap*2,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,5) = [X0-targetIm_width*2-imageGap*2,Y0-targetIm_height-imageGap,X0-targetIm_width-imageGap*2,Y0-imageGap];
        targetArrayPosition{16}(:,6) = [X0-targetIm_width-imageGap,Y0-targetIm_height*2-imageGap*2,X0-imageGap,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,7) = [X0+imageGap,Y0-targetIm_height-imageGap,X0+targetIm_width+imageGap,Y0-targetIm_height-imageGap*2];
        targetArrayPosition{16}(:,8) = [X0+targetIm_width+imageGap*2,Y0-targetIm_height-imageGap,X0+targetIm_width*2+imageGap*2,Y0-imageGap];    
        targetArrayPosition{16}(:,9) = [X0-targetIm_width*2-imageGap*2,Y0+imageGap,X0-targetIm_width-imageGap*2,Y0+targetIm_height+imageGap];
        targetArrayPosition{16}(:,10) = [X0-targetIm_width-imageGap,Y0+imageGap,X0-imageGap,Y0+targetIm_height+imageGap];
        targetArrayPosition{16}(:,11) = [X0+imageGap,Y0+imageGap,X0+targetIm_width+imageGap,Y0+targetIm_height+imageGap];
        targetArrayPosition{16}(:,12) = [X0+targetIm_width+imageGap*2,Y0+imageGap,X0+targetIm_width*2+imageGap*2,Y0+targetIm_height+imageGap];
        targetArrayPosition{16}(:,13) = [X0-targetIm_width*2-imageGap*2,Y0+targetIm_height+imageGap*2,X0-targetIm_width-imageGap*2,Y0+targetIm_height*2+imageGap*2];
        targetArrayPosition{16}(:,14) = [X0-targetIm_width-imageGap,Y0+targetIm_height+imageGap*2,X0-imageGap,Y0+targetIm_height*2+imageGap*2];
        targetArrayPosition{16}(:,15) = [X0+imageGap,Y0+targetIm_height+imageGap*2,X0+targetIm_width+imageGap,Y0+targetIm_height*2+imageGap*2];
        targetArrayPosition{16}(:,16) = [X0+targetIm_width+imageGap*2,Y0+targetIm_height+imageGap*2,X0+targetIm_width*2+imageGap*2,Y0+targetIm_height*2+imageGap*2];


        targetPosition(:,1) = [X0-targetIm_width/2,Y0-targetIm_height/2,X0+targetIm_width/2,Y0+targetIm_height/2];
        
