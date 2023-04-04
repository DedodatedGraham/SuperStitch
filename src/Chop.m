function [] = Chop(inputPath,N,M,O)
%Path points to a image wanting to be chopped up int an N x M set of
%pictures with a 'O'% overlap

%size of pictures in pixels will be determined based on input size px,py

imgPath = append(pwd,'\input\',inputPath);
mainImg = imread(imgPath);
pos = struct("x",0,"y",0,"w",0,"h",0);
imgpos(M,N) = pos; 
[py,px,~] = size(mainImg);
nx = floor(px/N);
ny = floor(py/M);
onx = floor(nx * O * .01);
ony = floor(ny * O * .01);
%ouput partitoned pictures
% end
ip = 1;
for i=1:1:M
    jp = 1;
    for j=1:1:N
        %Assign non adjusted box 
        imgpos(i,j).x = jp;
        imgpos(i,j).y = ip;
        imgpos(i,j).w = nx;
        imgpos(i,j).h = ny;
        %Apply overlap if not on edge, or final width correction
        if j ~= 1
            imgpos(i,j).x = imgpos(i,j).x - onx;
        end
        if i ~= 1
            imgpos(i,j).y = imgpos(i,j).y - ony;
        end
        if j == N
            imgpos(i,j).w = px - imgpos(i,j).x; 
        else
            imgpos(i,j).w = imgpos(i,j).w + onx;
        end
        if i == M
            imgpos(i,j).h = py - imgpos(i,j).y; 
        else 
            imgpos(i,j).h = imgpos(i,j).h + ony;
        end
        %Finally output image
        disp(' ')
        disp(append('i=',string(i)));
        disp(append('j=',string(j)));
        disp(append('x=',string(imgpos(i,j).x)));
        disp(append('y=',string(imgpos(i,j).y)));
        disp(append('w=',string(imgpos(i,j).w)));
        disp(append('h=',string(imgpos(i,j).h)));
        temp = mainImg(imgpos(i,j).y : imgpos(i,j).y + imgpos(i,j).h,imgpos(i,j).x : imgpos(i,j).x + imgpos(i,j).w,:);
        slicepath = append(pwd,'\input\brokenImg\',num2str(imgpos(i,j).x),'-',num2str(imgpos(i,j).y),'.png');
        imwrite(temp,slicepath);
        jp = jp + nx;
    end
    ip = ip + ny;
end
end

