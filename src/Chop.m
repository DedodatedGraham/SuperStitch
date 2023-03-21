function [] = Chop(inputPath,N,M,O)
%Path points to a image wanting to be chopped up int an N x M set of
%pictures with a 'O'% overlap

%size of pictures in pixels will be determined based on input size px,py
imgPath = append(pwd,'\input\',inputPath);
mainImg = imread(imgPath);
pos = struct("x",0,"y",0,"w",0,"h",0);
imgpos(N,M) = pos; 
[px,py,ncc] = size(mainImg);
%imgPart = zeros(M,N,ncc);
nx = floor(px/N);
ny = floor(py/M);
onx = floor(nx * O * .01);
ony = floor(ny * O * .01);
%assign pics
% end
ip = 1;
for i=1:1:N
    jp = 1;
    for j=1:1:M
        %Assign non adjusted box 
        imgpos(i,j).x = ip;
        imgpos(i,j).y = jp;
        imgpos(i,j).w = nx;
        imgpos(i,j).h = ny;
        if i ~= 1
            imgpos(i,j).x = imgpos(i,j).x - onx;
        end
        if j ~= 1
            imgpos(i,j).y = imgpos(i,j).y - ony;
        end
        if i == N
            imgpos(i,j).w = px - imgpos(i,j).x; 
        else
            imgpos(i,j).w = imgpos(i,j).w + onx;
        end
        if j == M
            imgpos(i,j).h = py - imgpos(i,j).y; 
        else 
            imgpos(i,j).h = imgpos(i,j).h + ony;
        end
        %Apply overlap if nt on edge
        %Finally output image
        temp = mainImg(imgpos(i,j).x : imgpos(i,j).x + imgpos(i,j).w,imgpos(i,j).y : imgpos(i,j).y + imgpos(i,j).h,:);
        slicepath = append(pwd,'\input\brokenImg\',num2str(imgpos(i,j).x),'-',num2str(imgpos(i,j).y),'.png');
        imwrite(temp,slicepath);
        jp = jp + ny;
    end
    ip = ip + nx;
end
