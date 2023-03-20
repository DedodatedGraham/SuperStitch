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
nx = ceil(px/N);
ny = ceil(py/M);
onx = ceil(nx * O * .01);
ony = ceil(ny * O * .01);
%assign pics
for i=1:1:N
    for j=1:1:M
        %Assign non adjusted box 
        imgpos(i,j).x = nx * i;
        imgpos(i,j).y = ny * j;
        imgpos(i,j).w = nx;
        imgpos(i,j).h = ny;
        %Apply overlap if nt on edge
        %Finally output image
        temp = mainImg(imgpos(i,j).x : imgpos(i,j).x + imgpos(i,j).w,imgpos(i,j).y : imgpos(i,j).y + imgpos(i,j).h,:);
        %slicepath = append(pwd,'\input\brokenImg\',num2str(imgpos(i,j).x),'-',num2str(imgpos(i,j).y),'.png');
        %imwrite(temp,slicepath);
    end
end
