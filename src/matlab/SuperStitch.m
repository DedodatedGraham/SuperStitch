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
timgPath = natsortfiles(dir(fullfile(s,'*.png')));

%Setup needed
count = 1;
imgstruct = struct('image',zeros(1,1,1,'uint8'),'surf',SURFPoints,'x',0,'y',0,'added',false);
data = repmat(imgstruct,M,N);
tw = 0;%total width 
th = 0;%total heigth
for j=1:1:N
    for i=1:1:M
        %disp(append('Creating pic @ ',string(i),',',string(j)));
        %Load in image and assign x & y values
        cimg = imread(append(s,timgPath(count,:).name));
        %disp(timgPath(count,:).name);
        x = split(timgPath(count,:).name,'-');
        y = split(x(2),'.');
        x = str2double(x(1));
        y = str2double(y(1));
        %disp(append('x,y= ',string(x(1)),',',string(y(1))));

        %Put data into a structure to hold 
        data(i,j).image = cimg;
        data(i,j).x = x(1);
        data(i,j).y = y(1);
        temp = detectSURFFeatures(rgb2gray(cimg),'MetricThreshold',100);
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
finalImg = zeros(th,tw,3,'uint8');%Final image is our output congolermate with out pixel size
%Time to load & preprocess data
tEnd = toc(tStart);
disp(append('Time for Setup: ',string(tEnd),' (s)'));

%% STITCH
%Next we start the stitching method, What we do on this layer is utalize
%the snake pattern for best stitching...(maybe? we will see)
tStart = tic;
notcase = true;
loopcounting = 1;
lastmiss = 0;
while(notcase)
    ttstart = tic;
    for i=1:1:M
        %snake
        
%         if mod(i,2) ~= 0
%             for j=1:1:N
%                 %The inside of both sides are realtively the same, so we will pass everything
%                 %to a new functions
%                 [finalImg,data] = LocalStitch(data,i,j,N,M,finalImg);
%                 %imshow(finalImg);
%             end
%         else
%             for j=N:-1:1
%                 [finalImg,data] = LocalStitch(data,i,j,N,M,finalImg);
%             end
%         end
        for j=1:1:N
            [finalImg,data] = LocalStitch(data,i,j,N,M,finalImg);
        end
    end
    notcase = false;
    countmiss = 0;
    for i=1:1:M
        for j=1:1:N
            if data(i,j).added == false
                notcase = true;
                countmiss = countmiss+1;
                %j = N;
                %i = M;
            end
        end
    end
    ttemp = toc(ttstart);
    disp(' ');
    disp(append(string(loopcounting),'-Time for Stitch: ',string(floor(ttemp/60)),' (m)',string(mod(ttemp,60)),' (s)'));
    disp(append('missed-',string(countmiss)));
    disp(' ');
    loopcounting = loopcounting + 1;
    if countmiss == lastmiss
        notcase = false;
    end
    lastmiss = countmiss;
end

%Lastly we go through, find regions which missed for some reason
%We should be able to brute force this one 
for i=1:1:M
    for j=1:1:N
        if data(i,j).added == false
            for pos=1:4
                %we use img dir again for speed and safety
                [go,compData,iagg,jagg] = getImgDir(data,i,j,N,M,pos);
                if go
                    thisData = data(i,j);
                    %safe to procede
                    %Here we will compare compData & thisData, and apply a
                    %shift for the best results
                    [besti,bestj] = redshift(thisData,compData,i,j,iagg,jagg,5);
                    %Applies the best shift we can 
                    [finalImg] = redadd(finalImg,thisData,besti,bestj,i,j,N,M);
                end
            end
        end
    end
end
%Finally we will save out output image :)
%Formatting for different OS 
outputName = 'test.png';
if ispc()%if Windows
    s = append(pwd,'\output\testout\',outputName);
else%Linux/Mac
    s = append(pwd,'/output/testout/',outputName);
end
imwrite(finalImg, s);
tEnd = toc(tStart);
disp(append('Time for Stitch: ',string(floor(tEnd/60)),' (m)',string(mod(tEnd,60)),' (s)'));
end
