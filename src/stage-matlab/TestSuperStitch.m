function []  = TestSuperStitch(inputPath,M,N)
tStart = tic;
%Super Stitch input 
%Input Path will be externally provided and have the path 
% past SuperStitch/Input
%N is the row amount of photos needed to be loaded in

%Formatting for different OS 
if ispc()%if Windows
    s = append(pwd,'/input/',inputPath);
else%Linux/Mac
    s = append(pwd,'/input/',inputPath);
end
%Count Sort Files
%Puts x&y locations into propper arrangement allowing for variablility
timgPath = natsortfiles(dir(fullfile(s,'*.png')));
[long,~] = size(timgPath);
trestdat = zeros(long,4,'double');
count = 1;
imgpathhold = strings(long);
for i=1:long
    x = split(timgPath(count,:).name,'-');
    y = split(x(2),'.');
    t = str2double(append(y(1),'.',y(2)));
    trestdat(count,2) = str2double(x(1));
    trestdat(count,2) = str2double(y(1));
    imgpathhold(count) = append(s,timgPath(count,:).name);
    count = count + 1;
end
%Next we will grab time data from beaglebone to get our image set 
%posdat = rmmissing(readmatrix(append(pwd,'/input/',posfile)));
% maxx = 0;
% maxy = 0;
% thx = 1;%tempholdvalues
% thy = 1;
% runcount = 1;
% runstart = 100000;
% runend = 0;
% timese = zeros(1,2);
% tcnt = 0;
% for i=1:2:st
%     tstart = timedat(i);
%     tend = timedat(i+1);
%     istart = 1000000;
%     iend = 0;
%     griddycnt = 0;
%     for j=1:long
%         if mod(i,4) == 1 && trestdat(j,1) > tstart && trestdat(j,1) < tend
%             if runstart > j
%                 runstart = j;
%             end
%             if runend < j
%                 runend = j;
    %         end
    %         if istart > j
    %             istart = j;
    %         end
    %         if iend < j
    %             iend = j;
    %         end
    %         %We are in the time so we count
    %         griddycnt = griddycnt + 1;
    %     end
    % end
    % 
    % if mod(i,4) == 1
    %     if tcnt == 0
    %         timese(1,1) = istart;
    %         timese(1,2) = iend;
    %         tcnt = tcnt + 1;
    %     else
    %         timese = [timese;[istart,iend]];
    %         tcnt = tcnt + 1;
    %     end
    %     if griddycnt > maxx
