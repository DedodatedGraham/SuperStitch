function []  = SuperStitch(inputPath,timefile,posfile)
%% SETUP
tStart = tic;
%Super Stitch input 
%Input Path will be externally provided and have the path 
% past SuperStitch/Input
%N is the row amount of photos needed to be loaded in

%Formatting for different OS 
if ispc()%if Windows
    s = append(pwd,inputPath);
else%Linux/Mac
    s = append(pwd,inputPath);
end
%Count Sort Files
%Puts x&y locations into propper arrangement allowing for variablility
timgPath = natsortfiles(dir(fullfile(s,'*.jpg')));
[long,~] = size(timgPath);
trestdat = zeros(long,3,'double');
count = 1;
imgpathhold = strings(long);
for i=1:long
    x = split(timgPath(count,:).name,'-');
    y = split(x(2),'.');
    t = str2double(append(y(1),'.',y(2)));
    trestdat(count,1) = t;
    imgpathhold(count) = append(s,timgPath(count,:).name);
    count = count + 1;
end
%Next we will grab time data from beaglebone to get our image set 
timedat = load(append(pwd,'/input/',timefile));
[st,~] = size(timedat);
maxx = 0;
maxxy = 0;
for i=1:2:st
    tstart = timedat(i)
    tend = timedat(i+1)
    griddycnt = 0;
    for j=1:long
        if mod(i,4) == 1
            disp(i);
        else
            disp(i);
        end
    end
end
totalpic = iend - istart;
posdat = rmmissing(readmatrix(append(pwd,'/input/',posfile)));
%Now we have loaded in all of our data, so we will next go through
%everything

%%OLD LOAD
% for j=1:1:N
%     for i=1:1:M
%         x = split(timgPath(count,:).name,'-');
%         y = split(x(2),'.');
%         x = str2double(x(1));
%         y = str2double(y(1));
%         trestdat(count,1) = x;
%         trestdat(count,2) = y;
%         trestdat(count,3) = count;
%         imgpathhold(count) = append(s,timgPath(count,:).name);
%         count = count + 1;
%     end
% end
% for j=1:1:N
%     stemp = sortrows(trestdat(((j - 1) * M) + 1:((j - 1) * M) + M, :),2);
%     trestdat(((j - 1) * M) + 1:((j - 1) * M) + M, :) = stemp; 
% end

%Load needed data
count = 1;
imgstruct = struct('image',zeros(1,1,1,'uint8'),'surf',SURFPoints,'x',0,'y',0,'added',false,'offx',0,'offy',0);
data = repmat(imgstruct,M,N);
cw = 0;%total heigth
ch = 0;%total heigth
for j=1:1:N
    for i=1:1:M
        %Load in image and assign x & y values
        %imgpath = append(s,string(trestdat(count,1)),'-',string(trestdat(count,2)),'.png');
        %char(imgpathhold(trestdat(count,3),1))
        cimg = imread(imgpathhold(trestdat(count,3),1));
        %Put data into a structure to hold 
        data(i,j).image = cimg;
        data(i,j).x = trestdat(count,1);
        data(i,j).y = trestdat(count,2);
        temp = detectSURFFeatures(rgb2gray(cimg),'MetricThreshold',100);
        data(i,j).surf = temp;
        [h,w,~] = size(cimg);
        if i == M && j == N
            %Gets width and height of 'final' image size with overlap
            tw = data(i,j).x + w;
            th = data(i,j).y + h;
        end
        if i == M 
            %Gets width and height of total image size with overlap
            cw = cw + w;
        end
        if j == N
            ch = ch + h;
        end
        count = count + 1;
    end
end
finalImg = zeros(ch,cw,3,'uint8');%Final image is our output congolermate with out pixel size
finalAdd = false(ch,cw);%Final image is our output congolermate with out pixel size
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
        %regular
        for j=1:1:N
            [finalImg,data,finalAdd] = LocalStitch(data,i,j,N,M,finalImg,finalAdd);
        end
    end
    notcase = false;
    countmiss = 0;
    for i=1:1:M
        for j=1:1:N
            if data(i,j).added == false
                notcase = true;
                countmiss = countmiss+1;
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
%may or maynot be needed
% for i=1:1:M
%     for j=1:1:N
%         if data(i,j).added == false
%             [h,w,~] = size(data(i,j).image);
%             finalImg(data(i,j).y : data(i,j).y + h,data(i,j).x : data(i,j).x + w,1) = 255;
%             for pos=1:4
%                 %we use img dir again for speed and safety
%                 [go,compData,iagg,jagg] = getImgDir(data,i,j,N,M,pos);
%                 if go
%                     thisData = data(i,j);
%                     %safe to procede
%                     %Here we will compare compData & thisData, and apply a
%                     %shift for the best results
%                     [besti,bestj] = redshift(thisData,compData,i,j,iagg,jagg,5);
%                     %Applies the best shift we can 
%                     [finalImg] = redadd(finalImg,thisData,besti,bestj,i,j,N,M);
%                 end
%             end
%         end
%     end
% end
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
