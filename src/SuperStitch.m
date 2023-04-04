function []  = SuperStitch(inputPath,N,M)
%% SETUP
tStart = tic;
%Super Stitch input 
%Input Path will be externally provided and have the path 
% past SuperStitch/Input
%N is the row amount of photos needed to be loaded in

%Formatting for different OS 
if ispc()%if Windows
    s = append(pwd,'\input\',inputPath);
else%Linux/Mac
    s = append(pwd,'/input/',inputPath);
end
timgPath = dir(fullfile(s,'*.png'));
%Setup needed
count = 1;
imgstruct = struct('image',zeros(1,1,1),'surf',SURFPoints,'x',0,'y',0,'added',false);
data = repmat(imgstruct,M,N);
tw = 0;%total width 
th = 0;%total heigth
%Sort files for order, ie create a list of pictures which are sorted along
%the X and then the Y
sortedname(size(timgPath),1) = ' ';
for i=1:1:M
    for j=1:1:N
        
    end
end
%Next load in pictues in order
for i=1:1:M
    for j=1:1:N
        %Load in image and assign x & y values
        cimg = imread(append(s,timgPath(count,:).name));
        x = split(timgPath(count,:).name,'-');
        y = split(x(2),'.');
        x = str2double(x(1));
        y = str2double(y(1));
        %Put data into a structure to hold 
        data(i,j).image = cimg;
        data(i,j).x = x(1);
        data(i,j).y = y(1);
        temp = detectSURFFeatures(rgb2gray(cimg));
        data(i,j).surf = temp;
        if i == M && j == N
            %Gets width and height of total image size with overlap
            [h,w,~] = size(cimg);
            tw = data(i,j).x + w;
            th = data(i,j).y + h;
        end
        count = count + 1;
    end
end
finalImg = zeros(th,tw,3);%Final image is our output congolermate with out pixel size
%Time to load & preprocess data
tEnd = toc(tStart);
disp(append('Time for Setup: ',string(tEnd),' (s)'));

%% STITCH
%Next we start the stitching method, What we do on this layer is utalize
%the snake pattern for best stitching...(maybe? we will see)
tStart = tic;
for i=1:1:M
    %snake
    if mod(i,2) ~= 0
        for j=1:1:N
            
            %The inside of both sides are realtively the same, so we will pass everything
            %to a new functions
            finalImg = LocalStitch(data,i,j,N,M,finalImg);
        end
    else
        for j=N:-1:1
            finalImg = LocalStitch(data,i,j,N,M,finalImg);
        end
    end
end
tEnd = toc(tStart);
disp(append('Time for Stitch: ',string(tEnd),' (s)'));
end
