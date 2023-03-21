function []  = SuperStitch(inputPath,N,M)
%Super Stitch input 
%Input Path will be externally provided and have the path 
% past SuperStitch/Input
%N is the row amount of photos needed to be loaded in
s = append(pwd,'\input\',inputPath);
timgPath = dir(fullfile(s,'*.png'));
count = 1;
for i=1:1:N
    for j=1:1:M
        %Load in image and assign x & y values
        cimg = imread(append(s,timgPath(count,:).name));
        x = split(timgPath(count,:).name,'-');
        y = split(x(2),'.');
        x = str2double(x(1));
        y = str2double(y(1));
        %Put data into a structure to hold 
        data = struct('image',cimg,'x',x,'y',y)
        
        count = count + 1;
    end
end
end
