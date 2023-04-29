function [] = Chop(inputPath,N,M,O)
%Path points to a image wanting to be chopped up int an N x M set of
%pictures with a 'O'% overlap

%size of pictures in pixels will be determined based on input size px,py

imgPath = append(pwd,'/input/',inputPath);
mainImg = imread(imgPath);
pos = struct("x",0,"y",0,"w",0,"h",0);
imgpos = repmat(pos,M,N); 
[py,px,~] = size(mainImg);
nx = floor((px * (1-O*0.01))/N);
ny = floor((py * (1-O*0.01))/M);
onx = floor((px / N) * O * .01);
ony = floor((py / M) * O * .01);
%ouput partitoned pictures
% end
ip = 1;
for i=1:1:M
    jp = 1;
    for j=1:1:N
        %Assign non adjuste
        % 
        % d box 
        imgpos(i,j).x = jp;
        imgpos(i,j).y = ip;
        imgpos(i,j).w = nx + 2 * onx;
        imgpos(i,j).h = ny + 2 * ony;
        %Apply overlap if not on edge, or final width correction
        % if j == N
        %     imgpos(i,j).w = px - imgpos(i,j).x; 
        % else
        %     imgpos(i,j).w = imgpos(i,j).w + onx;
        % end
        % if i == M
        %     imgpos(i,j).h = py - imgpos(i,j).y; 
        % else 
        %     imgpos(i,j).h = imgpos(i,j).h + ony;
        % end
        %Finally output image
        disp(' ')
        disp(append('i=',string(i)));
        disp(append('j=',string(j)));
        disp(append('x=',string(imgpos(i,j).x)));
        disp(append('y=',string(imgpos(i,j).y)));
        disp(append('w=',string(imgpos(i,j).w)));
        disp(append('h=',string(imgpos(i,j).h)));
        if i ~= M
            imgpos(i,j).h = imgpos(i,j).h ;%+ randi([-5,5]);
        else
            imgpos(i,j).h = py - imgpos(i,j).y;
        end
        if j ~= N
            imgpos(i,j).w = imgpos(i,j).w ;%+ randi([-5,5]);
        else
            imgpos(i,j).w = px - imgpos(i,j).x;
        end
        temp = mainImg(imgpos(i,j).y : imgpos(i,j).y + imgpos(i,j).h,imgpos(i,j).x : imgpos(i,j).x + imgpos(i,j).w,:);
        if i ~= 1 
            imgpos(i,j).y = imgpos(i,j).y + randi([-5,5]);
        end
        if j ~= 1
            imgpos(i,j).x = imgpos(i,j).x + randi([-5,5]);
        end
        slicepath = append(pwd,'/input/brokenImg/',num2str(imgpos(i,j).x),'-',num2str(imgpos(i,j).y),'.png');
        imwrite(temp,slicepath);
        jp = jp + nx + onx;
    end
    ip = ip + ny + ony;
end
end

