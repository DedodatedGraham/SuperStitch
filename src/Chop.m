function [] = Chop(inputPath,N,M,O)
%Path points to a image wanting to be chopped up int an N x M set of
%pictures with a 'O'% overlap

%size of pictures in pixels will be determined based on input size px,py
imgPath = append(pwd,'\SuperStitch\input\',inputPath);
mainImg = imread(imgPath);
pos = struct("x",0,"y",0,"w",0,"h",0);
imgpos(N,M) = pos; 
imgPart(N,M);
[px,py,ncc] = size(mainImg);
nx = ceil(px/N);
ny = ceil(py/M);
onx = nx * O * .01;
ony = ny * O * .01;
%assign pics
for i=1:1:N
    for j=1:1:M
        %Assign non adjusted 
        imgpos(i,j).x = nx * i;
        imgpos(i,j).y = ny * j;
           
    end
end
nx;