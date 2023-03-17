function []  = untitled(inputPath,N,M)
%Super Stitch input 
%Input Path will be externally provided and have the path 
% past SuperStitch/Input
%N is the row amount of photos needed to be loaded in
imgCluster = zeros(N,M);
imgScan = zeros(N*M);
imgPath = dir(append('input\',inputPath));
for i=1:1:(N*M)
    rpath = append(pwd,imgPath[i].name);
    imgScan[i] = imread(impPath[i]);
end

%%
%Main SuperStitch Code

%%
end