%             maxx = griddycnt;
%         end
%         maxy = maxy + 1;
%     end
%     for j=1:long
%         if j >= istart && j <= iend
%             trestdat(j,4) = 1;
%         end
%     end
% end
% for i=1:2:st
%     tstart = timedat(i);
%     tend = timedat(i+1);
%     if mod(i,4) == 1
%         %ADDX
%         if thx > 1
%             thx = 1;
%         else
%             thx = 7000;
%         end
%     else
%         %ADDY
%         thy = thy + 300;
%     end
%     convfactor = 0.01 / 4;
%     for j=1:long
%         if mod(i,4) == 1 && trestdat(j,1) > runstart && trestdat(j,1) < runend
%             runcount = runcount + 1;
%         end
%         if trestdat(j,1) > tstart && trestdat(j,1) < tend
%             %We are in the time so we count
%             if mod(i,4) == 1
%                 if mod(i,8) == 1
%                     trestdat(j,2) = ((trestdat(j,1) - tstart)/(tend-tstart) * (7000 - 0) + 0) * convfactor;
%                     trestdat(j,3) = thy * convfactor;
%                 else
%                     trestdat(j,2) = ((trestdat(j,1) - tstart)/(tend-tstart) * (0 - 7000) + 7000) * convfactor;
%                     trestdat(j,3) = thy * convfactor;
%                 end
%             end
%         end
%     end
% end
% M = maxy;
% N = maxx;
imgstruct = struct('image',zeros(1,1,'uint8'),'surf',SURFPoints,'x',0,'y',0,'added',false,'offx',0,'offy',0);
data = repmat(imgstruct,M,N);
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
cw = 0;%total heigth
ch = 0;%total heigth
tw = 0;
th = 0;
for i=1:1:M
    if mod(i,2) == 1
        for j=1:1:N
            disp(append('loading: ',string(i),',',string(j)));
            %Load in image and assign x & y values
            %imgpath = append(s,string(trestdat(count,1)),'-',string(trestdat(count,2)),'.png');
            %char(imgpathhold(trestdat(count3),1))
            passvibecheck = true;
            % for pvc=1:tcnt
            %     if trestdat(count,1) > timese(pvc,1) && trestdat(count,1) < timese(pvc,2) 
            %         passvibecheck = true;
            %         break
            %     end
            % end
            if passvibecheck
                cimg = imread(imgpathhold(count));
                %Put data into a structure to hold 
                data(i,j).image = im2gray(cimg); 
                [h,w,~] = size(cimg);
                data(i,j).x = ceil(trestdat(count,2)*w) + 1;
                data(i,j).y = ceil(trestdat(count,3)*h) + 1;
                %disp(append('(',string(i),',',string(j),') => (',string(data(i,j).x),',',string(data(i,j).y),')'))
                temp = detectSURFFeatures(data(i,j).image,'MetricThreshold',100);
                data(i,j).surf = temp;
                if i == 10 && (j == 5 || j == 4)
                    imshow(cimg)
                    hold on
                    plot(temp)
                end
                if data(i,j).y + h > th 
                    %Gets width and height of 'final' image size with overlap
                    th = data(i,j).y + h;
                end
                if data(i,j).x + w > tw 
                    tw = data(i,j).x + w;
                end
                if i == M 
                    %Gets width and height of total image size with overlap
                    cw = cw + w;
                end
                if j == N
                    ch = ch + h;
                end
            else
                data(i,j).added = true;
            end
            count = count + 1;
        end
    else
        for j=N:-1:1
            disp(append('loading: ',string(i),',',string(j)));
            %Load in image and assign x & y values
            %imgpath = append(s,string(trestdat(count,1)),'-',string(trestdat(count,2)),'.png');
            %char(imgpathhold(trestdat(count3),1))
            passvibecheck = true;
            % for pvc=1:tcnt
            %     if trestdat(count,1) > timese(pvc,1) && trestdat(count,1) < timese(pvc,2) 
            %         passvibecheck = true;
            %         break
            %     end
            % end
            if passvibecheck
                cimg = imread(imgpathhold(count));
                %Put data into a structure to hold 
                data(i,j).image = im2gray(cimg); 
                [h,w,~] = size(cimg);
                data(i,j).x = ceil(trestdat(count,2)*w) + 1;
                data(i,j).y = ceil(trestdat(count,3)*h) + 1;
                %disp(append('(',string(i),',',string(j),') => (',string(data(i,j).x),',',string(data(i,j).y),')'))
                temp = detectSURFFeatures(data(i,j).image,'MetricThreshold',100);
                data(i,j).surf = temp;
                if i == 10 && (j == 5 || j == 4)
                    imshow(cimg)
                    hold on
                    plot(temp)
                end
                if data(i,j).y + h > th 
                    %Gets width and height of 'final' image size with overlap
                    th = data(i,j).y + h;
                end
                if data(i,j).x + w > tw 
                    tw = data(i,j).x + w;
                end
                if i == M 
                    %Gets width and height of total image size with overlap
                    cw = cw + w;
                end
                if j == N
                    ch = ch + h;
                end
            else
                data(i,j).added = true;
            end
            count = count + 1;
        end
    end
end
%Break into 4's
ch = th + 5000;
cw = tw + 5000;
finalImg = zeros(ch,cw,'uint8');%Final image is our output congolermate with out pixel size
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
%disp(append('We have ',string(runcount),'/',string(N*M),' cells active'))
notcasecounts = 0;
while(notcase)
    if notcasecounts > 50
        break
    end
    ttstart = tic;
    for i=1:1:M
        %snake
        if mod(i,2) ~= 0
            for j=1:1:N
                %The inside of both sides are realtively the same, so we will pass everything
                %to a new functions
                [finalImg,data,finalAdd] = LocalStitch(data,i,j,N,M,finalImg,finalAdd);
                %imshow(finalImg);
            end
        else
            for j=N:-1:1
                [finalImg,data,finalAdd] = LocalStitch(data,i,j,N,M,finalImg,finalAdd);
            end
        end
        %regular
        % for j=1:1:N
        %     [finalImg,data,finalAdd] = LocalStitch(data,i,j,N,M,finalImg,finalAdd);
        % end
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
    notcasecounts = notcasecounts+1;
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
%Formatting for differ
% ent OS 
% [oh,ow] = size(finalImg)
% for i=1:oh
%     if finalImg(i,1) == 0
%         holdcase = true;
%         for j=1:ow
%             if finalImg(i,j) ~= 0
%                 holdcase = false;
%                 break
%             end
%         end
%         if holdcase
%             finalImg = finalImg(1:i,:);
%             break
%         end
%     end
% end
% [oh,ow] = size(finalImg)
% for j=ow:-1:1
%     if finalImg(1,j) == 0
%         holdcase = true;
%         for i=1:oh
%             if finalImg(i,j) ~= 0
%                 holdcase = false;
%                 break
%             end
%         end
%         if holdcase
%             finalImg = finalImg(:,1:j);
%         end
%     end
% end
[oh,ow] = size(finalImg)
outputName = 'test.jpg';
if ispc()%if Windows
    s = append(pwd,'\output\testout\',outputName);
else%Linux/Mac
    s = append(pwd,'/output/testout/',outputName);
end
imwrite(finalImg, s);
tEnd = toc(tStart);
disp(append('Time for Stitch: ',string(floor(tEnd/60)),' (m)',string(mod(tEnd,60)),' (s)'));
end
