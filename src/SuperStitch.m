function []  = SuperStitch(inputPath,N,M)
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
[px,py,colordep] = size(imread(append(s,timgPath(1,:).name)));
imgstruct = struct('image',zeros(px,py,colordep),'x',0,'y',0);
data = repmat(imgstruct,N,M);
for i=1:1:N
    for j=1:1:M
        %Load in image and assign x & y values
        cimg = imread(append(s,timgPath(count,:).name));
        x = split(timgPath(count,:).name,'-');
        y = split(x(2),'.');
        x = str2double(x(1));
        y = str2double(y(1));
        %Put data into a structure to hold 
        data(N,M).image = rgb2gray(cimg);
        data(N,M).image
        data(N,M).x = x;
        data(N,M).y = y;
        pts = detectSURFFeatures(data(N,M).image);
        count = count + 1;
    end
end
end
