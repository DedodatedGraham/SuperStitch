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
th
tw
finalImg = zeros(th,tw,3);%Final image is our output congolermate with out pixel size
%Time to load & preprocess data
tEnd = toc(tStart);
disp(append('Time for Setup: ',string(tEnd),' (s)'));

%% STITCH
%Next we start the stitching method, What we do on this layer is utalize
%the snake pattern for best stitching...(maybe? we will see)
tStart = tic;
for j=1:1:M
    %snake
    
    if mod(j,2) ~= 0
        for i=1:1:N
            %The inside of both sides are realtively the same, so we will pass everything
            %to a new functions
            disp(append('[',string(i),',',string(j),']'));
            finalImg = LocalStitch(data,i,j,N,M,finalImg);
        end
    else
        for i=N:-1:1
            disp(append('[',string(i),',',string(j),']'));
            finalImg = LocalStitch(data,i,j,N,M,finalImg);
        end
    end
end
%Finally we will save out output image :)
%Formatting for different OS 
outputName = 'test.png';
if ispc()%if Windows
    s = append(pwd,'\output\testout\',outputName);
else%Linux/Mac
    s = append(pwd,'/output/testout\',outputName);
end
imwrite(finalImg, s);
tEnd = toc(tStart);
disp(append('Time for Stitch: ',string(round(tEnd/60)),' (m)',string(mod(tEnd,60)),' (s)'));
end
